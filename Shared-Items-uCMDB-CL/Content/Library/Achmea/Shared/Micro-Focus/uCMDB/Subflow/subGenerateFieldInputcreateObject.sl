namespace: Achmea.Shared.Micro-Focus.uCMDB.Subflow
flow:
  name: subGenerateFieldInputcreateObject
  inputs:
    - prop
    - prop1
    - prop2:
        required: false
    - prop3:
        required: false
    - prop4:
        required: false
    - prop5:
        required: false
  workflow:
    - Change_Input_to_flowvar_do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - prop: '${prop}'
            - prop1: '${prop1}'
            - prop2: '${prop2}'
            - prop3: '${prop3}'
            - prop4: '${prop4}'
            - prop5: '${prop5}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Change_Input_to_flowvar_do_nothing:
        x: 280
        'y': 120
        navigate:
          cd41fb73-e634-8b83-588c-9847b1186d5c:
            targetId: 45a5d3ab-9da3-c4b1-1366-ef75faf066f7
            port: FAILURE
          feb55603-e925-bd2b-0cf5-cc44aee22919:
            targetId: a516b3d9-8417-e9d2-6e06-58a8e718a3bc
            port: SUCCESS
    results:
      FAILURE:
        45a5d3ab-9da3-c4b1-1366-ef75faf066f7:
          x: 280
          'y': 320
      SUCCESS:
        a516b3d9-8417-e9d2-6e06-58a8e718a3bc:
          x: 520
          'y': 120
