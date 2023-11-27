########################################################################################################################
#!!
#! @description: This flow will retrieve an Task that is "In Progress" and has a given Task Title field name and is based on its parent Entity ID
#!                
#!               Step 1 - Checks for an available SSO token.
#!               Step 2 - Answer from API call for Task ID
#!               Step 3 - Script that filters JSON for task Id
#!                
#!               Inputs:
#!               requestId: Given ID of the entity that needs updating.
#!               	  Example: 123456
#!               sMAxUrl: Url for SMAx 
#!               	 Example: https://sma.preview.hosting.corp
#!               tenantID: SMAx Tenant ID
#!               	 Example: '781313141' 
#!                
#!               Outputs: 
#!               resultGetTask:  id requested task
#!               errorMessage:	An error message containing an exception.
#!                
#!               Responses: 
#!               success - the operation succeeded.
#!               failure - failure, to be handled by the calling flow
#!
#! @input parentId: The Entity Id of the Task parent Change
#!
#! @result CUSTOM: No task found that fulfils to the task field values in the query filter
#!!#
########################################################################################################################
namespace: Achmea.Subflows.SMAx
flow:
  name: Get_SMATask
  inputs:
    - smaTennant: "${get_sp('Achmea.SMA.Tentant')}"
    - smaUrl: "${get_sp('Achmea.SMA.URL')}"
    - parentId
    - titleTask
    - currentPhase
    - smaUser: "${get_sp('Achmea.SMA.User')}"
    - smaPassw:
        default: "${get_sp('Achmea.SMA.Password')}"
        sensitive: true
    - sso_token:
        required: false
  workflow:
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_token}'
        publish:
          - output_0: output_0
        navigate:
          - IS_NULL: SMA_Token
          - IS_NOT_NULL: get_task_id
    - SMA_Token:
        do:
          Achmea.Subflows.SMAx.SMA_Token:
            - smaUrl: '${smaUrl}'
            - smaTennant: '${smaTennant}'
            - smaUser: '${smaUser}'
            - smaPassw:
                value: '${smaPassw}'
                sensitive: true
        publish:
          - smaToken: '${ssoToken}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: get_task_id
    - Get_KeyValue:
        do:
          Achmea.Shared.Generic.Operations.Get_KeyValue:
            - dataJson: '${taskJson}'
            - keyName: Id
        publish:
          - id: '${value}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
          - NO_RESULT: CUSTOM
    - get_task_id:
        do:
          io.cloudslang.microfocus.service_management_automation_x.commons.query_entities:
            - saw_url: '${smaUrl}'
            - sso_token: '${sso_token}'
            - tenant_id: '${smaTennant}'
            - entity_type: Task
            - query: "${\"ParentEntityId='\" + parentId + \"' and PhaseId='\" + currentPhase + \"' and DisplayLabelKey='\" + titleTask + \"'\"}"
            - fields: 'Id,ParentEntityId,ProcessId,PhaseId,DisplayLabelKey'
            - trust_all_roots: 'true'
        publish:
          - taskJson: '${return_result}'
          - errorMessage: '${error_json}'
          - result_count
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: Get_KeyValue
          - NO_RESULTS: CUSTOM
  outputs:
    - resultGetTask: '${id}'
    - errorMessage: '${errorMessage}'
  results:
    - FAILURE
    - SUCCESS
    - CUSTOM
extensions:
  graph:
    steps:
      is_null:
        x: 200
        'y': 240
      SMA_Token:
        x: 280
        'y': 360
        navigate:
          800e0665-2abd-93da-5c71-1b0979414ac3:
            targetId: e8bf3e16-ba0d-aff6-5bfc-384743e1a5da
            port: FAILURE
      Get_KeyValue:
        x: 680
        'y': 240
        navigate:
          d6165e4f-df81-a14a-81c8-4e4009e4ee12:
            targetId: a6322a46-7f6b-2b3d-1870-baee0f2a7dbd
            port: SUCCESS
          f959a3db-e5d8-4367-3961-1236c7c5f44c:
            targetId: e8bf3e16-ba0d-aff6-5bfc-384743e1a5da
            port: FAILURE
          1c40e74c-7f0b-518b-f690-74b7934a6538:
            targetId: a69dabd9-a416-916f-de57-103e9d5fd825
            port: NO_RESULT
      get_task_id:
        x: 400
        'y': 240
        navigate:
          46f3f200-51e6-8f2d-d4e8-3a79e4ac6e81:
            targetId: e8bf3e16-ba0d-aff6-5bfc-384743e1a5da
            port: FAILURE
          65a30a7e-fe8e-f4c6-7963-386daa4467dc:
            targetId: a69dabd9-a416-916f-de57-103e9d5fd825
            port: NO_RESULTS
    results:
      FAILURE:
        e8bf3e16-ba0d-aff6-5bfc-384743e1a5da:
          x: 400
          'y': 440
      SUCCESS:
        a6322a46-7f6b-2b3d-1870-baee0f2a7dbd:
          x: 800
          'y': 240
      CUSTOM:
        a69dabd9-a416-916f-de57-103e9d5fd825:
          x: 520
          'y': 80
