namespace: Achmea.Shared.Micro-Focus.uCMDB.Operation
operation:
  name: aitFilterStringValue
  inputs:
    - StringValue
    - LeftRemove
    - RightRemove
  python_action:
    use_jython: false
    script: "def execute(StringValue,LeftRemove,RightRemove):\r\n    return_code = 0\r\n    error_message = \"\"\r\n    return_result = \"\"\r\n    error_message = \"\"\r\n    intLeft = int(LeftRemove)\r\n    intRight = int(RightRemove)\r\n    \r\n    try:\r\n        intLeft = int(LeftRemove)\r\n        strTemp = StringValue[intLeft:]\r\n        if RightRemove != '0':\r\n            intRight = - int(RightRemove)\r\n            return_result = strTemp[:intRight]\r\n        else:\r\n            return_result = strTemp\r\n    except Exception as e:\r\n        return_code = 1\r\n        error_message = str(e)\r\n        \r\n    return {\"return_result\": return_result, \"return_code\":return_code, \"error_message\":error_message}"
  outputs:
    - return_code
    - return_result
    - error_message
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
