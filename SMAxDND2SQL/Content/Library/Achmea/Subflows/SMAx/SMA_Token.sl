########################################################################################################################
#!!
#! @description: This flow will request a token for an SMAx API request
#!                
#!               Step - request an SMAx SSO token
#!                
#!               Inputs:
#!               sMAxUrl: Url for SMAx 
#!               	 Example: https://sma.preview.hosting.corp
#!               tenantID: SMAx Tenant ID
#!               	 Example: '781313141' 
#!                
#!               Outputs: 
#!               ssoToken:  sso token to be used in a cookie header in an API request
#!               errorMessage:	An error message containing an exception.
#!                
#!               Responses: 
#!               success - the operation succeeded.
#!               failure - failure, to be handled by the calling flow
#!!#
########################################################################################################################
namespace: Achmea.Subflows.SMAx
flow:
  name: SMA_Token
  inputs:
    - smaUrl: '${smaUrl}'
    - smaTennant: '${smaTennant}'
    - smaUser: '${smaUser}'
    - smaPassw:
        default: '${smaPassw}'
        sensitive: true
  workflow:
    - requestToken:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${smaUrl + '/auth/authentication-endpoint/authenticate/token?TENANTID=' + smaTennant}"
            - username: '${smaUser}'
            - password:
                value: '${smaPassw}'
                sensitive: true
            - trust_all_roots: 'true'
            - body: "${('{\"login\":' + '\"' + username + '\"' + ',\"password\":' + '\"' + password + '\"' + '}')}"
        publish:
          - ssoToken: '${return_result}'
          - errorMessage: '${error_message}'
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - ssoToken: '${ssoToken}'
    - errorMessage: '${errorMessage}'
    - return_code: '${return_code}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      requestToken:
        x: 253
        'y': 112.203125
        navigate:
          a7cb7819-3b75-2eb9-2759-13ae68533de5:
            targetId: 58bf4cb4-f15e-3ce1-3aa8-7bc57df53e23
            port: SUCCESS
          24175e9c-248f-1a12-5b57-58d7b1257b0f:
            targetId: 594ee8ed-577c-be69-8e74-1daf06da3a07
            port: FAILURE
    results:
      FAILURE:
        594ee8ed-577c-be69-8e74-1daf06da3a07:
          x: 250
          'y': 267
      SUCCESS:
        58bf4cb4-f15e-3ce1-3aa8-7bc57df53e23:
          x: 443
          'y': 114
