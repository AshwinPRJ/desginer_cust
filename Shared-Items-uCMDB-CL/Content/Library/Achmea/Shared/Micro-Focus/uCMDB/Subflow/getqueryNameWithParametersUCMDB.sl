namespace: Achmea.Shared.Micro-Focus.uCMDB.Subflow
flow:
  name: getqueryNameWithParametersUCMDB
  inputs:
    - uCMDB_queryName:
        prompt:
          type: text
    - uCMDB_QueryElementLabel:
        prompt:
          type: text
    - uCMDB_ConditionAttributeName:
        prompt:
          type: text
    - uCMDB_ConditionOperator:
        prompt:
          type: text
    - uCMDB_SearchValue:
        prompt:
          type: text
    - uCMDB_ChunkSize: '200'
    - search_Field:
        prompt:
          type: text
    - sso_Token:
        required: false
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_Token}'
        navigate:
          - IS_NULL: getAuthenticationTokenAchmea
          - IS_NOT_NULL: opGeneratePayLoadBodyQueryWithParametersUcmdb
    - opGeneratePayLoadBodyQueryWithParametersUcmdb:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Operation.opGeneratePayLoadBodyQueryWithParametersUcmdb:
            - uCMDB_queryName: '${uCMDB_queryName}'
            - uCMDB_QueryElementLabel: '${uCMDB_QueryElementLabel}'
            - uCMDB_ConditionAttributeName: '${uCMDB_ConditionAttributeName}'
            - uCMDB_ConditionOperator: '${uCMDB_ConditionOperator}'
            - uCMDB_SearchValue: '${uCMDB_SearchValue}'
        publish:
          - return_result
          - return_code
          - error_message
        navigate:
          - SUCCESS: http_client_post
          - FAILURE: FAILURE
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get_sp('MF.uCMDB.uCMDB_url') + '/rest-api/topology/queryNameWithParameters?chunkSize=' + uCMDB_ChunkSize}"
            - auth_type: anonymous
            - trust_all_roots: 'true'
            - headers: "${'Authorization: Bearer ' +  sso_Token}"
            - body: '${return_result}'
            - content_type: application/json
        publish:
          - sso_Token: '${error_message}'
          - return_result_Json: '${return_result}'
        navigate:
          - SUCCESS: getUcmdbJsonSearchCount
          - FAILURE: FAILURE
    - getUcmdbJsonSearchCount:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getUcmdbJsonSearchCount:
            - JsonResult: '${return_result_Json}'
        publish:
          - Count
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: FAILURE
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result_Json}'
            - json_path: $..ucmdbId
        publish:
          - uCMDBiD: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
    - getAuthenticationTokenAchmea:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getAuthenticationTokenAchmea: []
        publish:
          - sso_Token: '${token}'
          - error_message
          - return_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: opGeneratePayLoadBodyQueryWithParametersUcmdb
  outputs:
    - queryCount: '${return_result}'
    - return_code: '${return_code}'
    - JsonSearchResult: '${return_result_Json}'
    - queryResult: '${uCMDBiD[2:-2]}'
    - Count: '${Count}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      opGeneratePayLoadBodyQueryWithParametersUcmdb:
        x: 280
        'y': 40
        navigate:
          5c1b8145-9905-5622-1e0a-215550cd1f2c:
            targetId: faf88d95-cb80-2f32-77f5-e862c8a18d10
            port: FAILURE
      http_client_post:
        x: 720
        'y': 40
        navigate:
          a5863b03-c39e-d5e9-2083-618d60fc899d:
            targetId: faf88d95-cb80-2f32-77f5-e862c8a18d10
            port: FAILURE
      getUcmdbJsonSearchCount:
        x: 920
        'y': 200
        navigate:
          2bd07868-15e8-67cd-f8f0-550ae65a6bc4:
            targetId: faf88d95-cb80-2f32-77f5-e862c8a18d10
            port: FAILURE
      json_path_query:
        x: 720
        'y': 360
        navigate:
          abf4e673-a141-78d2-a33f-871a541d8d1a:
            targetId: 6b904ebd-84fe-857e-a4f8-fd5018898adc
            port: SUCCESS
          f59ad24d-775b-8f78-ced3-e422b0d84215:
            targetId: faf88d95-cb80-2f32-77f5-e862c8a18d10
            port: FAILURE
      is_null:
        x: 80
        'y': 40
      getAuthenticationTokenAchmea:
        x: 160
        'y': 240
    results:
      SUCCESS:
        6b904ebd-84fe-857e-a4f8-fd5018898adc:
          x: 960
          'y': 360
      FAILURE:
        faf88d95-cb80-2f32-77f5-e862c8a18d10:
          x: 280
          'y': 360
