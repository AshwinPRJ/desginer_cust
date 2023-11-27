namespace: Achmea.Actions.Operations
operation:
  name: manageExcelRow
  inputs:
    - excelRow
    - columnDelimiter
  python_action:
    use_jython: false
    script: "def execute(excelRow,columnDelimiter):\r\n    return_code = 0\r\n    error_message = \"\"\r\n    return_value = \"\"    \r\n    intTeller = 0\r\n    share_IDs = \"\"\r\n    share_rights = \"\"\r\n    share_paths = \"\"\r\n    NewLine = \"<br>\"\r\n    \r\n\r\n    try:\r\n        arrExcelRow = excelRow.split(columnDelimiter)\r\n        for rowValue in arrExcelRow:\r\n            if intTeller == 0:\r\n                server_name = arrExcelRow[intTeller]\r\n            elif  intTeller == 1:\r\n                share_paths = arrExcelRow[intTeller]\r\n            elif intTeller == 2:\r\n                share_IDs = arrExcelRow[intTeller]\r\n            elif intTeller == 3: \r\n                share_rights =  arrExcelRow[intTeller]\r\n            else:\r\n                error_message = \"Unknown columns\"\r\n                return_code = '1'\r\n            intTeller +=1\r\n\r\n        securityIncidentDescription = \"Path: \" +  share_paths + NewLine + \"Share rights: \" + share_IDs + NewLine + \"Share Rights: \" + share_rights + NewLine + NewLine         \r\n\r\n    except Exception as e:\r\n        return_code = 1\r\n        error_message = str\r\n    return{\"return_value\":securityIncidentDescription,\"server_name\":server_name,\"return_code\":return_code, \"error_message\":error_message}"
  outputs:
    - return_value
    - return_code
    - error_message
    - server_name
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
