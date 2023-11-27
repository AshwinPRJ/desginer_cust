########################################################################################################################
#!!
#! @description: This flow will create security incidents for a list of servers with open shares. This excel file will be used to:
#!               1. itterate to all rows and get all information from excelsheet
#!               2. Gather via hostname the 2e level support group of a related business application (relation in Ucmdb, 2 level support group smax
#!               3. Gather the Business service to create the security incident
#!               4. When the topology is not found (Server -.> BA) the default group will be used to create the security incident
#!               5. The security incident will be created when the title is not found (system prop + hostname)
#!               6. A default line with instructions (sys prop) will be added in the first row of the description of the security incident.
#!               6. The security incident will be updated when there is a match for open security incidents with sysprop + hostname
#!               7. Update: the new line will be added with the open share information from excel line
#!!#
########################################################################################################################
namespace: Achmea
flow:
  name: createSecurityIncidentsForOpenShares
  workflow:
    - setVars_do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - overAllIncidentDescription: null
            - current_server: null
            - Started: 'Yes'
            - previousServer: ''
            - isNewServer: 'No'
        publish:
          - overAllIncidentDescription
          - current_server
          - Started
          - previousServer
          - isNewServer
        navigate:
          - SUCCESS: getDataExcelListOpenShares_get_cell
          - FAILURE: on_failure
    - getDataExcelListOpenShares_get_cell:
        do:
          io.cloudslang.base.excel.get_cell:
            - excel_file_name: "${get_sp('Achmea.createSecurityIncidentsForOpenShares.OpenSharesExcelSheet')}"
            - worksheet_name: "${get_sp('Achmea.createSecurityIncidentsForOpenShares.OpenSharesExcelSheetTab')}"
            - has_header: 'yes'
            - row_delimiter: "${get_sp('Achmea.createSecurityIncidentsForOpenShares.OpenSharesRowDelimiter')}"
            - column_delimiter: "${get_sp('Achmea.createSecurityIncidentsForOpenShares.OpenSharesColumnDelimiter')}"
        publish:
          - rawExcelData: '${return_result}'
          - return_code
          - exception
          - row_counts: '${rows_count}'
        navigate:
          - SUCCESS: getTokenSmaAchmea_SMA
          - FAILURE: on_failure
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${rawExcelData}'
            - separator: "${get_sp('createSecurityIncidentsForOpenShares.OpenSharesRowDelimiter')}"
        publish:
          - excelRow: '${result_string}'
          - return_result
          - return_code
          - Counter
        navigate:
          - HAS_MORE: manageExcelRow
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - manageExcelRow:
        do:
          Achmea.Actions.Operations.manageExcelRow:
            - excelRow: '${excelRow}'
            - columnDelimiter: "${get_sp('Achmea.createSecurityIncidentsForOpenShares.OpenSharesColumnDelimiter')}"
        publish:
          - rowDescription: '${return_value}'
          - return_code
          - error_message
          - server_name
        navigate:
          - SUCCESS: manageSecurityIncident
          - FAILURE: on_failure
    - getTokenSmaAchmea_SMA:
        do:
          Achmea.Shared.subFlows.SMA.getTokenSmaAchmea: []
        publish:
          - sso_TokenSMA: '${sso_Token}'
          - status_Code
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - manageSecurityIncident:
        do:
          Achmea.Actions.Subflows.manageSecurityIncident:
            - server_name: '${server_name}'
            - incident_description: '${rowDescription}'
            - sso_TokenSMA: '${sso_TokenSMA}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      setVars_do_nothing:
        x: 40
        'y': 40
      getDataExcelListOpenShares_get_cell:
        x: 200
        'y': 40
      list_iterator:
        x: 520
        'y': 40
        navigate:
          30640d75-2180-2c40-6a78-990ccf0ed395:
            targetId: e2bff0a4-d017-d4e8-78c6-594a9777aada
            port: NO_MORE
      manageExcelRow:
        x: 720
        'y': 40
      getTokenSmaAchmea_SMA:
        x: 360
        'y': 40
      manageSecurityIncident:
        x: 720
        'y': 440
    results:
      SUCCESS:
        e2bff0a4-d017-d4e8-78c6-594a9777aada:
          x: 360
          'y': 360
