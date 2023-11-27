namespace: Achmea.Shared.subFlows.LDAP
flow:
  name: isUserLdapGroupMember
  inputs:
    - sourceIdSMAx
    - sourceTypeSMAx
    - idmGroup
  workflow:
    - powershell_script:
        do:
          io.cloudslang.base.powershell.powershell_script:
            - host: localhost
            - auth_type: Kerberos
            - script: "'E:\\Data\\Scripts\\Powershell\\IsUserGroupsMember.ps1 \"A5805134\" \"eur.tld\" \"g-s-rbap-a-sma-assetconfigurationadministrator\"'\n"
            - trust_all_roots: 'True'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      powershell_script:
        x: 640
        'y': 120
        navigate:
          ce15c65f-e0d4-aa77-3671-4f24864b379d:
            targetId: 00a8134d-9ec5-b412-c858-cc00e57832c8
            port: SUCCESS
          1065684f-6498-338a-3895-42fa81167f90:
            targetId: 181becd0-eaf8-a9fc-393c-31df1d8cb10f
            port: FAILURE
    results:
      SUCCESS:
        00a8134d-9ec5-b412-c858-cc00e57832c8:
          x: 960
          'y': 120
      FAILURE:
        181becd0-eaf8-a9fc-393c-31df1d8cb10f:
          x: 640
          'y': 360
