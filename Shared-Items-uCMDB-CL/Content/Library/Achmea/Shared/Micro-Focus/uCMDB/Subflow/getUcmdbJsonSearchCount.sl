namespace: Achmea.Shared.Micro-Focus.uCMDB.Subflow
flow:
  name: getUcmdbJsonSearchCount
  inputs:
    - JsonResult
  workflow:
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${JsonResult}'
            - json_path: $..ucmdbId
        publish:
          - return_result_list: '${return_result}'
        navigate:
          - SUCCESS: length
          - FAILURE: FAILURE
    - length:
        do:
          io.cloudslang.base.lists.length:
            - list: '${return_result_list}'
            - delimiter: ','
        publish:
          - Count: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - Count: '${Count}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      json_path_query:
        x: 240
        'y': 120
        navigate:
          5882ec56-2558-debd-9f32-089317ab542b:
            targetId: 50e20705-2145-a11b-efea-47d1b7df8d35
            port: FAILURE
      length:
        x: 440
        'y': 120
        navigate:
          6fe8ba4c-083b-80bd-af10-fb8a30b0c327:
            targetId: 50e20705-2145-a11b-efea-47d1b7df8d35
            port: FAILURE
          16e348ea-a091-a201-25e1-ad9e2235a07c:
            targetId: 86894b01-b02a-ad09-1822-e50fdbca1d69
            port: SUCCESS
    results:
      SUCCESS:
        86894b01-b02a-ad09-1822-e50fdbca1d69:
          x: 720
          'y': 120
      FAILURE:
        50e20705-2145-a11b-efea-47d1b7df8d35:
          x: 360
          'y': 320
