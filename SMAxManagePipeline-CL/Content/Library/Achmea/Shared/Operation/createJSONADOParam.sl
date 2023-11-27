namespace: Achmea.Shared.Operation
operation:
  name: createJSONADOParam
  inputs:
    - FlowVarsNames
    - FlowVarsValues
    - seperator
  python_action:
    use_jython: false
    script: "def execute(FlowVarsNames, FlowVarsValues, seperator):\r\n    return_code  = 0\r\n    error_message = ''\r\n    intTeller = 0\r\n    strJson = ''\r\n    try:\r\n        FlowVarNameList = FlowVarsNames.split(seperator)\r\n        FlowVarsValuesList = FlowVarsValues.split(seperator)\r\n        for FlowVarName in FlowVarNameList:\r\n            strJson = strJson + \"'\" + FlowVarName +  \"':'\"  + FlowVarsValuesList[intTeller] + \"',\"\r\n            intTeller += 1\r\n        strJson = strJson[0:len(strJson) - 1]\r\n        strJson = strJson + '}'\r\n    except Exception as e:\r\n        return_code = 1\r\n        error_message = str\r\n    return{\"outputJson\":strJson, \"return_code\":return_code, \"error_message\":error_message}"
  outputs:
    - outputJson
    - return_code
    - error_message
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
