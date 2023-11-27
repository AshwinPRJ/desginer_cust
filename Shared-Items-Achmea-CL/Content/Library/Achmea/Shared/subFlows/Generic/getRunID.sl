namespace: Achmea.Shared.subFlows.Generic
flow:
  name: getRunID
  workflow:
    - Get_RunID_do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - RUN_ID: '${run_id}'
        publish:
          - RUN_ID
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - RUN_ID: '${RUN_ID}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_RunID_do_nothing:
        x: 400
        'y': 160
        navigate:
          8c9f298f-e616-fc6f-cab8-ab0e80cec6ce:
            targetId: 196d19db-fb5d-0d2b-e297-4e00e81ca0b7
            port: SUCCESS
    results:
      SUCCESS:
        196d19db-fb5d-0d2b-e297-4e00e81ca0b7:
          x: 640
          'y': 160
