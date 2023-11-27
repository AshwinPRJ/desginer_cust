namespace: Achmea.Shared.Operations
operation:
  name: pocSetLDAPGroupName
  inputs:
    - Environment: Acc
    - Name: sma-achmeareader
  python_action:
    use_jython: false
    script: "def execute(Name, Environment):    \r\n    return_code = '0'\r\n    error_message = ''\r\n    return_value = ''\r\n    dn = ''\r\n    PreName = 'g-s-rbap-'\r\n    \r\n    try:\r\n        if Environment =='acc':\r\n           return_value = PreName + Environment + '-' + Name\r\n    except Exception as e:\r\n            return_code = 1\r\n            error_message = str(e)\r\n    return{\"return_code\":return_code, \"return_value\":return_value,\"dn\":dn,\"error_message\":error_message}"
  outputs:
    - return_value
    - return_code
    - error_message
  results:
    - SUCCESS
