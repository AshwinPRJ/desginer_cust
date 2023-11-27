########################################################################################################################
#!!
#! @description: This script will request up to 10 values from a given JSON. 
#!               -Instructions:
#!               enter the JSON into the "dataJson" input as a string.
#!               The first "keyName1" input is mandatory. Enter a JSON key as a string.
#!               The following inputs (keyName2 to keyName10) are optional and can be used for extra JSON keys to retrieve values.
#!               The flow will return all values for the keys that are given as inputs. You will have to add outputs in this operation when added to a flow that will have the name of the required flow variable.
#!               e.g. suppose you want to retrieve the key in a JSON called status. You will first have to add status as a string to input KeyName1. The output that will catch the result of the search for
#!               the value of the key "status" will be returned as keyValue1. So you have to create the output "status" with value "keyValue1". and so forth for extra key's (up to 10 keys).
#!               (the script will output other keyValue with value "No Value' in case an key is not given as an input to the corresponding keyName, You don't have to configure these values as an output)
#!!#
########################################################################################################################
namespace: Achmea.Shared.Generic.Operations
operation:
  name: Get_nKeysvalue
  inputs:
    - dataJson
    - keyName1
    - keyName2:
        required: false
    - keyName3:
        required: false
    - keyName4:
        required: false
    - keyName5:
        required: false
    - keyName6:
        required: false
    - keyName7:
        required: false
    - keyName8:
        required: false
    - keyName9:
        required: false
    - keyName10:
        required: false
  python_action:
    use_jython: false
    script: "import json\n# do not remove the execute function\ndef execute(dataJson, keyName1, keyName2, keyName3, keyName4, keyName5, keyName6, keyName7, keyName8, keyName9, keyName10):\n    error_message=''\n    return_code=''\n    if dataJson[0] == '[':\n        dataJson=dataJson[1:] \n    if dataJson[-1] == ']':\n        dataJson = dataJson[:-1] \n    found = dataJson.find('\\\\')\n    if found != -1:\n        dataJson = dataJson.replace('\\\\', '/')\n    data = json.loads(dataJson)\n    key1=key2=key3=key4=key5=key6=key7=key8=key9=key10=None\n    try:\n        for key, value in dictionaryparse(data):\n            if key == keyName1:\n                key1=value\n            if key == keyName2:\n                key2=value\n            if key == keyName3:\n                key3=value\n            if key == keyName4:\n                key4=value\n            if key == keyName5:\n                key5=value\n            if key == keyName6:\n                key6=value\n            if key == keyName7:\n                key7=value\n            if key == keyName8:\n                key8=value\n            if key == keyName9:\n                key9=value\n            if key == keyName10:\n                key10=value\n        if key1==None:\n            key1='No Value'\n        if key2==None:\n            key2='No Value'\n        if key3==None:\n            key3='No Value'\n        if key4==None:\n            key4='No Value'\n        if key5==None:\n            key5='No Value'\n        if key6==None:\n            key6='No Value'    \n        if key7==None:\n            key7='No Value'\n        if key8==None:\n            key8='No Value'\n        if key9==None:\n            key9='No Value'    \n        if key10==None:\n            key10='No Value'\n        return_code='0'    \n    except Exception as e:\n        error_message = e\n        return_code = '-1'\n    return{\"keyValue1\": key1, \"keyValue2\": key2, \"keyValue3\": key3, \"keyValue4\": key4, \"keyValue5\": key5, \n        \"keyValue6\": key6, \"keyValue7\": key7, \"keyValue8\": key8, \"keyValue9\": key9, \"keyValue10\": key10, \n        \"error_message\":error_message, \"return_code\":return_code}        \ndef dictionaryparse(datanested):\n    for key, value in datanested.items():\n        if type(value) is dict:\n            yield from dictionaryparse(value)\n        elif type(value) is list:\n            newlist=list()\n            for v in value:\n                if type(v) is dict:\n                    yield from dictionaryparse(v)\n                else:\n                    newlist.append(v)\n                yield (key, newlist)\n        else:\n            yield(key, value)"
  outputs:
    - FlowVar1: '${keyValue1}'
    - FlowVar2: '${keyValue2}'
    - FlowVar3: '${keyValue3}'
    - FlowVar4: '${keyValue4}'
    - FlowVar5: '${keyValue5}'
    - FlowVar6: '${keyValue6}'
    - FlowVar7: '${keyValue7}'
    - FlowVar8: '${keyValue8}'
    - FlowVar9: '${keyValue9}'
    - FlowVar10: '${keyValue10}'
    - error_message: "${ str(error_message) if return_code == '-1' else '' }"
    - return_code: '${return_code}'
  results:
    - SUCCESS: "${return_code=='0'}"
    - FAILURE
