namespace: Achmea.Shared.Operation
operation:
  name: getJsonValuePwsResult
  inputs:
    - rawData
  python_action:
    use_jython: false
    script: "# Remove first results (not json format) from Pws result\r\ndef execute(rawData):\r\n    return_code  = '0'\r\n    error_message = ''    \r\n    strJson = ''\r\n    try:\r\n        beginJSON = rawdata.find(\"<SMAxOutput>\")\r\n        endJSON =  rawdata.find(\"</SMAxOutput>\")\r\n        jsonResult = rawdata[beginJSON:endJSON]\r\n    except Exception as e:\r\n        return_code = '1'\r\n        error_message = str\r\n    return{\"outputJson\":strJson, \"return_code\":return_code, \"error_message\":error_message}"
  outputs:
    - outputJson
    - error_message
    - return_code
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
