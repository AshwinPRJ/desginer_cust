namespace: Achmea.Actions
flow:
  name: RegressieTest_EmergencyChange
  inputs:
    - sma_url: "${get_sp('Achmea.SMA.URL')}"
    - sma_tenantID: "${get_sp('Achmea.SMA.Tentant')}"
    - sma_changeModel: "${get_sp('SMA.RegressieEmergencyChangeModel')}"
    - proces: Emergency Change
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
          - FAILURE: FAILURE
    - get_displayLabel:
        do:
          Achmea.Operation.get_displayLabel:
            - Proces: '${proces}'
        publish:
          - displayLabel
        navigate:
          - SUCCESS: sma_createChange
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
          - FAILURE: FAILURE
          - SUCCESS: PlanningStage_Emergency
    - PlanningStage_Emergency:
        do:
          Achmea.Actions.PlanningStage_Emergency:
            - entityID: '${created_ID}'
            - sso_token: '${sso_token}'
            - ApprovalName: Service Owner
        navigate:
          - FAILURE: FAILURE
          - CUSTOM: CUSTOM
          - SUCCESS: sma_changePhase_2
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
          - FAILURE: FAILURE
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
          - FAILURE: FAILURE
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
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
          - CUSTOM: CUSTOM
  results:
    - FAILURE
    - SUCCESS
    - CUSTOM
extensions:
  graph:
    steps:
      getTokenSmaAchmea:
        x: 80
        'y': 160
        navigate:
          8477f6a7-17e7-892c-afe0-dd5eeeb0ff00:
            targetId: 16055990-931a-5572-9984-ef1d5fa11053
            port: FAILURE
      get_displayLabel:
        x: 120
        'y': 40
      sma_createChange:
        x: 200
        'y': 160
        navigate:
          bb3b0452-5fa4-ef8b-e10e-917280d2f0f8:
            targetId: 16055990-931a-5572-9984-ef1d5fa11053
            port: FAILURE
      PlanningStage_Emergency:
        x: 320
        'y': 160
        navigate:
          3bb74856-ae0a-b1a9-0646-91d584be345b:
            targetId: 16055990-931a-5572-9984-ef1d5fa11053
            port: FAILURE
          6cc272d0-bfa5-b486-643b-c3f1ffaa9df9:
            targetId: b582939d-45ab-b70d-e08c-0f037da25609
            port: CUSTOM
      sma_changePhase_2:
        x: 440
        'y': 160
        navigate:
          2add0b45-6dad-12a8-7e9f-231be2bb683a:
            targetId: 16055990-931a-5572-9984-ef1d5fa11053
            port: FAILURE
          38916d08-2b5c-5995-dbe3-1a57049391a7:
            targetId: b582939d-45ab-b70d-e08c-0f037da25609
            port: CUSTOM
      sma_changePhase_3:
        x: 560
        'y': 160
        navigate:
          67e92b68-743b-ecb7-e87a-d20995b0b9c7:
            targetId: 16055990-931a-5572-9984-ef1d5fa11053
            port: FAILURE
          5db22fb5-cacd-5a9a-f236-4068a263fde0:
            targetId: b582939d-45ab-b70d-e08c-0f037da25609
            port: CUSTOM
      sma_changePhase_4:
        x: 760
        'y': 160
        navigate:
          a92df7de-426a-8c72-d413-051bafa839ca:
            targetId: 16055990-931a-5572-9984-ef1d5fa11053
            port: FAILURE
          bf3ddcf6-68b6-68ea-6b89-9504cfd2c0a6:
            targetId: a00afede-55f1-0f0c-787e-7adb280fb87b
            port: SUCCESS
          e2c57a6b-9d2c-3105-7570-b50fcfe3afcc:
            targetId: b582939d-45ab-b70d-e08c-0f037da25609
            port: CUSTOM
    results:
      FAILURE:
        16055990-931a-5572-9984-ef1d5fa11053:
          x: 440
          'y': 360
      SUCCESS:
        a00afede-55f1-0f0c-787e-7adb280fb87b:
          x: 960
          'y': 160
      CUSTOM:
        b582939d-45ab-b70d-e08c-0f037da25609:
          x: 520
          'y': 40
