namespace: Achmea.Shared.subFlows.Generic
flow:
  name: getCreditsKeepass_Backup
  inputs:
    - KeepassEntry
  workflow:
    - GetPassWord_run_command:
        do:
          io.cloudslang.base.cmd.run_command:
            - command: "${'pwsh -File E:\\Data\\Scripts\\Powershell\\GetUserNamePassword\\GetUserNamePasswordDummy.ps1 -KeePassEntry ' + KeepassEntry}"
        publish:
          - return_result
          - return_code
          - error_message
        navigate:
          - SUCCESS: getCreditsKeepass
          - FAILURE: FAILURE
    - getCreditsKeepass:
        do:
          Achmea.Shared.Operations.getCreditsKeepass:
            - jsonData: '${return_result}'
        publish:
          - UserName
          - PassWord
          - return_code
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - UserName: '${UserName}'
    - PassWord: '${PassWord}'
    - return_code: '${return_code}'
    - error_message: '${error_message}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      GetPassWord_run_command:
        x: 120
        'y': 40
        navigate:
          56ec2acb-a181-938f-dd2e-dae196f2ef49:
            targetId: d8ff8b23-0b83-42f6-1ce0-2dcc3e4de8f0
            port: FAILURE
      getCreditsKeepass:
        x: 600
        'y': 40
        navigate:
          ebbd2517-d536-0f31-600e-8e26572a3e79:
            targetId: 020b00a7-23f2-b4fe-df02-f12fd48e829f
            port: SUCCESS
          7de9c948-6240-da14-70a8-fa6c24a8727b:
            targetId: d8ff8b23-0b83-42f6-1ce0-2dcc3e4de8f0
            port: FAILURE
    results:
      SUCCESS:
        020b00a7-23f2-b4fe-df02-f12fd48e829f:
          x: 760
          'y': 200
      FAILURE:
        d8ff8b23-0b83-42f6-1ce0-2dcc3e4de8f0:
          x: 160
          'y': 240
