namespace: Achmea.Shared.Operations
operation:
  name: ReplaceCharacter
  inputs:
    - value
    - oldValue
    - newValue
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      def execute(value, oldValue,newValue):
          # code goes here
          return_code = 0
          error_message = ''
          return_value = ''
          try:
              return_result = value.replace(oldValue,newValue)

          except Exception as e:
              return_code = 1
              error_message = str(e)
          return{"return_result":return_result, "return_code":return_code, "error_message":error_message}
  outputs:
    - return_result: '${return_result}'
    - return_code: '${return_code}'
    - error_message: '${error_message}'
  results:
    - SUCCESS
