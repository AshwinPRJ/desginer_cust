########################################################################################################################
#!!
#! @description: This flow can be called through OO Central and will resume or fail a DND service instance that is in a paused state
#!
#! @input smaUrl: Enter the SMA url
#! @input smaTennant: Enter the SMA Tennant ID
#! @input dndUser: Enter the DND Integration User
#! @input dndPassw: Enter the DND Integration user password
#! @input dndStatus: Enter "resume" or "fail" for the pauzed service instance
#! @input dndServiceInstanceId: Enter the DND ServiceinstanceId to be resumed or failed
#!!#
########################################################################################################################
namespace: Achmea.Shared.Micro-Focus.SMAx.Subflows
flow:
  name: Return2DND
  inputs:
    - smaUrl:
        default: "${get_sp('MF.SMAx.DND_HOST_URL')}"
    - smaTennant:
        default: "${get_sp('MF.SMAx.DND_TENNANT_ID')}"
    - dndUser:
        default: "${get_sp('MF.SMAx.DND_INT_USER')}"
    - dndPassw:
        default: "${get_sp('MF.SMAx.DND_INT_USER_PW')}"
        sensitive: true
    - dndStatus
    - dndServiceInstanceId
  workflow:
    - get_sso_token:
        do:
          io.cloudslang.microfocus.service_management_automation_x.commons.get_sso_token:
            - saw_url: '${smaUrl}'
            - tenant_id: '${smaTennant}'
            - username: '${dndUser}'
            - password:
                value: '${dndPassw}'
                sensitive: true
            - trust_all_roots: 'true'
        publish:
          - smaToken: '${sso_token}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: resume_service_instance
    - resume_service_instance:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: '${smaUrl + "/" + smaTennant + "/dnd/api/service/instance/" + dndServiceInstanceId + "/" + dndStatus}'
            - username: '${dndUser}'
            - password:
                value: '${dndPassw}'
                sensitive: true
            - trust_all_roots: 'true'
            - headers: '${("COOKIE:LWSSO_COOKIE_KEY=" + smaToken + ";TENANTID=" + smaTennant)}'
            - content_type: application/json
        publish:
          - return_result
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: check_if_return_result_contains_execeptionmessage
    - get_exception_message:
        do:
          Achmea.Shared.Generic.Operations.Get_KeyValue:
            - dataJson: '${return_result}'
            - keyName: message
        publish:
          - error_message: '${value}'
        navigate:
          - SUCCESS: set_return_result_default_failure_remark
          - FAILURE: set_return_result_default_failure_remark
          - NO_RESULT: NO_RESULT
    - check_if_return_result_contains_execeptionmessage:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${return_result}'
        navigate:
          - IS_NULL: set_return_result_default_failure_remark
          - IS_NOT_NULL: get_exception_message
    - set_return_result_default_failure_remark:
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - return_result: 'Flow results in an Exception or a Failure, check dndErrorMessage for more details'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: FAILURE
  outputs:
    - dndResult: '${return_result}'
    - dndErrorMessage: '${error_message}'
  results:
    - FAILURE
    - SUCCESS
    - NO_RESULT
extensions:
  graph:
    steps:
      get_sso_token:
        x: 149
        'y': 144
        navigate:
          d9e96ef2-1fa7-3f98-8548-c9826282c14e:
            targetId: da1fc479-8270-496c-a5b8-8860fc207a49
            port: FAILURE
      resume_service_instance:
        x: 388
        'y': 144
        navigate:
          1f7eae67-e62a-496f-053d-216d324d4e80:
            targetId: 5929c98b-fad5-92d3-b2dd-404ab357dbce
            port: SUCCESS
      get_exception_message:
        x: 519
        'y': 572
        navigate:
          3720ebba-749c-3c7e-1fab-55e2e6f08143:
            targetId: b8cb7283-35ab-a042-d46c-dd95f9d4893b
            port: NO_RESULT
      check_if_return_result_contains_execeptionmessage:
        x: 391
        'y': 352
      set_return_result_default_failure_remark:
        x: 157
        'y': 572
        navigate:
          e9be4ce5-e25e-a0e5-68fa-db0ecf16a6f6:
            targetId: da1fc479-8270-496c-a5b8-8860fc207a49
            port: FAILURE
          1e220ade-d9dd-7e8b-a1ee-a9f080e20e22:
            targetId: da1fc479-8270-496c-a5b8-8860fc207a49
            port: SUCCESS
    results:
      FAILURE:
        da1fc479-8270-496c-a5b8-8860fc207a49:
          x: 152
          'y': 403
      SUCCESS:
        5929c98b-fad5-92d3-b2dd-404ab357dbce:
          x: 589
          'y': 143
      NO_RESULT:
        b8cb7283-35ab-a042-d46c-dd95f9d4893b:
          x: 720
          'y': 560
