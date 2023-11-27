namespace: Subflows
flow:
  name: sma_updatePhaseIncident
  inputs:
    - sso_token:
        required: false
    - sma_entityId
    - sma_changePhase
  workflow:
    - updatePhaseAchmea:
        do:
          Achmea.Shared.subFlows.SMA.updatePhaseAchmea:
            - sso_token: '${sso_token}'
            - sma_entityType: Incident
            - sma_entityId: '${sma_entityId}'
            - sma_changePhase: '${sma_changePhase}'
        navigate:
          - SUCCESS: SUCCESS
          - CUSTOM: CUSTOM
          - FAILURE: on_failure
  results:
    - CUSTOM
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      updatePhaseAchmea:
        x: 320
        'y': 360
        navigate:
          dc4e7ede-07de-4541-f1cb-5478abd8fd2e:
            targetId: 0d889a54-ab97-a188-6391-b3bc6fb0ac06
            port: CUSTOM
          dabc2289-e794-9375-fe9a-853e86762078:
            targetId: 1eaa8cc3-690c-9f07-9575-05ed6e75eded
            port: SUCCESS
    results:
      CUSTOM:
        0d889a54-ab97-a188-6391-b3bc6fb0ac06:
          x: 560
          'y': 160
      SUCCESS:
        1eaa8cc3-690c-9f07-9575-05ed6e75eded:
          x: 720
          'y': 320
