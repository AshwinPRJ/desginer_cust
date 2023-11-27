namespace: Achmea.Shared.subFlows.SMA
flow:
  name: queryEntityAchmea
  inputs:
    - entity_type
    - query
    - fields
    - sso_Token:
        required: false
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_Token}'
        navigate:
          - IS_NULL: getTokenSmaAchmea
          - IS_NOT_NULL: query_entities
    - query_entities:
        do:
          io.cloudslang.microfocus.service_management_automation_x.commons.query_entities:
            - saw_url: "${get_sp('Achmea.SMA.URL')}"
            - sso_token: '${sso_Token}'
            - tenant_id: "${get_sp('Achmea.SMA.Tentant')}"
            - entity_type: '${entity_type}'
            - query: '${query}'
            - fields: '${fields}'
            - trust_all_roots: "${get_sp('Achmea.SMA.trust_all_roots')}"
            - x509_hostname_verifier: "${get_sp('Achmea.SMA.x509_hostname_verifier')}"
        publish:
          - entity_json
          - error_json
          - return_result
          - result_count
          - sso_Token: '${sso_token}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
          - NO_RESULTS: CUSTOM
    - getTokenSmaAchmea:
        do:
          Achmea.Shared.subFlows.SMA.getTokenSmaAchmea: []
        publish:
          - sso_Token
          - status_Code
          - exception
        navigate:
          - SUCCESS: query_entities
          - FAILURE: FAILURE
  outputs:
    - entity_json: '${entity_json}'
    - return_result: '${return_result}'
    - error_json: '${error_json}'
    - result_count: '${result_count}'
  results:
    - FAILURE
    - SUCCESS
    - CUSTOM
extensions:
  graph:
    steps:
      is_null:
        x: 40
        'y': 120
      query_entities:
        x: 520
        'y': 80
        navigate:
          55eda637-0b4c-ea91-ce5f-c4b93794ffee:
            targetId: 14008736-cc34-d838-01ed-5f59a6b398fb
            port: FAILURE
          81482740-8d44-8dd9-2628-6f88b54a77b9:
            targetId: 3941b235-030b-96e1-3154-ed7ab4a92c85
            port: SUCCESS
          2be66200-d5e4-6789-03fe-4d59f954de4a:
            targetId: 172b28be-5ebb-1f81-a706-1827280c6a3c
            port: NO_RESULTS
      getTokenSmaAchmea:
        x: 320
        'y': 280
        navigate:
          bbb37e94-de0f-9fba-d06b-b1b2f2732f24:
            targetId: 14008736-cc34-d838-01ed-5f59a6b398fb
            port: FAILURE
    results:
      FAILURE:
        14008736-cc34-d838-01ed-5f59a6b398fb:
          x: 560
          'y': 320
      SUCCESS:
        3941b235-030b-96e1-3154-ed7ab4a92c85:
          x: 680
          'y': 200
      CUSTOM:
        172b28be-5ebb-1f81-a706-1827280c6a3c:
          x: 720
          'y': 40
