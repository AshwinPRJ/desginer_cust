namespace: Achmea.SiteCoreScalePipeline
flow:
  name: SiteCoreScalePipeline
  inputs:
    - RequestID
    - paramFlowVarNameList
    - paramflowVarValueList
    - numberOfInstances
    - resourcegroupName
    - piplineID
    - piplineProjectName
  workflow:
    - checkSMAxSource:
        do:
          Achmea.Shared.subFlows.Generic.checkSMAxSource:
            - RunSourceID: '${RequestID}'
            - RunSourceType: "${get_sp('Achmea.SiteCoreScalePipeline.smaSourceType')}"
            - CompareSourceID: "${get_sp('Achmea.SiteCoreScalePipeline.sourceOfferingID')}"
        publish:
          - error_message
          - return_code
        navigate:
          - FAILURE: on_failure
          - CUSTOM: CUSTOM
          - SUCCESS: SMAx2ADO
    - SMAx2ADO:
        do:
          Achmea.Shared.azurePipeline.SMAx2ADO:
            - SMAxEntityId: '${RequestID}'
            - SMAxEntityType: "${get_sp('Achmea.SiteCoreScalePipeline.smaSourceType')}"
            - separator: "${get_sp('Achmea.SiteCoreScalePipeline.seperator')}"
            - piplineProjectName: '${piplineProjectName}'
            - pipelineID: '${piplineID}'
            - paramFlowVarNameList: '${paramFlowVarNameList}'
            - numberOfInstances: '${numberOfInstances}'
            - resourcegroupName: '${resourcegroupName}'
            - paramflowVarValueList: '${paramflowVarValueList}'
            - flowReference: "${get_sp('Achmea.SiteCoreScalePipeline.flowReference')}"
            - systemName: "${get_sp('Achmea.SiteCoreScalePipeline.systemName')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - error_message: '${error_message}'
    - return_code: '${return_code}'
  results:
    - FAILURE
    - CUSTOM
    - SUCCESS
extensions:
  graph:
    steps:
      checkSMAxSource:
        x: 320
        'y': 80
        navigate:
          f51e718f-32ac-5efe-d08a-29f74ab387f7:
            targetId: 356bcb48-5694-d20f-a65b-a80cd58b12f0
            port: CUSTOM
      SMAx2ADO:
        x: 600
        'y': 80
        navigate:
          7c478f1a-be26-d7d6-c775-607e91f7d25c:
            targetId: 5d1173be-b592-e263-d504-630d6976a5cc
            port: SUCCESS
    results:
      CUSTOM:
        356bcb48-5694-d20f-a65b-a80cd58b12f0:
          x: 400
          'y': 360
      SUCCESS:
        5d1173be-b592-e263-d504-630d6976a5cc:
          x: 760
          'y': 360
