namespace: Achmea.Shared.Micro-Focus.uCMDB.Operation
operation:
  name: CheckCountResult
  inputs:
    - Counter
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      def execute(Counter):
          # Check if value is 0 or > 1 with message
          error_message=''
          return_code=''
          return_result=''
          if found == 0:
              return_result = 'Resource not found.'
      # you can add additional helper methods below.
  results:
    - SUCCESS
