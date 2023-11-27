namespace: Achmea.Actions.Operations
operation:
  name: getSubStringLeft
  inputs:
    - Value
    - Seperator
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(Value,Seperator):\n    return_code = 0\n    error_message = \"\"\n    return_value = \"\"\n    try:\n        arrTemp = Value.split(Seperator)\n        return_value = arrTemp[0]\n    \n    except Exception as e:\n        return_code = 1\n        error_message = str\n    return{\"return_value\":return_value,\"return_code\":return_code, \"error_message\":error_message}"
  outputs:
    - return_value
    - return_code
    - error_message
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
