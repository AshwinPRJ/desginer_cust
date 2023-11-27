namespace: Achmea.actions
flow:
  name: regression_serviceRequest
  inputs:
    - sso_token:
        required: false
  workflow:
    - getTokenSmaAchmea:
        do:
          Achmea.Shared.subFlows.SMA.getTokenSmaAchmea: []
        publish:
          - sso_token: '${sso_Token}'
        navigate:
          - SUCCESS: get_displayLabelRequest
          - FAILURE: on_failure
    - get_displayLabelRequest:
        do:
          Achmea.Operations.get_displayLabelRequest:
            - Proces: ServiceRequest
        publish:
          - displayLabel
        navigate:
          - SUCCESS: create_serviceRequest
    - create_serviceRequest:
        do:
          Achmea.subflows.create_serviceRequest:
            - sso_token: '${sso_token}'
            - DisplayLabel: '${displayLabel}'
            - Description: This is a test service request
        publish:
          - created_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: update_request
    - update_request:
        do:
          Achmea.subflows.update_request:
            - sso_token: '${sso_token}'
            - request_field: ExpertGroup
            - value: "${get_sp('ExpertGroup')}"
            - request_id: '${created_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: update_request_1
    - update_request_1:
        do:
          Achmea.subflows.update_request:
            - sso_token: '${sso_token}'
            - request_field: Solution
            - value: Fulfilled
            - request_id: '${created_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: update_request_1_1
    - update_request_1_1:
        do:
          Achmea.subflows.update_request:
            - sso_token: '${sso_token}'
            - request_field: CompletionCode
            - value: CompletionCodeFulfilled
            - request_id: '${created_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: updatePhase_request
    - updatePhase_request:
        do:
          Achmea.subflows.updatePhase_request:
            - sso_token: '${sso_token}'
            - request_Id: '${created_id}'
            - newPhase: Close
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
          - CUSTOM: CUSTOM
  results:
    - FAILURE
    - SUCCESS
    - CUSTOM
extensions:
  graph:
    steps:
      getTokenSmaAchmea:
        x: 40
        'y': 400
      get_displayLabelRequest:
        x: 160
        'y': 280
      create_serviceRequest:
        x: 240
        'y': 400
      update_request:
        x: 360
        'y': 400
      update_request_1:
        x: 480
        'y': 400
      update_request_1_1:
        x: 600
        'y': 400
      updatePhase_request:
        x: 720
        'y': 400
        navigate:
          55fd9e4b-54c7-7b11-63e1-a693c6253dbb:
            targetId: 15027148-8555-3856-7872-b9f82091dde9
            port: SUCCESS
          bd40078e-cc70-5eac-bfb0-1944335905c5:
            targetId: b44c5939-beae-f76b-f2d2-f79921a97496
            port: CUSTOM
    results:
      SUCCESS:
        15027148-8555-3856-7872-b9f82091dde9:
          x: 880
          'y': 400
      CUSTOM:
        b44c5939-beae-f76b-f2d2-f79921a97496:
          x: 720
          'y': 240
