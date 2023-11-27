########################################################################################################################
#!!
#! @description: This flow will create a new uCMDB relationship between two CI's. Inputs are the relationship type, the fromId (relation from CI) and toId (relation to CI).
#!!#
########################################################################################################################
namespace: Achmea.Shared.Micro-Focus.uCMDB.Subflow
flow:
  name: createRelationUCMDB_old
  inputs:
    - relationType
    - fromId
    - toId
    - force_temporary_id
    - ignore_existing
    - is_global
    - update_if_exact_match
    - is_global_id
    - with_icons
    - include_attributes_qualifiers
    - export_format
    - sso_Token:
        required: false
  workflow:
    - getQueryParametersUcmdbRelateCI:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Operation.getQueryParametersUcmdbRelateCI:
            - force_temporary_id: '${force_temporary_id}'
            - ignore_existing: '${ignore_existing}'
            - is_global: '${is_global}'
            - update_if_exact_match: '${update_if_exact_match}'
            - is_global_id: '${is_global_id}'
            - with_icons: '${with_icons}'
            - include_attributes_qualifiers: '${include_attributes_qualifiers}'
            - export_format: '${export_format}'
        publish:
          - query_params
          - return_code
          - error_message
        navigate:
          - SUCCESS: is_null
          - FAILURE: FAILURE
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_Token}'
        publish: []
        navigate:
          - IS_NULL: getAuthenticationTokenAchmea
          - IS_NOT_NULL: getUcmdbIDFromGlobalIDFROM
    - getAuthenticationTokenAchmea:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getAuthenticationTokenAchmea: []
        publish:
          - sso_Token: '${token}'
          - error_message
          - return_code
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: getUcmdbIDFromGlobalIDFROM
    - create_relation:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get_sp('MF.uCMDB.uCMDB_url') + '/rest-api/dataModel'}"
            - auth_type: anonymous
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - headers: "${'Authorization: Bearer ' + sso_Token}"
            - query_params: '${query_params}'
            - body: "${'{\"cis\":[],\"relations\":[{\"type\":\"' + relationType + '\",\"end1Id\":\"' + from_ucmdb_id + '\",\"end2Id\":\"' + toId + '\",\"properties\":{}}]}'}"
            - content_type: application/json
        publish:
          - return_code
          - status_code
          - response_headers
          - error_message
          - trust_all_roots: 'true'
          - output_0: output_0
          - return_result
        navigate:
          - SUCCESS: id_extractor
          - FAILURE: FAILURE
    - id_extractor:
        do:
          io.cloudslang.microfocus.ucmdb.v1.utils.id_extractor:
            - data: '${return_result}'
        publish:
          - ignored_cis
          - return_code
          - error_message
          - added_cis
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
    - getUcmdbIDFromGlobalIDFROM:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getUcmdbIDFromGlobalID:
            - sso_Token: '${sso_Token}'
            - GlobalID: '${fromId}'
        publish:
          - from_ucmdb_id: '${ucmdb_id}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: getUcmdbIDFromGlobalIDTO
          - FAILURE: FAILURE
    - getUcmdbIDFromGlobalIDTO:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getUcmdbIDFromGlobalID:
            - sso_Token: '${sso_Token}'
            - GlobalID: '${toId}'
        publish:
          - to_ucmdb_id: '${ucmdb_id}'
          - return_code
        navigate:
          - SUCCESS: create_relation
          - FAILURE: FAILURE
  outputs:
    - newRelationId: '${added_cis}'
    - error_message: '${error_message}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      getQueryParametersUcmdbRelateCI:
        x: 40
        'y': 240
        navigate:
          acad19da-fa87-71d5-23e5-01232f95ba3b:
            targetId: 404a6a07-8e37-d9cf-f701-d7f93e5c2945
            port: FAILURE
      is_null:
        x: 200
        'y': 40
      getAuthenticationTokenAchmea:
        x: 192
        'y': 243.23748779296875
        navigate:
          d84d90b7-bb5e-97d1-c96c-195d51b4fa64:
            targetId: 404a6a07-8e37-d9cf-f701-d7f93e5c2945
            port: FAILURE
      create_relation:
        x: 680
        'y': 240
        navigate:
          ddf145bc-f963-585c-d982-62d58b91d469:
            targetId: 404a6a07-8e37-d9cf-f701-d7f93e5c2945
            port: FAILURE
      id_extractor:
        x: 920
        'y': 240
        navigate:
          ecc09e39-d013-2c49-9612-b6b47a4816a6:
            targetId: 7e6fdac2-f181-1ee6-b245-d13af0320f36
            port: SUCCESS
          821ed262-d20f-6e75-16d1-b3611cf63038:
            targetId: 404a6a07-8e37-d9cf-f701-d7f93e5c2945
            port: FAILURE
      getUcmdbIDFromGlobalIDFROM:
        x: 320
        'y': 240
        navigate:
          1e6163aa-86d4-52fa-880f-27cff81aae2d:
            targetId: 404a6a07-8e37-d9cf-f701-d7f93e5c2945
            port: FAILURE
      getUcmdbIDFromGlobalIDTO:
        x: 480
        'y': 240
        navigate:
          d98d72d3-4380-94bc-a022-25d9204429ce:
            targetId: 404a6a07-8e37-d9cf-f701-d7f93e5c2945
            port: FAILURE
    results:
      FAILURE:
        404a6a07-8e37-d9cf-f701-d7f93e5c2945:
          x: 480
          'y': 480
      SUCCESS:
        7e6fdac2-f181-1ee6-b245-d13af0320f36:
          x: 1120
          'y': 360
