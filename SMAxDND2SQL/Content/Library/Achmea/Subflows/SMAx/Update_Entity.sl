########################################################################################################################
#!!
#! @description: This flow will update an useroption in a SMAx entity
#!               Step 1 - Checks for an available SSO token.
#!               Step 2 - set properties for the body of the API request
#!               Step 3 - Updates the useroption with the given properties (key:value pairs)
#!               Inputs:
#!               entityId: Given ID of the entity that needs to be transitioned to a next phase
#!               Example: 123456
#!               entityType: Kind of entity
#!               Example: Request
#!               entityProperties: key value pairs formatted for JSON
#!               Example: "Description":"This is a piece of text"
#!               sMAxUrl: Url for SMAx
#!               Example: https://sma.preview.hosting.corp
#!               tenantID: SMAx Tenant ID
#!               Example: '781313141'
#!               Outputs:
#!               resultUpdateEntity:  result of entity update
#!               errorMessage:	An error message containing an exception.
#!               Responses:
#!               success - the operation succeeded.
#!               failure - failure, to be handled by the calling flow
#!!#
########################################################################################################################
namespace: Achmea.Subflows.SMAx
flow:
  name: Update_Entity
  inputs:
    - entityType
    - entityId
    - entityProperties
    - smaUrl: '${smaUrl}'
    - smaTennant: '${smaTennant}'
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
          - SUCCESS: setProperties
    - setProperties:
        do:
          io.cloudslang.base.utils.do_nothing:
            - setJson: "${'{\"entity_type\":\"' + entityType + '\",\"properties\": {\"Id\": \"' + entityId + '\",' + entityProperties + '}}'}"
        publish:
          - inputJson: '${setJson}'
        navigate:
          - SUCCESS: UpdateIdentity
          - FAILURE: FAILURE
    - UpdateIdentity:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${smaUrl + '/rest/' + smaTennant + '/ems/bulk'}"
            - trust_all_roots: 'true'
            - headers: '${("COOKIE:LWSSO_COOKIE_KEY=" + smaToken + ";TENANTID=" + smaTennant)}'
            - body: "${'{\"entities\": [' + inputJson + '], \"operation\": \"UPDATE\"}'}"
            - content_type: application/json
        publish:
          - updateResult: '${return_result}'
          - errorMessage: '${error_message}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - resultUpdateEntity: '${updateResult}'
    - errorMessage: '${errorMessage}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      SMA_Token:
        x: 199
        'y': 203
        navigate:
          4ebf73ff-024d-eb4b-7efa-8b2f6e1e063e:
            targetId: e0803ddd-d245-8bab-1e1c-c779554eb312
            port: FAILURE
      setProperties:
        x: 400
        'y': 200
        navigate:
          79d4c0f5-e70d-d395-3751-1ef26a4aa3b2:
            targetId: e0803ddd-d245-8bab-1e1c-c779554eb312
            port: FAILURE
      UpdateIdentity:
        x: 583
        'y': 204
        navigate:
          288fa194-e089-b487-9e37-4bfe5de9b0c7:
            targetId: 83222fff-4f7f-0126-b24a-f1ea9b3414b7
            port: SUCCESS
          d40f7340-4cbe-6e63-6d79-83f7e1db52ce:
            targetId: e0803ddd-d245-8bab-1e1c-c779554eb312
            port: FAILURE
    results:
      FAILURE:
        e0803ddd-d245-8bab-1e1c-c779554eb312:
          x: 377
          'y': 383
      SUCCESS:
        83222fff-4f7f-0126-b24a-f1ea9b3414b7:
          x: 784
          'y': 198
