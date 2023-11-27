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
namespace: Achmea.Actions.MSSQL
flow:
  name: SMAxDND2SQL
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
          - 'TRUE': ConcatHostInstance
          - 'FALSE': FAILURE
    - ConcatHostInstance:
        do:
          Achmea.Subflows.MSSQL.ConcatHostInstance:
            - databaseHost: '${mssql_databaseHost}'
            - databaseInstance: '${mssql_databaseInstance}'
        publish:
          - mssql_hostInstance: '${hostinstanceName}'
        navigate:
          - SUCCESS: sql_command
          - FAILURE: FAILURE
    - sql_command:
        do:
          io.cloudslang.base.database.sql_command:
            - db_server_name: '${mssql_sqlManagementHost}'
            - db_type: MSSQL
            - username: '${mssql_sqlDbsUser}'
            - password:
                value: '${mssql_sqlPassword}'
                sensitive: true
            - instance: '${msql_sqlManagementInstance}'
            - db_port: '${mssql_sqlInstancePort}'
            - database_name: '${mssql_sqlManagementDatabase}'
            - command: "${'EXEC isp_mon_ServiceAutomation_Request' + ' ' + mssql_actionSQL + ',' + mssql_requestBy + ',' + '[' + mssql_hostInstance + ']' + ',' + mssql_databaseName + ',' + mssql_databaseSize + ',' + mssql_databaseCollation + ',' + 'Change' + ',' + \"'\" + mssql_serviceInstanceId + \"'\" + ',' + '[' + mssql_businessApplication + ']' + ',' + mssql_availabilityGroup}"
            - trust_all_roots: 'true'
        publish:
          - returnResult: '${return_result}'
          - exception
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
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
        x: 95
        'y': 183
        navigate:
          8eae990d-a1cb-44f2-2059-d0ec55ed18c0:
            targetId: 876b9582-15a4-4ff9-1907-1c6eac574c94
            port: 'FALSE'
      ConcatHostInstance:
        x: 321
        'y': 179
        navigate:
          dc2dcacf-7bc2-c377-2801-5260c2286c93:
            targetId: 876b9582-15a4-4ff9-1907-1c6eac574c94
            port: FAILURE
      sql_command:
        x: 539
        'y': 179
        navigate:
          f5734ac2-3180-84fd-8168-cef1545fa555:
            targetId: 876b9582-15a4-4ff9-1907-1c6eac574c94
            port: FAILURE
          90341d63-d0a4-a778-3600-8a9bd972ff53:
            targetId: 94b6dd9a-f099-3abd-5298-ed78bef8f173
            port: SUCCESS
    results:
      FAILURE:
        876b9582-15a4-4ff9-1907-1c6eac574c94:
          x: 320
          'y': 376
      SUCCESS:
        94b6dd9a-f099-3abd-5298-ed78bef8f173:
          x: 720
          'y': 200
