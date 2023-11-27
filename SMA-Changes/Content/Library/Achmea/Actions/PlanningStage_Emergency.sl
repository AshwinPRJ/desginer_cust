namespace: Achmea.Actions
flow:
  name: PlanningStage_Emergency
  inputs:
    - entityID
    - sso_token
    - ApprovalName
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
          - FAILURE: FAILURE
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
          - FAILURE: FAILURE
          - SUCCESS: sma_changePhase_1
          - CUSTOM: CUSTOM
    - sma_changePhase_1:
        do:
          Achmea.Actions.sma_changePhase:
            - sma_url: '${sma_url}'
            - sma_tenantID: '${sma_tenantID}'
            - sma_entityId: '${entityID}'
            - sma_changePhase: BuildAndTest
            - sso_token: '${sso_token}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: sma_changePhase_2
          - CUSTOM: CUSTOM
    - approveTask:
        do:
          Achmea.Actions.approveTask:
            - entityID: '${entityID}'
            - approvalName: '${ApprovalName}'
            - sso_token: '${sso_token}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
          - CUSTOM: CUSTOM
    - sma_changePhase_2:
        do:
          Achmea.Actions.sma_changePhase:
            - sma_url: '${sma_url}'
            - sma_tenantID: '${sma_tenantID}'
            - sma_entityId: '${entityID}'
            - sma_changePhase: ECAB
            - sso_token: '${sso_token}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: approveTask
          - CUSTOM: CUSTOM
  results:
    - FAILURE
    - CUSTOM
    - SUCCESS
extensions:
  graph:
    steps:
      is_null:
        x: 40
        'y': 240
      SMA_Token:
        x: 280
        'y': 400
        navigate:
          47daaf9d-8702-ffe9-ab49-9713d5842f8f:
            targetId: 7de629c1-2ad5-1116-8dc8-bcff29ae3f3a
            port: FAILURE
      sma_changePhase:
        x: 200
        'y': 240
        navigate:
          878884f8-7922-8e45-2228-e735ca6ef8c9:
            targetId: 7de629c1-2ad5-1116-8dc8-bcff29ae3f3a
            port: FAILURE
          8d17e4bd-dea0-a85f-93a4-958766757bf8:
            targetId: e867f62f-c232-9e4a-9546-38063390cce6
            port: CUSTOM
      sma_changePhase_1:
        x: 360
        'y': 240
        navigate:
          5cf226e1-96d0-addc-2c50-87d3f1e94bd6:
            targetId: e867f62f-c232-9e4a-9546-38063390cce6
            port: CUSTOM
          7f7f23ad-50d7-30f9-2480-bd8812403113:
            targetId: 7de629c1-2ad5-1116-8dc8-bcff29ae3f3a
            port: FAILURE
      approveTask:
        x: 600
        'y': 240
        navigate:
          521f8e51-da30-109d-e554-9b455d3e9278:
            targetId: e867f62f-c232-9e4a-9546-38063390cce6
            port: CUSTOM
          25c2a7d0-a469-6470-9a9e-3adbfaa7fc96:
            targetId: 7de629c1-2ad5-1116-8dc8-bcff29ae3f3a
            port: FAILURE
          ae4360bd-beda-c4ba-ae12-e0c559f9482a:
            targetId: 47a5213f-7741-b6c6-e250-ea347e172fa9
            port: SUCCESS
      sma_changePhase_2:
        x: 480
        'y': 240
        navigate:
          8023f457-2b9a-5ba3-0e2f-2b648d990d08:
            targetId: 7de629c1-2ad5-1116-8dc8-bcff29ae3f3a
            port: FAILURE
          f90843bb-bb98-1930-48a6-32c0a96dc8de:
            targetId: e867f62f-c232-9e4a-9546-38063390cce6
            port: CUSTOM
    results:
      FAILURE:
        7de629c1-2ad5-1116-8dc8-bcff29ae3f3a:
          x: 440
          'y': 400
      CUSTOM:
        e867f62f-c232-9e4a-9546-38063390cce6:
          x: 400
          'y': 80
      SUCCESS:
        47a5213f-7741-b6c6-e250-ea347e172fa9:
          x: 720
          'y': 240
