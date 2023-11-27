namespace: Achmea.Shared.Subflow
flow:
  name: startPipline
  inputs:
    - FlowVar1: paramValue1
    - FlowVar2: paramValue2
    - FlowVar3: paramValue4
    - FlowVarList: 'FlowVar1,FlowVar2,FlowVar3'
  workflow:
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - flowVarValues
        navigate:
          - SUCCESS: flowVar_list_iterator
          - FAILURE: FAILURE_1
    - flowVar_list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: lstFlowVarValues
            - separator: ','
        publish:
          - flowVarName: '${result_string}'
        navigate:
          - HAS_MORE: append
          - NO_MORE: SUCCESS
          - FAILURE: FAILURE
    - append:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${flowVarValues}'
            - text: '${globals()[flowVarName]}'
        navigate:
          - SUCCESS: flowVar_list_iterator
  outputs:
    - lstFlowVarValues
  results:
    - SUCCESS
    - FAILURE
    - FAILURE_1
extensions:
  graph:
    steps:
      do_nothing:
        x: 120
        'y': 360
        navigate:
          20069a15-3f56-f8ce-114d-430571649dec:
            targetId: c1361989-1b23-024f-611a-a15053edb0f3
            port: FAILURE
      flowVar_list_iterator:
        x: 280
        'y': 440
        navigate:
          261ecb27-a84a-a8f2-3b64-ecb1543af40f:
            targetId: 740bf1eb-2a25-1bbf-556a-aaffb4fe8b69
            port: FAILURE
          1c885afb-4da1-63c6-eaf2-ab961808cae6:
            targetId: 132d3bf1-f6db-7bbc-e7a4-6a522588e07c
            port: NO_MORE
      append:
        x: 680
        'y': 560
    results:
      SUCCESS:
        132d3bf1-f6db-7bbc-e7a4-6a522588e07c:
          x: 320
          'y': 120
      FAILURE:
        740bf1eb-2a25-1bbf-556a-aaffb4fe8b69:
          x: 680
          'y': 160
      FAILURE_1:
        c1361989-1b23-024f-611a-a15053edb0f3:
          x: 160
          'y': 560
