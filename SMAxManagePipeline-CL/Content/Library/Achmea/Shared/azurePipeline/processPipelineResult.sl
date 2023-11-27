namespace: Achmea.Shared.azurePipeline
flow:
  name: processPipelineResult
  inputs:
    - jsonObject: |-
        ${{
        "SmaxId":"4424725",
        "Status" : "SUCCESS",
        "Description":"This is a new test description",
        "CustomData":"test CustomData"
        }}
  workflow:
    - procesJsonResult:
        do:
          Achmea.Shared.Operation.procesJsonResult:
            - jsonObject: '${jsonObject}'
        publish:
          - error: '${error_message}'
          - return_code
          - SMAxEntityId
          - Description
          - Status
        navigate:
          - FAILURE: on_failure
          - SUCCESS: updatePipelineRequest
    - updatePipelineRequest:
        do:
          Achmea.Shared.Subflow.updatePipelineRequest:
            - sma_requestId: '${SMAxEntityId}'
            - value: '${Status}'
            - smaUrl: null
        navigate:
          - SUCCESS: updatePipelineRequest_1
          - FAILURE: FAILURE_1
    - updatePipelineRequest_1:
        do:
          Achmea.Shared.Subflow.updatePipelineRequest:
            - sma_requestId: '${SMAxEntityId}'
            - field: EM2_c
            - value: '${Description}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE_1
  results:
    - SUCCESS
    - FAILURE
    - FAILURE_1
extensions:
  graph:
    steps:
      procesJsonResult:
        x: 320
        'y': 360
      updatePipelineRequest:
        x: 480
        'y': 360
        navigate:
          1d40d88d-2cac-4204-e786-5d4b841665aa:
            targetId: 17394069-8ff2-3d92-49ce-ca1d8456b8bc
            port: FAILURE
      updatePipelineRequest_1:
        x: 640
        'y': 360
        navigate:
          ac987615-b39d-a457-1cbd-8c66441859ce:
            targetId: 22745837-13cc-b8ba-d1c1-a3413afaa3fa
            port: SUCCESS
          e1850845-38d0-3cce-b233-5c4fce9df5c9:
            targetId: 17394069-8ff2-3d92-49ce-ca1d8456b8bc
            port: FAILURE
    results:
      SUCCESS:
        22745837-13cc-b8ba-d1c1-a3413afaa3fa:
          x: 800
          'y': 360
      FAILURE_1:
        17394069-8ff2-3d92-49ce-ca1d8456b8bc:
          x: 520
          'y': 520
