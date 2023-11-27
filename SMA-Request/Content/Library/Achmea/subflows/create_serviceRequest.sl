namespace: Achmea.subflows
flow:
  name: create_serviceRequest
  inputs:
    - sso_token:
        required: false
    - DisplayLabel: "${get_sp('Request_DisplayLabel')}"
    - Description: "${get_sp('Request_Description')}"
    - Requester: "${get_sp('Request_Requester')}"
    - ActualService: "${get_sp('Request_ActualServer')}"
    - Request_Field: "${get_sp('ServiceRequest_Fields')}"
    - requestType: ServiceRequest
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
            - values: '${DisplayLabel +","+ Description +","+ Requester +","+ ActualService +","+ requestType}'
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
        x: 340
        'y': 380
      getTokenSmaAchmea:
        x: 460
        'y': 540
      createEntityAchmea:
        x: 560
        'y': 400
        navigate:
          0570f28c-d471-39ce-c044-6412a5371a53:
            targetId: 3712d0a3-1172-aeef-f96d-445f88cff2f2
            port: SUCCESS
    results:
      SUCCESS:
        3712d0a3-1172-aeef-f96d-445f88cff2f2:
          x: 720
          'y': 400
