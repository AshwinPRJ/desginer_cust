namespace: Achmea.Subflows
flow:
  name: ConceptSMAx
  workflow:
    - getTokenSmaAchmea:
        do:
          Achmea.Shared.subFlows.SMA.getTokenSmaAchmea: []
        publish:
          - sso_Token
        navigate:
          - SUCCESS: update_request
          - FAILURE: on_failure
    - update_request:
        do:
          io.cloudslang.microfocus.service_management_automation_x.requests.update_request:
            - saw_url: "${get_sp('Achmea.SMA.URL')}"
            - sso_token: '${sso_Token}'
            - tenant_id: "${get_sp('Achmea.SMA.Tentant')}"
            - entity_id: '4424725'
            - request_properties: "${'\"UserOptions\":\"{\\\"complexTypeProperties\\\":[{' + '\\\"properties\\\":{\\\"RC1_c\\\":\\\"' + 'Tafel' + '\\\"}}]}\"'}"
        navigate:
          - FAILURE: FAILURE_1
          - SUCCESS: SUCCESS
  results:
    - FAILURE_1
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      update_request:
        x: 360
        'y': 80
        navigate:
          b5dd35c3-4b77-c48d-d1b2-c3f9af019f89:
            targetId: 853d7215-4a36-9dbc-083c-fe27b0b21a63
            port: SUCCESS
          7957f1f9-427c-79d0-0b01-f0f2d90b18c8:
            targetId: 76de0ee0-ea80-073f-ef0d-48e061ba6b26
            port: FAILURE
      getTokenSmaAchmea:
        x: 160
        'y': 80
    results:
      FAILURE_1:
        76de0ee0-ea80-073f-ef0d-48e061ba6b26:
          x: 400
          'y': 240
      SUCCESS:
        853d7215-4a36-9dbc-083c-fe27b0b21a63:
          x: 600
          'y': 80
