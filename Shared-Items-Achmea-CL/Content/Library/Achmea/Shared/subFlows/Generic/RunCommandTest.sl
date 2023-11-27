namespace: Achmea.Shared.subFlows.Generic
flow:
  name: RunCommandTest
  workflow:
    - run_command:
        worker_group: RAS_Operator_Path
        do:
          io.cloudslang.base.cmd.run_command:
            - command: "pwsh -File E:\\Data\\Scripts\\Powershell\\GetUserNamePassword\\HelloWorld.ps1"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE_1
  results:
    - SUCCESS
    - FAILURE_1
extensions:
  graph:
    steps:
      run_command:
        x: 440
        'y': 160
        navigate:
          0e1a2fdd-d897-8799-9d5f-ee573c00894c:
            targetId: 67d62124-3e20-f795-c359-4fbad7b1aa71
            port: SUCCESS
          62872428-70a8-c456-9646-34778b1c03f9:
            targetId: 599b5dbf-6fc7-b527-3192-6b9708485300
            port: FAILURE
    results:
      SUCCESS:
        67d62124-3e20-f795-c359-4fbad7b1aa71:
          x: 680
          'y': 200
      FAILURE_1:
        599b5dbf-6fc7-b527-3192-6b9708485300:
          x: 440
          'y': 360
