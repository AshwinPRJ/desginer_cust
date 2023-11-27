namespace: Achmea.Shared.subFlows.SMA
flow:
  name: getEntityAchmea
  inputs:
    - entityType
    - entityID
    - entityFields
    - sso_Token:
        required: false
  workflow:
    - CheckToken_is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_Token}'
        navigate:
          - IS_NULL: getTokenSmaAchmea
          - IS_NOT_NULL: get_entity
    - get_entity:
        do:
          io.cloudslang.microfocus.service_management_automation_x.commons.get_entity:
            - saw_url: "${get_sp('Achmea.SMA.URL')}"
            - sso_token: '${sso_Token}'
            - tenant_id: "${get_sp('Achmea.SMA.Tentant')}"
            - entity_type: '${entityType}'
            - entity_id: '${entityID}'
            - fields: '${entityFields}'
            - trust_all_roots: "${get_sp('Achmea.SMA.trust_all_roots')}"
        publish:
          - entity_json
          - return_result
          - error_json
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
          - SUCCESS: get_entity
          - FAILURE: on_failure
  outputs:
    - entity_json: '${entity_json}'
    - return_result: '${return_result}'
    - error_json: '${error_json}'
  results:
    - SUCCESS
    - CUSTOM
    - FAILURE
extensions:
  graph:
    steps:
      CheckToken_is_null:
        x: 80
        'y': 80
      get_entity:
        x: 480
        'y': 160
        navigate:
          fe933cc5-892e-a242-4d2e-9c827d971861:
            targetId: 39421204-1a5d-8e1a-2faa-ac0062c1e14f
            port: FAILURE
          e92e96ce-5c39-b85a-f6a6-d614e95ad2ee:
            targetId: ff16fea6-f220-e3c3-ca65-016fac5ef338
            port: SUCCESS
          8010c19b-1a74-8ac3-4130-b08bc6783736:
            targetId: c6286ff5-e1e6-3db1-cb56-2674a3b524b3
            port: NO_RESULTS
      getTokenSmaAchmea:
        x: 280
        'y': 280
    results:
      SUCCESS:
        ff16fea6-f220-e3c3-ca65-016fac5ef338:
          x: 720
          'y': 40
      CUSTOM:
        c6286ff5-e1e6-3db1-cb56-2674a3b524b3:
          x: 720
          'y': 280
      FAILURE:
        39421204-1a5d-8e1a-2faa-ac0062c1e14f:
          x: 520
          'y': 400
