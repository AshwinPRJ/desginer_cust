########################################################################################################################
#!!
#! @description: Generic flow for sending e-mail through achmea smtp server
#!
#! @input recipients: if more than one mailaddress use ',' as a separator
#! @input carbonCopy: if more than one mailaddress use ',' as a separator
#! @input blindCarbonCopy: if more than one mailaddress use ',' as a separator
#!!#
########################################################################################################################
namespace: Achmea.Shared.Generic.Subflows
flow:
  name: SendMail
  inputs:
    - mailSubject
    - mailBody
    - recipients
    - carbonCopy:
        required: false
    - blindCarbonCopy:
        required: false
  workflow:
    - send_mail:
        do:
          io.cloudslang.base.mail.send_mail:
            - hostname: "${get_sp('MF.OO.SMTP_HOSTNAME')}"
            - port: "${get_sp('MF.OO.SMTP_PORT')}"
            - from: "${get_sp('MF.OO.SMTP_SENDER')}"
            - to: '${recipients}'
            - cc: '${carbonCopy}'
            - bcc: '${blindCarbonCopy}'
            - subject: '${mailSubject}'
            - body: '${mailBody}'
            - html_email: 'true'
        publish:
          - return_code
          - exception
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - return_code: '${return_code}'
    - exception: '${exception}'
    - return_result: '${return_result}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      send_mail:
        x: 345
        'y': 177
        navigate:
          b20277c8-1272-190e-6b1d-84066242dd92:
            targetId: ee8cdb67-5d48-40fb-30cf-04a9d5da512a
            port: FAILURE
          b55b945d-ab14-7969-6f8c-5001b2a3f62f:
            targetId: 7fa10e82-7a30-5cac-e6cb-fcea0356aab7
            port: SUCCESS
    results:
      FAILURE:
        ee8cdb67-5d48-40fb-30cf-04a9d5da512a:
          x: 344
          'y': 360
      SUCCESS:
        7fa10e82-7a30-5cac-e6cb-fcea0356aab7:
          x: 520
          'y': 177
