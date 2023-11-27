namespace: Achmea.ImportUcmdb
flow:
  name: ImportMSSQLRelations
  workflow:
    - ClientComputer_Excel_get_cell:
        do:
          io.cloudslang.base.excel.get_cell:
            - excel_file_name: "${get_sp('Achmea.ImportUcmdb.ImportMSSQL')}"
            - worksheet_name: "${get_sp('Achmea.ImportUcmdb.tabClientComputers')}"
            - has_header: 'yes'
            - row_delimiter: "${get_sp('Achmea.ImportUcmdb.rowDelimiter')}"
            - column_delimiter: "${get_sp('Achmea.ImportUcmdb.columnDelimiter')}"
        publish:
          - excelData: '${return_result}'
          - return_code
          - row_count: '${rows_count}'
          - column_count: '${columns_count}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - createUcmdbEnvironmentUCMDB:
        do:
          Achmea.Actions.MSSQL.createUcmdbEnvironmentUCMDB:
            - mssqlDatabaseName: "${excelRow.split(get_sp('Achmea.ImportUcmdb.columnDelimiter'))[6]}"
            - isClusterDB: "${excelRow.split(get_sp('Achmea.ImportUcmdb.columnDelimiter'))[0]}"
            - clusterRootContainer: "${excelRow.split(get_sp('Achmea.ImportUcmdb.columnDelimiter'))[7]}"
            - singleInstanceRootContainer: "${excelRow.split(get_sp('Achmea.ImportUcmdb.columnDelimiter'))[5]}"
            - mssqlDbRelateTo: ba
            - businessApplicationGlobalId: '${baGlobalID}'
            - msSQLRelateTo: '${baGlobalID}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: list_iterator
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${excelData}'
            - separator: "${get_sp('Achmea.ImportUcmdb.rowDelimiter')}"
        publish:
          - excelRow: '${result_string}'
          - return_rsult: '${return_result}'
        navigate:
          - HAS_MORE: getBAGlobalID
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - getBAGlobalID:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getBAGlobalID:
            - BAName: "${excelRow.split(get_sp('Achmea.ImportUcmdb.columnDelimiter'))[2]}"
        publish:
          - baGlobalID
          - return_code
          - error_message
        navigate:
          - FAILURE: on_failure
          - SUCCESS: createUcmdbEnvironmentUCMDB
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ClientComputer_Excel_get_cell:
        x: 160
        'y': 80
      createUcmdbEnvironmentUCMDB:
        x: 960
        'y': 80
      list_iterator:
        x: 440
        'y': 120
        navigate:
          8c38e911-d74c-be91-4f25-c28a7af90be3:
            targetId: 4721b576-349b-aa71-f202-9e5f8558056e
            port: NO_MORE
      getBAGlobalID:
        x: 680
        'y': 200
    results:
      SUCCESS:
        4721b576-349b-aa71-f202-9e5f8558056e:
          x: 560
          'y': 480
