namespace: Achmea.Actions
flow:
  name: RegressieTest_NormalChange
  inputs:
    - sma_url: "${get_sp('Achmea.SMA.URL')}"
    - sma_tenantID: "${get_sp('Achmea.SMA.Tentant')}"
    - sma_changeModel: "${get_sp('SMA.RegressieNormalChangeModel')}"
    - proces: Normal Change
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
          - SUCCESS: PlanningStage_Change
    - PlanningStage_Change:
        do:
          Achmea.Actions.PlanningStage_Change:
            - entityID: '${created_ID}'
            - sso_token: '${sso_token}'
            - ApprovalName: Service Owner
        navigate:
          - FAILURE_1: FAILURE
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
        x: 40
        'y': 280
        navigate:
          2fc39c29-6936-0447-99c3-74cb8f09bc2f:
            targetId: 6e89ba38-79dc-deb7-8ef2-77e4ef765ee0
            port: FAILURE
      get_displayLabel:
        x: 120
        'y': 160
      sma_createChange:
        x: 160
        'y': 280
        navigate:
          8813ecf8-574a-82fa-8053-6a63dd81886b:
            targetId: 6e89ba38-79dc-deb7-8ef2-77e4ef765ee0
            port: FAILURE
      PlanningStage_Change:
        x: 280
        'y': 280
        navigate:
          261807b9-4eee-7265-66b2-ba061a36e21c:
            targetId: 8f0c58bb-af55-2ca0-1c8e-8f9d38aa6731
            port: CUSTOM
          2f6247cf-1989-aae7-a516-6e60ba20336d:
            targetId: 6e89ba38-79dc-deb7-8ef2-77e4ef765ee0
            port: FAILURE_1
      sma_changePhase_2:
        x: 400
        'y': 280
        navigate:
          c094c255-21bf-dfc9-da96-29c0bacd47ce:
            targetId: 8f0c58bb-af55-2ca0-1c8e-8f9d38aa6731
            port: CUSTOM
          9a8b827c-b1d5-b682-958f-744b72cc12c6:
            targetId: 6e89ba38-79dc-deb7-8ef2-77e4ef765ee0
            port: FAILURE
      sma_changePhase_3:
        x: 520
        'y': 280
        navigate:
          9271ee3b-1d79-31a4-6739-13bcf93ac1a0:
            targetId: 8f0c58bb-af55-2ca0-1c8e-8f9d38aa6731
            port: CUSTOM
          19875d35-588e-409b-cc47-a6204d2d5f39:
            targetId: 6e89ba38-79dc-deb7-8ef2-77e4ef765ee0
            port: FAILURE
      sma_changePhase_4:
        x: 680
        'y': 280
        navigate:
          c83bd8c3-7e74-bc6e-20ff-5bad2ba53a3b:
            targetId: 6dffad0c-f7fe-3383-c0e0-c5ef8b685d52
            port: SUCCESS
          8d4a56e5-1e5f-f870-c27b-ce3bfa45e3c9:
            targetId: 8f0c58bb-af55-2ca0-1c8e-8f9d38aa6731
            port: CUSTOM
          c9b1553a-d55a-4583-79f9-5d985d43f5e7:
            targetId: 6e89ba38-79dc-deb7-8ef2-77e4ef765ee0
            port: FAILURE
    results:
      FAILURE:
        6e89ba38-79dc-deb7-8ef2-77e4ef765ee0:
          x: 360
          'y': 480
      SUCCESS:
        6dffad0c-f7fe-3383-c0e0-c5ef8b685d52:
          x: 960
          'y': 280
      CUSTOM:
        8f0c58bb-af55-2ca0-1c8e-8f9d38aa6731:
          x: 480
          'y': 120
