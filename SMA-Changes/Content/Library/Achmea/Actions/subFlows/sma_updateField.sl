namespace: Achmea.Actions.subFlows
flow:
  name: sma_updateField
  inputs:
    - sma_url: "${get_sp('Achmea.SMA.URL')}"
    - sma_password:
        sensitive: true
    - sma_userName
    - sma_tenantID: "${get_sp('Achmea.SMA.Tentant')}"
    - update_field
    - new_value
    - sma_entityType: Change
    - sma_entityId
  workflow:
    - SMA_Token:
        do:
          Achmea.Subflows.SMAx.SMA_Token:
            - smaUrl: '${sma_url}'
            - smaTennant: '${sma_tenantID}'
            - smaUser: '${sma_userName}'
            - smaPassw:
                value: '${sma_password}'
                sensitive: true
        publish:
          - smaToken: '${ssoToken}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: setProperties
    - setProperties:
        do:
          io.cloudslang.base.utils.do_nothing:
            - setJson: "${'{\"entity_type\":\"' + sma_entityType + '\",\"properties\": {\"Id\": \"' + sma_entityId + '\",\"' + update_field + '\": \"' + new_value + '\"}}'}"
        publish:
          - inputJson: '${setJson}'
        navigate:
          - SUCCESS: UpdateIdentity
          - FAILURE: FAILURE
    - UpdateIdentity:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${sma_url + '/rest/' + sma_tenantID + '/ems/bulk'}"
            - username: '${sma_userName}'
            - password:
                value: '${sma_password}'
                sensitive: true
            - trust_all_roots: 'true'
            - headers: '${("COOKIE:LWSSO_COOKIE_KEY=" + smaToken + ";TENANTID=" + sma_tenantID)}'
            - body: "${'{\"entities\": [' + inputJson + '], \"operation\": \"UPDATE\"}'}"
            - content_type: application/json
        publish:
          - updateResult: '${return_result}'
          - errorMessage: '${error_message}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      SMA_Token:
        x: 200
        'y': 240
        navigate:
          2c3e7bfb-546e-3e56-56f7-d7ac7011337a:
            targetId: e13e0e4c-ba34-b07f-6c46-ec3b85335df6
            port: FAILURE
      setProperties:
        x: 400
        'y': 240
        navigate:
          cbc6449f-e68e-5e57-e9b2-01fcd613dc7e:
            targetId: e13e0e4c-ba34-b07f-6c46-ec3b85335df6
            port: FAILURE
      UpdateIdentity:
        x: 600
        'y': 240
        navigate:
          953cf73d-6b7b-1d96-fffe-e158732a2349:
            targetId: 410f662d-c96f-a82c-a55f-01e61497674d
            port: SUCCESS
          17251b95-5afa-90b4-3b5e-eb33504256f2:
            targetId: e13e0e4c-ba34-b07f-6c46-ec3b85335df6
            port: FAILURE
    results:
      FAILURE:
        e13e0e4c-ba34-b07f-6c46-ec3b85335df6:
          x: 400
          'y': 480
      SUCCESS:
        410f662d-c96f-a82c-a55f-01e61497674d:
          x: 800
          'y': 240
