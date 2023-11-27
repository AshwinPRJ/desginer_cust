namespace: Achmea.Actions
flow:
  name: PlanningStage_Change
  inputs:
    - entityID
    - sso_token:
        required: false
    - ApprovalName:
        required: false
    - sma_url: "${get_sp('Achmea.SMA.URL')}"
    - sma_tenantID: "${get_sp('Achmea.SMA.Tentant')}"
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_token}'
        navigate:
          - IS_NULL: SMA_Token
          - IS_NOT_NULL: sma_changePhase
    - SMA_Token:
        do:
          Achmea.Subflows.SMAx.SMA_Token:
            - smaUrl: '${sma_url}'
            - smaTennant: '${sma_tenantID}'
            - smaUser: "${get_sp('SMA.sma_userName')}"
            - smaPassw:
                value: "${get_sp('SMA.sma_password')}"
                sensitive: true
        publish:
          - sso_token: '${ssoToken}'
        navigate:
          - FAILURE: FAILURE_1
          - SUCCESS: sma_changePhase
    - sma_changePhase:
        do:
          Achmea.Actions.sma_changePhase:
            - sma_url: '${sma_url}'
            - sma_tenantID: '${sma_tenantID}'
            - sma_entityId: '${entityID}'
            - sma_changePhase: Plan
            - sso_token: '${sso_token}'
        navigate:
          - FAILURE: FAILURE_1
          - SUCCESS: sma_changePhase_1
          - CUSTOM: CUSTOM
    - sma_changePhase_1:
        do:
          Achmea.Actions.sma_changePhase:
            - sma_url: '${sma_url}'
            - sma_tenantID: '${sma_tenantID}'
            - sma_entityId: '${entityID}'
            - sma_changePhase: ApprovePlan
            - sso_token: '${sso_token}'
        navigate:
          - FAILURE: FAILURE_1
          - SUCCESS: sleep_1
          - CUSTOM: CUSTOM
    - approveTask:
        do:
          Achmea.Actions.approveTask:
            - entityID: '${entityID}'
            - approvalName: '${ApprovalName}'
            - sso_token: '${sso_token}'
        navigate:
          - SUCCESS: sleep
          - FAILURE: FAILURE_1
          - CUSTOM: CUSTOM
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '0'
        navigate:
          - SUCCESS: sma_changePhase_2
          - FAILURE: FAILURE_1
    - sma_changePhase_2:
        do:
          Achmea.Actions.sma_changePhase:
            - sma_url: '${sma_url}'
            - sma_tenantID: '${sma_tenantID}'
            - sma_entityId: '${entityID}'
            - sma_changePhase: BuildAndTest
            - sso_token: '${sso_token}'
        navigate:
          - FAILURE: FAILURE_1
          - SUCCESS: sma_changePhase_3
          - CUSTOM: CUSTOM
    - sma_changePhase_3:
        do:
          Achmea.Actions.sma_changePhase:
            - sma_url: '${sma_url}'
            - sma_tenantID: '${sma_tenantID}'
            - sma_entityId: '${entityID}'
            - sma_changePhase: ApproveDeployment
            - sso_token: '${sso_token}'
        navigate:
          - FAILURE: FAILURE_1
          - SUCCESS: approveTask_1
          - CUSTOM: CUSTOM
    - approveTask_1:
        do:
          Achmea.Actions.approveTask:
            - entityID: '${entityID}'
            - approvalName: '${ApprovalName}'
            - sso_token: '${sso_token}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE_1
          - CUSTOM: CUSTOM
    - sleep_1:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '3'
        navigate:
          - SUCCESS: approveTask
          - FAILURE: FAILURE_1
  results:
    - FAILURE_1
    - CUSTOM
    - SUCCESS
