########################################################################################################################
#!!
#! @description: This flow can be used to create a new Change entity in SMAx based on a given Change model. The flow will output the Id of the new Change. Creating a new change will require mandatory fields in the change. So this flow will only work with a Change model that populates those required fields in the Change.
#!
#! @input sma_changeModel: Enter the model id for the new change:
#! @input sma_displayLabel: Enter the title for the new change:
#! @input sma_url: Enter the url for SMAx:
#! @input sma_tenantID: Enter the tennant for SMAx
#! @input sma_userName: Enter the user name for connecting to the SMAx API:
#! @input sma_password: Enter the user name password for connecting to the SMAx API:
#!!#
########################################################################################################################
namespace: Achmea.Actions.SMAx
flow:
  name: Create_Change
  inputs:
    - sma_changeModel:
        prompt:
          type: text
        default: '3986495'
    - sma_displayLabel:
        prompt:
          type: text
        default: SQL DND Automatic Standard Change
        required: true
    - sma_url:
        prompt:
          type: text
    - sma_tenantID:
        prompt:
          type: text
    - sma_userName:
        prompt:
          type: text
    - sma_password:
        prompt:
          type: text
        sensitive: true
  workflow:
    - SMA_Token:
        do:
          Achmea.Subflows.SMAx.SMA_Token:
            - smaUrl: '${sma_url}'
            - smaTennant: '${sma_tenantID}'
            - sMAxUrl: '${sma_url}'
            - tenantID: '${sma_tenantID}'
            - smaUser: '${sma_userName}'
            - smaPassw:
                value: '${sma_password}'
                sensitive: true
        publish:
          - ssoToken
          - errorMessage
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: create_entity_Change
    - create_entity_Change:
        do:
          io.cloudslang.microfocus.service_management_automation_x.commons.create_entity:
            - saw_url: '${sma_url}'
            - sso_token: '${ssoToken}'
            - tenant_id: '${sma_tenantID}'
            - json_body: "${'{\"entity_type\":\"Change\",\"properties\":{\"DisplayLabel\":\"' + str(sma_displayLabel) + '\",\"BasedOnChangeModel\":\"' + sma_changeModel + '\"}}'}"
            - trust_all_roots: 'true'
        publish:
          - changeId: '${created_id}'
          - returnJson: '${entity_json}'
          - errorMessage: '${error_json}'
          - return_result
          - statusChange: '${op_status}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - sma_changeID: '${changeId}'
    - sma_changeStatus: '${statusChange}'
    - sma_returnResult: '${return_result}'
    - sma_returnCode
    - sma_errorMessage: '${errorMessage}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      SMA_Token:
        x: 80
        'y': 120
        navigate:
          c125edb7-783a-b46d-e00c-dbaf2b823bff:
            targetId: 52267372-32f7-a826-9c2b-cb1ca32004a0
            port: FAILURE
      create_entity_Change:
        x: 280
        'y': 120
        navigate:
          c570cf67-9aab-132f-3c95-9e1f535de374:
            targetId: 78f1b12c-1bad-8cac-c5b7-3098891bba8c
            port: SUCCESS
          34dd8e51-48d5-c52a-ed89-872add6c270d:
            targetId: 52267372-32f7-a826-9c2b-cb1ca32004a0
            port: FAILURE
    results:
      FAILURE:
        52267372-32f7-a826-9c2b-cb1ca32004a0:
          x: 254
          'y': 319
      SUCCESS:
        78f1b12c-1bad-8cac-c5b7-3098891bba8c:
          x: 440
          'y': 120
