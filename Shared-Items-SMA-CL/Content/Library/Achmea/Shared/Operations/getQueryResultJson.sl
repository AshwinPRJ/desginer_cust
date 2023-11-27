namespace: Achmea.Shared.Operations
operation:
  name: getQueryResultJson
  inputs:
    - jsonResultSMAx
    - seperator
  python_action:
    use_jython: false
    script: "import json\r\ndef execute(jsonResultSMAx, seperator):    \r\n    return_fields = ''\r\n    return_values = ''\r\n    return_code = 0\r\n    error_message = ''\r\n    try:\r\n        objJson = json.loads(jsonResultSMAx)\r\n        for entitieName in objJson[\"entities\"][0][\"properties\"]:                    \r\n            return_fields = return_fields + seperator + entitieName\r\n            entitieValue = objJson[\"entities\"][0][\"properties\"][entitieName]\r\n            return_values =  return_values + seperator + str(entitieValue)\r\n        return_fields = return_fields[1:]\r\n        return_values = return_values[1:]\r\n    except Exception as e:\r\n            error_message = str(e)\r\n            return_code = '-1'  \r\n    return {\"error_message\": error_message, \"return_code\":return_code, \"return_fields\": return_fields, \"return_values\":return_values}"
  outputs:
    - error_message
    - return_code
    - return_fields
    - return_values
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
