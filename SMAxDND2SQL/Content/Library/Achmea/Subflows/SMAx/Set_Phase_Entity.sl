########################################################################################################################
#!!
#! @description: This flow will transistion an entity to a next phase.
#!                
#!               Step 1 - Checks for an available SSO token.
#!               Step 2 - Add discussion in a given entity.
#!                
#!               Inputs:
#!               entityId: Given ID of the entity that needs to be transitioned to a next phase
#!               	  Example: 123456
#!               entityType: Kind of entity
#!               Example: Request
#!               entityPhase: Next phase for entity
#!               	 Example: Validate
#!               sMAxUrl: Url for SMAx 
#!               	 Example: https://sma.preview.hosting.corp
#!               tenantID: SMAx Tenant ID
#!               	 Example: '781313141' 
#!                
#!               Outputs: 
#!               resultSetPhaseEntity:  result of transitioning entity to next phase
#!               errorMessage:	An error message containing an exception.
#!                
#!               Responses: 
#!               success - the operation succeeded.
#!               failure - failure, to be handled by the calling flow
#!!#
########################################################################################################################
namespace: Achmea.Subflows.SMAx
flow:
  name: Set_Phase_Entity
  inputs:
    - entityType: Task
    - entityId
    - entityPhase: Validate
    - smaTennant: '${smaTennant}'
    - smaUrl: '${smaUrl}'
    - smaUser: '${smaUser}'
    - smaPassw:
        default: '${smaPassw}'
        sensitive: true
  workflow:
    - SMA_Token:
        do:
          Achmea.Subflows.SMAx.SMA_Token:
            - smaUrl: '${smaUrl}'
            - smaTennant: '${smaTennant}'
            - smaUser: '${smaUser}'
            - smaPassw:
                value: '${smaPassw}'
                sensitive: true
        publish:
          - smaToken: '${ssoToken}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SetPhase
    - SetPhase:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${smaUrl + '/rest/' + smaTennant + '/ems/bulk'}"
            - trust_all_roots: 'true'
            - headers: '${("COOKIE:LWSSO_COOKIE_KEY=" + smaToken + ";TENANTID=" + smaTennant)}'
            - body: "${'{\"entities\": [{\"entity_type\": \"' + entityType + '\",\"properties\": {\"Id\": \"' + entityId + '\",\"PhaseId\":\"' + entityPhase + '\"},\"layout\": \"Id,PhaseId\"}],\"operation\": \"UPDATE\"}'}"
            - content_type: application/json
        publish:
          - resultSetPhase: '${return_result}'
          - errorMessage: '${error_message}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - resultSetPhaseEntity: '${resultSetPhase}'
    - errorMessage: '${errorMessage}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      SMA_Token:
        x: 223
        'y': 188.73333740234375
        navigate:
          75dfbb22-dc89-8932-e938-1f73b1783c49:
            targetId: 561ff38a-099a-ea38-a3e0-68dd08687e6f
            port: FAILURE
      SetPhase:
        x: 449
        'y': 193
        navigate:
          e69ad707-823e-99d0-be59-10a69c8d7d46:
            targetId: 15387bff-307d-58a6-2b6e-54449e05c7e5
            port: SUCCESS
          b15f60fb-e7d7-8fb1-11cb-39ba95963768:
            targetId: 561ff38a-099a-ea38-a3e0-68dd08687e6f
            port: FAILURE
    results:
      FAILURE:
        561ff38a-099a-ea38-a3e0-68dd08687e6f:
          x: 360
          'y': 382
      SUCCESS:
        15387bff-307d-58a6-2b6e-54449e05c7e5:
          x: 660
          'y': 193
