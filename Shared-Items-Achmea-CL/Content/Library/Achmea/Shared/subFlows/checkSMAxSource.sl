########################################################################################################################
#!!
#! @description: This flow will check the related offering in case of a request and the ChangeModel in case of a change if the source is like given in CompareSourceID. Goal is that flow cannot be triggert from a different changemodel of offering. 
#!               RunSourceID: ID of the source with automated task (change or Request)
#!               RunSourceType: Source type: Change or Request
#!               CompareSourceID: OfferingID or ChangeModelID
#!               Result:
#!               Success: All correct
#!               Failure: There is mismatch between the source of request and the given Offering or Changemodelid
#!!#
########################################################################################################################
namespace: Achmea.Shared.subFlows
flow:
  name: checkSMAxSource
  inputs:
    - RunSourceID: '2530504'
    - RunSourceType: Change
    - CompareSourceID: '2485558'
    - sso_TokenSMax:
        required: false
  workflow:
    - checkSourceIsChange_isTrue:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(RunSourceType == 'Change')}"
            - error_message: null
        navigate:
          - 'TRUE': Change_do_nothing
          - 'FALSE': Request_do_nothing
    - Change_do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - fieldName: BasedOnChangeModel
        publish:
          - fieldName
        navigate:
          - SUCCESS: queryEntityAchmea
          - FAILURE: on_failure
    - Request_do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - fieldName: RequestsOffering
        publish:
          - fieldName
        navigate:
          - SUCCESS: queryEntityAchmea
          - FAILURE: on_failure
    - queryEntityAchmea:
        do:
          Achmea.Shared.subFlows.SMA.queryEntityAchmea:
            - entity_type: '${RunSourceType}'
            - query: "${'Id=' + RunSourceID}"
            - fields: '${fieldName}'
            - sso_Token: '${sso_TokenSMax}'
        publish:
          - intity_json: '${entity_json}'
          - return_result
          - result_count
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
          - CUSTOM: CUSTOM
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${intity_json}'
            - json_path: "${'$..' + fieldName}"
        publish:
          - json_result: '${return_result}'
          - return_code
          - exception
        navigate:
          - SUCCESS: checkFoundSource_is_true
          - FAILURE: on_failure
    - checkFoundSource_is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(json_result.find(CompareSourceID)>0)}'
            - CompareSourceID: '${CompareSourceID}'
            - json_result: '${json_result}'
        publish:
          - bool_value
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': setErrorMessage_do_nothing
    - setErrorMessage_do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - error_message: SMA source not equal to given source
        publish:
          - error_message
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
  outputs:
    - error_message: '${error_message}'
    - return_result: '${return_result}'
  results:
    - FAILURE
    - CUSTOM
    - SUCCESS
extensions:
  graph:
    steps:
      checkSourceIsChange_isTrue:
        x: 40
        'y': 200
      Change_do_nothing:
        x: 280
        'y': 40
      Request_do_nothing:
        x: 280
        'y': 360
      queryEntityAchmea:
        x: 480
        'y': 200
        navigate:
          0c96cbfa-6410-23d5-7593-ff11189f4aa8:
            targetId: 434d0ab8-898e-2b75-4192-bebe2389825e
            port: CUSTOM
      json_path_query:
        x: 640
        'y': 40
      checkFoundSource_is_true:
        x: 720
        'y': 280
        navigate:
          0a144d4b-bc55-127e-03c2-c4e0feaed86b:
            targetId: 2d2dc002-46a4-c5bd-24ad-c8ad8bfd1643
            port: 'TRUE'
      setErrorMessage_do_nothing:
        x: 840
        'y': 120
        navigate:
          15f0abb1-52a1-a9a8-cff8-808cdeacf336:
            targetId: e199dc9a-3063-cff6-e624-48dbae7b587c
            port: SUCCESS
    results:
      FAILURE:
        e199dc9a-3063-cff6-e624-48dbae7b587c:
          x: 960
          'y': 40
      CUSTOM:
        434d0ab8-898e-2b75-4192-bebe2389825e:
          x: 560
          'y': 440
      SUCCESS:
        2d2dc002-46a4-c5bd-24ad-c8ad8bfd1643:
          x: 920
          'y': 400
