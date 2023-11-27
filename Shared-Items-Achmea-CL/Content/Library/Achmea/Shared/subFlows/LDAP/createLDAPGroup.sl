########################################################################################################################
#!!
#! @result SUCCESS: return_code == '0'
#!!#
########################################################################################################################
namespace: Achmea.Shared.subFlows.LDAP
flow:
  name: createLDAPGroup
  inputs:
    - groupName: sma-achmea-poc
  workflow:
    - pocSetLDAPGroupName:
        do:
          Achmea.Shared.Operations.pocSetLDAPGroupName:
            - Environment: acc
            - Name: '${groupName}'
        publish:
          - samAccountName: '${return_value}'
          - GroupNameDN: '${dn}'
        navigate:
          - SUCCESS: create_group
    - create_group:
        do:
          io.cloudslang.base.active_directory.groups.create_group:
            - host: eur.tld
            - username: SY000018@eur.tld
            - password:
                value: 'Axe%s3fz'
                sensitive: true
            - distinguished_name: '${GroupNameDN}'
            - group_common_name: '${samAccountName}'
            - sam_account_name: '${samAccountName}'
            - group_type: '-2147483646'
            - trust_all_roots: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      pocSetLDAPGroupName:
        x: 200
        'y': 120
      create_group:
        x: 440
        'y': 120
        navigate:
          4165b4e0-65ef-96ba-af6d-82413ea422c2:
            targetId: 3b7cc204-5045-0cc8-ef13-a0f2cc58bbfc
            port: SUCCESS
          78e46e88-87a6-e6fe-e66c-a632e4793acf:
            targetId: dbee49f1-a2ba-34cf-026f-f5d93cabb585
            port: FAILURE
    results:
      SUCCESS:
        3b7cc204-5045-0cc8-ef13-a0f2cc58bbfc:
          x: 720
          'y': 120
      FAILURE:
        dbee49f1-a2ba-34cf-026f-f5d93cabb585:
          x: 440
          'y': 360
