namespace: Achmea.Shared.subFlows.Generic
flow:
  name: XPathQueryPws
  inputs:
    - XML
    - XPathQuery
  workflow:
    - run_command:
        do:
          io.cloudslang.base.cmd.run_command:
            - command: "${'pwsh -File E:\\Data\\Scripts\\Powershell\\XPathQuery\\XPathQuery.ps1 -XML ' + XML + '-XPathQuery' + XPathQuery}"
        publish:
          - return_result
          - return_code
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - return_result
    - result_code
    - error_message
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      run_command:
        x: 240
        'y': 120
        navigate:
          9d870da6-84ec-e6af-4739-beae2ce13f23:
            targetId: 8fe57491-1cea-0a13-357c-d14463e1de81
            port: SUCCESS
          01152b77-2a01-b24f-9bb1-2d9b1b0ecab8:
            targetId: f1c04797-4531-ec2e-af54-91cea7096e6b
            port: FAILURE
    results:
      SUCCESS:
        8fe57491-1cea-0a13-357c-d14463e1de81:
          x: 520
          'y': 120
      FAILURE:
        f1c04797-4531-ec2e-af54-91cea7096e6b:
          x: 240
          'y': 360
