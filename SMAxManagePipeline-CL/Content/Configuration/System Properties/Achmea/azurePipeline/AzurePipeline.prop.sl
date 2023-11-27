namespace: Achmea.azurePipeline
properties:
  - azurePiplineSMAxUser: ExampleSMAxUser
  - azurePiplinePwsScript: Create-ADO-ReleaseYAML-RestAPI.ps1
  - azurePiplinePwsCodePath: "AutomationGeneric\\PoSHTools\\SMAx2ADOrelease\\"
  - azurePipelinePwsPort: '443'
  - azurePipelineProtocol: https
  - azurePipelineServer: P01506.hosting.corp
  - flowPath: Library/Achmea/Shared/azurePipeline/SMAx2ADO
