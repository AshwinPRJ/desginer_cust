namespace: Achmea.Shared.Micro-Focus.uCMDB.Subflow
flow:
  name: createRelationUCMDB_OOTBNotWorking
  inputs:
    - sso_Token:
        required: false
    - from_Id
    - to_Id
    - relationType
    - properties:
        required: false
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_Token}'
        navigate:
          - IS_NULL: getAuthenticationTokenAchmea
          - IS_NOT_NULL: fromID_getUcmdbIDFromGlobalID
    - getAuthenticationTokenAchmea:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getAuthenticationTokenAchmea: []
        publish:
          - sso_Token: '${token}'
          - error_message
          - return_code
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: fromID_getUcmdbIDFromGlobalID
    - fromID_getUcmdbIDFromGlobalID:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getUcmdbIDFromGlobalID:
            - sso_Token: '${sso_Token}'
            - GlobalID: '${from_Id}'
        publish:
          - from_id_ucmdbid: '${ucmdb_id}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: toId_getUcmdbIDFromGlobalID
          - FAILURE: on_failure
    - toId_getUcmdbIDFromGlobalID:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getUcmdbIDFromGlobalID:
            - sso_Token: '${sso_Token}'
            - GlobalID: '${to_Id}'
        publish:
          - to_id_ucmdbid: '${ucmdb_id}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: sleep
          - FAILURE: FAILURE
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '5'
        navigate:
          - SUCCESS: create_relation
          - FAILURE: FAILURE
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
            - body: "${'{\"cis\":[],\"relations\":[{\"type\":\"' + relationType + '\",\"end1Id\":\"' + from_id_ucmdbid + '\",\"end2Id\":\"' + to_id_ucmdbid + '\",\"properties\":{}}]}'}"
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
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      is_null:
        x: 200
        'y': 40
      create_relation:
        x: 880
        'y': 320
        navigate:
          60ac00e7-cf14-d55f-f803-5ff287eb3632:
            targetId: 9290f0fa-d67e-328d-3168-efd4805e1b86
            port: FAILURE
          a6b67c57-8928-44b0-26c8-a7f75fa37431:
            targetId: 4cff075b-e391-33a8-c0c8-b835dc1534ae
            port: SUCCESS
      getAuthenticationTokenAchmea:
        x: 200
        'y': 200
        navigate:
          824517e9-881e-a544-3378-810a3871857f:
            targetId: 9290f0fa-d67e-328d-3168-efd4805e1b86
            port: FAILURE
      fromID_getUcmdbIDFromGlobalID:
        x: 400
        'y': 80
      toId_getUcmdbIDFromGlobalID:
        x: 560
        'y': 120
        navigate:
          4c6c9ca0-f3d6-7c74-bc31-20661b85ea19:
            targetId: 9290f0fa-d67e-328d-3168-efd4805e1b86
            port: FAILURE
      sleep:
        x: 640
        'y': 240
        navigate:
          0e49dc27-1ee2-dc27-ef9a-d26591966a21:
            targetId: 9290f0fa-d67e-328d-3168-efd4805e1b86
            port: FAILURE
    results:
      SUCCESS:
        4cff075b-e391-33a8-c0c8-b835dc1534ae:
          x: 720
          'y': 80
      FAILURE:
        9290f0fa-d67e-328d-3168-efd4805e1b86:
          x: 320
          'y': 400
