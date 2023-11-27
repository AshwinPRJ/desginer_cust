namespace: Achmea.Actions.MSSQL
flow:
  name: createRelationRaw
  workflow:
    - add_configuration_item_relation:
        do:
          io.cloudslang.microfocus.ucmdb.v1.data_model.relation.add_configuration_item_relation:
            - url: "${get_sp('MF.uCMDB.uCMDB_url')}"
            - token: '${sso_Token}'
            - from_id: '${from_id_ucmdbid}'
            - to_id: '${to_id_ucmdbid}'
            - relation_type: '${relationType}'
            - properties: '${properties}'
            - trust_all_roots: 'true'
        publish:
          - return_result
          - return_code
          - exception
          - added_cis
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      add_configuration_item_relation:
        x: 320
        'y': 160
        navigate:
          a3582aab-8cdd-a652-10de-e7bde53883cc:
            targetId: 8c0e17c3-81b3-359a-5560-f4f11528f74b
            port: SUCCESS
          1dcb6e60-9be8-cf85-1d49-bbff33aed253:
            targetId: 91345daf-f8e2-b739-b192-1aaa9b2c554f
            port: FAILURE
    results:
      SUCCESS:
        8c0e17c3-81b3-359a-5560-f4f11528f74b:
          x: 560
          'y': 160
      FAILURE:
        91345daf-f8e2-b739-b192-1aaa9b2c554f:
          x: 400
          'y': 440
