########################################################################################################################
#!!
#! @description: prop: fill the list of fields you want to fill. For example: name, root_container, bios
#!               prop1: value first field of in list prop field
#!               prop2: value second field of in list prop field
#!               prop3: etc
#!               prop4: etc
#!               prop5: etc
#!!#
########################################################################################################################
namespace: Achmea.Shared.Micro-Focus.uCMDB.Operation
operation:
  name: set_Inputs_to_flowvars
  inputs:
    - prop
    - prop1
    - prop2:
        required: false
    - prop3:
        required: false
    - prop4:
        required: false
    - prop5:
        required: false
  python_action:
    use_jython: false
    script: "def execute(prop, prop1, prop2, prop3, prop4, prop5):\r\n    error_message = ''\r\n    return_result = ''\r\n    return_code = ''\r\n    varFields = prop.split(\",\")\r\n    try:\r\n        if prop1 != '':\r\n            return_result = varFields[0] + '=' + prop1 + ','\r\n            return_code = '0'\r\n        if prop2 != '':\r\n            return_result = return_result + varFields[1] + '=' + prop2 + ','\r\n            return_code = '0'\r\n        if prop3 != '':\r\n            return_result = return_result + varFields[2] + '=' + prop3 + ','\r\n            return_code = '0'\r\n        if prop4 != '':\r\n            return_result = return_result + varFields[3] + '=' + prop4 + ','\r\n            return_code = '0'\r\n        if prop5 != '':\r\n            return_result = varFields[4] + '=' + prop5 + ','\r\n            return_code = '0'\r\n        retLength = len(return_result) - 1\r\n        return_result= (return_result[0:retLength])\r\n        \r\n    except Exception as e:\r\n        error_message = 'Error during gather prop values. Please check total of fieldnames in prop and prop1 .. prop5'\r\n        return_code = '-1'\r\n    return{\"error_message\": error_message, \"return_code\": return_code, \"return_result\": return_result}"
  outputs:
    - error_message: '${error_message}'
    - return_code: '${return_code}'
    - return_result: '${return_result}'
  results:
    - SUCCESS: "${return_code=='0'}"
    - FAILURE
