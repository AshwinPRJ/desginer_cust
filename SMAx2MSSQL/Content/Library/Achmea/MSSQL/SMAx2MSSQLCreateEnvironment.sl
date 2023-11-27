########################################################################################################################
#!!
#! @description: This flow will execute a Stored procedure on the MS SQL management environment to create or delete a MS SQL database
#!
#! @input mssql_requestBy: Enter the name of the requestor
#! @input mssql_actionSQL: Enter the SQL request type ("CreateDB, MoveDB, DeleteDB):
#! @input mssql_businessApplication: Enter the name of the BusinessApplication:
#! @input mssql_databaseHost: Enter the SQL server hostname for the requested database:
#! @input mssql_databaseInstance: Enter the instance for the requested database:
#! @input mssql_databaseName: Enter the requested database name:
#! @input mssql_availabilityGroup: Enter the SQL listener group in case of a SQL Cluster request:
#! @input mssql_databaseSize: Enter the size of the database in GB:
#! @input mssql_sqlManagementDatabase: Enter the SQL management database:
#! @input mssql_sqlManagementHost: Enter the SQL management server name:
#! @input msql_sqlManagementInstance: Enter the SQL management instance name:
#! @input mssql_sqlInstancePort: Enter the port number for the SQL management instance::
#! @input mssql_sqlDbsUser: Enter the SQL account to log on to the SQL management server
#! @input mssql_sqlPassword: Enter the password for the SQL account:
#! @input mssql_serviceInstanceId: Enter the Id of the Service Instance
#! @input mssql_executeDeployment: True for execute deployment, False for no deployment
#!!#
########################################################################################################################
namespace: Achmea.MSSQL
flow:
  name: SMAx2MSSQLCreateEnvironment
  inputs:
    - mssql_requestBy:
        prompt:
          type: text
    - mssql_actionSQL:
        prompt:
          type: text
    - mssql_businessApplication:
        prompt:
          type: text
    - mssql_databaseHost:
        prompt:
          type: text
    - mssql_databaseInstance:
        prompt:
          type: text
    - mssql_databaseName:
        prompt:
          type: text
    - mssql_availabilityGroup:
        prompt:
          type: text
        default: 'NULL'
        required: false
    - mssql_databaseSize:
        prompt:
          type: text
    - mssql_databaseCollation:
        prompt:
          type: text
        default: 'NULL'
    - mssql_sqlManagementDatabase:
        prompt:
          type: text
    - mssql_sqlManagementHost:
        prompt:
          type: text
    - msql_sqlManagementInstance:
        prompt:
          type: text
    - mssql_sqlInstancePort:
        prompt:
          type: text
    - mssql_sqlDbsUser:
        prompt:
          type: text
    - mssql_sqlPassword:
        prompt:
          type: text
        sensitive: true
    - mssql_serviceInstanceId:
        prompt:
          type: text
    - mssql_executeDeployment:
        prompt:
          type: text
        default: 'True'
  workflow:
    - is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${mssql_executeDeployment}'
        publish:
          - returnResult: '${bool_value}'
        navigate:
          - 'TRUE': getCreditsKeepass
          - 'FALSE': FAILURE
    - sql_command:
        do:
          io.cloudslang.base.database.sql_command:
            - db_server_name: '${mssql_sqlManagementHost}'
            - db_type: MSSQL
            - username: '${UserName}'
            - password:
                value: '${PassWord}'
                sensitive: true
            - instance: "${get_sp('Achmea.MSSQL.dbInstanceName')}"
            - db_port: "${get_sp('Achmea.MSSQL.dbPort')}"
            - database_name: "${get_sp('Achmea.MSSQL.mssqlDBName')}"
            - authentication_type: "${get_sp('Achmea.MSSQL.mssqlAuthenticationType')}"
            - command: "${'EXEC isp_mon_ServiceAutomation_Request' + ' ' + mssql_actionSQL + ',' + mssql_requestBy + ',' + '[' + mssql_hostInstance + ']' + ',' + mssql_databaseName + ',' + mssql_databaseSize + ',' + mssql_databaseCollation + ',' + 'Change' + ',' + \"'\" + mssql_serviceInstanceId + \"'\" + ',' + '[' + mssql_businessApplication + ']' + ',' + mssql_availabilityGroup}"
            - trust_all_roots: 'true'
        publish:
          - returnResult: '${return_result}'
          - exception
          - return_code
        navigate:
          - SUCCESS: sleep
          - FAILURE: FAILURE
    - ConcatHostInstance:
        do:
          Achmea.MSSQL.Operations.ConcatHostInstance:
            - databaseHost: '${mssql_databaseHost}'
            - databaseInstance: '${mssql_databaseInstance}'
        publish:
          - mssql_hostInstance: '${hostinstanceName}'
        navigate:
          - SUCCESS: sql_command
          - FAILURE: FAILURE
    - getCreditsKeepass:
        do:
          Achmea.Shared.subFlows.Generic.getCreditsKeepass:
            - KeepassEntry: mssqlEnvironment
        publish:
          - UserName
          - PassWord
          - return_code
          - error_message
        navigate:
          - SUCCESS: ConcatHostInstance
          - FAILURE: on_failure
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: "${get_sp('Achmea.MSSQL.waitAfterMSSqlRequestSeconds')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - mssql_returnResult: '${returnResult}'
    - mssql_returnCode: '${return_code}'
    - mssql_errorMessage: '${exception}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_true:
        x: 40
        'y': 160
        navigate:
          8eae990d-a1cb-44f2-2059-d0ec55ed18c0:
            targetId: 876b9582-15a4-4ff9-1907-1c6eac574c94
            port: 'FALSE'
      sql_command:
        x: 560
        'y': 160
        navigate:
          f5734ac2-3180-84fd-8168-cef1545fa555:
            targetId: 876b9582-15a4-4ff9-1907-1c6eac574c94
            port: FAILURE
      ConcatHostInstance:
        x: 360
        'y': 160
        navigate:
          4c96672e-8cb2-d11b-8ced-fb240bfdc4c0:
            targetId: 876b9582-15a4-4ff9-1907-1c6eac574c94
            port: FAILURE
      getCreditsKeepass:
        x: 200
        'y': 160
      sleep:
        x: 680
        'y': 120
        navigate:
          874e6bb7-ca5a-4af3-12ca-3f2a0d86b9cd:
            targetId: 94b6dd9a-f099-3abd-5298-ed78bef8f173
            port: SUCCESS
    results:
      FAILURE:
        876b9582-15a4-4ff9-1907-1c6eac574c94:
          x: 320
          'y': 376
      SUCCESS:
        94b6dd9a-f099-3abd-5298-ed78bef8f173:
          x: 840
          'y': 200
