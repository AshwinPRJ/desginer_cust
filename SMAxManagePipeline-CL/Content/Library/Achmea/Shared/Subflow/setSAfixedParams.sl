namespace: Achmea.Shared.Subflow
flow:
  name: setSAfixedParams
  inputs:
    - SMAxEntityId
    - SMAxEntityType
    - flowReference
    - separator
    - systemName
  workflow:
    - getRunID:
        do:
          Achmea.Shared.subFlows.Generic.getRunID: []
        publish:
          - RUN_ID
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: setFixedFlowvars_do_nothing
    - setFixedFlowvars_do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - SMAxUser: "${get_sp('Achmea.azurePipeline.azurePiplineSMAxUser')}"
            - RUN_ID: '${RUN_ID}'
            - OOuuId: '${flowReference}'
            - separator: '${separator}'
            - SMAxEntityId: '${SMAxEntityId}'
            - SMAxEntityType: '${SMAxEntityType}'
            - SystemName: '${systemName}'
        publish:
          - flowVars: "${'SMAxEntityId' + separator + 'SMAxEntityType' + separator + 'SMAxUser' + separator + 'OOexecutionId' + separator + 'OOuuId' + separator + 'SystemName'}"
          - flowVarsValues: '${SMAxEntityId + separator + SMAxEntityType + separator + SMAxUser + separator + RUN_ID + separator + OOuuId + separator + SystemName}'
        navigate:
          - SUCCESS: createJSONFromList
          - FAILURE: FAILURE
    - createJSONFromList:
        do:
          Achmea.Shared.Operation.createJSONFromList:
            - FlowVarsNames: '${flowVars}'
            - FlowVarsValues: '${flowVarsValues}'
            - separator: '${separator}'
        publish:
          - JsonSAfixedParams: '${outputJson}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - JsonSAfixedParams: '${JsonSAfixedParams}'
    - return_code: '${return_code}'
    - error_message: '${error_message}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      getRunID:
        x: 80
        'y': 120
        navigate:
          eefecf8d-db46-2942-36d4-722caae0dd34:
            targetId: c230f169-ab4a-6092-a12a-c980d9cb7c89
            port: FAILURE
      setFixedFlowvars_do_nothing:
        x: 240
        'y': 120
        navigate:
          d1062d5f-9547-68c6-cb71-f4d3e3841486:
            targetId: c230f169-ab4a-6092-a12a-c980d9cb7c89
            port: FAILURE
      createJSONFromList:
        x: 400
        'y': 120
        navigate:
          ec6f944b-2582-d3f1-eaa4-23af8977114a:
            targetId: 76d741d2-512e-eb17-738a-65cd02c2e00d
            port: SUCCESS
          35860edb-3bfc-b896-4166-7c54debb076b:
            targetId: c230f169-ab4a-6092-a12a-c980d9cb7c89
            port: FAILURE
    results:
      SUCCESS:
        76d741d2-512e-eb17-738a-65cd02c2e00d:
          x: 680
          'y': 120
      FAILURE:
        c230f169-ab4a-6092-a12a-c980d9cb7c89:
          x: 320
          'y': 360
