namespace: Achmea.Actions
flow:
  name: RegressieTest_Change
  inputs:
    - sma_url: "${get_sp('Achmea.SMA.URL')}"
    - sma_tenantID: "${get_sp('Achmea.SMA.Tentant')}"
    - sma_changeModel: "${get_sp('SMA.RegressieStandardChangeModel')}"
    - proces:
        default: Standard Change
        required: false
    - sso_token:
        required: false
  workflow:
    - getTokenSmaAchmea:
        do:
          Achmea.Shared.subFlows.SMA.getTokenSmaAchmea: []
        publish:
          - sso_token: '${sso_Token}'
        navigate:
          - SUCCESS: get_displayLabel
          - FAILURE: FAILURE_1
    - sma_createChange:
        do:
          Achmea.Actions.sma_createChange:
            - sma_url: '${sma_url}'
            - sma_tenantID: '${sma_tenantID}'
            - fields: 'DisplayLabel,BasedOnChangeModel'
            - values: '${displayLabel+","+sma_changeModel}'
            - sso_token: '${sso_token}'
        publish:
          - created_ID
        navigate:
          - FAILURE: FAILURE_1
          - SUCCESS: sma_changePhase
    - sma_changePhase:
        do:
          Achmea.Actions.sma_changePhase:
            - sma_url: '${sma_url}'
            - sma_tenantID: '${sma_tenantID}'
            - sma_entityId: '${created_ID}'
            - sma_changePhase: Plan
            - sso_token: '${sso_token}'
        publish:
          - message: '${Message}'
        navigate:
          - FAILURE: FAILURE_1
          - SUCCESS: sleep_1
          - CUSTOM: CUSTOM
    - sma_changePhase_1:
        do:
          Achmea.Actions.sma_changePhase:
            - sma_url: '${sma_url}'
            - sma_tenantID: '${sma_tenantID}'
            - sma_entityId: '${created_ID}'
            - sma_changePhase: Execute
            - sso_token: '${sso_token}'
        publish:
          - message: '${Message}'
        navigate:
          - FAILURE: FAILURE_1
          - SUCCESS: sma_changePhase_2
          - CUSTOM: CUSTOM
    - sma_changePhase_2:
        do:
          Achmea.Actions.sma_changePhase:
            - sma_url: '${sma_url}'
            - sma_tenantID: '${sma_tenantID}'
            - sma_entityId: '${created_ID}'
            - sma_changePhase: CMDBUpdate
            - sso_token: '${sso_token}'
        publish:
          - message: '${Message}'
        navigate:
          - FAILURE: FAILURE_1
          - SUCCESS: sma_changePhase_3
          - CUSTOM: CUSTOM
    - sma_changePhase_3:
        do:
          Achmea.Actions.sma_changePhase:
            - sma_url: '${sma_url}'
            - sma_tenantID: '${sma_tenantID}'
            - sma_entityId: '${created_ID}'
            - sma_changePhase: Review
            - sso_token: '${sso_token}'
        publish:
          - message: '${Message}'
        navigate:
          - FAILURE: FAILURE_1
          - SUCCESS: sma_changePhase_4
          - CUSTOM: CUSTOM
    - sma_changePhase_4:
        do:
          Achmea.Actions.sma_changePhase:
            - sma_url: '${sma_url}'
            - sma_tenantID: '${sma_tenantID}'
            - sma_entityId: '${created_ID}'
            - sma_changePhase: Close
            - sso_token: '${sso_token}'
        publish:
          - message: '${Message}'
        navigate:
          - FAILURE: FAILURE_1
          - SUCCESS: SUCCESS
          - CUSTOM: CUSTOM
    - get_displayLabel:
        do:
          Achmea.Operation.get_displayLabel:
            - Proces: '${proces}'
        publish:
          - displayLabel
        navigate:
          - SUCCESS: sma_createChange
    - sleep_1:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '7'
        navigate:
          - SUCCESS: sma_changePhase_1
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE_1
    - CUSTOM
    - FAILURE
extensions:
  graph:
    steps:
      sma_createChange:
        x: 200
        'y': 240
        navigate:
          a21b773e-f44d-9973-4d12-44e46a0f637c:
            targetId: 8d894c01-8544-11c1-a910-6075ebb8c5be
            port: FAILURE
      sma_changePhase_1:
        x: 560
        'y': 240
        navigate:
          9b42813f-2201-5fd8-29d5-593514ff9f40:
            targetId: 8d894c01-8544-11c1-a910-6075ebb8c5be
            port: FAILURE
          37367be7-0aa0-a437-709d-bc96ef881c09:
            targetId: a3788751-2a88-9313-815c-29c89201f000
            port: CUSTOM
      sma_changePhase_2:
        x: 680
        'y': 240
        navigate:
          be6d8a4c-f60a-d6be-57d8-5a06c292388a:
            targetId: 8d894c01-8544-11c1-a910-6075ebb8c5be
            port: FAILURE
          67786db7-5346-ba4c-c7d0-fa39cdc5147c:
            targetId: a3788751-2a88-9313-815c-29c89201f000
            port: CUSTOM
      getTokenSmaAchmea:
        x: 80
        'y': 240
        navigate:
          ba8341a1-8585-5eba-64df-b69c1b2ac9b4:
            targetId: 8d894c01-8544-11c1-a910-6075ebb8c5be
            port: FAILURE
      sma_changePhase_3:
        x: 800
        'y': 240
        navigate:
          5ee5e04a-c0a7-4d41-d4f0-f67c82e382bd:
            targetId: 8d894c01-8544-11c1-a910-6075ebb8c5be
            port: FAILURE
          79140776-6145-37b8-6132-d346eaf8726b:
            targetId: a3788751-2a88-9313-815c-29c89201f000
            port: CUSTOM
      sma_changePhase_4:
        x: 960
        'y': 240
        navigate:
          1eb947e5-257d-c231-d994-1032c99f4dbf:
            targetId: 8d894c01-8544-11c1-a910-6075ebb8c5be
            port: FAILURE
          5c146a27-3be3-f7ef-f23b-70228a874bc6:
            targetId: c103eb39-c0b1-9771-acb0-de28561df203
            port: SUCCESS
          3e5efba9-b72d-0f7c-e768-fb1336ee9a04:
            targetId: a3788751-2a88-9313-815c-29c89201f000
            port: CUSTOM
      sleep_1:
        x: 440
        'y': 240
      sma_changePhase:
        x: 320
        'y': 240
        navigate:
          7b759257-1221-72df-4290-ef9261f930d5:
            targetId: 8d894c01-8544-11c1-a910-6075ebb8c5be
            port: FAILURE
          5c192861-4103-28b9-6e2a-78640eb29552:
            targetId: a3788751-2a88-9313-815c-29c89201f000
            port: CUSTOM
      get_displayLabel:
        x: 160
        'y': 120
    results:
      SUCCESS:
        c103eb39-c0b1-9771-acb0-de28561df203:
          x: 1160
          'y': 240
      FAILURE_1:
        8d894c01-8544-11c1-a910-6075ebb8c5be:
          x: 440
          'y': 480
      CUSTOM:
        a3788751-2a88-9313-815c-29c89201f000:
          x: 600
          'y': 80
