namespace: Achmea.Shared.Micro-Focus.uCMDB.Subflow
flow:
  name: getAuthenticationTokenAchmea
  workflow:
    - getCreditsKeepass:
        do:
          Achmea.Shared.subFlows.Generic.getCreditsKeepass:
            - KeepassEntry: "${get_sp('MF.uCMDB.uCMDBKeepassEntry')}"
        publish:
          - PassWord
          - UserName
          - return_code
          - error_message
        navigate:
          - SUCCESS: request_body_creator
          - FAILURE: FAILURE
    - request_body_creator:
        do:
          io.cloudslang.microfocus.ucmdb.v1.utils.request_body_creator:
            - username: '${UserName}'
            - password:
                value: '${PassWord}'
                sensitive: true
            - repository: '${repository}'
            - client_context: '1'
        publish:
          - body
          - return_code
          - error_message
        navigate:
          - SUCCESS: http_client_post
          - FAILURE: FAILURE
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get_sp('MF.uCMDB.uCMDB_url') + '/rest-api/authenticate'}"
            - username: '${UserName}'
            - password:
                value: '${PassWord}'
                sensitive: true
            - trust_all_roots: 'True'
            - body: '${body}'
            - content_type: application/json; charset=UTF-8
        publish:
          - return_result
          - error_message
        navigate:
          - SUCCESS: aitGetTokenKey
          - FAILURE: FAILURE
    - aitGetTokenKey:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Operation.aitGetTokenKey:
            - dataJson: '${return_result}'
            - keyName: token
        publish:
          - token: '${value}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - token: '${token}'
    - error_message: '${error_message}'
    - return_code: '${return_code}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      getCreditsKeepass:
        x: 80
        'y': 80
        navigate:
          4da965a0-4b28-f698-dbcc-01a56cbfd9d5:
            targetId: 74699740-ebf2-0c14-c394-456934ccd1ca
            port: FAILURE
      request_body_creator:
        x: 240
        'y': 80
        navigate:
          1c22d724-f937-db83-1166-b86864fb223a:
            targetId: 74699740-ebf2-0c14-c394-456934ccd1ca
            port: FAILURE
      http_client_post:
        x: 400
        'y': 80
        navigate:
          74fe429d-5477-1d77-a256-6245a6027167:
            targetId: 74699740-ebf2-0c14-c394-456934ccd1ca
            port: FAILURE
      aitGetTokenKey:
        x: 600
        'y': 80
        navigate:
          162d8348-a1f9-c143-63ac-b9573325032b:
            targetId: 74699740-ebf2-0c14-c394-456934ccd1ca
            port: FAILURE
          3c7f404b-29fb-2351-9d42-a16584ff1e2d:
            targetId: 2fb9972e-284f-ac7c-af82-943b3e2389c9
            port: SUCCESS
    results:
      FAILURE:
        74699740-ebf2-0c14-c394-456934ccd1ca:
          x: 360
          'y': 360
      SUCCESS:
        2fb9972e-284f-ac7c-af82-943b3e2389c9:
          x: 760
          'y': 80
