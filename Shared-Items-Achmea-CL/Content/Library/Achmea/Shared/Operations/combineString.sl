########################################################################################################################
#!!
#! @description: This operator will add the new string to the existing string with a seperator. 
#!               value - NewValue that will add to existing string (orginalString)
#!               seperator - seperator between 2 strings
#!               orginalString - String that will be enriched
#!               Return
#!               newvalue - the new combined string with the new value added with seperator
#!!#
########################################################################################################################
namespace: Achmea.Shared.Operations
operation:
  name: combineString
  inputs:
    - value
    - seperator
    - orginalString:
        required: false
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      def execute(value, seperator,orginalString):
          # code goes here
          return_code = 0
          error_message = ''
          newvalue = ''
          try:
              if orginalString == '':
                  newvalue = value
              else:
                  newvalue = orginalString + seperator + value
          except Exception as e:
              return_code = 1
              error_message = str(e)
          return{"newvalue":newvalue, "return_code":return_code, "error_message":error_message}
  outputs:
    - newvalue
    - error_message
    - return_code
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
