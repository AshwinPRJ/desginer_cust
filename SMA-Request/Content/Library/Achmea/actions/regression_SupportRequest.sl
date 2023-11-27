namespace: Achmea.actions
flow:
  name: regression_SupportRequest
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
    - create_request:
        do:
          Achmea.subflows.create_request:
            - sso_token: '${sso_token}'
            - DisplayLabel: '${displayLabel}'
            - Description: This is a request for the regression testing
        publish:
          - request_id: '${created_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: update_request
    - get_displayLabelRequest:
        do:
          Achmea.Operations.get_displayLabelRequest:
            - Proces: SupportRequest
        publish:
          - displayLabel
        navigate:
          - SUCCESS: create_request
    - update_request:
        do:
          Achmea.subflows.update_request:
            - sso_token: '${sso_token}'
            - request_field: Solution
            - value: OK
            - request_id: '${request_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: update_request_1
    - update_request_1:
        do:
          Achmea.subflows.update_request:
            - sso_token: '${sso_token}'
            - request_field: CompletionCode
            - value: CompletionCodeFulfilled
            - request_id: '${request_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: updatePhase_request
    - updatePhase_request:
        do:
          Achmea.subflows.updatePhase_request:
            - sso_token: '${sso_token}'
            - request_Id: '${request_id}'
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
        x: 120
        'y': 360
      create_request:
        x: 320
        'y': 360
      get_displayLabelRequest:
        x: 240
        'y': 240
      update_request:
        x: 440
        'y': 360
      update_request_1:
        x: 560
        'y': 360
      updatePhase_request:
        x: 680
        'y': 360
        navigate:
          058ae5b3-69be-d0eb-d9d6-d07715467965:
            targetId: 72266f2e-03aa-0281-d6e6-47b2a1b9cfcd
            port: CUSTOM
          df66cc4d-a141-c63f-6510-d23d03a374eb:
            targetId: ea63ddd6-2581-c330-9bf5-9bb3911aeb77
            port: SUCCESS
    results:
      SUCCESS:
        ea63ddd6-2581-c330-9bf5-9bb3911aeb77:
          x: 840
          'y': 360
      CUSTOM:
        72266f2e-03aa-0281-d6e6-47b2a1b9cfcd:
          x: 680
          'y': 200
