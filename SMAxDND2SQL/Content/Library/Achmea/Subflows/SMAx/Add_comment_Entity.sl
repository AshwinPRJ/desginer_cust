########################################################################################################################
#!!
#! @description: This flow will update the Discussions property in a given entity which is identified by its ID.
#!                
#!               Step 1 - Checks for an available SSO token.
#!               Step 2 - Add discussion in a given entity.
#!                
#!               Inputs:
#!               entityId: Given ID of the entity that needs updating.
#!               	  Example: 123456
#!               entityType: Kind of entity
#!               Example: Request
#!               message: Text to put in the discussion.
#!               	 Example: Request is succesfull
#!               sMAxUrl: Url for SMAx 
#!               	 Example: https://sma.preview.hosting.corp
#!               tenantID: SMAx Tenant ID
#!               	 Example: '781313141' 
#!                
#!                
#!               Outputs: 
#!               commentResult:  Result from the flow 
#!               errorMessage:	An error message containing an exception.
#!                
#!               Responses: 
#!               success - the operation succeeded.
#!               failure - failure, to be handled by the calling flow
#!!#
########################################################################################################################
namespace: Achmea.Subflows.SMAx
flow:
  name: Add_comment_Entity
  inputs:
    - smaUrl
    - smaTennant
    - entityId
    - entityType
    - message
    - smaUser
    - smaPassw:
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
          - errorMessage
          - return_code
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: FormatMessage
    - FormatMessage:
        do:
          io.cloudslang.base.utils.do_nothing:
            - messageComment: '${message}'
        publish:
          - comment: '${messageComment}'
        navigate:
          - SUCCESS: AddComment
          - FAILURE: FAILURE
    - AddComment:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${smaUrl + '/rest/' + smaTennant + '/collaboration/comments/' + entityType + '/' + entityId}"
            - trust_all_roots: 'true'
            - headers: '${("COOKIE:LWSSO_COOKIE_KEY=" + smaToken + ";TENANTID=" + smaTennant)}'
            - body: "${'{\"IsSystem\": false,\"Body\": \"' + comment + '\",\"AttachmentIds\": [],\"PrivacyType\": \"INTERNAL\",\"ActualInterface\": \"API\",\"CommentFrom\": \"Agent\",\"CommentTo\": \"Agent\",\"FunctionalPurpose\": \"StatusUpdate\",\"Media\": \"Unknown\",\"PersonParticipant\": \"\",\"CompanyVendor\": \"\",\"Group\": \"\"}'}"
            - content_type: application/json
        publish:
          - resultAddComment: '${return_result}'
          - errorMessage: '${error_message}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - commentResult: '${resultAddComment}'
    - errorMessage: '${errorMessage}'
    - return_code: '${return_code}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      SMA_Token:
        x: 126
        'y': 148
        navigate:
          36285196-b429-e344-849f-53e6e21ec89c:
            targetId: 66233c0a-30f6-7c79-5a24-478158c82546
            port: FAILURE
      FormatMessage:
        x: 330
        'y': 150
        navigate:
          79a76a9c-40bd-7a59-4208-0668cd1b96c9:
            targetId: 66233c0a-30f6-7c79-5a24-478158c82546
            port: FAILURE
      AddComment:
        x: 520
        'y': 145
        navigate:
          359fb4ed-17e5-5cfa-e32c-e5987b3acae7:
            targetId: 95435074-d8ee-f7ed-55eb-74f8a1aeb3a1
            port: SUCCESS
          23e17d37-96c5-8e43-af4d-04901b6dc3de:
            targetId: 66233c0a-30f6-7c79-5a24-478158c82546
            port: FAILURE
    results:
      FAILURE:
        66233c0a-30f6-7c79-5a24-478158c82546:
          x: 324
          'y': 325
      SUCCESS:
        95435074-d8ee-f7ed-55eb-74f8a1aeb3a1:
          x: 697
          'y': 149
