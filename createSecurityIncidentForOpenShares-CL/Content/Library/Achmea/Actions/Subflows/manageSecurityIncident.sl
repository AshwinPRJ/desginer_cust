namespace: Achmea.Actions.Subflows
flow:
  name: manageSecurityIncident
  inputs:
    - server_name
    - incident_description
    - splitter: '@'
    - sso_TokenSMA:
        required: false
  workflow:
    - getSmaxIDsForSecurityIncident:
        do:
          Achmea.Actions.Subflows.getSmaxIDsForSecurityIncident:
            - server_name: '${server_name}'
            - sso_TokenSMA: '${sso_TokenSMA}'
        publish:
          - groupIDSMAx
          - BusinessServiceSMAxID: '${ServiceSMAxID}'
        navigate:
          - SUCCESS: setTitle_do_nothing
          - FAILURE: on_failure
          - CUSTOM_DefaultInfraNotFound: set_error_message_do_nothing
          - SUCCESS_DEFAULT: setTitle_do_nothing
    - setTitle_do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - SecurityIncidentTitle: "${get_sp('Achmea.createSecurityIncidentsForOpenShares.Incident_Title') + ' ' + server_name}"
        publish:
          - SecurityIncidentTitle
        navigate:
          - SUCCESS: Description_ReplaceCharacter
          - FAILURE: on_failure
    - createEntityAchmea:
        do:
          Achmea.Shared.subFlows.SMA.createEntityAchmea:
            - sso_token: '${sso_TokenSMA}'
            - entityType: SecurityIncident_c
            - fields: 'DisplayLabel|Description_c|ExpertGroup_c|Service_c|Priority_c|Category_c'
            - splitter: '|'
            - values: "${SecurityIncidentTitle + '|' + incident_description_init + '|' + groupIDSMAx + '|' + BusinessServiceSMAxID + \"|\" + get_sp('Achmea.createSecurityIncidentsForOpenShares.SecurityIncidentPriority') + '|' + get_sp('Achmea.createSecurityIncidentsForOpenShares.SecurityIncidentCategory')}"
        publish:
          - securityIncidentNumber: '${created_id}'
          - error_Json: '${error_json}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - Description_ReplaceCharacter:
        do:
          Achmea.Shared.Operations.ReplaceCharacter:
            - value: '${incident_description}'
            - oldValue: "${\"\\\\\"}"
            - newValue: "${'\\\\\\\\'}"
        publish:
          - incident_description: '${return_result}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: findSecurityIncident
    - findSecurityIncident:
        do:
          Achmea.Actions.Subflows.findSecurityIncident:
            - SecurityIncidentTitle: '${SecurityIncidentTitle}'
            - sso_TokenSMA: '${sso_TokenSMA}'
        publish:
          - Id
          - DescriptionExisting: '${Description}'
          - error_message
          - return_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: AddtoExistingDes_do_nothing
          - CUSTOM: FilleInitDescription_do_nothing
    - updateEntityAchmea:
        do:
          Achmea.Shared.subFlows.SMA.updateEntityAchmea:
            - sso_token: '${sso_TokenSMA}'
            - entityType: SecurityIncident_c
            - field: Description_c
            - entityID: '${Id}'
            - value: '${newDescription}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - AddtoExistingDes_do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - newDescription: "${DescriptionExisting +  '<br><br>' + incident_description}"
        publish:
          - newDescription
        navigate:
          - SUCCESS: updateEntityAchmea
          - FAILURE: on_failure
    - FilleInitDescription_do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - incident_description_init: "${get_sp('Achmea.createSecurityIncidentsForOpenShares.SecurityIncidentStartDescription')  + \"<BR>\" + incident_description}"
        publish:
          - incident_description_init
        navigate:
          - SUCCESS: createEntityAchmea
          - FAILURE: on_failure
    - set_error_message_do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - error_message: 'Default in systemprops defined service not found!'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
  outputs:
    - error_message: '${error_message}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      createEntityAchmea:
        x: 880
        'y': 80
        navigate:
          8ec58ae4-26af-493f-3622-a458e4f2ddb4:
            targetId: 5d562866-aa72-a811-2db3-4610f3fdbdc6
            port: SUCCESS
      setTitle_do_nothing:
        x: 480
        'y': 80
      set_error_message_do_nothing:
        x: 160
        'y': 320
        navigate:
          15b1c674-905c-70b9-fe27-1bd47a0ffc19:
            targetId: bc6399ad-ed94-77a3-a906-da79846a27a3
            port: SUCCESS
      getSmaxIDsForSecurityIncident:
        x: 40
        'y': 120
      findSecurityIncident:
        x: 680
        'y': 440
      AddtoExistingDes_do_nothing:
        x: 880
        'y': 320
      FilleInitDescription_do_nothing:
        x: 760
        'y': 240
      updateEntityAchmea:
        x: 1040
        'y': 320
        navigate:
          bbbba177-8631-d084-640a-17f37e074861:
            targetId: 5d562866-aa72-a811-2db3-4610f3fdbdc6
            port: SUCCESS
      Description_ReplaceCharacter:
        x: 680
        'y': 80
    results:
      SUCCESS:
        5d562866-aa72-a811-2db3-4610f3fdbdc6:
          x: 1040
          'y': 80
      FAILURE:
        bc6399ad-ed94-77a3-a906-da79846a27a3:
          x: 320
          'y': 440
