namespace: Achmea.ImportUcmdb
flow:
  name: ImportClientComputers
  workflow:
    - ClientComputer_Excel_get_cell:
        do:
          io.cloudslang.base.excel.get_cell:
            - excel_file_name: "${get_sp('Achmea.ImportUcmdb.ImportFileClientComputer')}"
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
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${excelData}'
            - separator: "${get_sp('Achmea.ImportUcmdb.rowDelimiter')}"
        publish:
          - excelRow: '${result_string}'
          - return_rsult: '${return_result}'
        navigate:
          - HAS_MORE: createObjectUCMDB
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - createObjectUCMDB:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.createObjectUCMDB:
            - ciType: nt
            - prop: 'name,node_role,node_model,serial_number'
            - prop1: "${excelRow.split(get_sp('Achmea.ImportUcmdb.columnDelimiter'))[0]}"
            - prop2: "${excelRow.split(get_sp('Achmea.ImportUcmdb.columnDelimiter'))[1]}"
            - prop3: "${excelRow.split(get_sp('Achmea.ImportUcmdb.columnDelimiter'))[2]}"
            - prop4: "${excelRow.split(get_sp('Achmea.ImportUcmdb.columnDelimiter'))[3]}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: list_iterator
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      createObjectUCMDB:
        x: 680
        'y': 120
      list_iterator:
        x: 400
        'y': 160
        navigate:
          f93e1677-cbfd-dccf-0ec3-48fb730ac0fc:
            targetId: 51f51cc8-f4e4-3151-c97a-be590c441332
            port: NO_MORE
      ClientComputer_Excel_get_cell:
        x: 160
        'y': 80
    results:
      SUCCESS:
        51f51cc8-f4e4-3151-c97a-be590c441332:
          x: 600
          'y': 360
