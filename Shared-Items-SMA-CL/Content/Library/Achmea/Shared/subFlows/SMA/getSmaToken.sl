namespace: Achmea.Shared.subFlows.SMA
flow:
  name: getSmaToken
  inputs:
    - smaUrl: "${get_sp('Achmea.SMA.URL')}"
    - smaTennant: "${get_sp('Achmea.SMA.Tentant')}"
    - smaUser: "${get_sp('Achmea.SMA.User')}"
    - smaPassw:
        default: "${get_sp('Achmea.SMA.Password')}"
        sensitive: true
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${smaUrl + '/auth/authentication-endpoint/authenticate/token?TENANTID=' + smaTennant}"
            - username: '${smaUser}'
            - password:
                value: '${smaPassw}'
                sensitive: true
            - trust_all_roots: 'true'
            - body: "${('{\"login\":' + '\"' + username + '\"' + ',\"password\":' + '\"' + password + '\"' + '}')}"
        publish:
          - return_result
          - return_code
          - error_message
          - headers: '${response_headers}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - sso_token: '${return_result}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      http_client_post:
        x: 320
        'y': 200
        navigate:
          ec4509e0-d806-89c4-fcf3-5f7f2dffe538:
            targetId: ffdf40e3-8197-1c8e-7d28-4edd6481f9e9
            port: SUCCESS
    results:
      SUCCESS:
        ffdf40e3-8197-1c8e-7d28-4edd6481f9e9:
          x: 480
          'y': 200
