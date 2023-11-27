namespace: Achmea.subflows
flow:
  name: update_request
  inputs:
    - sso_token:
        required: false
    - request_field: CompletionCode
    - value: CompletionCodeFulfilled
    - request_id: '2639514'
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_token}'
        navigate:
          - IS_NULL: getTokenSmaAchmea
          - IS_NOT_NULL: updateEntityAchmea
    - getTokenSmaAchmea:
        do:
          Achmea.Shared.subFlows.SMA.getTokenSmaAchmea: []
        publish:
          - sso_token: '${sso_Token}'
        navigate:
          - SUCCESS: updateEntityAchmea
          - FAILURE: on_failure
    - updateEntityAchmea:
        do:
          Achmea.Shared.subFlows.SMA.updateEntityAchmea:
            - sso_token: '${sso_token}'
            - entityType: Request
            - field: '${request_field}'
            - entityID: '${request_id}'
            - value: '${value}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_null:
        x: 200
        'y': 320
      getTokenSmaAchmea:
        x: 320
        'y': 480
      updateEntityAchmea:
        x: 400
        'y': 320
        navigate:
          c37298da-6c8c-4be3-d003-c2fd601a7c99:
            targetId: 2c87c461-5fb7-f094-eb85-63f8953d1f01
            port: SUCCESS
    results:
      SUCCESS:
        2c87c461-5fb7-f094-eb85-63f8953d1f01:
          x: 600
          'y': 320
