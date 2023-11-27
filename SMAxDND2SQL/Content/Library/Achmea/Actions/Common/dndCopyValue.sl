namespace: Achmea.Actions.Common
flow:
  name: dndCopyValue
  inputs:
    - dnd_sourceValue
  workflow:
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - dnd_sourceValue: '${dnd_sourceValue}'
        publish:
          - result: '${dnd_sourceValue}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE_1
  outputs:
    - dnd_destinationValue: '${dnd_sourceValue}'
    - dnd_returnResult
    - dnd_returnCode
    - dnd_errorMessage
  results:
    - FAILURE_1
    - SUCCESS
extensions:
  graph:
    steps:
      do_nothing:
        x: 760
        'y': 320
        navigate:
          86e4b5ed-4ddb-83cf-9c59-9d316dee3cf1:
            targetId: 15b1242d-9c05-dd69-faf0-f46fab9f7661
            port: FAILURE
          48729d7f-eaf4-ab78-fc64-63d31c04efad:
            targetId: 15c9db6a-4cc4-ca32-db6e-083d306d983d
            port: SUCCESS
    results:
      FAILURE_1:
        15b1242d-9c05-dd69-faf0-f46fab9f7661:
          x: 760
          'y': 520
      SUCCESS:
        15c9db6a-4cc4-ca32-db6e-083d306d983d:
          x: 1000
          'y': 320
