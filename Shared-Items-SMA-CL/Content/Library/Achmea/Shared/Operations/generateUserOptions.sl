namespace: Achmea.Shared.Operations
operation:
  name: generateUserOptions
  inputs:
    - field
    - value
  python_action:
    use_jython: false
    script: "import json\r\ndef execute(field,value):\r\n    return_code = 0\r\n    error_message = ''\r\n    try:\r\n        strResult = '\"UserOptions\": \"{\\\\\"complexTypeProperties\\\\\": [{\\\\\"properties\\\\\": {\\\\\"'\r\n        return_result = strResult + field + '\\\\\": \\\\\"' + value + '\\\\\"}}]}\"'\r\n    except Exception as e:\r\n        return_code = 1\r\n        error_message = str(e)\r\n    return{\"return_result\":return_result,\"return_code\":return_code, \"error_message\":error_message}"
  outputs:
    - return_result
    - return_code
    - error_message
  results:
    - SUCCESS
