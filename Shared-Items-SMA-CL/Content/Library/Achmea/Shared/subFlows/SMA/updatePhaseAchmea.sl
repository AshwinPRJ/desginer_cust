namespace: Achmea.Shared.subFlows.SMA
flow:
  name: updatePhaseAchmea
  inputs:
    - sso_token:
        required: false
    - sma_url: "${get_sp('Achmea.SMA.URL')}"
    - sma_tenantID: "${get_sp('Achmea.SMA.Tentant')}"
    - sma_entityType
    - sma_entityId
    - sma_changePhase
    - completion_ok: '["OK" , "OK"]'
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_token}'
        navigate:
          - IS_NULL: getSmaToken
          - IS_NOT_NULL: http_client_post
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${sma_url + '/rest/' + sma_tenantID + '/ems/bulk'}"
            - trust_all_roots: 'true'
            - headers: '${("COOKIE:LWSSO_COOKIE_KEY=" + sso_token + ";TENANTID=" + sma_tenantID)}'
            - body: "${'{\"entities\": [{\"entity_type\": \"' + sma_entityType + '\",\"properties\": {\"Id\": \"' + sma_entityId + '\",\"PhaseId\":\"' + sma_changePhase + '\"},\"layout\": \"Id,PhaseId\"}],\"operation\": \"UPDATE\"}'}"
            - content_type: application/json
        publish:
          - resultSetPhase: '${return_result}'
          - error_message
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${resultSetPhase}'
            - json_path: $..completion_status
        publish:
          - completion_code: '${return_result}'
        navigate:
          - SUCCESS: equals
          - FAILURE: on_failure
    - equals:
        do:
          io.cloudslang.base.json.equals:
            - json_input1: '${completion_code}'
            - json_input2: '${completion_ok}'
        publish:
          - message: New Phase Set
        navigate:
          - EQUALS: SUCCESS
          - NOT_EQUALS: do_nothing
          - FAILURE: on_failure
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - phase: '${sma_changePhase}'
        publish:
          - Message: "'Could not go to phase ' + str(phase)"
        navigate:
          - SUCCESS: CUSTOM
          - FAILURE: on_failure
    - getSmaToken:
        do:
          Achmea.Shared.subFlows.SMA.getSmaToken:
            - smaUrl: '${sma_url}'
            - smaTennant: '${sma_tenantID}'
        publish:
          - sso_token
        navigate:
          - SUCCESS: http_client_post
          - FAILURE: on_failure
  results:
    - SUCCESS
    - CUSTOM
    - FAILURE
extensions:
  graph:
    steps:
      is_null:
        x: 40
        'y': 240
      http_client_post:
        x: 280
        'y': 240
      json_path_query:
        x: 400
        'y': 240
      equals:
        x: 520
        'y': 240
        navigate:
          a2dee48f-a938-d1f5-8938-bb5ad818ba02:
            targetId: 4aed2e26-7710-9252-274d-e7f7039efe51
            port: EQUALS
      do_nothing:
        x: 520
        'y': 400
        navigate:
          b8e6eed4-7903-1a89-61ba-2f7837510191:
            targetId: 820132c8-8838-7e3f-0286-f2e2e0b0f547
            port: SUCCESS
      getSmaToken:
        x: 160
        'y': 360
    results:
      SUCCESS:
        4aed2e26-7710-9252-274d-e7f7039efe51:
          x: 640
          'y': 240
      CUSTOM:
        820132c8-8838-7e3f-0286-f2e2e0b0f547:
          x: 680
          'y': 400
