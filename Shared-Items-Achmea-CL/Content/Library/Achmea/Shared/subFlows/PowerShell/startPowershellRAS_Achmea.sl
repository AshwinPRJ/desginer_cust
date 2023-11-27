########################################################################################################################
#!!
#! @description: This will execute a powershell script with Powershell version 5 or Powershell version 7 via RAS within Achmea. 
#!               Script will be executed from the RAS server (or ooDesigner when debugging)
#!                
#!               PwsVersion = 5 or 7: will execute powershell.exe i case of version 5 and pwsh.exe in case of powershell 7
#!               PwsScriptWithPath = Powershell script with fill path
#!                
#!               Result
#!               Results powershell execution
#!               Note
#!               There is a json construction for the result. This will be the raw result of the powershell execution. It will be return in flow vars in the last step
#!!#
########################################################################################################################
namespace: Achmea.Shared.subFlows.PowerShell
flow:
  name: startPowershellRAS_Achmea
  inputs:
    - PwsVersion
    - PwsScriptWithPath
  workflow:
    - setPowershellCommand:
        do:
          Achmea.Shared.Operations.setPowershellCommand:
            - PwsVersion: '${PwsVersion}'
            - PwsScriptWithPath: '${PwsScriptWithPath}'
        publish:
          - PwsCommand: '${return_result}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: run_command
          - FAILURE: FAILURE
    - run_command:
        worker_group: RAS_Operator_Path
        do:
          io.cloudslang.base.cmd.run_command:
            - command: '${PwsCommand}'
        publish:
          - return_result
          - return_code
          - error_message
        navigate:
          - SUCCESS: managePowershellResult
          - FAILURE: FAILURE
    - managePowershellResult:
        do:
          Achmea.Shared.Operations.managePowershellResult:
            - PwsResult: '${return_result}'
        publish:
          - error_message
          - return_code
          - PwsErrorMessage
          - PwsReturnResult
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - PwsErrorMessage
    - PwsReturnResult
    - error_message
    - return_code
    - return_resultPws
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      setPowershellCommand:
        x: 160
        'y': 80
        navigate:
          0182f509-432c-9248-88c0-3c42b7a9ed0f:
            targetId: dfcc66c4-09c0-c30b-0157-9c46f11d8005
            port: FAILURE
      run_command:
        x: 480
        'y': 80
        navigate:
          1764f964-ba4b-acef-4c8b-2b09b1cbb4f4:
            targetId: dfcc66c4-09c0-c30b-0157-9c46f11d8005
            port: FAILURE
      managePowershellResult:
        x: 720
        'y': 80
        navigate:
          01f9a446-c00d-0acb-f88d-d51f1c3b8235:
            targetId: a1e3c34c-1fa1-02b3-f385-a4e587d4cd37
            port: SUCCESS
          2e8edae2-ff71-6e34-5d5e-567bcc535f31:
            targetId: dfcc66c4-09c0-c30b-0157-9c46f11d8005
            port: FAILURE
    results:
      FAILURE:
        dfcc66c4-09c0-c30b-0157-9c46f11d8005:
          x: 240
          'y': 320
      SUCCESS:
        a1e3c34c-1fa1-02b3-f385-a4e587d4cd37:
          x: 880
          'y': 80
