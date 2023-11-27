namespace: actions
flow:
  name: RegressieTest_Incident
  inputs:
    - sma_url: "${get_sp('Achmea.SMA.URL')}"
    - sma_tenantID: "${get_sp('Achmea.SMA.Tentant')}"
    - sma_incidentModel: "${get_sp('incidentModel')}"
    - proces: Incident
    - sso_token:
        required: false
    - fields: "${get_sp('incidentFields')}"
  workflow:
    - getTokenSmaAchmea:
        do:
          Achmea.Shared.subFlows.SMA.getTokenSmaAchmea: []
        publish:
          - sso_token: '${sso_Token}'
        navigate:
          - SUCCESS: get_displayLabel
          - FAILURE: on_failure
    - get_displayLabel:
        do:
          Operation.get_displayLabel:
            - Proces: '${proces}'
        publish:
          - displayLabel
        navigate:
          - SUCCESS: sma_createIncident
    - sma_createIncident:
        do:
          Subflows.sma_createIncident:
            - sso_token: '${sso_token}'
            - fields: '${fields}'
            - values: '${displayLabel+","+sma_incidentModel}'
        publish:
          - created_Id
        navigate:
          - SUCCESS: sma_updateIncident
          - FAILURE: on_failure
    - sma_updateIncident:
        do:
          Subflows.sma_updateIncident:
            - sso_token: '${sso_token}'
            - entityId: '${created_Id}'
            - field: Category
            - value: "${get_sp('incidentCategory')}"
        navigate:
          - SUCCESS: sma_updatePhaseIncident
          - FAILURE: on_failure
    - sma_updatePhaseIncident:
        do:
          Subflows.sma_updatePhaseIncident:
            - sso_token: '${sso_token}'
            - sma_entityId: '${created_Id}'
            - sma_changePhase: Close
        navigate:
          - CUSTOM: CUSTOM
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE_1
  results:
    - FAILURE
    - SUCCESS
    - FAILURE_1
    - CUSTOM
extensions:
  graph:
    steps:
      getTokenSmaAchmea:
        x: 80
        'y': 440
      get_displayLabel:
        x: 200
        'y': 440
      sma_createIncident:
        x: 360
        'y': 440
      sma_updateIncident:
        x: 520
        'y': 440
      sma_updatePhaseIncident:
        x: 680
        'y': 440
        navigate:
          67ad16d1-36e6-1c5a-24de-b3aa20e2426e:
            targetId: e86863b6-cebe-dcc7-7b54-211efb132d3c
            port: SUCCESS
          bd3bfc7f-93b7-111b-5964-81147597d094:
            targetId: e01a58b9-5341-d872-5b55-39fd55943da0
            port: CUSTOM
          fbb18437-5135-4ff0-2a40-3c00804a1013:
            targetId: e557f123-68cd-fec9-434d-62a317aeece2
            port: FAILURE
    results:
      SUCCESS:
        e86863b6-cebe-dcc7-7b54-211efb132d3c:
          x: 960
          'y': 480
      FAILURE_1:
        e557f123-68cd-fec9-434d-62a317aeece2:
          x: 680
          'y': 640
      CUSTOM:
        e01a58b9-5341-d872-5b55-39fd55943da0:
          x: 640
          'y': 240
