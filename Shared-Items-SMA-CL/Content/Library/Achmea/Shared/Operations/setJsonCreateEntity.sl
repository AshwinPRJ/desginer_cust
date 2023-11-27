namespace: Achmea.Shared.Operations
operation:
  name: setJsonCreateEntity
  inputs:
    - entityType
    - fields
    - values: '${[]}'
    - splitter
  python_action:
    use_jython: false
    script: "import json\r\ndef execute(entityType,fields,values,splitter):\r\n    return_code = 0\r\n    error_message = ''\r\n    \r\n    try:\r\n        startJson = '{\"entity_type\":\"' + entityType + '\",\"properties\":{'\r\n        value = values.split(splitter)\r\n        intTeller = 0\r\n        for field in fields.split(splitter):\r\n            newValues = '\"' + field.strip() + '\":\"' + value[intTeller].strip() + '\"'    \r\n            startJson = startJson + newValues + \",\"\r\n            intTeller += 1\r\n            \r\n        \r\n        startJson = startJson[:-1]\r\n        startJson = startJson + '}}'    \r\n        \r\n    except Exception as e:\r\n        return_code = 1\r\n        error_message = str(e)\r\n    return{\"JsonCreateEntity\":startJson,\"return_code\":return_code, \"error_message\":error_message}\r\n    \r\n      #strJson = '{\"entity_type\":\"' + entityType + '\",\"properties\":{\"' + field.strip() + '\":\"' + value[intTeller].strip() + '\"Pr,'spl"
  outputs:
    - JsonCreateEntity
    - return_code
    - error_message
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
