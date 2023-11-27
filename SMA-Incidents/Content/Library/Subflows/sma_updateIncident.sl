namespace: Subflows
flow:
  name: sma_updateIncident
  inputs:
    - sso_token:
        required: false
    - entityType:
        default: Incident
        required: false
    - entityId
    - field
    - value
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_token}'
        navigate:
          - IS_NULL: getSmaToken
          - IS_NOT_NULL: updateEntityAchmea
    - updateEntityAchmea:
        do:
          Achmea.Shared.subFlows.SMA.updateEntityAchmea:
            - sso_token: '${sso_token}'
            - entityType: '${entityType}'
            - field: '${field}'
            - entityID: '${entityId}'
            - value: '${value}'
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
          - SUCCESS: updateEntityAchmea
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      is_null:
        x: 260
        'y': 260
      getSmaToken:
        x: 360
        'y': 400
      updateEntityAchmea:
        x: 480
        'y': 240
        navigate:
          4496f8f9-4009-71ef-a068-1862f569553a:
            targetId: 713d0229-7f5b-1b6c-8647-d9075447c4d9
            port: SUCCESS
    results:
      SUCCESS:
        713d0229-7f5b-1b6c-8647-d9075447c4d9:
          x: 600
          'y': 240
