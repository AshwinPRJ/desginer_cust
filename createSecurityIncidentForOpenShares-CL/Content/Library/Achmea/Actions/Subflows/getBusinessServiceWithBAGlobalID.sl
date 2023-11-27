namespace: Achmea.Actions.Subflows
flow:
  name: getBusinessServiceWithBAGlobalID
  inputs:
    - BusinessApplication_globalID: 905f6bf735c777021e1fb0ce947cbb3b
    - sso_TokenSMA:
        required: false
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
          - FAILURE: on_failure
    - xpath_query:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${return_resultXML}'
            - xpath_query: /CMDBTopology/Objects/CMDBSet/CMDBObject/Properties/global_id
            - query_type: value
        publish:
          - return_result
          - BusinessServiceGlobalID: '${selected_value}'
          - error_message
        navigate:
          - SUCCESS: queryEntityAchmea
          - FAILURE: on_failure
    - queryEntityAchmea:
        do:
          Achmea.Shared.subFlows.SMA.queryEntityAchmea:
            - entity_type: ActualService
            - query: "${\"GlobalId='\" + BusinessServiceGlobalID + \"'\"}"
            - fields: Id
            - sso_Token: '${sso_TokenSMA}'
        publish:
          - entity_json
          - entity_json_full: '${return_result}'
          - error_json
          - sso_TokenSMA
        navigate:
          - FAILURE: on_failure
          - SUCCESS: getQueryResultJson
          - CUSTOM: CUSTOM
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
          - FAILURE: on_failure
    - getValueFromList:
        do:
          Achmea.Shared.Operations.getValueFromList:
            - list: '${return_values}'
            - seperator: '@'
            - index: '1'
        publish:
          - BusinessServiceSMAxID: '${return_value}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - BusinessServiceSMAxID: '${BusinessServiceSMAxID}'
  results:
    - FAILURE
    - SUCCESS
    - CUSTOM
extensions:
  graph:
    steps:
      getBSName_GetTopologyMapByQueryNameWithParameterAchmea:
        x: 40
        'y': 120
      xpath_query:
        x: 200
        'y': 120
      queryEntityAchmea:
        x: 360
        'y': 120
        navigate:
          144a6047-bdfc-2001-9c56-a29f343f9c8d:
            targetId: bfdd4bbb-ad5f-f443-3c22-875e83b840de
            port: CUSTOM
      getQueryResultJson:
        x: 560
        'y': 120
      getValueFromList:
        x: 680
        'y': 160
        navigate:
          85447619-d1b2-02be-13d9-685bffa1f18f:
            targetId: ef68d928-6c5d-7dc7-a272-ec2fd4fcd08a
            port: SUCCESS
    results:
      SUCCESS:
        ef68d928-6c5d-7dc7-a272-ec2fd4fcd08a:
          x: 800
          'y': 200
      CUSTOM:
        bfdd4bbb-ad5f-f443-3c22-875e83b840de:
          x: 560
          'y': 360
