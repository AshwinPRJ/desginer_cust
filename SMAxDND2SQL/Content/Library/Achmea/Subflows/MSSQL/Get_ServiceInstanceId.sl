########################################################################################################################
#!!
#! @description: This flow will retrieve a service instance id based on the request id as an input
#!!#
########################################################################################################################
namespace: Achmea.Subflows.MSSQL
flow:
  name: Get_ServiceInstanceId
  inputs:
    - sma_url: "${get_sp('MF.SMAx.SMA_URL')}"
    - sma_tennant: "${get_sp('MF.SMAx.SMA_TenantID')}"
    - sma_userName: "${get_sp('MF.SMAx.SMA_OO_INT')}"
    - sma_password:
        default: "${get_sp('MF.SMAx.SMA_OO_INT_PW')}"
        sensitive: true
    - requestId:
        prompt:
          type: text
  workflow:
    - SMA_Token:
        do:
          Achmea.Subflows.SMAx.SMA_Token:
            - smaUrl: '${sma_url}'
            - smaTennant: '${sma_tennant}'
            - smaUser: '${sma_userName}'
            - smaPassw:
                value: '${sma_password}'
                sensitive: true
        publish:
          - smaToken: '${ssoToken}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: query_entities
    - query_entities:
        do:
          io.cloudslang.microfocus.service_management_automation_x.commons.query_entities:
            - saw_url: '${sma_url}'
            - sso_token: '${smaToken}'
            - tenant_id: '${sma_tennant}'
            - entity_type: Request
            - query: '${"Id eq " + requestId}'
            - fields: RegisteredForSubscription.RemoteServiceInstanceID
            - trust_all_roots: 'true'
        publish:
          - json: '${entity_json}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: Get_KeyValue
          - NO_RESULTS: NO_RESULT
    - Get_KeyValue:
        do:
          Achmea.Shared.Generic.Operations.Get_KeyValue:
            - dataJson: '${json}'
            - keyName: RemoteServiceInstanceID
        publish:
          - value
          - ErrorMessage: '${error_message}'
          - ReturnCode: '${return_code}'
          - ReturnResult: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
          - NO_RESULT: NO_RESULT
  outputs:
    - serviceInstanceId: '${value}'
    - sma_errorMessage: '${ErrorMessage}'
    - sma_returnCode: '${ReturnCode}'
    - sma_returnResult: '${ReturnResult}'
  results:
    - SUCCESS
    - FAILURE
    - NO_RESULT
extensions:
  graph:
    steps:
      SMA_Token:
        x: 233
        'y': 160
      query_entities:
        x: 427
        'y': 158
        navigate:
          73f82bfa-6993-65b7-8546-dea2f900f282:
            targetId: ca4b3c59-21b9-b102-5f4d-a712e97a0cd5
            port: NO_RESULTS
          deac68a2-773d-2206-f6a0-e9a2bb31d1cd:
            targetId: 95bf2b05-2ae3-e782-f905-5216207ba2e6
            port: FAILURE
      Get_KeyValue:
        x: 600
        'y': 160
        navigate:
          b73d6089-77fe-0c97-87f1-b98d422e74b5:
            targetId: e2cbf564-1fd7-f045-c1c7-dafaf30688c8
            port: SUCCESS
          54be96f1-14f8-221d-cde7-6fd6603dab6d:
            targetId: ca4b3c59-21b9-b102-5f4d-a712e97a0cd5
            port: NO_RESULT
    results:
      SUCCESS:
        e2cbf564-1fd7-f045-c1c7-dafaf30688c8:
          x: 853
          'y': 161
      FAILURE:
        95bf2b05-2ae3-e782-f905-5216207ba2e6:
          x: 425
          'y': 322
      NO_RESULT:
        ca4b3c59-21b9-b102-5f4d-a712e97a0cd5:
          x: 421
          'y': 15
