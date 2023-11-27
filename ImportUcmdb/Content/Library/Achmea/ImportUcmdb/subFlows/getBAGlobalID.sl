namespace: Achmea.ImportUcmdb.subFlows
flow:
  name: getBAGlobalID
  inputs:
    - BAName
  workflow:
    - GetTopologyMapByQueryNameWithParameterAchmea:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.GetTopologyMapByQueryNameWithParameterAchmea:
            - QueryName: ait_BusinessApplicationByName
            - string_props: "${'pBAName=' + BAName}"
        publish:
          - rawResult: '${return_result}'
          - return_code
          - exception
        navigate:
          - SUCCESS: xpath_query
          - FAILURE: on_failure
    - xpath_query:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${rawResult}'
            - xpath_query: /CMDBTopology/Objects/CMDBSet/CMDBObject/identifier
            - query_type: value
        publish:
          - baGlobalID: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - baGlobalID: '${baGlobalID}'
    - return_code: '${return_code}'
    - error_message: '${error_message}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      GetTopologyMapByQueryNameWithParameterAchmea:
        x: 360
        'y': 80
      xpath_query:
        x: 560
        'y': 80
        navigate:
          ab8b9af9-24a5-6674-f57b-8d0918da4cfe:
            targetId: cdc6265c-e0d5-2def-886b-5261a593c501
            port: SUCCESS
    results:
      SUCCESS:
        cdc6265c-e0d5-2def-886b-5261a593c501:
          x: 760
          'y': 80
