namespace: Achmea.Shared.Micro-Focus.uCMDB.Operation
operation:
  name: opGeneratePayLoadBodyQueryWithParametersUcmdb
  inputs:
    - uCMDB_queryName
    - uCMDB_QueryElementLabel
    - uCMDB_ConditionAttributeName
    - uCMDB_ConditionOperator
    - uCMDB_SearchValue
  python_action:
    use_jython: false
    script: "# do not remove the execute function\r\ndef execute(uCMDB_queryName, uCMDB_QueryElementLabel, uCMDB_ConditionAttributeName, uCMDB_ConditionOperator, uCMDB_SearchValue):\r\n# This will generate the payload for the body for the rest-api call to Ucmdb.\r\n    error_message = ''\r\n    return_code = ''\r\n    return_result = ''\r\n    try:\r\n        # uCMDBJson = '{\"name\":\"' + uCMDB_queryName + '\",\"nodes\":[{\"elementLabel\":\"' + uCMDB_QueryElementLabel + '\",\"attributeConditions\":[{\"attribute\":\"' + uCMDB_ConditionAttributeName + '\",\"operator\":\"' + uCMDB_ConditionOperator + '\",\"value\":\"' + uCMDB_SearchValue + '\"}]}]}\"'\r\n        uCMDBJson = '{\"name\":\"' + uCMDB_queryName + '\",\"nodes\":[{\"elementLabel\":\"' + uCMDB_QueryElementLabel + '\",\"attributeConditions\":[{\"attribute\":\"' + uCMDB_ConditionAttributeName + '\",\"operator\":\"' + uCMDB_ConditionOperator + '\",\"value\":\"' + uCMDB_SearchValue + '\"}]}]}'\r\n        return_result = uCMDBJson\r\n        return_code = '0'   \r\n        error_message = ''\r\n    except Exception as e:\r\n        error_message = 'Error during generate payload for getqueryNameWithParametersUcmdb. Please check inputvalues'\r\n        return_code = '-1'\r\n    return{\"error_message\": error_message, \"return_code\": return_code, \"return_result\": return_result}"
  outputs:
    - return_result: '${return_result}'
    - return_code: '${return_code}'
    - error_message: '${error_message}'
  results:
    - SUCCESS: "${return_code=='0' }"
    - FAILURE
