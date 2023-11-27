namespace: Achmea.Shared.Micro-Focus.uCMDB.Operation
operation:
  name: aitGetTokenKey
  inputs:
    - dataJson
    - keyName
  python_action:
    use_jython: false
    script: "import json\n# do not remove the execute function\ndef execute(dataJson, keyName):\n    error_message=''\n    return_code=''\n    return_result=''\n    if dataJson[0] == '[':\n        dataJson=dataJson[1:] \n    if dataJson[-1] == ']':\n        dataJson = dataJson[:-1] \n    found = dataJson.find('\\\\')\n    if found != -1:\n        dataJson = dataJson.replace('\\\\', '/')\n    data = json.loads(dataJson)\n    keyValue = ''\n    try:\n        for key, value in dictionaryparse(data):\n            if key == keyName:\n                keyValue = value\n                return_code='0'\n            else:\n                return_result = 'requested key is not found'\n    except Exception as e:\n        error_message = e\n        return_code = '-1'\n    return{\"keyValue\": keyValue,\"error_message\":error_message, \"return_code\":return_code, \"return_result\":return_result}\ndef dictionaryparse(datanested):\n    for key, value in datanested.items():\n        if type(value) is dict:\n            yield from dictionaryparse(value)\n        elif type(value) is list:\n            newlist=list()\n            for v in value:\n                if type(v) is dict:\n                    yield from dictionaryparse(v)\n                else:\n                    newlist.append(v)\n                yield (key, newlist)\n        else:\n            yield(key, value)"
  outputs:
    - value: '${keyValue}'
    - error_message: "${str(error_message) if return_code == '-1' else ''}"
    - return_code: '${return_code}'
    - return_result: '${return_result}'
  results:
    - SUCCESS: "${return_code=='0'}"
    - FAILURE
