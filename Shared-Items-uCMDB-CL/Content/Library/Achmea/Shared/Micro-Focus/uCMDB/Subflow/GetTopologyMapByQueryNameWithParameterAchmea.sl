namespace: Achmea.Shared.Micro-Focus.uCMDB.Subflow
flow:
  name: GetTopologyMapByQueryNameWithParameterAchmea
  inputs:
    - QueryName
    - string_props:
        required: false
    - string_list_props:
        required: false
    - integer_props:
        required: false
    - date_props:
        required: false
  workflow:
    - getCreditsKeepass:
        do:
          Achmea.Shared.subFlows.Generic.getCreditsKeepass:
            - KeepassEntry: "${get_sp('MF.uCMDB.uCMDBKeepassEntry')}"
        publish:
          - UserName
          - PassWord
          - return_code
          - error_message
        navigate:
          - SUCCESS: get_topology_map_by_query_name_with_parameter
          - FAILURE: FAILURE
    - get_topology_map_by_query_name_with_parameter:
        do:
          io.cloudslang.microfocus.ucmdb.v1.topology.get_topology_map_by_query_name_with_parameter:
            - url: "${get_sp('MF.uCMDB.uCMDB_url')}"
            - username: '${UserName}'
            - password:
                value: '${PassWord}'
                sensitive: true
            - query_name: '${QueryName}'
            - string_props: '${string_props}'
            - string_list_props: '${string_list_props}'
            - integer_props: '${integer_props}'
            - date_props: '${date_props}'
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - return_result: '${return_result}'
    - return_code: '${return_code}'
    - exception: '${exception}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      getCreditsKeepass:
        x: 120
        'y': 80
        navigate:
          e74ef6b8-ec16-36e7-97d1-d649685072a2:
            targetId: 5c747534-13ce-3099-1f58-9a0dac179689
            port: FAILURE
      get_topology_map_by_query_name_with_parameter:
        x: 360
        'y': 160
        navigate:
          c7c4513f-1bb9-e9ae-c091-77a1103b74b9:
            targetId: 5c747534-13ce-3099-1f58-9a0dac179689
            port: FAILURE
          bba5563a-4e63-f429-e166-2d7ad2ae1ba1:
            targetId: cfc5bffb-c5a0-4aec-e62a-ebfa8573095e
            port: SUCCESS
    results:
      SUCCESS:
        cfc5bffb-c5a0-4aec-e62a-ebfa8573095e:
          x: 600
          'y': 80
      FAILURE:
        5c747534-13ce-3099-1f58-9a0dac179689:
          x: 280
          'y': 440
