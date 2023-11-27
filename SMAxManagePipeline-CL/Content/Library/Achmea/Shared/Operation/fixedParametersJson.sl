namespace: Achmea.Shared.Operation
operation:
  name: fixedParametersJson
  inputs:
    - SMAxEntityId
    - SMAxEntityType
    - SMAxUser
    - OOexecutionId
    - OOuuId
    - SystemName
  python_action:
    use_jython: false
    script: "def execute(SMAxEntityId, SMAxEntityType, SMAxUser,OOexecutionId,OOuuId,SystemName):\r\n    return_code  = 0\r\n    error_message = ''\r\n    intTeller = 0\r\n    strJson = ''\r\n    try:\r\n        strJson = \"{'SMAxEntityId':\" + SMAxEntityId + \",'SMAxEntityType':'\" + SMAxEntityType + \"','SMAxUser':'\" + SMAxUser + \"','OOexecutionId':\"  + OOexecutionId \r\n        strJson = strJson + \"\",'OOuuId':'\"  + OOuuId  + \"','SystemName':'\" SystemName +  \"'}\"\r\n    except Exception as e:\r\n        return_code = 1\r\n        error_message = str\r\n    return{\"outputJson\":strJson, \"return_code\":return_code, \"error_message\":error_message}"
  outputs:
    - outputJson
    - error_message
    - return_code
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
