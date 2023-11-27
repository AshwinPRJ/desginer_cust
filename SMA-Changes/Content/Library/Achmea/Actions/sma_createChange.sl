namespace: Achmea.Actions
flow:
  name: sma_createChange
  inputs:
    - sma_url: "${get_sp('Achmea.SMA.URL')}"
    - sma_tenantID: "${get_sp('Achmea.SMA.Tentant')}"
    - fields
    - values
    - sso_token:
        required: false
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_token}'
        navigate:
          - IS_NULL: SMA_Token
          - IS_NOT_NULL: createEntityAchmea
    - SMA_Token:
        do:
          Achmea.Subflows.SMAx.SMA_Token:
            - smaUrl: '${sma_url}'
            - smaTennant: '${sma_tenantID}'
            - smaUser: "${get_sp('Achmea.SMA.User')}"
            - smaPassw:
                value: "${get_sp('Achmea.SMA.Password')}"
                sensitive: true
        publish:
          - sso_token: '${ssoToken}'
          - errorMessage
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: createEntityAchmea
    - createEntityAchmea:
        do:
          Achmea.Shared.subFlows.SMA.createEntityAchmea:
            - sso_token: '${sso_token}'
            - entityType: Change
            - fields: '${fields}'
            - values: '${values}'
        publish:
          - json: '${entity_json}'
          - changeId: '${created_id}'
          - error: '${error_json}'
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - created_ID: '${changeId}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_null:
        x: 280
        'y': 160
      SMA_Token:
        x: 320
        'y': 320
        navigate:
          a67c1d1c-665c-4f69-fe71-0a574a31bb44:
            targetId: cc9e475d-b441-778b-4985-e8a6056d8625
            port: FAILURE
      createEntityAchmea:
        x: 480
        'y': 200
        navigate:
          4c1c3a6d-8433-e18e-e169-9500fb15cdd1:
            targetId: 9452995d-0daf-c596-420d-f5c0fb1669b0
            port: SUCCESS
          12e666ee-71a2-4c28-ce2f-27d709f35555:
            targetId: cc9e475d-b441-778b-4985-e8a6056d8625
            port: FAILURE
    results:
      FAILURE:
        cc9e475d-b441-778b-4985-e8a6056d8625:
          x: 640
          'y': 320
      SUCCESS:
        9452995d-0daf-c596-420d-f5c0fb1669b0:
          x: 640
          'y': 160
