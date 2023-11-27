namespace: Achmea.Actions
flow:
  name: approveTask
  inputs:
    - entityID
    - approvalName
    - sso_token:
        required: false
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_token}'
        navigate:
          - IS_NULL: SMA_Token
          - IS_NOT_NULL: sma_getTask
    - sma_getTask:
        do:
          Achmea.Actions.sma_getTask:
            - parentID: '${entityID}'
            - titleTask: '${approvalName}'
            - sso_token: '${sso_token}'
        publish:
          - taskID
        navigate:
          - FAILURE_1: FAILURE
          - SUCCESS: sma_changePhase
          - CUSTOM: CUSTOM
    - sma_changePhase:
        do:
          Achmea.Actions.sma_changePhase:
            - sma_url: "${get_sp('Achmea.SMA.URL')}"
            - sma_tenantID: "${get_sp('Achmea.SMA.Tentant')}"
            - sma_entityType: Task
            - sma_entityId: '${taskID}'
            - sma_changePhase: Approved
            - sso_token: '${sso_token}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
          - CUSTOM: CUSTOM
    - SMA_Token:
        do:
          Achmea.Subflows.SMAx.SMA_Token:
            - smaUrl: "${get_sp('Achmea.SMA.URL')}"
            - smaTennant: "${get_sp('Achmea.SMA.Tentant')}"
            - smaUser: "${get_sp('Achmea.SMA.User')}"
            - smaPassw:
                value: "${get_sp('Achmea.SMA.Password')}"
                sensitive: true
        publish:
          - sso_token: '${ssoToken}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: sma_getTask
  results:
    - SUCCESS
    - FAILURE
    - CUSTOM
extensions:
  graph:
    steps:
      is_null:
        x: 120
        'y': 240
      sma_getTask:
        x: 320
        'y': 320
        navigate:
          7a41b3c8-62bc-201f-0b35-0154375cd08a:
            targetId: e41bae20-7bac-6b3c-8781-af77339736bf
            port: FAILURE_1
          fe2d8686-bc25-e38a-40e7-05ca0628022d:
            targetId: a35396cf-e2b4-99c0-ab79-6fa3bb0e4644
            port: CUSTOM
      sma_changePhase:
        x: 520
        'y': 320
        navigate:
          160f3039-24ad-243d-8700-405d3334ab32:
            targetId: e41bae20-7bac-6b3c-8781-af77339736bf
            port: FAILURE
          b660b6a9-85f8-7096-0b08-237201698686:
            targetId: a35396cf-e2b4-99c0-ab79-6fa3bb0e4644
            port: CUSTOM
          8f7af31c-2c4c-e81b-8f19-14f1c02ca93b:
            targetId: c4699093-bbf7-54e0-6a76-0eb1881cfef0
            port: SUCCESS
      SMA_Token:
        x: 160
        'y': 400
        navigate:
          db48b278-da1f-e246-22bb-69214798cdc2:
            targetId: e41bae20-7bac-6b3c-8781-af77339736bf
            port: FAILURE
    results:
      SUCCESS:
        c4699093-bbf7-54e0-6a76-0eb1881cfef0:
          x: 680
          'y': 320
      FAILURE:
        e41bae20-7bac-6b3c-8781-af77339736bf:
          x: 440
          'y': 480
      CUSTOM:
        a35396cf-e2b4-99c0-ab79-6fa3bb0e4644:
          x: 440
          'y': 160
