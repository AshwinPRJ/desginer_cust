namespace: Achmea.Subflows.Achmea.CreateLDAPGroup.Operations
operation:
  name: determineLDAPStartOU
  inputs:
    - Name
    - startOU_Authentication
    - startOUGTN_Administration
    - startOU_UserAggregatedApplications
    - startOUDistribution
    - startOUnetwork_folders
    - startOU_ITAdministration
    - startOU_DatabaseAggregatedApplications
    - startOU_ManagementGroups
    - startOU_TerminalServerAggregatedApplications
    - startOU_GroupData
  python_action:
    use_jython: false
    script: "# This operator will determine the start OU where the LDAP group will be created. The startOUs are stored in system props, what StartOU will be used depends on the name of the LDAP group\r\ndef execute(Name,startOU_Authentication,startOUGTN_Administration,startOU_UserAggregatedApplications,startOUDistribution,startOUnetwork_folders,startOU_ITAdministration,startOU_DatabaseAggregatedApplications,startOU_ManagementGroups,startOU_TerminalServerAggregatedApplications,startOU_GroupData):\r\n    return_code = '0'\r\n    error_message = ''\r\n    return_result = ''\r\n    constFound = -1\r\n\r\n    try:\r\n        if Name.find('g-s-auth-') > constFound:\r\n            return_result = startOU_Authentication\r\n        elif Name.find('g-s-ddir-') > constFound or Name.find('g-s-rbap-') > constFound or Name.find('g-s-share') > constFound or Name.find('g-s-supp-') > constFound or Name.find('l-s-ddir-') > constFound:\r\n            return_result = startOUGTN_Administration\r\n        elif Name.find('g-s-uapp-') >  constFound:\r\n            return_result = startOU_UserAggregatedApplications\r\n        elif Name.find('g-s-seqd-') > constFound or Name.find('g-s-udis-') > constFound:\r\n            return_result = startOUDistribution\r\n        elif Name.find('g-s-wdir-') > constFound or Name.find('l-s-wdir-') > constFound:\r\n            return_result = startOUnetwork_folders\r\n        elif Name.find('g-s-ddir-') > constFound:\r\n            return_result = startOU_ITAdministration\r\n        elif Name.find('g-s-dbms-') > constFound:\r\n            return_result = startOU_DatabaseAggregatedApplications\r\n        elif Name.find('u-s-srvr-') > constFound:\r\n            return_result = startOU_ManagementGroups\r\n        elif Name.find('g-s-sbc-') > constFound:\r\n            return_result = startOU_TerminalServerAggregatedApplications\r\n        elif Name.find('g-s-gdir-') > constFound:\r\n            return_result = startOU_GroupData\r\n        else:\r\n            error_message = 'Unknown syntax name to determine StartOU'\r\n            return_code = '1'        \r\n\r\n    except Exception as e:\r\n        return_code = '1'\r\n        error_message = str\r\n    return{\"return_result\":return_result,\"return_code\":return_code, \"error_message\":error_message}"
  outputs:
    - return_result
    - return_code
    - error_message
  results:
    - SUCCESS
