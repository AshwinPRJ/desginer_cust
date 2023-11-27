namespace: Achmea.Shared.subFlows.SMA
flow:
  name: sma_getTask
  inputs:
    - sso_token
    - parentId
    - currentPhase
    - titleTask
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_token}'
        navigate:
          - IS_NULL: getTokenSmaAchmea
          - IS_NOT_NULL: get_task_id
    - getTokenSmaAchmea:
        do:
          Achmea.Shared.subFlows.SMA.getTokenSmaAchmea: []
        publish:
          - sso_token: '${sso_Token}'
        navigate:
          - SUCCESS: get_task_id
          - FAILURE: on_failure
    - get_task_id:
        do:
          io.cloudslang.microfocus.service_management_automation_x.commons.query_entities:
            - saw_url: "${get_sp('Achmea.SMA.URL')}"
            - sso_token: '${sso_token}'
            - tenant_id: "${get_sp('Achmea.SMA.Tentant')}"
            - entity_type: Task
            - query: "${\"ParentEntityId='\" + parentId + \"' and PhaseId='\" + currentPhase + \"' and DisplayLabelKey='\" + titleTask + \"'\"}"
            - fields: 'Id,ParentEntityId,ProcessId,PhaseId,DisplayLabelKey'
            - trust_all_roots: 'true'
        publish:
          - taskJson: '${return_result}'
          - errorMessage: '${error_json}'
          - result_count
        navigate:
          - FAILURE: FAILURE_1
          - SUCCESS: Get_KeyValue
          - NO_RESULTS: CUSTOM
    - Get_KeyValue:
        do:
          Achmea.Shared.Generic.Operations.Get_KeyValue:
            - dataJson: '${taskJson}'
            - keyName: Id
        publish:
          - id: '${value}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE_1
          - NO_RESULT: CUSTOM
  outputs:
    - taskID: '${id}'
  results:
    - FAILURE
    - SUCCESS
    - CUSTOM
    - FAILURE_1
extensions:
  graph:
    steps:
      is_null:
        x: 160
        'y': 360
      getTokenSmaAchmea:
        x: 240
        'y': 480
      get_task_id:
        x: 320
        'y': 360
        navigate:
          12cb1253-57d6-c983-df61-a201680db9ca:
            targetId: 70c266d3-b455-9194-6650-adc1ffa9ffc4
            port: NO_RESULTS
          e103ac52-94e5-c996-7d98-2837cf2d7670:
            targetId: d4f7e21a-8b9b-c8dc-c521-e40a080933e5
            port: FAILURE
      Get_KeyValue:
        x: 440
        'y': 360
        navigate:
          63f8ce4e-f961-40b0-6ef1-c2c3562bd0b8:
            targetId: c091f3a1-81a3-1a08-35ea-a9228fbc5b57
            port: SUCCESS
          82f2eb05-ff86-d463-2734-196e7cc7773f:
            targetId: 70c266d3-b455-9194-6650-adc1ffa9ffc4
            port: NO_RESULT
          445b5f02-05f1-57dd-6011-bb2f3b9f510e:
            targetId: d4f7e21a-8b9b-c8dc-c521-e40a080933e5
            port: FAILURE
    results:
      SUCCESS:
        c091f3a1-81a3-1a08-35ea-a9228fbc5b57:
          x: 600
          'y': 400
      CUSTOM:
        70c266d3-b455-9194-6650-adc1ffa9ffc4:
          x: 360
          'y': 240
      FAILURE_1:
        d4f7e21a-8b9b-c8dc-c521-e40a080933e5:
          x: 400
          'y': 520
