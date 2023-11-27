########################################################################################################################
#!!
#! @description: This flow will create a new incident in SMAx. An incident can be created in two ways:
#!                
#!               1. Use the "incidentProperties" input.
#!               The properties in JSON format for the entity to be created. If this input is provided then all the
#!               other incident input fields are ignored.
#!               Examples: {"Urgency":"NoDisruption","RegisteredForActualService":"11453","Category":"10937",
#!               "OwnedByPerson":"10069","ContactPerson":"10069","PreferredContactMethod":"PreferredContactMethodEmail",
#!               "ClosureCategory":"10937","DisplayLabel":"Incident 01","Description":"<p>Test Incident</p>",
#!               "DataDomains":["Public"],"KnowledgeCandidate":true}
#!                
#!               2. Use the separate inputs to define the values for the incident model and fields in the to be created Incident. 
#!               Leave the "incidentProperties" input empty.
#!
#! @input incidentProperties: Leave this input empty if the properties of the incidentThis input can be used to summarize all Incident fields in a JSON. Leave empty if separate inputs being used.
#!!#
########################################################################################################################
namespace: Achmea.Shared.Micro-Focus.SMAx.Subflows
flow:
  name: Create_Incident
  inputs:
    - incidentProperties:
        prompt:
          type: text
        required: false
    - incidentTitle:
        prompt:
          type: text
        required: false
    - incidentDescripion:
        prompt:
          type: text
        required: false
    - incidentImpact:
        prompt:
          type: text
        required: false
    - incidentUrgency:
        prompt:
          type: text
        required: false
    - incidentReportedBy:
        prompt:
          type: text
        required: false
    - incidentCurrentAssignment:
        prompt:
          type: text
        required: false
    - incidentServicedeskGroup:
        prompt:
          type: text
        required: false
    - incidentExpertGroup:
        prompt:
          type: text
        required: false
    - incidentContact:
        prompt:
          type: text
        required: false
    - incidentService:
        prompt:
          type: text
        required: false
    - incidentCategory:
        prompt:
          type: text
        required: false
    - incidentModel:
        prompt:
          type: text
        required: false
    - incidentOwner:
        prompt:
          type: text
        required: false
    - incidentExpertAssignee:
        required: false
    - incidentPreferredContactMethod:
        required: false
  workflow:
    - get_sso_token:
        do:
          io.cloudslang.microfocus.service_management_automation_x.commons.get_sso_token:
            - saw_url: "${get_sp('MF.SMAx.SMA_URL')}"
            - tenant_id: "${get_sp('MF.SMAx.SMA_TenantID')}"
            - username: "${get_sp('MF.SMAx.SMA_OO_INT')}"
            - password:
                value: "${get_sp('MF.SMAx.SMA_OO_INT_PW')}"
                sensitive: true
            - trust_all_roots: 'true'
        publish:
          - ssoToken: '${sso_token}'
          - errorMessage: '${exception}'
        navigate:
          - FAILURE: SendMailR2F
          - SUCCESS: create_incident
    - create_incident:
        do:
          io.cloudslang.microfocus.service_management_automation_x.incidents.create_incident:
            - saw_url: "${get_sp('MF.SMAx.SMA_URL')}"
            - sso_token: '${ssoToken}'
            - tenant_id: "${get_sp('MF.SMAx.SMA_TenantID')}"
            - incident_properties: '${incidentProperties}'
            - incident_title: '${incidentTitle}'
            - incident_descripion: '${incidentDescripion}'
            - incident_impact: '${incidentImpact}'
            - incident_urgency: '${incidentUrgency}'
            - incident_reported_by: '${incidentReportedBy}'
            - incident_current_assignment: '${incidentCurrentAssignment}'
            - incident_service_desk_group: '${incidentServicedeskGroup}'
            - incident_expert_group: '${incidentExpertGroup}'
            - incident_contact: '${incidentContact}'
            - incident_service: '${incidentService}'
            - incident_category: '${incidentCategory}'
            - incident_model: '${incidentModel}'
            - incident_owner: '${incidentOwner}'
            - incident_expert_assignee: '${incidentExpertAssignee}'
            - incident_preferred_contact_method: '${incidentPreferredContactMethod}'
            - trust_all_roots: 'true'
        publish:
          - incidentId: '${created_id}'
          - return_result
          - errorMessage: '${error_json}'
          - statusIncident: '${op_status}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: SendMailR2F
    - SendMailR2F:
        do:
          Achmea.Shared.Generic.Subflows.SendMailR2F:
            - errorMessage: '${errorMessage}'
            - runId: '${run_id}'
            - smtpHostname: "${get_sp('MF.OO.SMTP_HOSTNAME')}"
            - smtpPort: "${get_sp('MF.OO.SMTP_PORT')}"
            - smtpSender: "${get_sp('MF.OO.SMTP_SENDER')}"
            - ooMailNotification: "${get_sp('MF.OO.OO_Mail_Notification')}"
        publish:
          - return_code
          - exception
          - return_result
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
  outputs:
    - incidentId: '${incidentId}'
    - statusIncident: '${statusIncident}'
    - errorMessage: '${errorMessage}'
    - return_result: '${return_result}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_sso_token:
        x: 147
        'y': 141
      create_incident:
        x: 324
        'y': 143
        navigate:
          e6825478-1b23-ce29-8cd7-300e1e3e672e:
            targetId: 4767c5cd-a5f4-b654-0c65-ece0a209e683
            port: SUCCESS
      SendMailR2F:
        x: 322
        'y': 368
        navigate:
          d58da9c4-ef6c-8211-bc8e-54120133071b:
            targetId: 7008a4f7-50f3-1fa0-b7a2-4c2bb4088002
            port: FAILURE
          589010b3-2cb7-26a1-5951-ece32419f957:
            targetId: 4767c5cd-a5f4-b654-0c65-ece0a209e683
            port: SUCCESS
    results:
      FAILURE:
        7008a4f7-50f3-1fa0-b7a2-4c2bb4088002:
          x: 319
          'y': 528
      SUCCESS:
        4767c5cd-a5f4-b654-0c65-ece0a209e683:
          x: 528
          'y': 141
