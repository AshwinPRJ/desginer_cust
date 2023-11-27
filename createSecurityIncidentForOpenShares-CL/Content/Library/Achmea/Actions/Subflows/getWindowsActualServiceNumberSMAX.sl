namespace: Achmea.Actions.Subflows
flow:
  name: getWindowsActualServiceNumberSMAX
  inputs:
    - BusinessApplication_globalID: 4245ce4afc1cd1a56cc9375bc2736756
  workflow:
    - GetTopologyMapByQueryNameWithParameterAchmea:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.GetTopologyMapByQueryNameWithParameterAchmea:
            - QueryName: ait_BusService_BusApp
            - string_props: "${'pGlobalID=' + BusinessApplication_globalID}"
        publish:
          - XMLResult: '${return_result}'
          - return_code
          - exception
        navigate:
          - SUCCESS: xpath_query
          - FAILURE: FAILURE
    - queryEntityAchmea:
        do:
          Achmea.Shared.subFlows.SMA.queryEntityAchmea:
            - entity_type: ActualService
            - query: "${'DisplayLabel=' + \"'\" + BSName_return_result + \"'\"}"
            - fields: Id
        publish:
          - entity_json
          - return_result
          - result_count
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
          - CUSTOM: CUSTOM
    - xpath_query:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${XMLResult}'
            - xpath_query: /CMDBTopology/Objects/CMDBSet/CMDBObject/Properties/name
            - query_type: nodelist
        publish:
          - ResultAfterXPathQuery: '${selected_value}'
          - error_message
          - return_code
        navigate:
          - SUCCESS: queryEntityAchmea
          - FAILURE: FAILURE
  results:
    - SUCCESS
    - CUSTOM
    - FAILURE
extensions:
  graph:
    steps:
      queryEntityAchmea:
        x: 440
        'y': 80
        navigate:
          e001b66d-0cf1-dee4-f539-7041f496ed32:
            targetId: e1c33409-402b-93c1-c2c9-39d224423ce5
            port: CUSTOM
          c1617bbb-ee98-4ba4-7391-b62624159063:
            targetId: 94aa52e9-3f69-dd02-0ca3-d1e1b7e22206
            port: SUCCESS
          0d31f8db-d4d3-92e4-00a3-014a55a9695f:
            targetId: 4cac866b-f49b-e84d-7f2e-d67fb3f76599
            port: FAILURE
      GetTopologyMapByQueryNameWithParameterAchmea:
        x: 80
        'y': 80
        navigate:
          9b1daa7b-b204-bf0f-b6b1-aaf533334e89:
            targetId: 4cac866b-f49b-e84d-7f2e-d67fb3f76599
            port: FAILURE
      xpath_query:
        x: 240
        'y': 80
        navigate:
          4819f738-05ec-9a76-45a4-c903be66a6f6:
            targetId: 4cac866b-f49b-e84d-7f2e-d67fb3f76599
            port: FAILURE
    results:
      SUCCESS:
        94aa52e9-3f69-dd02-0ca3-d1e1b7e22206:
          x: 760
          'y': 80
      CUSTOM:
        e1c33409-402b-93c1-c2c9-39d224423ce5:
          x: 600
          'y': 280
      FAILURE:
        4cac866b-f49b-e84d-7f2e-d67fb3f76599:
          x: 440
          'y': 360