extensions:
  graph:
    steps:
      SMA_Token:
        x: 200
        'y': 480
        navigate:
          304a30fe-5ddd-0823-82ea-d69c6ff69ffa:
            targetId: b1351993-e569-6b42-8439-d2a5ce37ef3d
            port: FAILURE
      approveTask_1:
        x: 920
        'y': 280
        navigate:
          dc325489-42a2-8c45-9548-c8295fe92ab7:
            targetId: 6a58833f-f25e-c584-2b3a-ed6e407347fd
            port: CUSTOM
          3a1dd581-f10e-8acc-e79f-04d7a2453559:
            targetId: b1351993-e569-6b42-8439-d2a5ce37ef3d
            port: FAILURE
          c54a02a4-00bf-e125-6ce3-e4d219a61887:
            targetId: b0fcf549-6a9c-e0b4-8777-e2f53dc8fe74
            port: SUCCESS
      sma_changePhase_1:
        x: 200
        'y': 280
        navigate:
          e0a852ae-d435-4cd6-654c-621193a01fdb:
            targetId: 6a58833f-f25e-c584-2b3a-ed6e407347fd
            port: CUSTOM
          be01ef46-bb03-bac9-c059-6351d5e1c8b9:
            targetId: b1351993-e569-6b42-8439-d2a5ce37ef3d
            port: FAILURE
      sma_changePhase_2:
        x: 680
        'y': 280
        navigate:
          2e59d7cc-7d2b-0c71-5aeb-41044adeab93:
            targetId: 6a58833f-f25e-c584-2b3a-ed6e407347fd
            port: CUSTOM
          1c25b97a-1895-0763-d2cc-3234ca704ab1:
            targetId: b1351993-e569-6b42-8439-d2a5ce37ef3d
            port: FAILURE
      sma_changePhase_3:
        x: 800
        'y': 280
        navigate:
          80cbe7b2-1441-2875-29da-717adfa32ac9:
            targetId: 6a58833f-f25e-c584-2b3a-ed6e407347fd
            port: CUSTOM
          0936781c-e8bc-1979-108c-1a39db2c1f8a:
            targetId: b1351993-e569-6b42-8439-d2a5ce37ef3d
            port: FAILURE
      sleep_1:
        x: 320
        'y': 280
        navigate:
          30c1eb26-9e82-61ba-dc30-16189b5ece1f:
            targetId: b1351993-e569-6b42-8439-d2a5ce37ef3d
            port: FAILURE
      approveTask:
        x: 440
        'y': 280
        navigate:
          384c8981-317e-c38f-439c-134deb285191:
            targetId: 6a58833f-f25e-c584-2b3a-ed6e407347fd
            port: CUSTOM
          d8dff1be-8d90-2ef8-a9ca-5d1cdd22c51e:
            targetId: b1351993-e569-6b42-8439-d2a5ce37ef3d
            port: FAILURE
      sma_changePhase:
        x: 80
        'y': 280
        navigate:
          ec51555c-3fc7-e3b5-a077-1fbbfed4d0ef:
            targetId: 6a58833f-f25e-c584-2b3a-ed6e407347fd
            port: CUSTOM
          244cbdcc-61ff-b6c3-99c6-7b9d31bf1639:
            targetId: b1351993-e569-6b42-8439-d2a5ce37ef3d
            port: FAILURE
      sleep:
        x: 560
        'y': 280
        navigate:
          f7e93e7c-112e-1fc5-601f-160f61659d3e:
            targetId: b1351993-e569-6b42-8439-d2a5ce37ef3d
            port: FAILURE
      is_null:
        x: 40
        'y': 480
    results:
      FAILURE_1:
        b1351993-e569-6b42-8439-d2a5ce37ef3d:
          x: 560
          'y': 480
      CUSTOM:
        6a58833f-f25e-c584-2b3a-ed6e407347fd:
          x: 560
          'y': 120
      SUCCESS:
        b0fcf549-6a9c-e0b4-8777-e2f53dc8fe74:
          x: 920
          'y': 440
