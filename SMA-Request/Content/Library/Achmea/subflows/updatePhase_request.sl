namespace: Achmea.subflows
flow:
  name: updatePhase_request
  inputs:
    - sso_token:
        required: false
    - request_Id: '2638350'
    - newPhase: Abandon
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_token}'
        navigate:
          - IS_NULL: getTokenSmaAchmea
          - IS_NOT_NULL: updatePhaseAchmea
    - getTokenSmaAchmea:
        do:
          Achmea.Shared.subFlows.SMA.getTokenSmaAchmea: []
        publish:
          - sso_token: '${sso_Token}'
        navigate:
          - SUCCESS: updatePhaseAchmea
          - FAILURE: on_failure
    - updatePhaseAchmea:
        do:
          Achmea.Shared.subFlows.SMA.updatePhaseAchmea:
            - sso_token: '${sso_token}'
            - sma_entityType: Request
            - sma_entityId: '${request_Id}'
            - sma_changePhase: '${newPhase}'
        navigate:
          - SUCCESS: SUCCESS
          - CUSTOM: CUSTOM
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
    - CUSTOM
extensions:
  graph:
    steps:
      is_null:
        x: 80
        'y': 360
      getTokenSmaAchmea:
        x: 320
        'y': 480
      updatePhaseAchmea:
        x: 320
        'y': 280
        navigate:
          4096b6d3-f013-6f2e-2e3e-c0d06d202518:
            targetId: 76a958ba-5878-9442-4496-2cc7e809a787
            port: SUCCESS
          13bb023f-ca12-85f0-655f-50485a4358c7:
            targetId: 6773d64c-2b39-303a-2ec0-8608d92cc834
            port: CUSTOM
    results:
      SUCCESS:
        76a958ba-5878-9442-4496-2cc7e809a787:
          x: 480
          'y': 400
      CUSTOM:
        6773d64c-2b39-303a-2ec0-8608d92cc834:
          x: 480
          'y': 240
