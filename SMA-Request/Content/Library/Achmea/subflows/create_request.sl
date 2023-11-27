namespace: Achmea.subflows
flow:
  name: create_request
  inputs:
    - sso_token:
        required: false
    - DisplayLabel: "${get_sp('Request_DisplayLabel')}"
    - Description: "${get_sp('Request_Description')}"
    - Requester: "${get_sp('Request_Requester')}"
    - ActualService: "${get_sp('Request_ActualServer')}"
    - Request_Field: "${get_sp('Request_Fields')}"
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_token}'
        navigate:
          - IS_NULL: getTokenSmaAchmea
          - IS_NOT_NULL: createEntityAchmea
    - getTokenSmaAchmea:
        do:
          Achmea.Shared.subFlows.SMA.getTokenSmaAchmea: []
        publish:
          - sso_token: '${sso_Token}'
        navigate:
          - SUCCESS: createEntityAchmea
          - FAILURE: on_failure
    - createEntityAchmea:
        do:
          Achmea.Shared.subFlows.SMA.createEntityAchmea:
            - sso_token: '${sso_token}'
            - entityType: Request
            - fields: '${Request_Field}'
            - values: '${DisplayLabel +","+ Description +","+ Requester +","+ ActualService}'
        publish:
          - created_id
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - created_id: '${created_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_null:
        x: 320
        'y': 360
      getTokenSmaAchmea:
        x: 440
        'y': 520
      createEntityAchmea:
        x: 640
        'y': 360
        navigate:
          2a70a498-ec18-69d9-dbc8-9fd8aa2935f8:
            targetId: 02b8a6d4-6d56-ba7b-26b3-93c3b2683af4
            port: SUCCESS
    results:
      SUCCESS:
        02b8a6d4-6d56-ba7b-26b3-93c3b2683af4:
          x: 840
          'y': 360
