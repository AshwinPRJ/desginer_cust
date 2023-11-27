namespace: Achmea.Actions.MSSQL.Subflow
flow:
  name: ucmdbGetMSSqlRootContainerSingle
  inputs:
    - uCMDB_MSSqlInstanceName
    - sso_Token:
        required: false
  workflow:
    - getqueryNameWithParametersUCMDB:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getqueryNameWithParametersUCMDB:
            - uCMDB_url: '${uCMDB_url}'
            - uCMDB_User: '${uCMDB_User}'
            - uCMDB_PW:
                value: '${uCMDB_PW}'
                sensitive: true
            - uCMDB_queryName: MS_SQLSingleInstance
            - uCMDB_QueryElementLabel: SQL_Server
            - uCMDB_ConditionAttributeName: name
            - sso_Token: '${sso_Token}'
            - uCMDB_ConditionOperator: equals
            - uCMDB_SearchValue: '${uCMDB_MSSqlInstanceName}'
            - search_Field: global_id
        publish:
          - root_container: '${queryResult}'
          - Count
          - sso_Token
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - root_container: '${root_container}'
    - Count: '${Count}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      getqueryNameWithParametersUCMDB:
        x: 320
        'y': 120
        navigate:
          e148aae2-f6aa-ca6e-b8b3-94d00bdfa84a:
            targetId: 4dfd4464-9f81-e209-a6ee-e556e2c9b734
            port: SUCCESS
          0d8c5422-87b4-2d73-563f-ba2ff66f6454:
            targetId: 1acfb5d3-f45c-51e4-01dc-bb75225c3be1
            port: FAILURE
    results:
      FAILURE:
        1acfb5d3-f45c-51e4-01dc-bb75225c3be1:
          x: 600
          'y': 120
      SUCCESS:
        4dfd4464-9f81-e209-a6ee-e556e2c9b734:
          x: 400
          'y': 360
