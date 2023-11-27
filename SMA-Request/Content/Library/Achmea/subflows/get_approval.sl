namespace: Achmea.subflows
flow:
  name: get_approval
  inputs:
    - sso_token:
        required: false
    - parentID: '2638346'
    - taskTitle: New approval task
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_token}'
        navigate:
          - IS_NULL: getTokenSmaAchmea
          - IS_NOT_NULL: sma_getTask
    - getTokenSmaAchmea:
        do:
          Achmea.Shared.subFlows.SMA.getTokenSmaAchmea: []
        publish:
          - sso_token: '${sso_Token}'
        navigate:
          - SUCCESS: sma_getTask
          - FAILURE: on_failure
    - sma_getTask:
        do:
          Achmea.Actions.sma_getTask:
            - parentID: '${parentID}'
            - titleTask: '${taskTitle}'
            - sso_token: '${sso_token}'
        publish:
          - taskID
        navigate:
          - FAILURE_1: FAILURE_1
          - SUCCESS: updatePhaseAchmea
          - CUSTOM: CUSTOM
    - updatePhaseAchmea:
        do:
          Achmea.Shared.subFlows.SMA.updatePhaseAchmea:
            - sso_token: '${sso_token}'
            - sma_entityType: Task
            - sma_entityId: '${taskID}'
            - sma_changePhase: Approved
        navigate:
          - SUCCESS: SUCCESS
          - CUSTOM: CUSTOM
          - FAILURE: FAILURE_1
  results:
    - SUCCESS
    - FAILURE
    - CUSTOM
    - FAILURE_1
extensions:
  graph:
    steps:
      is_null:
        x: 200
        'y': 360
      getTokenSmaAchmea:
        x: 320
        'y': 480
      sma_getTask:
        x: 320
        'y': 320
        navigate:
          ccefe6a4-9ff4-46c3-d14e-ad124200b813:
            targetId: a7dc5d79-c616-478b-7e0b-048d958e20ba
            port: CUSTOM
          3929877a-d7a3-1876-c7b3-101fccef9e11:
            targetId: 0bd02919-67a8-21f6-a079-66a48951fce2
            port: FAILURE_1
      updatePhaseAchmea:
        x: 480
        'y': 320
        navigate:
          9f4afe9d-bb08-d34a-5ca2-c01dcfb7aaa1:
            targetId: ae3e80eb-6247-b8df-928d-bc4f00266153
            port: SUCCESS
          de5975ef-b651-2e92-739d-bbcbe24dcd5e:
            targetId: 0bd02919-67a8-21f6-a079-66a48951fce2
            port: FAILURE
          cfda1690-a31b-6acb-3171-a04ee7a52893:
            targetId: a7dc5d79-c616-478b-7e0b-048d958e20ba
            port: CUSTOM
    results:
      SUCCESS:
        ae3e80eb-6247-b8df-928d-bc4f00266153:
          x: 640
          'y': 320
      CUSTOM:
        a7dc5d79-c616-478b-7e0b-048d958e20ba:
          x: 400
          'y': 200
      FAILURE_1:
        0bd02919-67a8-21f6-a079-66a48951fce2:
          x: 480
          'y': 520
