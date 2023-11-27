namespace: Achmea.Shared.Operation
operation:
  name: procesJsonResult
  inputs:
    - jsonObject
  python_action:
    use_jython: false
    script: "import json\r\ndef execute(jsonObject):\r\n    return_code = 0\r\n    error_message = \"all fine\"\r\n\r\n    try:\r\n        jsondata = json.loads(jsonObject)    \r\n        SMAxEntityId = jsondata['SmaxId']\r\n        Description = jsondata['Description']\r\n        Status = jsondata['Status']\r\n        CustomData = jsondata['CustomData']\r\n        \r\n    \r\n    except Exception as e:\r\n        return_code = 1\r\n        error_message = e\r\n        \r\n    return{\"return_code\":return_code,\"error_message\":error_message,\"SMAxEntityId\":SMAxEntityId,\"Description\":Description,\"Status\":Status,\"CustomData\":CustomData}"
  outputs:
    - return_code
    - error_message
    - SMAxEntityId
    - Description
    - Status
    - CustomData
  results:
    - FAILURE: "${return_code == '1'}"
    - SUCCESS
