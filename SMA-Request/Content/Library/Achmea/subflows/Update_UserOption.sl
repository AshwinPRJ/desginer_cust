namespace: Achmea.subflows
flow:
  name: Update_UserOption
  inputs:
    - sso_token:
        required: false
    - sma_requestId: '2638245'
    - field: testrtyu
    - value: Test
    - smaTennant:
        default: "${get_sp('Achmea.SMA.Tentant')}"
        required: false
    - smaUrl:
        default: "${get_sp('Achmea.SMA.URL')}"
        required: false
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_token}'
        navigate:
          - IS_NULL: getTokenSmaAchmea
          - IS_NOT_NULL: generateUserOptions
    - getTokenSmaAchmea:
        do:
          Achmea.Shared.subFlows.SMA.getTokenSmaAchmea: []
        publish:
          - sso_token: '${sso_Token}'
        navigate:
          - SUCCESS: generateUserOptions
          - FAILURE: on_failure
    - generateUserOptions:
        do:
          Achmea.Shared.Operations.generateUserOptions:
            - field: '${field}'
            - value: '${value}'
        publish:
          - jsonField: '${return_result}'
        navigate:
          - SUCCESS: do_nothing
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - jsonString: "${'{\"entities\": [{\"entity_type\":\"Request\",\"properties\": {\"Id\": \"' + sma_requestId + '\",' + jsonField + '}}], \"operation\": \"UPDATE\"}'}"
        publish:
          - jsonBody: '${jsonString}'
        navigate:
          - SUCCESS: http_client_post
          - FAILURE: on_failure
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${smaUrl + '/rest/' + smaTennant + '/ems/bulk'}"
            - trust_all_roots: 'true'
            - headers: '${("COOKIE:LWSSO_COOKIE_KEY=" + sso_token + ";TENANTID=" + smaTennant)}'
            - body: '${jsonBody}'
            - content_type: application/json
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      is_null:
        x: 240
        'y': 400
      getTokenSmaAchmea:
        x: 400
        'y': 480
      generateUserOptions:
        x: 400
        'y': 320
      do_nothing:
        x: 520
        'y': 320
      http_client_post:
        x: 640
        'y': 320
        navigate:
          b87a8925-1167-5523-e43d-669240b12fd6:
            targetId: 31065ef8-9eb5-1c86-7ffc-aaf0a77bd3cf
            port: SUCCESS
    results:
      SUCCESS:
        31065ef8-9eb5-1c86-7ffc-aaf0a77bd3cf:
          x: 880
          'y': 320
