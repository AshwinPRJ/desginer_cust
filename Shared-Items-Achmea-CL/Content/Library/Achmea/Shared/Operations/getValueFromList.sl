namespace: Achmea.Shared.Operations
operation:
  name: getValueFromList
  inputs:
    - list
    - seperator
    - index
  python_action:
    use_jython: false
    script: "#This operator will get you the item in de list index\r\n\r\ndef execute(list,seperator,index):\r\n    \r\n    return_code = 0\r\n    error_message = ''\r\n    return_value = ''\r\n    \r\n    try:\r\n        intIndex = int(index)\r\n        arrTemp = list.split(seperator) \r\n        return_value = arrTemp[intIndex]\r\n        \r\n    except Exception as e:\r\n        return_code = 1\r\n        error_message = str(e)  \r\n    return{\"return_code\":return_code, \"return_value\":return_value, \"error_message\":error_message}"
  outputs:
    - return_value
    - return_code
    - error_message
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
