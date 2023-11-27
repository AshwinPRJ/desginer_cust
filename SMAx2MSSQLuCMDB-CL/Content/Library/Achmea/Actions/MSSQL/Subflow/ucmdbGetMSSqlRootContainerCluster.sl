namespace: Achmea.Actions.MSSQL.Subflow
flow:
  name: ucmdbGetMSSqlRootContainerCluster
  inputs:
    - uCMDB_MSCSResourceGroup
    - sso_Token:
        required: false
  workflow:
    - getqueryNameWithParametersUCMDB:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getqueryNameWithParametersUCMDB:
            - uCMDB_queryName: MS_SQLCluster
            - uCMDB_QueryElementLabel: MSSQLCluster
            - uCMDB_ConditionAttributeName: name
            - uCMDB_ConditionOperator: equals
            - uCMDB_SearchValue: '${uCMDB_MSCSResourceGroup}'
            - search_Field: global_id
            - sso_Token: '${sso_Token}'
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
        'y': 160
        navigate:
          7561621b-0b91-d1b1-8dec-18b388bf497d:
            targetId: 1acfb5d3-f45c-51e4-01dc-bb75225c3be1
            port: FAILURE
          bd4a00fc-aa3b-089b-9b24-b3f6b68830f5:
            targetId: 4dfd4464-9f81-e209-a6ee-e556e2c9b734
            port: SUCCESS
    results:
      FAILURE:
        1acfb5d3-f45c-51e4-01dc-bb75225c3be1:
          x: 600
          'y': 160
      SUCCESS:
        4dfd4464-9f81-e209-a6ee-e556e2c9b734:
          x: 320
          'y': 360
