########################################################################################################################
#!!
#! @description: This flow is called from another flow (parent) to sleep for a given time. When the sleep time is ended it will check the parent flow if it is still in paused status. If false it will end, if true it will resume the parent flow with given inputs.
#!               This flow is created to resume a paused flow to be completed so it will not wait indefinitely for input..
#!                
#!               inputs:
#!                
#!               runId
#!               -runId of parentflow
#!               timeToWait
#!               - amount of seconds the flow has to sleep
#!               oocentral
#!               - systemproperty with OO central address
#!                
#!               Outputs:
#!                
#!               parentFlowStatus
#!               - returns the status of the parentflow that is requested for a resume.
#!                
#!               This flow has a custum result "No_Paused_Flow" in case the parent flow is completed or does not has a pause status
#!!#
########################################################################################################################
namespace: Achmea.Shared.subFlows.ooCont
flow:
  name: removeFlowAfterPauze
  inputs:
    - runId:
        required: true
    - timeToWait
    - ooCentralUrl
    - ooCentralUser
    - ooCentralPassw:
        sensitive: true
  workflow:
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${timeToWait}'
        navigate:
          - SUCCESS: Get_Status_Flow
          - FAILURE: FAILURE
    - Get_Status_Flow:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${ooCentralUrl + '/rest/v2/executions/' + runId + '/summary'}"
            - auth_type: basic
            - username: '${ooCentralUser}'
            - password:
                value: '${ooCentralPassw}'
                sensitive: true
            - trust_all_roots: 'true'
            - content_type: application/json
        publish:
          - json: '${return_result}'
        navigate:
          - SUCCESS: Get_KeyValueJson
          - FAILURE: FAILURE
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${value}'
            - second_string: PAUSED
            - ignore_case: 'true'
        publish:
          - statusParentFlow: '${first_string}'
        navigate:
          - SUCCESS: Resume_with_Failed_result
          - FAILURE: No_Paused_Flow
    - Resume_with_Failed_result:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${ooCentralUrl + '/rest/v2/executions/' + runId + '/status'}"
            - auth_type: basic
            - username: '${ooCentralUser}'
            - password:
                value: '${ooCentralPassw}'
                sensitive: true
            - trust_all_roots: 'true'
            - use_cookies: 'false'
            - body: '{"action":"RESUME","data":{"branchId":null,"input_binding":{"DNDStatus":"FAILED","DNDMessage": "TIME-OUT: No SQL response received"}}}'
            - content_type: application/json
            - method: PUT
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
    - Get_KeyValueJson:
        do:
          Achmea.Shared.Operations.Get_KeyValueJson:
            - dataJson: '${json}'
            - keyName: status
        publish:
          - value
        navigate:
          - SUCCESS: string_equals
          - FAILURE: FAILURE
          - NO_RESULT: No_Paused_Flow
  outputs:
    - parentFlowStatus: '${statusParentFlow}'
  results:
    - FAILURE
    - SUCCESS
    - No_Paused_Flow
extensions:
  graph:
    steps:
      sleep:
        x: 50
        'y': 199
        navigate:
          b9f3e77e-e097-8623-35d9-5248e365d9ca:
            targetId: c0098c47-00ce-7542-b817-a8deed32d40b
            port: FAILURE
      Get_Status_Flow:
        x: 246
        'y': 199
        navigate:
          0fb0d53a-b672-049b-db7a-7f4f646aa0b9:
            targetId: c0098c47-00ce-7542-b817-a8deed32d40b
            port: FAILURE
      Get_KeyValueJson:
        x: 440
        'y': 200
        navigate:
          52ff63b5-e5ae-e6ea-9d4d-89a33a30a9d0:
            targetId: 556fc4ce-f08b-2614-58cc-c931c9b50709
            port: NO_RESULT
          8c782433-6c29-1448-cb05-3a5f5e3d226c:
            targetId: c0098c47-00ce-7542-b817-a8deed32d40b
            port: FAILURE
      string_equals:
        x: 649
        'y': 209
        navigate:
          e6d62954-7d2d-f186-0c7a-79944bb46597:
            targetId: 556fc4ce-f08b-2614-58cc-c931c9b50709
            port: FAILURE
      Resume_with_Failed_result:
        x: 838
        'y': 216
        navigate:
          309c3d38-2bf6-127c-ed92-9b9bac155daf:
            targetId: c16a7d0c-a1e9-932c-110c-75612d370f5a
            port: SUCCESS
          2e8937c8-2491-3ae8-4b34-70c365a2823e:
            targetId: c0098c47-00ce-7542-b817-a8deed32d40b
            port: FAILURE
    results:
      FAILURE:
        c0098c47-00ce-7542-b817-a8deed32d40b:
          x: 552
          'y': 446
      SUCCESS:
        c16a7d0c-a1e9-932c-110c-75612d370f5a:
          x: 1033
          'y': 207
      No_Paused_Flow:
        556fc4ce-f08b-2614-58cc-c931c9b50709:
          x: 649
          'y': 14
