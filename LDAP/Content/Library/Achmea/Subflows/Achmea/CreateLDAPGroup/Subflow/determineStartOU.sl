namespace: Achmea.Subflows.Achmea.CreateLDAPGroup.Subflow
flow:
  name: determineStartOU
  inputs:
    - ldapGroupName
  workflow:
    - determineLDAPStartOU:
        do:
          Achmea.Subflows.Achmea.CreateLDAPGroup.Operations.determineLDAPStartOU:
            - Name: '${ldapGroupName}'
            - startOU_Authentication: "${get_sp('Achmea.LDAP.Authentication_startOU')}"
            - startOUGTN_Administration: "${get_sp('Achmea.LDAP.Administration_startOUGTN')}"
            - startOU_UserAggregatedApplications: "${get_sp('Achmea.LDAP.UserAggregatedApplications_startOU')}"
            - startOUDistribution: "${get_sp('Achmea.LDAP.Distribution_startOU')}"
            - startOUnetwork_folders: "${get_sp('Achmea.LDAP.network_folders_startOU')}"
            - startOU_ITAdministration: "${get_sp('Achmea.LDAP.ITAdministration_startOU')}"
            - startOU_DatabaseAggregatedApplications: "${get_sp('Achmea.LDAP.DatabaseAggregatedApplications_startOU')}"
            - startOU_ManagementGroups: "${get_sp('Achmea.LDAP.ManagementGroups_startOU')}"
            - startOU_TerminalServerAggregatedApplications: "${get_sp('Achmea.LDAP.TerminalServerAggregatedApplications_startOU')}"
            - startOU_GroupData: "${get_sp('Achmea.LDAP.GroupData_startOU')}"
        publish:
          - return_result
          - return_code
          - error_message
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - return_result: '${return_result}'
    - return_code: '${return_code}'
    - error_message: '${error_message}'
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      determineLDAPStartOU:
        x: 240
        'y': 120
        navigate:
          92277417-e13d-92ad-4e7c-ea93b3657bbe:
            targetId: 973340a1-7afc-fbf1-6229-6b6f90bc7e04
            port: SUCCESS
    results:
      SUCCESS:
        973340a1-7afc-fbf1-6229-6b6f90bc7e04:
          x: 440
          'y': 120
