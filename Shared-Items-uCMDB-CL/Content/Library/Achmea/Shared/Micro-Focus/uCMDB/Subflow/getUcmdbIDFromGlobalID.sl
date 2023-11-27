########################################################################################################################
#!!
#! @description: This flow will give the UcmdbID as output. When relate a CI or do other updates you need the Ucmdb and not the global id to perform this.
#!               The GlobalID is the ID you will get from a external application with an integration with Ucmdb.
#!!#
########################################################################################################################
namespace: Achmea.Shared.Micro-Focus.uCMDB.Subflow
flow:
  name: getUcmdbIDFromGlobalID
  inputs:
    - sso_Token:
        required: false
    - GlobalID
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_Token}'
        publish: []
        navigate:
          - IS_NULL: getAuthenticationTokenAchmea
          - IS_NOT_NULL: getUcmdbCIData
    - getUcmdbCIData:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getUcmdbCIData:
            - ucmdbID: '${GlobalID}'
            - sso_Token: '${sso_Token}'
            - is_global_id: 'True'
        publish:
          - JsonCIDataList
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: FAILURE
    - getAuthenticationTokenAchmea:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getAuthenticationTokenAchmea: []
        publish:
          - sso_Token: '${token}'
          - error_message
          - return_code
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: getUcmdbCIData
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${JsonCIDataList}'
            - json_path: $..ucmdbId
        publish:
          - return_result
        navigate:
          - SUCCESS: getCIValueJSON
          - FAILURE: FAILURE
    - getCIValueJSON:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Operation.getCIValueJSON:
            - JSONSubset: '${return_result}'
        publish:
          - ucmdb_id: '${return_result}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - ucmdb_id: '${ucmdb_id}'
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
      getUcmdbCIData:
        x: 520
        'y': 80
        navigate:
          111635b6-8a0e-e6e4-6c7c-1847e101181e:
            targetId: b7bf7863-a850-2f4b-0ec2-f9336ed492a1
            port: FAILURE
      getAuthenticationTokenAchmea:
        x: 360
        'y': 240
        navigate:
          72a18dd8-6815-48f0-469f-860015ec791c:
            targetId: b7bf7863-a850-2f4b-0ec2-f9336ed492a1
            port: FAILURE
      json_path_query:
        x: 680
        'y': 80
        navigate:
          041909ab-5ce0-1b68-166e-d197ff8411af:
            targetId: b7bf7863-a850-2f4b-0ec2-f9336ed492a1
            port: FAILURE
      getCIValueJSON:
        x: 680
        'y': 240
        navigate:
          3632b9bf-6dd4-1020-d3cd-de8b1600f6db:
            targetId: b7bf7863-a850-2f4b-0ec2-f9336ed492a1
            port: FAILURE
          5221455f-f353-33ec-b954-f771b3d034b5:
            targetId: e171af24-bf07-2094-d24b-6ea5b0e3fe28
            port: SUCCESS
    results:
      SUCCESS:
        e171af24-bf07-2094-d24b-6ea5b0e3fe28:
          x: 680
          'y': 400
      FAILURE:
        b7bf7863-a850-2f4b-0ec2-f9336ed492a1:
          x: 520
          'y': 400
