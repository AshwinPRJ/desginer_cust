namespace: Achmea.Actions.Subflows
flow:
  name: findSecurityIncident
  inputs:
    - SecurityIncidentTitle
    - sso_TokenSMA:
        required: false
    - SecurityIncidentActive: 'true'
  workflow:
    - queryEntityAchmea:
        do:
          Achmea.Shared.subFlows.SMA.queryEntityAchmea:
            - entity_type: SecurityIncident_c
            - query: "${\"DisplayLabel='\" +  SecurityIncidentTitle + \"' and Active_c=\" + SecurityIncidentActive}"
            - fields: 'Id,Description_c'
            - sso_Token: '${sso_TokenSMA}'
        publish:
          - entity_json
          - return_result
          - error_message: '${error_json}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: getDescription_json_path_query
          - CUSTOM: CUSTOM
    - getDescription_json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${entity_json}'
            - json_path: $..Description_c
        publish:
          - descriptionRaw: '${return_result}'
          - return_code
          - error_message: '${exception}'
        navigate:
          - SUCCESS: getID_json_path_query
          - FAILURE: on_failure
    - getID_json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${entity_json}'
            - json_path: $..Id
        publish:
          - IdRaw: '${return_result}'
          - return_code
          - error_message: '${exception}'
        navigate:
          - SUCCESS: Description_removeCharactersString
          - FAILURE: on_failure
    - Description_removeCharactersString:
        do:
          Achmea.Shared.Operations.removeCharactersString:
            - Value: '${descriptionRaw}'
            - seperator: ','
            - removeCharacters: '[,], /,"'
        publish:
          - Description: '${return_result}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: IDremoveCharactersString
          - FAILURE: on_failure
    - IDremoveCharactersString:
        do:
          Achmea.Shared.Operations.removeCharactersString:
            - Value: '${IdRaw}'
            - seperator: ','
            - removeCharacters: '[","]'
        publish:
          - Id: '${return_result}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - Id: '${Id}'
    - Description: '${Description}'
    - error_message: '${error_message}'
    - return_code: '${return_code}'
  results:
    - FAILURE
    - SUCCESS
    - CUSTOM
extensions:
  graph:
    steps:
      queryEntityAchmea:
        x: 160
        'y': 160
        navigate:
          2da721f4-1b96-d97c-63b1-a8344b6d1322:
            targetId: 4c219dc2-731e-ff0b-60c8-f207de40f971
            port: CUSTOM
      getDescription_json_path_query:
        x: 400
        'y': 200
      getID_json_path_query:
        x: 560
        'y': 200
      Description_removeCharactersString:
        x: 800
        'y': 320
      IDremoveCharactersString:
        x: 800
        'y': 80
        navigate:
          34f67cad-0039-9c0c-df9e-a37bb3a8ffa2:
            targetId: e3fb716d-8eaf-ca37-642e-cd9faa53463f
            port: SUCCESS
    results:
      SUCCESS:
        e3fb716d-8eaf-ca37-642e-cd9faa53463f:
          x: 920
          'y': 240
      CUSTOM:
        4c219dc2-731e-ff0b-60c8-f207de40f971:
          x: 320
          'y': 40
