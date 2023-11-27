namespace: Achmea.Shared.Subflow
flow:
  name: setSAsolParams
  inputs:
    - piplineProjectName
    - pipelineID
    - separator
  workflow:
    - setVars_do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - FlowVarsNames: "${'ProjectName' + separator + 'PipelineId'}"
            - FlowVarValues: '${piplineProjectName + separator + pipelineID}'
        publish:
          - FlowVarsNames
          - FlowVarValues
        navigate:
          - SUCCESS: createJSONFromList
          - FAILURE: FAILURE
    - createJSONFromList:
        do:
          Achmea.Shared.Operation.createJSONFromList:
            - FlowVarsNames: '${FlowVarsNames}'
            - FlowVarsValues: '${FlowVarValues}'
            - separator: '${separator}'
        publish:
          - JsonSASolParams: '${outputJson}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - JsonSASolParams: '${JsonSASolParams}'
    - return_code: '${return_code}'
    - error_message: '${error_message}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      setVars_do_nothing:
        x: 200
        'y': 120
        navigate:
          25eee136-6b8d-d7a4-c544-1a34b845a77a:
            targetId: 9b4275d8-0d92-e38c-e730-277720037984
            port: FAILURE
      createJSONFromList:
        x: 520
        'y': 120
        navigate:
          1c153276-d94c-30b0-a0c4-1f60cefc2128:
            targetId: 433686dd-c60f-f55f-d469-4e4471c4c6b5
            port: SUCCESS
          f68ef88c-c82d-9f1b-5cb3-9aa1787336ae:
            targetId: 9b4275d8-0d92-e38c-e730-277720037984
            port: FAILURE
    results:
      SUCCESS:
        433686dd-c60f-f55f-d469-4e4471c4c6b5:
          x: 800
          'y': 120
      FAILURE:
        9b4275d8-0d92-e38c-e730-277720037984:
          x: 400
          'y': 280
