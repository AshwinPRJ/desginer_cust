namespace: Achmea.Shared.Operations
operation:
  name: setPowershellCommand
  inputs:
    - PwsVersion
    - PwsScriptWithPath
  python_action:
    use_jython: false
    script: "def execute(PwsVersion,PwsScriptWithPath):    \r\n    return_code = '0'\r\n    error_message = ''\r\n    return_value = ''\r\n    pwsExe = ''\r\n    try:\r\n        if(PwsVersion=='7'):\r\n            pwsExe = \"Pwsh.exe\"\r\n        elif(PwsVersion=='5'):\r\n            pwsExe = \"Powershell.exe\"\r\n        else:\r\n            return_code = 1\r\n            error_message = 'Unknown Powershell version : ' + PwsVersion           \r\n        strPre = ' -executionpolicy bypass -file '\r\n        return_result = pwsExe + strPre + PwsScriptWithPath\r\n        \r\n\r\n    except Exception as e:\r\n            return_code = 1\r\n            error_message = str(e)\r\n    return{\"return_code\":return_code, \"return_result\":return_result,\"error_message\":error_message}"
  outputs:
    - return_code
    - return_result
    - error_message
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
