########################################################################################################################
#!!
#! @result SUCCESS: return_code == '0'
#!!#
########################################################################################################################
namespace: Achmea.Shared.subFlows.LDAP
flow:
  name: createLDAPGroupPWS
  inputs:
    - groupName: TestDemo02
    - StartOU: 'OU=Automation Test,OU=Software Directory,DC=eur,DC=tld'
    - groupDescription: Description of demo new demo group
    - owner: '471751'
  workflow:
    - pocSetLDAPGroupName:
        do:
          Achmea.Shared.Operations.pocSetLDAPGroupName:
            - Environment: acc
            - Name: '${groupName}'
        publish:
          - GroupName: '${return_value}'
        navigate:
          - SUCCESS: startPowershellRAS_Achmea
    - startPowershellRAS_Achmea:
        do:
          Achmea.Shared.subFlows.PowerShell.startPowershellRAS_Achmea:
            - PwsVersion: '7'
            - PwsScriptWithPath: "${'E:\\Data\\Scripts\\Powershell\\CreateLDAPGroup\\createLDAPGroup.ps1 -GroupName \"' + GroupName + '\" -Owner \"' + owner + '\" -GroupDescription \"' + groupDescription + '\" -StartOU \"' + StartOU + '\"'}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      pocSetLDAPGroupName:
        x: 120
        'y': 120
      startPowershellRAS_Achmea:
        x: 440
        'y': 120
        navigate:
          45223c7e-c822-83d4-9811-56fc02ec589e:
            targetId: 3b7cc204-5045-0cc8-ef13-a0f2cc58bbfc
            port: SUCCESS
    results:
      SUCCESS:
        3b7cc204-5045-0cc8-ef13-a0f2cc58bbfc:
          x: 720
          'y': 120
