namespace: Achmea.Shared.Micro-Focus.uCMDB.Subflow
flow:
  name: getUcmdbCIData
  inputs:
    - ucmdbID
    - is_global_id
    - sso_Token:
        required: false
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_Token}'
        publish: []
        navigate:
          - IS_NULL: getAuthenticationTokenAchmea
          - IS_NOT_NULL: get_configuration_item
    - getAuthenticationTokenAchmea:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getAuthenticationTokenAchmea:
            - uCMDB_url: '${uCMDB_url}'
            - uCMDB_User: '${userName}'
            - uCMDB_PW:
                value: '${userPassword}'
                sensitive: true
        publish:
          - sso_Token: '${token}'
          - error_message
          - return_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_configuration_item
    - get_configuration_item:
        do:
          io.cloudslang.microfocus.ucmdb.v1.data_model.ci.get_configuration_item:
            - url: "${get_sp('MF.uCMDB.uCMDB_url')}"
            - token: '${sso_Token}'
            - configuration_item_id: '${ucmdbID}'
            - include_attributes_qualifiers: 'False'
            - is_global_id: '${is_global_id}'
            - trust_all_roots: 'True'
        publish:
          - return_result
          - return_code
          - error_message
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
  outputs:
    - JsonCIDataList: '${return_result}'
    - return_code: '${return_code}'
    - error_message: '${error_message}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      is_null:
        x: 120
        'y': 80
      getAuthenticationTokenAchmea:
        x: 120
        'y': 320
      get_configuration_item:
        x: 600
        'y': 80
        navigate:
          3cfacd48-34ab-c139-cb9a-532c847099f0:
            targetId: e4ec4d7f-3236-6374-3962-bced486cf01d
            port: FAILURE
          e86fc01c-6b83-ae72-7628-e86e20b70e79:
            targetId: f33d032f-2348-3cc0-35a0-845d7588fa37
            port: SUCCESS
    results:
      SUCCESS:
        f33d032f-2348-3cc0-35a0-845d7588fa37:
          x: 800
          'y': 80
      FAILURE:
        e4ec4d7f-3236-6374-3962-bced486cf01d:
          x: 440
          'y': 280
