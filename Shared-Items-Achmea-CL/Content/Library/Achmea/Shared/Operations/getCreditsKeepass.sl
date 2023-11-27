########################################################################################################################
#!!
#! @description: This operator will translate the Json value from the Powershell GetCredentials from json the parameter with the name UserName and Password (Secret). 
#!               The UserName / PassWord are encrypted in the Powershell script and will be decrypted in this operation
#!!#
########################################################################################################################
namespace: Achmea.Shared.Operations
operation:
  name: getCreditsKeepass
  inputs:
    - jsonData
  python_action:
    use_jython: false
    script: "# do not remove the execute function'\r\nimport json\r\nimport base64\r\n\r\ndef execute(jsonData):    \r\n    return_code = 0\r\n    error_message = ''\r\n    try:\r\n        JsonObject = json.loads(jsonData)\r\n        strUserNameEn = JsonObject[0]['UserName']       \r\n        strUserNameEn_bytes = strUserNameEn.encode('ascii')\r\n        strUserNameDe_bytes = base64.b64decode(strUserNameEn_bytes)\r\n        strUserName = strUserNameDe_bytes.decode('ascii')\r\n\r\n        strPasswordEn = JsonObject[0]['PassWord']\r\n        strPasswordEn_bytes = strPasswordEn.encode('ascii')\r\n        strPasswordDe_bytes = base64.b64decode(strPasswordEn_bytes)\r\n        strPassword = strPasswordDe_bytes.decode('ascii')\r\n    except Exception as e:\r\n            return_code = 1\r\n            error_message = str(e)\r\n    return{\"UserName\":strUserName, \"PassWord\":strPassword,\"return_code\":return_code, \"error_message\":error_message}"
  outputs:
    - return_code
    - error_message
    - UserName:
        sensitive: true
    - PassWord:
        sensitive: true
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
