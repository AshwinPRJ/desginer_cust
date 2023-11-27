########################################################################################################################
#!!
#! @description: This function will remove 1 or more characters from a string. When the seperator is not filled only 1 character will be remove...
#!               Example1: banaan# as value without seperator and a character # will result is banaan
#!               Example2: banaan#$ as value wit seperator ',' and character #,$ will result in banaan.
#!               Value  - dirty string
#!               seperator - optional: option to remove more char. with this seperator
#!               removeCharacters - chracter or list of character with seperator
#!               Result
#!               return_result - Clean string
#!               
#!               
#!!#
########################################################################################################################
namespace: Achmea.Shared.Operations
operation:
  name: removeCharactersString
  inputs:
    - Value
    - seperator:
        required: false
    - removeCharacters
  python_action:
    use_jython: false
    script: "def execute(Value,seperator,removeCharacters):    \r\n    \r\n    return_code = '0'\r\n    error_message = ''\r\n    return_result = ''\r\n    strTemp = '' \r\n    \r\n    try:\r\n        strValue = str(Value)\r\n        if seperator == '':\r\n            return_result = strValue.replace(removeCharacters,'')        \r\n        else:\r\n            arrRemoveCharacters = removeCharacters.split(seperator)\r\n            for Character in arrRemoveCharacters:\r\n                strValue = strValue.replace(Character,'')        \r\n            return_result = strValue        \r\n\r\n    except Exception as e:\r\n            return_code = '1'\r\n            error_message = str(e)\r\n    return{\"return_code\":return_code, \"return_result\":return_result,\"error_message\":error_message}"
  outputs:
    - return_result
    - return_code
    - error_message
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
