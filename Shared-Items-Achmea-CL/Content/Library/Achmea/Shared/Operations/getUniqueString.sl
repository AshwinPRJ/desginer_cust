########################################################################################################################
#!!
#! @description: This will make the string unique in values with a septerator. 
#!               return_value  = new value
#!               return_code = 0 good, 1 error
#!               error_message = error message in case of failure
#!!#
########################################################################################################################
namespace: Achmea.Shared.Operations
operation:
  name: getUniqueString
  inputs:
    - values
    - seperator
  python_action:
    use_jython: false
    script: "# This operator will make a list of values with seperator. Example\r\n# Appel,Peer,Banaan,Appel,Peer\r\n# Will be\r\n# Appel,Peer,Banaan\r\n\r\ndef execute(values,seperator):    \r\n    return_code = '0'\r\n    error_message = ''\r\n    return_value = ''\r\n    unique_list = []\r\n    try:\r\n        arrValues = values.split(seperator)\r\n        for x in arrValues:\r\n            if x not in unique_list:\r\n                unique_list.append(x)\r\n        \r\n        for y in unique_list:\r\n            return_value = return_value + y + seperator\r\n        return_value = return_value[:-1]\r\n    except Exception as e:\r\n            return_code = 1\r\n            error_message = str(e)\r\n    return{\"return_code\":return_code, \"return_value\":return_value,\"error_message\":error_message}"
  outputs:
    - return_code
    - return_value
    - error_message
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
