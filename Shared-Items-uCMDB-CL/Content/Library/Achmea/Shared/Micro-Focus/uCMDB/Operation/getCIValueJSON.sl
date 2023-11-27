namespace: Achmea.Shared.Micro-Focus.uCMDB.Operation
operation:
  name: getCIValueJSON
  inputs:
    - JSONSubset
  python_action:
    use_jython: false
    script: "def execute(JSONSubset):\r\n    query_params = \"\"\r\n    return_code = 0\r\n    error_message = \"\"\r\n    return_result = \"\"\r\n    error_message = \"\"\r\n    \r\n    try:\r\n        JSONSubset = JSONSubset.replace('\"','')\r\n        JSONSubset = JSONSubset.replace('[','')\r\n        JSONSubset = JSONSubset.replace(']','')\r\n        return_result = JSONSubset\r\n    except Exception as e:\r\n        return_code = 1\r\n        error_message = str(e)\r\n        \r\n    return {\"return_result\": return_result, \"return_code\":return_code, \"error_message\":error_message}"
  outputs:
    - return_code
    - return_result
    - error_message
  results:
    - SUCCESS: "${return_code=='0'}"
    - FAILURE
