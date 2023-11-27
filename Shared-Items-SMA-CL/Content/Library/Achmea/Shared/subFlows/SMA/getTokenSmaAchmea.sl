namespace: Achmea.Shared.subFlows.SMA
flow:
  name: getTokenSmaAchmea
  workflow:
    - getCreditsKeepass:
        do:
          Achmea.Shared.subFlows.Generic.getCreditsKeepass:
            - KeepassEntry: "${get_sp('Achmea.SMA.SMAKeepassEntry')}"
        publish:
          - UserName
          - PassWord
          - return_code
          - error_message
        navigate:
          - SUCCESS: get_sso_token
          - FAILURE: FAILURE
    - get_sso_token:
        do:
          io.cloudslang.microfocus.service_management_automation_x.commons.get_sso_token:
            - saw_url: "${get_sp('Achmea.SMA.URL')}"
            - tenant_id: "${get_sp('Achmea.SMA.Tentant')}"
            - username: '${UserName}'
            - password:
                value: '${PassWord}'
                sensitive: true
            - trust_all_roots: "${get_sp('Achmea.SMA.trust_all_roots')}"
            - x509_hostname_verifier: "${get_sp('Achmea.SMA.x509_hostname_verifier')}"
        publish:
          - sso_Token: '${sso_token}'
          - status_Code: '${status_code}'
          - exception
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
  outputs:
    - sso_Token: '${sso_Token}'
    - status_Code: '${status_Code}'
    - exception: '${exception}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      getCreditsKeepass:
        x: 160
        'y': 160
        navigate:
          793c7787-4b21-8fd7-654f-2c98d0480cf5:
            targetId: 1be2f341-b381-5f58-6a87-b02f4c461b0c
            port: FAILURE
      get_sso_token:
        x: 360
        'y': 160
        navigate:
          143e7abf-8e25-73d8-752e-78e77671663f:
            targetId: 1be2f341-b381-5f58-6a87-b02f4c461b0c
            port: FAILURE
          986bcec2-05e6-b963-ad01-94a049d77a44:
            targetId: ae7afd84-13a6-9219-22a4-165bd3a2b8e9
            port: SUCCESS
    results:
      SUCCESS:
        ae7afd84-13a6-9219-22a4-165bd3a2b8e9:
          x: 600
          'y': 160
      FAILURE:
        1be2f341-b381-5f58-6a87-b02f4c461b0c:
          x: 360
          'y': 400
