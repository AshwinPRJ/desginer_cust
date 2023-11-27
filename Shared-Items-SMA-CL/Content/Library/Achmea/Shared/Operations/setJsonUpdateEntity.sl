namespace: Achmea.Shared.Operations
operation:
  name: setJsonUpdateEntity
  inputs:
    - entityType
    - entityID
    - field
    - value
  python_action:
    use_jython: false
    script: "import json\r\ndef execute(entityType,entityID,field,value):\r\n    return_code = 0\r\n    error_message = ''\r\n    try:\r\n        entityProperties = '\"'+ field + '\":\"' + value + '\"'\r\n        strJson = '{\"entity_type\":\"' + entityType + '\",\"properties\": {\"Id\": \"' + entityID + '\",' + entityProperties + '}}'   \r\n     \r\n    except Exception as e:\r\n        return_code = 1\r\n        error_message = str(e)\r\n    \r\n    return{\"JsonUpdateEntity\":strJson,\"return_code\":return_code, \"error_message\":error_message}"
  outputs:
    - JsonUpdateEntity
    - return_code
    - error_message
  results:
    - SUCCESS
