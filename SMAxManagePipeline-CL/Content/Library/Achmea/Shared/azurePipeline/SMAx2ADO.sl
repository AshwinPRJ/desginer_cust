########################################################################################################################
#!!
#! @description: This flow fill generate the powershell command with json parameters to start the pipeline.
#!
#! @result SUCCESS: return_code == '0'
#!!#
########################################################################################################################
namespace: Achmea.Shared.azurePipeline
flow:
  name: SMAx2ADO
  inputs:
    - SMAxEntityId
    - SMAxEntityType
    - separator
    - piplineProjectName
    - pipelineID
    - paramFlowVarNameList
    - numberOfInstances
    - resourcegroupName
    - paramflowVarValueList:
        required: false
    - flowReference
    - systemName
  workflow:
    - setVars_do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - flowVarValues: ''
        publish:
          - flowVarValues
        navigate:
          - SUCCESS: setSAfixedParams
          - FAILURE: FAILURE
    - setSAfixedParams:
        do:
          Achmea.Shared.Subflow.setSAfixedParams:
            - SMAxEntityId: '${SMAxEntityId}'
            - SMAxEntityType: '${SMAxEntityType}'
            - flowReference: '${flowReference}'
            - separator: '${separator}'
            - systemName: '${systemName}'
        publish:
          - JsonSAfixedParams
          - result_code: '${return_code}'
          - error_message
        navigate:
          - SUCCESS: setSAsolParams
          - FAILURE: FAILURE
    - setSAsolParams:
        do:
          Achmea.Shared.Subflow.setSAsolParams:
            - piplineProjectName: '${piplineProjectName}'
            - pipelineID: '${pipelineID}'
            - separator: '${separator}'
        publish:
          - JsonSASolParams
          - return_code
          - error_message
        navigate:
          - SUCCESS: param_list_iterator
          - FAILURE: FAILURE
    - param_list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${paramFlowVarNameList}'
            - separator: '${separator}'
        publish:
          - paramFlowVarName: '${result_string}'
        navigate:
          - HAS_MORE: getparamValue_do_nothing
          - NO_MORE: ADOvarParamsJson_createJSONFromList
          - FAILURE: FAILURE
    - getparamValue_do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - FlowVarValue: '${globals()[paramFlowVarName]}'
        publish:
          - FlowVarValue
        navigate:
          - SUCCESS: combineString
          - FAILURE: FAILURE
    - ADOvarParamsJson_createJSONFromList:
        do:
          Achmea.Shared.Operation.createJSONFromList:
            - FlowVarsNames: '${paramFlowVarNameList}'
            - FlowVarsValues: '${flowVarValues}'
            - separator: '${separator}'
        publish:
          - DOAParamsJson: '${outputJson}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: getSysprops_do_nothing
          - FAILURE: on_failure
    - getSysprops_do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - pwsLocationPart1: "${get_sp('Achmea.Powershell.RobotoriumLocation')}"
            - pwsLocationPart2: "${get_sp('Achmea.azurePipeline.azurePiplinePwsCodePath')}"
            - pwsLocationPart3: "${get_sp('Achmea.azurePipeline.azurePiplinePwsScript')}"
        publish:
          - azurePipelinePwsScriptWithPath: "${'\"' + pwsLocationPart1 + pwsLocationPart2 + pwsLocationPart3 + '\"'}"
        navigate:
          - SUCCESS: startPowershellRAS_Achmea
          - FAILURE: FAILURE
    - combineString:
        do:
          Achmea.Shared.Operations.combineString:
            - value: '${FlowVarValue}'
            - seperator: '${separator}'
            - orginalString: '${flowVarValues}'
        publish:
          - flowVarValues: '${newvalue}'
          - error_message
          - return_code
        navigate:
          - SUCCESS: param_list_iterator
          - FAILURE: FAILURE
    - startPowershellRAS_Achmea:
        do:
          Achmea.Shared.subFlows.PowerShell.startPowershellRAS_Achmea:
            - PwsVersion: '7'
            - PwsScriptWithPath: "${azurePipelinePwsScriptWithPath + ' -SAfixedParams '  + JsonSAfixedParams  + ' -SAsolParams '  + JsonSASolParams  + ' -ADOParams '  + DOAParamsJson}"
        publish:
          - rawResult: '${return_resultPws}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: getJsonValuePwsResult
    - getJsonValuePwsResult:
        do:
          Achmea.Shared.Operation.getJsonValuePwsResult:
            - rawData: '${rawResult}'
        publish:
          - outPutJson: '${outputJson}'
          - error_message
          - return_code
        navigate:
          - SUCCESS: getPwsJsonResults
          - FAILURE: on_failure
    - getPwsJsonResults:
        do:
          Achmea.Shared.Operation.getPwsJsonResults:
            - PwsResult: '${outPutJson}'
        publish:
          - error_message: '${PwsErrorMessage}'
          - return_code: '${PwsReturnCode}'
          - return_result: '${PwsReturnResult}'
          - error_message_adv: '${PwsAdvancedMessage}'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - error_message: '${error_message}'
    - return_result: '${return_result}'
    - result_code: '${result_code}'
    - PSErrorMessage: '${PSErrorMessage}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ADOvarParamsJson_createJSONFromList:
        x: 920
        'y': 120
      setSAsolParams:
        x: 440
        'y': 120
        navigate:
          7cba55c0-940e-9a3e-6054-4a2f5fbb4f0c:
            targetId: 38ee20c0-8944-ca2c-4255-f0b6744b0ee2
            port: FAILURE
      setSAfixedParams:
        x: 240
        'y': 120
        navigate:
          2fa0c088-a0a0-e0d0-8f57-9cb8015f163c:
            targetId: 38ee20c0-8944-ca2c-4255-f0b6744b0ee2
            port: FAILURE
      setVars_do_nothing:
        x: 40
        'y': 120
        navigate:
          d166c229-21bd-9f34-7244-232a7886afcb:
            targetId: 38ee20c0-8944-ca2c-4255-f0b6744b0ee2
            port: FAILURE
      startPowershellRAS_Achmea:
        x: 1040
        'y': 320
        navigate:
          dfb79f6e-4474-69d3-2d3a-a1062a57bbc9:
            targetId: f18221c5-8cbb-e349-9049-96a80850937e
            port: FAILURE
      combineString:
        x: 760
        'y': 560
        navigate:
          b174103a-4939-65da-9bd5-adc52ef592be:
            targetId: 38ee20c0-8944-ca2c-4255-f0b6744b0ee2
            port: FAILURE
      getJsonValuePwsResult:
        x: 1240
        'y': 320
      getPwsJsonResults:
        x: 1280
        'y': 560
        navigate:
          3a7411cf-40f4-2b6f-4434-44797de3c711:
            targetId: 82fe7104-ff7c-5599-85e8-1319352fdaa7
            port: SUCCESS
      param_list_iterator:
        x: 720
        'y': 120
        navigate:
          018332aa-91fe-98ff-b7cb-19dfd44413a6:
            targetId: 38ee20c0-8944-ca2c-4255-f0b6744b0ee2
            port: FAILURE
      getparamValue_do_nothing:
        x: 600
        'y': 400
        navigate:
          b57ed722-05a5-d9f5-990a-253fcff8e9b9:
            targetId: 38ee20c0-8944-ca2c-4255-f0b6744b0ee2
            port: FAILURE
      getSysprops_do_nothing:
        x: 1120
        'y': 120
        navigate:
          6b7c4c0e-42af-91db-648f-c0d8c4364d65:
            targetId: f18221c5-8cbb-e349-9049-96a80850937e
            port: FAILURE
    results:
      FAILURE:
        38ee20c0-8944-ca2c-4255-f0b6744b0ee2:
          x: 240
          'y': 520
        f18221c5-8cbb-e349-9049-96a80850937e:
          x: 800
          'y': 360
      SUCCESS:
        82fe7104-ff7c-5599-85e8-1319352fdaa7:
          x: 1000
          'y': 600
