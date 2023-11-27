namespace: Achmea.Shared.Micro-Focus.uCMDB.Operation
operation:
  name: getQueryResultWithParametersUcmdbValues
  inputs:
    - JsonResult
    - fieldName
  python_action:
    use_jython: false
    script: "# do not remove the execute function\r\ndef execute():\r\n    error_message = ''\r\n    return_code'= ''\r\n    return_result = ''\r\n    try:\r\n        json_object = json.loads(JsonResult)\r\n        stResultValue = json.get(\"properties\")[0].get(fieldName)\r\n    except Exception as e:\r\n        error_message = 'Error during getting queryresult getqueryNameWithParametersUcmdb. Please check inputvalues'\r\n        return_code = '-1'\r\n    return{\"error_message\": error_message, \"return_code\": return_code, \"return_result\": return_result}"
  results:
    - SUCCESS
