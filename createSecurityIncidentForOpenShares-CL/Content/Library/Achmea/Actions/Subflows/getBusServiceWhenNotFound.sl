########################################################################################################################
#!!
#! @description: When the Bus. service is not found a default infra service will be used to create the security incident. The name of this service is stored in the system props. 
#!                
#!               This flow will get the infra service ID from SMAX and the AssignmentGroup for this Group (ID)
#!!#
########################################################################################################################
namespace: Achmea.Actions.Subflows
flow:
  name: getBusServiceWhenNotFound
  inputs:
    - sso_TokenSMA:
        required: false
  workflow:
    - getInfraService_queryEntityAchmea:
        do:
          Achmea.Shared.subFlows.SMA.queryEntityAchmea:
            - entity_type: ActualService
            - query: "${\"DisplayLabel='\" + get_sp('Achmea.createSecurityIncidentsForOpenShares.infraServiceWhenInvalidStructure') + \"'\"}"
            - fields: 'Id,SupportLevel1Group'
            - sso_Token: '${sso_TokenSMA}'
        publish:
          - entity_json
          - entity_json_full: '${return_result}'
          - error_json
          - sso_TokenSMA
        navigate:
          - FAILURE: on_failure
          - SUCCESS: getInfraServiceFields_getQueryResultJson
          - CUSTOM: CUSTOM_InfraNotFound
    - getInfraServiceFields_getQueryResultJson:
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
          - SUCCESS: getActualServiceID_getValueFromList
          - FAILURE: on_failure
    - getActualServiceID_getValueFromList:
        do:
          Achmea.Shared.Operations.getValueFromList:
            - list: '${return_values}'
            - seperator: '@'
            - index: '1'
        publish:
          - ServiceSMAxID: '${return_value}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: getActualServiceSupportGoupID_getValueFromList
          - FAILURE: on_failure
    - getActualServiceSupportGoupID_getValueFromList:
        do:
          Achmea.Shared.Operations.getValueFromList:
            - list: '${return_values}'
            - seperator: '@'
            - index: '2'
        publish:
          - smaxGroupID: '${return_value}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - error_message: '${error_message}'
    - ServiceSMAxID: '${ServiceSMAxID}'
    - smaxGroupID: '${smaxGroupID}'
  results:
    - FAILURE
    - CUSTOM_InfraNotFound
    - SUCCESS
extensions:
  graph:
    steps:
      getInfraService_queryEntityAchmea:
        x: 280
        'y': 80
        navigate:
          6c47b493-cad7-a852-0347-114a37f69ac3:
            targetId: a5a19454-6b6c-d41f-82e9-ff732fb5204d
            port: CUSTOM
      getInfraServiceFields_getQueryResultJson:
        x: 560
        'y': 80
      getActualServiceID_getValueFromList:
        x: 840
        'y': 80
      getActualServiceSupportGoupID_getValueFromList:
        x: 1040
        'y': 80
        navigate:
          d14462ab-fd46-5afa-97f0-cdb9d39b6fb9:
            targetId: f41cc476-b98a-6342-431a-2ddd2e75028e
            port: SUCCESS
    results:
      CUSTOM_InfraNotFound:
        a5a19454-6b6c-d41f-82e9-ff732fb5204d:
          x: 80
          'y': 280
      SUCCESS:
        f41cc476-b98a-6342-431a-2ddd2e75028e:
          x: 1280
          'y': 80
