namespace: Achmea.Shared.subFlows.SMA
flow:
  name: createEntityAchmea
  inputs:
    - json_body:
        required: false
    - sso_token:
        required: false
    - entityType
    - fields
    - splitter:
        default: ','
        required: false
    - values
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_token}'
        navigate:
          - IS_NULL: getTokenSmaAchmea
          - IS_NOT_NULL: setJsonCreateEntity
    - create_entity:
        do:
          io.cloudslang.microfocus.service_management_automation_x.commons.create_entity:
            - saw_url: "${get_sp('Achmea.SMA.URL')}"
            - sso_token: '${sso_token}'
            - tenant_id: "${get_sp('Achmea.SMA.Tentant')}"
            - json_body: '${json_body}'
            - trust_all_roots: "${get_sp('Achmea.SMA.trust_all_roots')}"
            - x509_hostname_verifier: "${get_sp('Achmea.SMA.x509_hostname_verifier')}"
        publish:
          - created_id
          - entity_json
          - error_json
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
    - getTokenSmaAchmea:
        do:
          Achmea.Shared.subFlows.SMA.getTokenSmaAchmea: []
        publish:
          - sso_token: '${sso_Token}'
        navigate:
          - SUCCESS: setJsonCreateEntity
          - FAILURE: FAILURE
    - setJsonCreateEntity:
        do:
          Achmea.Shared.Operations.setJsonCreateEntity:
            - entityType: '${entityType}'
            - fields: '${fields}'
            - values: '${values}'
            - splitter: '${splitter}'
        publish:
          - json_body: '${JsonCreateEntity}'
        navigate:
          - SUCCESS: create_entity
          - FAILURE: on_failure
  outputs:
    - created_id: '${created_id}'
    - entity_json: '${entity_json}'
    - error_json: '${error_json}'
    - return_result: '${return_result}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      is_null:
        x: 80
        'y': 160
      create_entity:
        x: 600
        'y': 160
        navigate:
          400d4f82-cfd1-b165-dbad-fd8d87dabb2d:
            targetId: 83fb681e-0a74-3b1a-5573-8da20561a284
            port: FAILURE
          df7c899f-8c76-c091-d77b-58965ae78809:
            targetId: adcfd7cb-4c07-ae94-3649-aed3bcc9b0b5
            port: SUCCESS
      getTokenSmaAchmea:
        x: 240
        'y': 320
        navigate:
          f07f5326-41a2-daed-7010-8fc2479edd50:
            targetId: 83fb681e-0a74-3b1a-5573-8da20561a284
            port: FAILURE
      setJsonCreateEntity:
        x: 400
        'y': 160
    results:
      SUCCESS:
        adcfd7cb-4c07-ae94-3649-aed3bcc9b0b5:
          x: 720
          'y': 160
      FAILURE:
        83fb681e-0a74-3b1a-5573-8da20561a284:
          x: 440
          'y': 440
