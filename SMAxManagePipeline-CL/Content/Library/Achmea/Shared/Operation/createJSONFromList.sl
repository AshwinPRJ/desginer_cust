namespace: Achmea.Shared.Operation
operation:
  name: createJSONFromList
  inputs:
    - FlowVarsNames
    - FlowVarsValues
    - separator
  python_action:
    use_jython: false
    script: "def execute(FlowVarsNames,FlowVarsValues, separator):\r\n    return_code = 0\r\n    error_message = \"\"\r\n    strJson = \"{\"\r\n    try:\r\n        FlowVarNameList = FlowVarsNames.split(separator)\r\n        FlowVarsValuesList = FlowVarsValues.split(separator)\r\n        intTeller = 0\r\n        for FlowVarName in FlowVarNameList:\r\n            strJson = strJson + \"'\" + FlowVarName + \"':'\" + FlowVarsValuesList[intTeller] + \"',\"\r\n            intTeller += 1\r\n        strJson = strJson[0:len(strJson) - 1]\r\n        strJson = strJson + \"}\"\r\n    except Exception as e:\r\n        return_code = 1\r\n        error_message = str\r\n    return{\"outputJson\":strJson, \"return_code\":return_code, \"error_message\":error_message}"
  outputs:
    - outputJson
    - return_code
    - error_message
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
