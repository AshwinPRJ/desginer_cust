namespace: Achmea.Actions
flow:
  name: sma_getTask
  inputs:
    - parentID
    - currentPhase: Pending
    - titleTask
    - sso_token
  workflow:
    - Get_SMATask:
        do:
          Achmea.Subflows.SMAx.Get_SMATask:
            - smaTennant: "${get_sp('Achmea.SMA.Tentant')}"
            - smaUrl: "${get_sp('Achmea.SMA.URL')}"
            - parentId: '${parentID}'
            - titleTask: '${titleTask}'
            - currentPhase: '${currentPhase}'
            - smaUser: "${get_sp('Achmea.SMA.User')}"
            - smaPassw:
                value: "${get_sp('Achmea.SMA.Password')}"
                sensitive: true
            - sso_token: '${sso_token}'
        publish:
          - taskID: '${resultGetTask}'
        navigate:
          - FAILURE: FAILURE_1
          - SUCCESS: SUCCESS
          - CUSTOM: CUSTOM
  outputs:
    - taskID: '${taskID}'
  results:
    - FAILURE_1
    - SUCCESS
    - CUSTOM
extensions:
  graph:
    steps:
      Get_SMATask:
        x: 360
        'y': 320
        navigate:
          9666b9dd-9132-efef-1c51-e011a03aa4e3:
            targetId: 500c9bc9-4e5e-67c7-33be-8db6c29b618e
            port: FAILURE
          deb1f2e1-62e7-349f-27a3-99a5a3994535:
            targetId: 667669a0-d634-1c73-7d12-f4bd29523435
            port: SUCCESS
          389cbe49-c8d2-90bd-5030-9978a52dfb69:
            targetId: 67e210d9-18c2-13a7-813b-76c5ef7ffe85
            port: CUSTOM
    results:
      FAILURE_1:
        500c9bc9-4e5e-67c7-33be-8db6c29b618e:
          x: 400
          'y': 480
      SUCCESS:
        667669a0-d634-1c73-7d12-f4bd29523435:
          x: 520
          'y': 320
      CUSTOM:
        67e210d9-18c2-13a7-813b-76c5ef7ffe85:
          x: 360
          'y': 160
