########################################################################################################################
#!!
#! @description: isClusterDB: Yes - cluster, No: - Single instance
#!               mssqlDbRelateTo - ba - business application - cicoll - cicollection
#!!#
########################################################################################################################
namespace: Achmea.Actions.MSSQL
flow:
  name: createUcmdbEnvironmentUCMDB
  inputs:
    - mssqlDatabaseName: dbsBanaan85
    - isClusterDB: 'Yes'
    - clusterRootContainer:
        default: AO_HELSINKI_ACC
        required: false
    - singleInstanceRootContainer:
        required: false
    - mssqlDbRelateTo: ba
    - businessApplicationGlobalId:
        default: 74322194262d8c0250f6f2cd2d0e6d1a
        required: false
    - ciCollectionGlobalId:
        required: false
    - msSQLRelateTo: '${businessApplicationGlobalId}'
  workflow:
    - getAuthenticationTokenAchmea:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getAuthenticationTokenAchmea: []
        publish:
          - sso_Token: '${token}'
        navigate:
          - FAILURE: ucmdbGetMSSqlRootContainerSingle
          - SUCCESS: isCluster_string_equals
    - isCluster_string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${isClusterDB}'
            - second_string: 'Yes'
            - ignore_case: 'false'
        navigate:
          - SUCCESS: ucmdbGetMSSqlRootContainerCluster
          - FAILURE: ucmdbGetMSSqlRootContainerSingle
    - ucmdbCreateMSSQLDatabase:
        do:
          Achmea.Actions.MSSQL.Subflow.ucmdbCreateMSSQLDatabase:
            - uCMDB_MSSQLName: '${mssqlDatabaseName}'
            - uCMDB_MSSQLRootContainer: '${root_container}'
            - sso_Token: '${sso_Token}'
            - token: '${sso_Token}'
        publish:
          - MSSQL_UcmdbId
        navigate:
          - SUCCESS: relateToBA_string_equals
          - FAILURE: on_failure
    - ucmdbGetMSSqlRootContainerCluster:
        do:
          Achmea.Actions.MSSQL.Subflow.ucmdbGetMSSqlRootContainerCluster:
            - uCMDB_MSCSResourceGroup: '${clusterRootContainer}'
            - sso_Token: '${sso_Token}'
        publish:
          - root_container
        navigate:
          - FAILURE: on_failure
          - SUCCESS: ucmdbCreateMSSQLDatabase
    - ucmdbGetMSSqlRootContainerSingle:
        do:
          Achmea.Actions.MSSQL.Subflow.ucmdbGetMSSqlRootContainerSingle:
            - uCMDB_MSSqlInstanceName: '${singleInstanceRootContainer}'
            - sso_Token: '${sso_Token}'
        publish:
          - root_container
        navigate:
          - FAILURE: on_failure
          - SUCCESS: ucmdbCreateMSSQLDatabase
    - relateToBA_string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${mssqlDbRelateTo}'
            - second_string: ba
            - ignore_case: 'false'
        navigate:
          - SUCCESS: setBA_GlobalID_do_nothing
          - FAILURE: setCIcoll_GlobalID_do_nothing
    - setBA_GlobalID_do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - msSQLRelateTo: '${businessApplicationGlobalId}'
        navigate:
          - SUCCESS: createRelationUCMDB_1
          - FAILURE: on_failure
    - setCIcoll_GlobalID_do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - msSQLRelateTo: '${ciCollectionGlobalId}'
        navigate:
          - SUCCESS: createRelationUCMDB_1
          - FAILURE: on_failure
    - createRelationUCMDB_1:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.createRelationUCMDB:
            - from_Id: '${MSSQL_UcmdbId}'
            - to_Id: '${businessApplicationGlobalId}'
            - relationType: usage
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      relateToBA_string_equals:
        x: 600
        'y': 80
      ucmdbCreateMSSQLDatabase:
        x: 480
        'y': 160
      ucmdbGetMSSqlRootContainerCluster:
        x: 320
        'y': 40
      getAuthenticationTokenAchmea:
        x: 40
        'y': 240
      setCIcoll_GlobalID_do_nothing:
        x: 720
        'y': 400
      createRelationUCMDB_1:
        x: 1080
        'y': 160
        navigate:
          2010924e-4188-8c72-affa-a65cc6e5da37:
            targetId: da6eaa71-b5b9-07a7-2a43-14ab98b98bae
            port: SUCCESS
      ucmdbGetMSSqlRootContainerSingle:
        x: 280
        'y': 400
      setBA_GlobalID_do_nothing:
        x: 720
        'y': 40
      isCluster_string_equals:
        x: 160
        'y': 80
    results:
      SUCCESS:
        da6eaa71-b5b9-07a7-2a43-14ab98b98bae:
          x: 1120
          'y': 320
