namespace: Achmea.Actions.Operations
operation:
  name: manageListBusinessApplications
  inputs:
    - rawlistGlobalID
    - rawlistNames
    - server_name
  python_action:
    use_jython: false
    script: "def execute(rawlistGlobalID,rawlistNames,server_name):\r\n    return_code = '0'\r\n    error_message = ''\r\n    tempGlobalIDlist = ''\r\n    tempNamelist = ''\r\n    BAtoBookIncident = ''\r\n\r\n    try:\r\n        tempGlobalIDlist = rawlistGlobalID.replace('[', '')\r\n        tempGlobalIDlist = tempGlobalIDlist.replace(']', '') \r\n        tempGlobalIDlist = tempGlobalIDlist.replace('\"', '')\r\n        \r\n        tempNamelist = rawlistNames.replace('[', '')\r\n        tempNamelist = tempNamelist.replace(']','')\r\n        tempNamelist = tempNamelist.replace('\"','')        \r\n        tempNamelist = tempNamelist.replace(server_name,'')\r\n        \r\n        arrTemp = tempGlobalIDlist.split(',')\r\n        BAtoBookIncident = arrTemp[0]\r\n    except Exception as e:\r\n        return_code = 1\r\n        error_message = str\r\n    return{\"listNames\":tempNamelist,\"BAGlobalIDtoBookIncident\":BAtoBookIncident,\"return_code\":return_code, \"error_message\":error_message}"
  outputs:
    - return_code
    - listNames
    - BAGlobalIDtoBookIncident
    - error_message
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
