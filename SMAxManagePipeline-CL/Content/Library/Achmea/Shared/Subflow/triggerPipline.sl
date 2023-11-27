namespace: Achmea.Shared.Subflow
flow:
  name: triggerPipline
  inputs:
    - flowVarName1: flowVarVALUE1
    - flowVarName2: flowVarVALUE2
    - flowVarNameList: 'flowVarName1,flowVarName2'
    - flowVarValueList:
        required: false
  workflow:
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${flowVarNameList}'
            - separator: ','
        publish:
          - flowVarName: '${result_string}'
        navigate:
          - HAS_MORE: do_nothing
          - NO_MORE: SUCCESS
          - FAILURE: FAILURE
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - FlowVarValue: '${globals()[flowVarName]}'
        publish:
          - FlowVarValue
        navigate:
          - SUCCESS: combineString
          - FAILURE: FAILURE
    - combineString:
        do:
          Achmea.Shared.Operations.combineString:
            - value: '${FlowVarValue}'
            - seperator: ','
            - orginalString: '${flowVarValueList}'
        publish:
          - flowVarValueList: '${newvalue}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: FAILURE
  outputs:
    - output_0: '${output_0}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      list_iterator:
        x: 40
        'y': 160
        navigate:
          32a640c8-5c20-65ab-dfae-261ea0520abf:
            targetId: d763faac-6646-968b-2c60-c0f0f33b2e3d
            port: NO_MORE
          c42f0eba-23aa-915a-b1cd-645dd340e51f:
            targetId: e73db5b9-a635-8664-8d57-8d0f1d332cd0
            port: FAILURE
      do_nothing:
        x: 240
        'y': 320
        navigate:
          2119d642-45ac-74d2-9a1b-8c62f1f3e6ed:
            targetId: e73db5b9-a635-8664-8d57-8d0f1d332cd0
            port: FAILURE
      combineString:
        x: 520
        'y': 360
        navigate:
          18d5b377-ee69-f49d-55b0-70d51f5ba002:
            targetId: e73db5b9-a635-8664-8d57-8d0f1d332cd0
            port: FAILURE
    results:
      SUCCESS:
        d763faac-6646-968b-2c60-c0f0f33b2e3d:
          x: 520
          'y': 120
      FAILURE:
        e73db5b9-a635-8664-8d57-8d0f1d332cd0:
          x: 120
          'y': 480
