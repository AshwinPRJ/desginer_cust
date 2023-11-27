########################################################################################################################
#!!
#! @description: The SetTaskPhase flow can be used to set the transistion phase of an SMAx task entity. A phase transition is limited to requirements on phase steps in SMAx, so phase transitions that are not allowed in SMAx are also not allowed in the flow. You can set the next phase for the task with the input "setPhase" (eg: "Validate") and define the following filters to query for a specific task: "parentId" (the entity Id of the task Parent entity), "currentPhase" (eg. "InProgress") and "titleTask" (the title of the Task) . The flow will only process one task under a given parent entity (Request or Change).
#!
#! @input sma_parentID: Unable to load description
#! @input sma_TaskTitle: Enter the requested task title, e.g. "DNDdeliverySQL":
#! @input sma_currentPhase: Enter the current phase for the task, e.g. "InProgress":
#! @input sma_newPhase: Enter the new phase for the task, e.g. "Validate":
#! @input sma_url: Enter the SMAx url, e.g. "https://sma.preview.hosting.corp":
#! @input sma_tenantID: Enter the SMAx Tennant, e.g. "781313141":
#! @input sma_userName: Enter the SMAx user:
#! @input sma_password: Enter the SMax user password:
#!!#
########################################################################################################################
namespace: Achmea.Actions.SMAx
flow:
  name: SetTaskPhase
  inputs:
    - sma_parentID
    - sma_TaskTitle
    - sma_currentPhase
    - sma_newPhase
    - sma_url
    - sma_tenantID
    - sma_userName
    - sma_password:
        sensitive: true
  workflow:
    - Get_SMATask:
        do:
          Achmea.Subflows.SMAx.Get_SMATask:
            - smaTennant: '${sma_tenantID}'
            - smaUrl: '${sma_url}'
            - parentId: '${sma_parentID}'
            - titleTask: '${sma_TaskTitle}'
            - currentPhase: '${sma_currentPhase}'
            - smaUser: '${sma_userName}'
            - smaPassw:
                value: '${sma_password}'
                sensitive: true
        publish:
          - taskId: '${resultGetTask}'
          - errorMessage
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: Set_Phase_Entity
          - CUSTOM: NORESULT
    - Set_Phase_Entity:
        do:
          Achmea.Subflows.SMAx.Set_Phase_Entity:
            - entityId: '${taskId}'
            - entityPhase: '${sma_newPhase}'
            - smaTennant: '${sma_tenantID}'
            - smaUrl: '${sma_url}'
            - smaUser: '${sma_userName}'
            - smaPassw:
                value: '${sma_password}'
                sensitive: true
        publish:
          - entityPhase: '${resultSetPhaseEntity}'
          - errorMessage
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
  outputs:
    - sma_entityStatus: '${entityPhase}'
    - sma_errorMessage: '${errorMessage}'
    - sma_returnResult
    - sma_returnCode
  results:
    - FAILURE
    - SUCCESS
    - NORESULT
extensions:
  graph:
    steps:
      Get_SMATask:
        x: 261
        'y': 242
        navigate:
          2c18360a-0521-7830-4291-c1f658b04414:
            targetId: 7d4888b6-19f0-805f-1a8d-1980f70fdfba
            port: FAILURE
          bb78fe1e-05d9-e67a-8b4d-2aed7744029c:
            targetId: 66c56479-dd0c-5faf-3e6d-1ce5e5f70633
            port: CUSTOM
      Set_Phase_Entity:
        x: 450
        'y': 243
        navigate:
          b8cb81fd-7c91-a9f9-de82-4a6171f3d8a1:
            targetId: 90128f30-3c87-fd2e-adcf-162b6fd7ed81
            port: SUCCESS
          56f42053-c70a-0a62-70c3-1a7911f0ffd0:
            targetId: 7d4888b6-19f0-805f-1a8d-1980f70fdfba
            port: FAILURE
    results:
      FAILURE:
        7d4888b6-19f0-805f-1a8d-1980f70fdfba:
          x: 359
          'y': 422
      SUCCESS:
        90128f30-3c87-fd2e-adcf-162b6fd7ed81:
          x: 625
          'y': 244
      NORESULT:
        66c56479-dd0c-5faf-3e6d-1ce5e5f70633:
          x: 257
          'y': 77
