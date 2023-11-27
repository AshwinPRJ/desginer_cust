namespace: Achmea.Shared.Micro-Focus.uCMDB.Operation
operation:
  name: getUcmdbRelationID
  inputs:
    - JSON_Input
    - SearchID
  python_action:
    use_jython: false
    script: "import json\r\ndef execute(JSON_Input, SearchID):\r\n        try:\r\n            strJSON = JSON_Input\r\n            strSearchID = SearchID\r\n            error_message = ''\r\n            return_code = ''\r\n            ciFound = ''\r\n            return_result = ''\r\n            jsonList = json.loads(strJSON)\r\n            for allRelations in jsonList:       \r\n                for item in allRelations:      \r\n                    if type(item) is dict:\r\n                        if (item['end2Id']) == strSearchID:\r\n                            return_result = (item['globalId'])\r\n                            ciFound = 'True'\r\n                            return_code = '0'\r\n                            break\r\n                        else:\r\n                            ciFound = 'False'\r\n            if ciFound == 'False':\r\n                error_message = 'CI not found.'\r\n                return_code = '-1'\r\n        except Exception as e:\r\n            error_message = str(e)\r\n            return_code = '-1'\r\n        return {\"return_result\": return_result, \"return_code\":return_code, \"error_message\":error_message}"
  outputs:
    - return_result: '${return_result}'
    - return_code: '${return_code}'
    - error_message: '${error_message}'
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
