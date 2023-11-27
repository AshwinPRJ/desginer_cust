namespace: Achmea.Shared.subFlows.SMA
flow:
  name: changePhaseAchmea
  inputs:
    - sma_url: "${get_sp('Achmea.SMA.URL')}"
    - sma_tenantID: "${get_sp('Achmea.SMA.Tentant')}"
    - sma_userName:
        default: "${get_sp('Achmea.SMA.User')}"
        required: false
    - sma_password:
        default: "${get_sp('Achmea.SMA.Password')}"
        required: false
        sensitive: true
    - sma_entityType
    - sma_entityId
    - sma_changePhase
    - completion_ok: '["OK" , "OK"]'
    - sso_token:
        required: false
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_token}'
        navigate:
          - IS_NULL: getSmaToken
          - IS_NOT_NULL: SetPhase
    - SetPhase:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${sma_url + '/rest/' + sma_tenantID + '/ems/bulk'}"
            - auth_type: Basic
            - trust_all_roots: 'true'
            - headers: '${("COOKIE:LWSSO_COOKIE_KEY=" + sso_token + ";TENANTID=" + sma_tenantID)}'
            - body: "${'{\"entities\": [{\"entity_type\": \"' + sma_entityType + '\",\"properties\": {\"Id\": \"' + sma_entityId + '\",\"PhaseId\":\"' + sma_changePhase + '\"},\"layout\": \"Id,PhaseId\"}],\"operation\": \"UPDATE\"}'}"
            - content_type: application/json
        publish:
          - resultSetPhase: '${return_result}'
          - errorMessage: '${error_message}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: FAILURE
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${resultSetPhase}'
            - json_path: $..completion_status
        publish:
          - completion_code: '${return_result}'
        navigate:
          - SUCCESS: equals
          - FAILURE: FAILURE
    - equals:
        do:
          io.cloudslang.base.json.equals:
            - json_input1: '${completion_code}'
            - json_input2: '${completion_ok}'
        publish:
          - message: new phase set
        navigate:
          - EQUALS: sleep
          - NOT_EQUALS: do_nothing
          - FAILURE: FAILURE
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - phase: '${sma_changePhase}'
        publish:
          - message: "${'Could not go to phase ' + str(phase)}"
        navigate:
          - SUCCESS: sleep_1
          - FAILURE: FAILURE
    - getSmaToken:
        do:
          Achmea.Shared.subFlows.SMA.getSmaToken:
            - smaUrl: '${sma_url}'
            - smaTennant: '${sma_tenantID}'
            - smaUser: '${sma_userName}'
            - smaPassw: '${sma_password}'
        publish:
          - sso_token
        navigate:
          - SUCCESS: SetPhase
          - FAILURE: on_failure
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '7'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - sleep_1:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '7'
        navigate:
          - SUCCESS: CUSTOM
          - FAILURE: on_failure
  outputs:
    - Message: '${message}'
  results:
    - FAILURE
    - SUCCESS
    - CUSTOM
extensions:
  graph:
    steps:
      is_null:
        x: 160
        'y': 240
      SetPhase:
        x: 640
        'y': 240
        navigate:
          77197f22-d584-2403-7c5a-e54aa45b8eec:
            targetId: 1d1ad433-8188-ca32-bd69-3eca596e771c
            port: FAILURE
      json_path_query:
        x: 800
        'y': 240
        navigate:
          6b6756a3-c8ad-ec5c-9571-dde8b2fccd7f:
            targetId: 1d1ad433-8188-ca32-bd69-3eca596e771c
            port: FAILURE
      equals:
        x: 960
        'y': 240
        navigate:
          eb4ffca4-59b7-5dff-5f92-b3020507ea10:
            targetId: 1d1ad433-8188-ca32-bd69-3eca596e771c
            port: FAILURE
      do_nothing:
        x: 960
        'y': 400
        navigate:
          f2ef47a3-a37f-6da6-74dd-1b2c2a840862:
            targetId: 1d1ad433-8188-ca32-bd69-3eca596e771c
            port: FAILURE
      getSmaToken:
        x: 320
        'y': 480
      sleep:
        x: 1080
        'y': 240
        navigate:
          33e1373f-d786-9fd2-9ba4-a42321628cc4:
            targetId: 47f81361-040a-d838-2ea3-575d439ad233
            port: SUCCESS
      sleep_1:
        x: 960
        'y': 520
        navigate:
          2b5f1a37-fa29-5668-771c-dac2ab6a5f31:
            targetId: 5ee72957-1882-7080-718a-c907fb434345
            port: SUCCESS
    results:
      FAILURE:
        1d1ad433-8188-ca32-bd69-3eca596e771c:
          x: 760
          'y': 520
      SUCCESS:
        47f81361-040a-d838-2ea3-575d439ad233:
          x: 1200
          'y': 240
      CUSTOM:
        5ee72957-1882-7080-718a-c907fb434345:
          x: 960
          'y': 640
