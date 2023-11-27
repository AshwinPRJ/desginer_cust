namespace: Achmea.Shared.Micro-Focus.uCMDB.Subflow
flow:
  name: removeRelationUcmdb
  inputs:
    - FromID
    - ToID
    - RelationType
    - ssoToken:
        required: false
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${ssoToken}'
        navigate:
          - IS_NULL: getAuthenticationTokenAchmea
          - IS_NOT_NULL: getUcmdbCIData
    - getAuthenticationTokenAchmea:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getAuthenticationTokenAchmea: []
        publish:
          - ssoToken: '${token}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: getUcmdbCIData
    - getqueryNameWithParametersUCMDB:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getqueryNameWithParametersUCMDB:
            - uCMDB_url: '${uCMDB_url}'
            - uCMDB_User: '${userName}'
            - uCMDB_PW:
                value: '${userPassword}'
                sensitive: true
            - uCMDB_queryName: ait_GetRelationsFromCI
            - uCMDB_QueryElementLabel: FROM_ID
            - uCMDB_ConditionAttributeName: name
            - uCMDB_ConditionOperator: equals
            - uCMDB_SearchValue: '${FromName}'
            - search_Field: global_Id
        publish:
          - queryCount
          - return_code
          - JsonSearchResult
        navigate:
          - SUCCESS: Get_Relations_json_path_query
          - FAILURE: FAILURE
    - Get_Relations_json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${JsonSearchResult}'
            - json_path: $..relations
        publish:
          - JSON_Relations: '${return_result}'
        navigate:
          - SUCCESS: getUcmdbRelationID
          - FAILURE: FAILURE
    - getUcmdbRelationID:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Operation.getUcmdbRelationID:
            - JSON_Input: '${JSON_Relations}'
            - SearchID: '${ToID}'
        publish:
          - uCMDBRelationID: '${return_result}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: delete_configuration_item_relation
          - FAILURE: FAILURE
    - delete_configuration_item_relation:
        do:
          io.cloudslang.microfocus.ucmdb.v1.data_model.relation.delete_configuration_item_relation:
            - url: '${uCMDB_url}'
            - token: '${ssoToken}'
            - configuration_item_relation_id: '${uCMDBRelationID}'
            - is_global_id: 'False'
            - trust_all_roots: 'True'
        publish:
          - Result: '${return_result}'
          - Result_Code: '${return_code}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
    - getUcmdbCIData:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getUcmdbCIData:
            - ssoToken: '${ssoToken}'
            - ucmdbID: '${FromID}'
            - is_global_id: 'True'
        publish:
          - CI_Fields_JSON: '${JsonCIDataList}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: FAILURE
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${CI_Fields_JSON}'
            - json_path: $..name
        publish:
          - FromNameRaw: '${return_result}'
        navigate:
          - SUCCESS: aitFilterStringValue
          - FAILURE: FAILURE
    - aitFilterStringValue:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Operation.aitFilterStringValue:
            - StringValue: '${FromNameRaw}'
            - LeftRemove: '2'
            - RightRemove: '2'
        publish:
          - FromName: '${return_result}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: getqueryNameWithParametersUCMDB
          - FAILURE: FAILURE
  outputs:
    - Result_Code: '${Result_Code}'
    - Result: '${Result}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      json_path_query:
        x: 280
        'y': 80
        navigate:
          b479cf5d-7cd4-18a5-48e4-7c125f0307e6:
            targetId: ed73c49b-61a5-0f07-0c56-874501538266
            port: FAILURE
      delete_configuration_item_relation:
        x: 1040
        'y': 80
        navigate:
          df79e3e1-f3aa-9090-60d3-143a8932dd21:
            targetId: ed73c49b-61a5-0f07-0c56-874501538266
            port: FAILURE
          044c659d-2ff9-e40b-c6ad-390930188ae2:
            targetId: d8067e4a-10a1-7e68-0d48-39ef50117c5e
            port: SUCCESS
      getAuthenticationTokenAchmea:
        x: 40
        'y': 360
        navigate:
          37cab971-721a-f65d-9f65-ee6fa4408258:
            targetId: ed73c49b-61a5-0f07-0c56-874501538266
            port: FAILURE
      getqueryNameWithParametersUCMDB:
        x: 560
        'y': 80
        navigate:
          71c31aef-7d8a-8e11-b5f2-853e40776694:
            targetId: ed73c49b-61a5-0f07-0c56-874501538266
            port: FAILURE
      Get_Relations_json_path_query:
        x: 760
        'y': 80
        navigate:
          e37b1d5f-8199-0411-34e5-8f6b0fea0ea9:
            targetId: ed73c49b-61a5-0f07-0c56-874501538266
            port: FAILURE
      getUcmdbCIData:
        x: 160
        'y': 80
        navigate:
          fcd4bfbc-8a8b-c651-d5fd-43c46598bf7b:
            targetId: ed73c49b-61a5-0f07-0c56-874501538266
            port: FAILURE
      aitFilterStringValue:
        x: 440
        'y': 80
        navigate:
          9b03fc2a-50b2-324e-1bec-eb99903c902d:
            targetId: ed73c49b-61a5-0f07-0c56-874501538266
            port: FAILURE
      is_null:
        x: 40
        'y': 80
      getUcmdbRelationID:
        x: 880
        'y': 80
        navigate:
          6a38c89a-bc96-8ae8-d79a-813d38e0e53a:
            targetId: ed73c49b-61a5-0f07-0c56-874501538266
            port: FAILURE
    results:
      FAILURE:
        ed73c49b-61a5-0f07-0c56-874501538266:
          x: 560
          'y': 400
      SUCCESS:
        d8067e4a-10a1-7e68-0d48-39ef50117c5e:
          x: 760
          'y': 360
