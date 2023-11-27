namespace: Achmea.Subflows
flow:
  name: test
  workflow:
    - Create_GroupName:
        do:
          Achmea.Oprations.Create_GroupName:
            - Scope: g
            - Type: s
            - Category: SMA
            - Description: mgt
            - Environment: tst
            - Remark: rw
        publish:
          - return_result
          - error: '${error_message}'
          - return_code
        navigate:
          - CUSTOM: CUSTOM
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE
    - CUSTOM
extensions:
  graph:
    steps:
      Create_GroupName:
        x: 320
        'y': 400
        navigate:
          d8efe862-e884-1c11-657e-8284ffd7fc4b:
            targetId: 4ca710c3-4c3d-a868-db13-d5cc54e2f55f
            port: CUSTOM
          b862cee0-6e3a-2b8e-4e4a-3c6ceb314451:
            targetId: 846a4ac2-375a-7f1a-819e-27d4822600f7
            port: SUCCESS
    results:
      SUCCESS:
        846a4ac2-375a-7f1a-819e-27d4822600f7:
          x: 640
          'y': 400
      CUSTOM:
        4ca710c3-4c3d-a868-db13-d5cc54e2f55f:
          x: 520
          'y': 240
