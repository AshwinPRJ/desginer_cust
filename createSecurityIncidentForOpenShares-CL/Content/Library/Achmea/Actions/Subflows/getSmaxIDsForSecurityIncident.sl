########################################################################################################################
#!!
#! @description: This flow will try to find all the ID's to create the security incident. 
#!               Ucmdb: find the relations (Server -> BA -> Service OR Server -> CIColl - Service
#!               SMAx: Find ID's and solutiongroupid for Group
#!               SMAx: Find ID for Service
#!               When something is not found the default Infra service with solution group will be returned.
#!!#
########################################################################################################################
namespace: Achmea.Actions.Subflows
flow:
  name: getSmaxIDsForSecurityIncident
  inputs:
    - server_name
    - sso_TokenSMA:
        required: false
  workflow:
    - getHostNameFlat_getSubStringLeft:
        do:
          Achmea.Actions.Operations.getSubStringLeft:
            - Value: '${server_name}'
            - Seperator: .
        publish:
          - server_name_filtered: '${return_value}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: GetTopologyMapByQueryNameWithParameterAchmea
          - FAILURE: on_failure
    - GetTopologyMapByQueryNameWithParameterAchmea:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.GetTopologyMapByQueryNameWithParameterAchmea:
            - QueryName: "${get_sp('Achmea.createSecurityIncidentsForOpenShares.UcmdbComputerToBATQL')}"
            - string_props: '${"pServerName=" + server_name_filtered}'
        publish:
          - xmlResult: '${return_result}'
          - return_code
          - exception
        navigate:
          - SUCCESS: getBA_xpath_query
          - FAILURE: on_failure
    - findBusinessApplicationqueryEntityAchmea:
        do:
          Achmea.Shared.subFlows.SMA.queryEntityAchmea:
            - entity_type: ServiceComponent
            - query: "${\"GlobalId='\" + BusinessApplication_globalID + \"'\"}"
            - fields: "${get_sp('Achmea.createSecurityIncidentsForOpenShares.SupportLevelGroup')}"
            - sso_Token: '${sso_TokenSMA}'
        publish:
          - entity_json
          - entity_json_full: '${return_result}'
          - error_json
          - sso_TokenSMA
        navigate:
          - FAILURE: on_failure
          - SUCCESS: getBusAppDetails_getQueryResultJson
          - CUSTOM: getBusServiceWhenNotFound
    - unique_globaldID_getUniqueString:
        do:
          Achmea.Shared.Operations.getUniqueString:
            - values: '${xPathQueryReturn_result}'
            - seperator: ','
        publish:
          - return_code
          - BusinessApplication_globalID: '${return_value}'
          - error_message
        navigate:
          - SUCCESS: findBusinessApplicationqueryEntityAchmea
          - FAILURE: on_failure
    - getBA_xpath_query:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${xmlResult}'
            - xpath_query: /CMDBTopology/Objects/CMDBSet/CMDBObject/Properties/global_id
            - query_type: value
            - delimiter: ','
        publish:
          - xPathQueryReturn_result: '${selected_value}'
          - error_message
          - return_code
        navigate:
          - SUCCESS: UcmdbBANotFound_string_equals
          - FAILURE: on_failure
    - getBusAppDetails_getQueryResultJson:
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
          - SUCCESS: getAssignementGroupBA_getValueFromList
          - FAILURE: on_failure
    - getAssignementGroupBA_getValueFromList:
        do:
          Achmea.Shared.Operations.getValueFromList:
            - list: '${return_values}'
            - seperator: '@'
            - index: '0'
        publish:
          - smaxGroupID: '${return_value}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: getBusinessServiceSMAxIDWithBAGlobalID
          - FAILURE: on_failure
    - getBusinessServiceSMAxIDWithBAGlobalID:
        do:
          Achmea.Actions.Subflows.getBusinessServiceSMAxIDWithBAGlobalID:
            - BusinessApplication_globalID: '${BusinessApplication_globalID}'
            - sso_TokenSMA: '${sso_TokenSMA}'
        publish:
          - ServiceSMAxID: '${BusinessServiceSMAxID}'
          - error_message
          - return_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
          - CUSTOM: getBusServiceWhenNotFound
    - UcmdbBANotFound_string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${xPathQueryReturn_result}'
            - second_string: No match found
        navigate:
          - SUCCESS: getBusServiceWhenNotFound
          - FAILURE: unique_globaldID_getUniqueString
    - getBusServiceWhenNotFound:
        do:
          Achmea.Actions.Subflows.getBusServiceWhenNotFound:
            - sso_TokenSMA: '${sso_TokenSMA}'
        publish:
          - error_message
          - ServiceSMAxID
          - smaxGroupID
        navigate:
          - FAILURE: on_failure
          - CUSTOM_InfraNotFound: CUSTOM_DefaultInfraNotFound
          - SUCCESS: SUCCESS_DEFAULT
  outputs:
    - groupIDSMAx: '${smaxGroupID}'
    - return_result: '${return_result}'
    - error_message: '${error_message}'
    - ServiceSMAxID: '${ServiceSMAxID}'
  results:
    - SUCCESS
    - FAILURE
    - CUSTOM_DefaultInfraNotFound
    - SUCCESS_DEFAULT
extensions:
  graph:
    steps:
      GetTopologyMapByQueryNameWithParameterAchmea:
        x: 320
        'y': 40
      getAssignementGroupBA_getValueFromList:
        x: 200
        'y': 520
      unique_globaldID_getUniqueString:
        x: 960
        'y': 320
      getBusAppDetails_getQueryResultJson:
        x: 400
        'y': 520
      getBusinessServiceSMAxIDWithBAGlobalID:
        x: 240
        'y': 240
        navigate:
          353d6d1a-7483-51a3-9673-b09c88f1d94a:
            targetId: 31f3d985-cc34-2cb4-0302-edcf12dacbdd
            port: SUCCESS
      getBusServiceWhenNotFound:
        x: 480
        'y': 280
        navigate:
          be7287eb-189c-c69c-c953-c63defb7c4c1:
            targetId: 794f48e8-2d26-390b-3075-73a7c9cacf39
            port: CUSTOM_InfraNotFound
          447f8eaf-a175-cdc1-3de2-0e45ca7546dd:
            targetId: fb96cd4f-fc88-b6cd-e2bd-62c33cedab77
            port: SUCCESS
      findBusinessApplicationqueryEntityAchmea:
        x: 720
        'y': 600
      UcmdbBANotFound_string_equals:
        x: 920
        'y': 80
      getBA_xpath_query:
        x: 680
        'y': 40
      getHostNameFlat_getSubStringLeft:
        x: 80
        'y': 40
    results:
      SUCCESS:
        31f3d985-cc34-2cb4-0302-edcf12dacbdd:
          x: 40
          'y': 280
      CUSTOM_DefaultInfraNotFound:
        794f48e8-2d26-390b-3075-73a7c9cacf39:
          x: 800
          'y': 280
      SUCCESS_DEFAULT:
        fb96cd4f-fc88-b6cd-e2bd-62c33cedab77:
          x: 720
          'y': 400
