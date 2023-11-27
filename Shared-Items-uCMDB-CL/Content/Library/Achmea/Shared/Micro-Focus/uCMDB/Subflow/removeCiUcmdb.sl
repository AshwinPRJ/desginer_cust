namespace: Achmea.Shared.Micro-Focus.uCMDB.Subflow
flow:
  name: removeCiUcmdb
  inputs:
    - removeUcmdbID
    - sso_Token:
        required: false
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_Token}'
        navigate:
          - IS_NULL: getAuthenticationTokenAchmea
          - IS_NOT_NULL: getUcmdbIDFromGlobalID
    - delete_configuration_item:
        do:
          io.cloudslang.microfocus.ucmdb.v1.data_model.ci.delete_configuration_item:
            - url: "${get_sp('MF.uCMDB.uCMDB_url')}"
            - token: '${sso_Token}'
            - configuration_item_id: '${removeUcmdbIDFinal}'
        publish:
          - return_result
          - result_code: '${return_code}'
          - error_message
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - getAuthenticationTokenAchmea:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getAuthenticationTokenAchmea: []
        publish:
          - sso_Token: '${token}'
        navigate:
          - FAILURE: FAILURE_1
          - SUCCESS: getUcmdbIDFromGlobalID
    - getUcmdbIDFromGlobalID:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getUcmdbIDFromGlobalID:
            - ssoToken: '${sso_Token}'
            - GlobalID: '${removeUcmdbID}'
        publish:
          - removeUcmdbIDFinal: '${ucmdb_id}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: delete_configuration_item
          - FAILURE: FAILURE_1
  outputs:
    - return_result: '${return_result}'
    - result_code: '${result_code}'
    - error_message: '${error_message}'
  results:
    - FAILURE
    - SUCCESS
    - FAILURE_1
extensions:
  graph:
    steps:
      is_null:
        x: 200
        'y': 40
      delete_configuration_item:
        x: 520
        'y': 160
        navigate:
          8ca541fc-17e3-6a98-f8ab-5ea14b835fa5:
            targetId: dad29363-101a-a557-0650-c7f0d7a97982
            port: SUCCESS
      getAuthenticationTokenAchmea:
        x: 120
        'y': 240
        navigate:
          ed75d1ba-867f-c60e-0442-5d6399249295:
            targetId: 85fac9de-1a6e-351d-5544-0698c1f55312
            port: FAILURE
      getUcmdbIDFromGlobalID:
        x: 360
        'y': 160
        navigate:
          cc4d4aa3-e1dc-923a-32d5-893aec98b49d:
            targetId: 85fac9de-1a6e-351d-5544-0698c1f55312
            port: FAILURE
    results:
      SUCCESS:
        dad29363-101a-a557-0650-c7f0d7a97982:
          x: 520
          'y': 360
      FAILURE_1:
        85fac9de-1a6e-351d-5544-0698c1f55312:
          x: 320
          'y': 360
