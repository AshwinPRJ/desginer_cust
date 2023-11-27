namespace: Achmea.Shared.Micro-Focus.uCMDB.Subflow
flow:
  name: getRelatedCIsUcmdb
  inputs:
    - getRelatedCIsUcmdbID
    - sso_Token:
        required: false
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_Token}'
        navigate:
          - IS_NULL: getAuthenticationTokenAchmea
          - IS_NOT_NULL: get_configuration_item_related_ci
    - get_configuration_item_related_ci:
        do:
          io.cloudslang.microfocus.ucmdb.v1.data_model.ci.get_configuration_item_related_ci:
            - url: "${get_sp('MF.uCMDB.uCMDB_url')}"
            - token: '${sso_Token}'
            - configuration_item_id: '${getRelatedCIsUcmdbID}'
            - is_global_id: 'False'
            - trust_all_roots: 'True'
        publish:
          - return_result
          - return_code
          - status_code
          - error_message
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: xpath_query
    - getAuthenticationTokenAchmea:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getAuthenticationTokenAchmea: []
        publish:
          - sso_Token: '${token}'
          - error_message
          - return_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_configuration_item_related_ci
    - xpath_query:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${return_result}'
            - xpath_query: //end1Id
            - query_type: value
        publish:
          - ids: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - return_code: '${return_code}'
    - return_result: '${return_result}'
    - status_code: '${status_code}'
    - error_message: '${error_message}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_null:
        x: 80
        'y': 200
      get_configuration_item_related_ci:
        x: 440
        'y': 200
        navigate:
          4bdf71ab-bba9-5044-d0f6-08b22abcee97:
            targetId: 17af12a9-54d5-79be-859a-d3350a09b35d
            port: FAILURE
      getAuthenticationTokenAchmea:
        x: 200
        'y': 360
      xpath_query:
        x: 640
        'y': 200
        navigate:
          e16b75a9-0e78-dbe5-b05b-109e6a1d49d3:
            targetId: b19e05da-dfde-285e-dbd1-64fc28d9b60e
            port: SUCCESS
          055d8a96-d4c0-2ad3-472d-8210bfa9945b:
            targetId: 17af12a9-54d5-79be-859a-d3350a09b35d
            port: FAILURE
    results:
      FAILURE:
        17af12a9-54d5-79be-859a-d3350a09b35d:
          x: 440
          'y': 480
      SUCCESS:
        b19e05da-dfde-285e-dbd1-64fc28d9b60e:
          x: 640
          'y': 360
