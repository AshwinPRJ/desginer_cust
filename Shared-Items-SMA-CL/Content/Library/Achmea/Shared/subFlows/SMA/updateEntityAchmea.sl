namespace: Achmea.Shared.subFlows.SMA
flow:
  name: updateEntityAchmea
  inputs:
    - sso_token:
        required: false
    - jsonBody:
        required: false
    - entityType
    - field
    - entityID
    - value
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_token}'
        navigate:
          - IS_NULL: getTokenSmaAchmea
          - IS_NOT_NULL: setJsonUpdateEntity
    - getTokenSmaAchmea:
        do:
          Achmea.Shared.subFlows.SMA.getTokenSmaAchmea: []
        publish:
          - sso_token: '${sso_Token}'
        navigate:
          - SUCCESS: setJsonUpdateEntity
          - FAILURE: FAILURE
    - update_entities:
        do:
          io.cloudslang.microfocus.service_management_automation_x.commons.update_entities:
            - saw_url: "${get_sp('Achmea.SMA.URL')}"
            - sso_token: '${sso_token}'
            - tenant_id: "${get_sp('Achmea.SMA.Tentant')}"
            - json_body: '${jsonBody}'
            - trust_all_roots: "${get_sp('Achmea.SMA.trust_all_roots')}"
            - x509_hostname_verifier: "${get_sp('Achmea.SMA.x509_hostname_verifier')}"
        publish:
          - return_result
          - error_json
          - op_status
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
    - setJsonUpdateEntity:
        do:
          Achmea.Shared.Operations.setJsonUpdateEntity:
            - entityType: '${entityType}'
            - entityID: '${entityID}'
            - field: '${field}'
            - value: '${value}'
        publish:
          - jsonBody: '${JsonUpdateEntity}'
        navigate:
          - SUCCESS: update_entities
  outputs:
    - return_result: '${return_result}'
    - error_json: '${error_json}'
    - op_status: '${op_status}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      is_null:
        x: 80
        'y': 80
      getTokenSmaAchmea:
        x: 120
        'y': 280
        navigate:
          4be2c13d-dba3-20b8-4830-34847c7200a9:
            targetId: e4dfeb72-49a8-6cd9-5a11-701c44ec1814
            port: FAILURE
      update_entities:
        x: 440
        'y': 120
        navigate:
          ae8df318-10e4-7eee-a686-fa7aafa18ea8:
            targetId: e958b691-122c-c105-6d91-3aeee326310a
            port: SUCCESS
          aa9e69a3-6c11-4abc-ae44-6f86d7c31c0e:
            targetId: e4dfeb72-49a8-6cd9-5a11-701c44ec1814
            port: FAILURE
      setJsonUpdateEntity:
        x: 280
        'y': 120
    results:
      SUCCESS:
        e958b691-122c-c105-6d91-3aeee326310a:
          x: 640
          'y': 120
      FAILURE:
        e4dfeb72-49a8-6cd9-5a11-701c44ec1814:
          x: 480
          'y': 280
