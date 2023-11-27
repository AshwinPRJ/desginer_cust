namespace: Subflows
flow:
  name: sma_createIncident
  inputs:
    - sso_token:
        required: false
    - fields
    - values
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_token}'
        navigate:
          - IS_NULL: getSmaToken
          - IS_NOT_NULL: createEntityAchmea
    - createEntityAchmea:
        do:
          Achmea.Shared.subFlows.SMA.createEntityAchmea:
            - sso_token: '${sso_token}'
            - entityType: Incident
            - fields: '${fields}'
            - values: '${values}'
        publish:
          - created_ID: '${created_id}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - getSmaToken:
        do:
          Achmea.Shared.subFlows.SMA.getSmaToken: []
        publish:
          - sso_token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: createEntityAchmea
  outputs:
    - created_Id: '${created_ID}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      is_null:
        x: 240
        'y': 240
      getSmaToken:
        x: 320
        'y': 400
      createEntityAchmea:
        x: 440
        'y': 240
        navigate:
          1a06a0f7-35b5-6c1e-ee74-0a1aa9f9abd3:
            targetId: 32e564f7-51c3-a679-8e1d-be5a21bc79ea
            port: SUCCESS
    results:
      SUCCESS:
        32e564f7-51c3-a679-8e1d-be5a21bc79ea:
          x: 640
          'y': 240
