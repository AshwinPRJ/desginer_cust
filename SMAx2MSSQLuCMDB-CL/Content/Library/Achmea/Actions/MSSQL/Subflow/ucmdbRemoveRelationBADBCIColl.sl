namespace: Achmea.Actions.MSSQL.Subflow
flow:
  name: ucmdbRemoveRelationBADBCIColl
  inputs:
    - ssoToken:
        default: '${ssoToken}'
        required: false
    - uCMDB_url: '${uCMDB_url}'
    - userName: '${userName}'
    - userPassword:
        sensitive: true
    - FromID: '${FromID}'
    - ToID: '${ToID}'
  workflow:
    - removeRelationUcmdb:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.removeRelationUcmdb:
            - ssoToken: '${ssoToken}'
            - uCMDB_url: '${uCMDB_url}'
            - userName: '${userName}'
            - userPassword:
                value: '${userPassword}'
                sensitive: true
            - FromID: '${FromID}'
            - FromName: '${FromName}'
            - ToID: '${ToID}'
            - RelationType: usage
        publish:
          - Result_Code
          - Result
        navigate:
          - FAILURE: FAILURE_1
          - SUCCESS: SUCCESS
  outputs:
    - Result: '${Result}'
    - Result_Code: '${Result_Code}'
  results:
    - SUCCESS
    - FAILURE_1
extensions:
  graph:
    steps:
      removeRelationUcmdb:
        x: 240
        'y': 80
        navigate:
          0e434eb4-d29e-1ded-fde4-6226852c8e0e:
            targetId: 8966049e-bb56-bca2-1572-40dedccbaad4
            port: FAILURE
          616f51b4-4b86-8131-d49c-46f2a8eacb9b:
            targetId: aa2be3e0-b13c-da74-2f66-353e4cf1aad7
            port: SUCCESS
    results:
      SUCCESS:
        aa2be3e0-b13c-da74-2f66-353e4cf1aad7:
          x: 400
          'y': 80
      FAILURE_1:
        8966049e-bb56-bca2-1572-40dedccbaad4:
          x: 240
          'y': 280
