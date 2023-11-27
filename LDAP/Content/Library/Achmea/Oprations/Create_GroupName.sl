namespace: Achmea.Oprations
operation:
  name: Create_GroupName
  inputs:
    - Scope:
        required: true
        default: ''
    - Type:
        required: true
        default: ''
    - Category:
        required: true
        default: ''
    - Description: ''
    - Environment: ''
    - Remark: ''
    - MaxCh: "${get_sp('Achmea.MaxCharacters')}"
  python_action:
    use_jython: false
    script: |-
      def execute(Scope,Type,Category,Description,Environment,Remark,MaxCh):
          return_code = 0
          return_result=''
          error_message = ''
          error=''
          name = ''
          input_list = [Scope,Type,Category,Description,Environment,Remark]
          MaxNr = int(MaxCh)
          try:
              for x in input_list:
                  if x == '':
                      name = name
                  elif x.isalnum()==False:
                      error= 'A wrong character was used'
                      return_code = 2
                  else:
                      if name == '':
                          name = x
                      else:
                          name = name + '-' + x
              if return_code == 2:
                  return_result = error
              elif len(name)> MaxNr:
                  return_result = 'The name is too long'
                  return_code = 2
              else:
                  return_result = name.lower()
          except Exception as e:
              return_code = 1
              error_message = str(e)
          return{"return_result":return_result,"return_code":return_code, "error_message":error_message}
  outputs:
    - return_result
    - return_code
    - error_message
  results:
    - FAILURE: "${return_code=='1'}"
    - CUSTOM: "${return_code=='2'}"
    - SUCCESS
