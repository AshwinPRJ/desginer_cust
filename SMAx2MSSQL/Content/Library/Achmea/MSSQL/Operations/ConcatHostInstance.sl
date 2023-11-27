namespace: Achmea.MSSQL.Operations
operation:
  name: ConcatHostInstance
  inputs:
    - databaseHost
    - databaseInstance
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(databaseHost, databaseInstance):\n    host = databaseHost.split(';')\n    instance = databaseInstance.split(';')\n    l=list()\n    error_message = ''\n    return_code = '' \n    try:\n        for host, instance in looplist(host,instance):\n            s= host + '\\\\' + instance + ';'\n            l.append(s)\n            cs = ''.join(l)\n        hostinstance = cs[:-1]\n        return_code = '0'\n    except Exception as e:\n        error_message = e\n        return_code = '-1'\n    return {\"hostinstanceName\" : hostinstance, \"error_message\" : error_message, \"return_code\" : return_code }\ndef looplist(host,instance):\n    for h in host:\n        for i in instance:\n            yield(h, i)"
  outputs:
    - hostinstanceName: '${hostinstanceName}'
    - error_message: '${error_message}'
    - return_code: '${return_code}'
  results:
    - SUCCESS: "${return_code =='0'}"
    - FAILURE
