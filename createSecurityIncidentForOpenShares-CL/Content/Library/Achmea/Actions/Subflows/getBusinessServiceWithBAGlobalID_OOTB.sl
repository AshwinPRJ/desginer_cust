namespace: Achmea.Actions.Subflows
flow:
  name: getBusinessServiceWithBAGlobalID_OOTB
  inputs:
    - BusinessApplication_globalID: 491d977c5774d8ab8d5c46b4a163861f
  workflow:
    - getBSName_GetTopologyMapByQueryNameWithParameterAchmea:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.GetTopologyMapByQueryNameWithParameterAchmea:
            - QueryName: ait_BusService_BusApp
            - string_props: "${'pGlobalID=' +  BusinessApplication_globalID}"
        publish:
          - return_resultXML: '${return_result}'
          - return_code
          - exception
        navigate:
          - SUCCESS: xpath_query
          - FAILURE: FAILURE
    - xpath_query:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${return_resultXML}'
            - xpath_query: /CMDBTopology/Objects/CMDBSet/CMDBObject/Properties/display_label
            - query_type: value
        publish:
          - return_result
          - BussinessServiceName: '${selected_value}'
        navigate:
          - SUCCESS: GetBSGlobalID_GetTopologyMapByQueryNameWithParameterAchmea
          - FAILURE: FAILURE
    - queryEntityAchmea:
        do:
          Achmea.Shared.subFlows.SMA.queryEntityAchmea:
            - entity_type: ActualService
            - query: "${\"GlobalId='\" + BussinessServiceGlobalID + \"'\"}"
            - fields: Id
        publish:
          - entity_json
          - entity_json_full: '${return_result}'
          - error_json
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: getQueryResultJson
          - CUSTOM: CUSTOM
    - GetBSGlobalID_GetTopologyMapByQueryNameWithParameterAchmea:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.GetTopologyMapByQueryNameWithParameterAchmea:
            - QueryName: aitGetBusinessServiceGlobalIDByName
            - string_props: '${"aitBSName=" +  BussinessServiceName}'
        publish:
          - return_resultXML: '${return_result}'
          - return_code
          - exception
        navigate:
          - SUCCESS: getBSGlobalID_xpath_query
          - FAILURE: FAILURE
    - getBSGlobalID_xpath_query:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${return_resultXML}'
            - xpath_query: /CMDBTopology/Objects/CMDBSet/CMDBObject/identifier
            - query_type: value
        publish:
          - return_resultXML: '${return_result}'
          - BussinessServiceGlobalID: '${selected_value}'
        navigate:
          - SUCCESS: queryEntityAchmea
          - FAILURE: FAILURE
    - getQueryResultJson:
        do:
          Achmea.Shared.Operations.getQueryResultJson:
            - jsonResultSMAx: '${entity_json_full}'
            - seperator: '@'
        publish:
          - error_message
          - return_code
          - return_fields
          - return_values
        navigate:
          - SUCCESS: getValueFromList
          - FAILURE: FAILURE
    - getValueFromList:
        do:
          Achmea.Shared.Operations.getValueFromList:
            - list: '${return_values}'
            - seperator: '@'
            - index: '1'
        publish:
          - ActualServiceID: '${return_value}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - ActualServiceID: '${ActualServiceID}'
    - return_result: '${return_result}'
  results:
    - SUCCESS
    - FAILURE
    - CUSTOM
extensions:
  graph:
    steps:
      getBSName_GetTopologyMapByQueryNameWithParameterAchmea:
        x: 80
        'y': 80
        navigate:
          d2aefb08-b337-df6e-cc04-ae6e0c6a2c1c:
            targetId: ef0dcee5-d991-7e90-eee1-5245993077ba
            port: FAILURE
      xpath_query:
        x: 240
        'y': 80
        navigate:
          882ccee7-ae02-8e14-78d3-a567c2934d02:
            targetId: ef0dcee5-d991-7e90-eee1-5245993077ba
            port: FAILURE
      queryEntityAchmea:
        x: 680
        'y': 80
        navigate:
          08f40813-e68c-23ec-12d4-3015ea3f62bc:
            targetId: b1ccc607-6005-5f08-de32-2cfb18654530
            port: CUSTOM
          62b94f48-6950-e748-5cac-4bd54f1a10e8:
            targetId: ef0dcee5-d991-7e90-eee1-5245993077ba
            port: FAILURE
      GetBSGlobalID_GetTopologyMapByQueryNameWithParameterAchmea:
        x: 400
        'y': 80
        navigate:
          409a217b-035f-ac51-6e2f-f5bc643a21e5:
            targetId: ef0dcee5-d991-7e90-eee1-5245993077ba
            port: FAILURE
      getBSGlobalID_xpath_query:
        x: 520
        'y': 80
        navigate:
          161f58b9-162c-bccb-082f-49411b2da593:
            targetId: ef0dcee5-d991-7e90-eee1-5245993077ba
            port: FAILURE
      getQueryResultJson:
        x: 840
        'y': 80
        navigate:
          6daf30be-13db-6857-78e4-3ea6f54aa68a:
            targetId: ef0dcee5-d991-7e90-eee1-5245993077ba
            port: FAILURE
      getValueFromList:
        x: 800
        'y': 280
        navigate:
          b116885d-81a7-1465-c310-769d92be16cd:
            targetId: 5318edfc-5729-4939-d611-14b34075e234
            port: SUCCESS
          58c73f88-ec9e-7c76-1486-8a74886515b7:
            targetId: ef0dcee5-d991-7e90-eee1-5245993077ba
            port: FAILURE
    results:
      SUCCESS:
        5318edfc-5729-4939-d611-14b34075e234:
          x: 800
          'y': 480
      FAILURE:
        ef0dcee5-d991-7e90-eee1-5245993077ba:
          x: 320
          'y': 360
      CUSTOM:
        b1ccc607-6005-5f08-de32-2cfb18654530:
          x: 480
          'y': 0
