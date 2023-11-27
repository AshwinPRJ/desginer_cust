namespace: Achmea.Actions.MSSQL.Subflow
flow:
  name: ucmdbCreateMSSQLDatabase
  inputs:
    - uCMDB_MSSQLName
    - uCMDB_MSSQLRootContainer
    - sso_Token:
        required: false
  workflow:
    - createObjectUCMDB:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.createObjectUCMDB:
            - ciType: sqldatabase
            - prop: 'name,root_container'
            - prop1: '${uCMDB_MSSQLName}'
            - prop2: '${uCMDB_MSSQLRootContainer}'
            - sso_Token: '${sso_Token}'
            - token: '${token}'
        publish:
          - MSSQL_UcmdbId: '${added_cis}'
          - output_0: output_0
          - error_message
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
  outputs:
    - MSSQL_UcmdbId: '${MSSQL_UcmdbId}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      createObjectUCMDB:
        x: 280
        'y': 40
        navigate:
          4bc306dd-f15c-097a-cc2e-2a7c13ee761a:
            targetId: 1d4009d3-01eb-6526-d4a8-0869cb0b0350
            port: SUCCESS
          6e5a86a0-0331-f5c2-eb71-93fa048c8bbe:
            targetId: 6af7dcc1-42d9-bc6b-2fdf-f24a52007c0d
            port: FAILURE
    results:
      SUCCESS:
        1d4009d3-01eb-6526-d4a8-0869cb0b0350:
          x: 640
          'y': 40
      FAILURE:
        6af7dcc1-42d9-bc6b-2fdf-f24a52007c0d:
          x: 280
          'y': 280
