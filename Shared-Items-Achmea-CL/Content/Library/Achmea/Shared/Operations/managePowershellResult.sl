namespace: Achmea.Shared.Operations
operation:
  name: managePowershellResult
  inputs:
    - PwsResult
  python_action:
    use_jython: false
    script: "import json\r\ndef execute(PwsResult):\r\n    error_message=''\r\n    return_code='0'\r\n    return_result=''   \r\n    # Find the JSON within the result by search on < character and then until end of string -1\r\n    try: \r\n        intFind = PwsResult.find('>')\r\n        strResult = PwsResult[intFind:-1] \r\n        arrT = strResult.split(\"</SMAxOutput>\")    \r\n        strJson = arrT[0]\r\n        strJson = strJson[1:]        \r\n        data = json.loads(strJson)\r\n        PwsErrorMessage = data[\"ErrorMessage\"]        \r\n        PwsReturnCode = data[\"ReturnCode\"]\r\n        PwsReturnResult = data[\"ReturnResult\"]\r\n        PwsAdvancedMessage = data[\"CustomData\"]\r\n    except Exception as e:\r\n        error_message = str(e)\r\n        return_code = '-1'  \r\n    return {\"error_message\": error_message, \"return_code\":return_code, \"PwsErrorMessage\": PwsErrorMessage, \"PwsReturnCode\":PwsReturnCode, \"PwsReturnResult\":PwsReturnResult, \"PwsAdvancedMessage\":PwsAdvancedMessage}"
  outputs:
    - error_message
    - return_code
    - PwsErrorMessage
    - PwsReturnCode
    - PwsReturnResult
    - PwsAdvancedMessage
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
