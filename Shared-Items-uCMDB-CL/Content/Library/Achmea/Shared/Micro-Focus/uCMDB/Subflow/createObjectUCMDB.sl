########################################################################################################################
#!!
#! @input ciType: CI type to be created. this is the technical name of the ci in Ucmdb
#! @input sso_Token: Ucmdb Token
#!!#
########################################################################################################################
namespace: Achmea.Shared.Micro-Focus.uCMDB.Subflow
flow:
  name: createObjectUCMDB
  inputs:
    - ciType
    - prop
    - prop1
    - prop2:
        required: false
    - prop3:
        required: false
    - prop4:
        required: false
    - prop5:
        required: false
    - sso_Token:
        required: false
  workflow:
    - set_Inputs_to_flowvars_1:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Operation.set_Inputs_to_flowvars:
            - prop: '${prop}'
            - prop1: '${prop1}'
            - prop2: '${prop2}'
            - prop3: '${prop3}'
            - prop4: '${prop4}'
            - prop5: '${prop5}'
        publish:
          - error_message
          - return_code
          - ci_props: '${return_result}'
          - output_1: output_1
        navigate:
          - SUCCESS: is_null
          - FAILURE: FAILURE
    - create_configuration_item:
        do:
          io.cloudslang.microfocus.ucmdb.v1.data_model.ci.create_configuration_item:
            - url: "${get_sp('MF.uCMDB.uCMDB_url')}"
            - token: '${sso_Token}'
            - type: '${ciType}'
            - ci_properties: '${ci_props}'
            - force_temporary_id: 'true'
            - ignore_existing: 'false'
            - is_global: 'true'
            - trust_all_roots: 'true'
        publish:
          - added_cis
          - status_code
          - error_message
          - return_code
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
    - is_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${sso_Token}'
        publish: []
        navigate:
          - IS_NULL: getAuthenticationTokenAchmea
          - IS_NOT_NULL: create_configuration_item
    - getAuthenticationTokenAchmea:
        do:
          Achmea.Shared.Micro-Focus.uCMDB.Subflow.getAuthenticationTokenAchmea: []
        publish:
          - sso_Token: '${token}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: create_configuration_item
  outputs:
    - added_cis: '${added_cis}'
    - error_message: '${error_message}'
    - return_code: '${return_code}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      set_Inputs_to_flowvars_1:
        x: 120
        'y': 80
        navigate:
          5d2931f6-5f5d-33fe-f5cf-a35e3beef86e:
            targetId: 33cb9475-2154-2900-4ab2-5dd2716c2170
            port: FAILURE
      create_configuration_item:
        x: 760
        'y': 240
        navigate:
          954ed659-ff86-cced-3dbf-a603f800b91b:
            targetId: e23c34e2-1a6e-d04a-eeb2-ede0206117c5
            port: SUCCESS
          1541dfbb-fb73-3c7a-e044-fe42dc62db94:
            targetId: 33cb9475-2154-2900-4ab2-5dd2716c2170
            port: FAILURE
      is_null:
        x: 440
        'y': 40
      getAuthenticationTokenAchmea:
        x: 440
        'y': 240
        navigate:
          ae083950-5f0a-268d-a9f5-fce94f82429a:
            targetId: 33cb9475-2154-2900-4ab2-5dd2716c2170
            port: FAILURE
    results:
      FAILURE:
        33cb9475-2154-2900-4ab2-5dd2716c2170:
          x: 440
          'y': 440
      SUCCESS:
        e23c34e2-1a6e-d04a-eeb2-ede0206117c5:
          x: 880
          'y': 120
