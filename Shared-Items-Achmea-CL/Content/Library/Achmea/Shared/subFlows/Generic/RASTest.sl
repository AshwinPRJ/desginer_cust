namespace: Achmea.Shared.subFlows.Generic
flow:
  name: RASTest
  inputs:
    - RASHost
  workflow:
    - pwsh_script:
        worker_group: RAS_Operator_Path
        do:
          io.cloudslang.base.powershell.pwsh_script:
            - host: localhost
            - script: localhost
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      pwsh_script:
        x: 280
        'y': 200
        navigate:
          6dc9c342-618c-61fd-2ba6-2a8fcaa64ad7:
            targetId: 95367871-f87d-e7c1-7ac9-477882e7bce7
            port: SUCCESS
    results:
      SUCCESS:
        95367871-f87d-e7c1-7ac9-477882e7bce7:
          x: 640
          'y': 200
