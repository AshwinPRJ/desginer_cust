########################################################################################################################
#!!
#! @description: This will create a new array or list with the unique values: for example:
#!               List input
#!               Banaan
#!               Appel
#!               Peer
#!               Banaan
#!               Peer
#!               Will be a list of
#!               Banaan
#!               Appel
#!               Peer
#!!#
########################################################################################################################
namespace: Achmea.Shared.Operations
operation:
  name: getUniqueList
  inputs:
    - listSource
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(listSource):\n    return_code = 0\n    error_message = ''\n    unique_list = []\n    try:\n        for value in listSource:\n            if value not in unique_list:\n                unique_list.append(value)\n    except Exception as e:\n        return_code = 1\n        error_message = str(e)\n        \n    return{\"return_code\":return_code, \"unique_list\":unique_list, \"error_message\":error_message}"
  outputs:
    - return_code
    - unique_list
    - error_message
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
