namespace: Achmea.Shared.Subflow
flow:
  name: updatePipelineRequest
  inputs:
    - sma_requestId: '4424725'
    - field: RC2_c
    - value: Succes
    - smaUrl:
        default: 'https://sma.preview.hosting.corp/'
        required: false
    - smaTennant:
        default: '781313141'
        required: false
    - smaToken:
        required: false
  workflow:
    - getSmaToken:
        do:
          Achmea.Shared.subFlows.SMA.getSmaToken:
            - smaUrl: 'https://sma.preview.hosting.corp'
            - smaTennant: '781313141'
            - smaUser: Admin
            - smaPassw: FalconAchmea1?Q
        publish:
          - smaToken: '${sso_token}'
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
            - headers: '${("COOKIE:LWSSO_COOKIE_KEY=" + smaToken + ";TENANTID=" + smaTennant)}'
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
      http_client_post:
        x: 720
        'y': 280
        navigate:
          ca27b367-9ffc-8892-2e8c-a71807b36dfd:
            targetId: 469a16d4-b901-889c-7c98-c8247dcf90d9
            port: SUCCESS
      generateUserOptions:
        x: 400
        'y': 280
      do_nothing:
        x: 560
        'y': 280
      getSmaToken:
        x: 240
        'y': 280
    results:
      SUCCESS:
        469a16d4-b901-889c-7c98-c8247dcf90d9:
          x: 840
          'y': 280
