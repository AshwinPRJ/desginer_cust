########################################################################################################################
#!!
#! @description: Flow for returning error messages to R2F in case a flow results in an error.
#!
#! @input errorMessage: Enter Error Message:
#! @input runId: Enter Run Id failed flow:
#! @input smtpHostname: Enter the hostname of the relaying SMTP server:
#! @input smtpPort: Enter the port number for SMTP on the listening server:
#! @input smtpSender: Enter the sending mail address:
#! @input ooMailNotification: Enter the receiving mail address :
#!!#
########################################################################################################################
namespace: Achmea.Shared.subFlows.Generic
flow:
  name: sendMailR2F
  inputs:
    - errorMessage:
        prompt:
          type: text
    - runId:
        prompt:
          type: text
    - smtpHostname:
        prompt:
          type: text
    - smtpPort:
        prompt:
          type: text
    - smtpSender:
        prompt:
          type: text
    - ooMailNotification:
        prompt:
          type: text
  workflow:
    - Get_Run_Id:
        do:
          io.cloudslang.base.utils.do_nothing:
            - GetId: '${run_id}'
        publish:
          - runId: '${GetId}'
        navigate:
          - SUCCESS: send_mail
          - FAILURE: FAILURE
    - send_mail:
        do:
          io.cloudslang.base.mail.send_mail:
            - hostname: '${smtpHostname}'
            - port: '${smtpPort}'
            - from: '${smtpSender}'
            - to: '${ooMailNotification}'
            - subject: OO flow execution failure
            - body: "${'Flow with run Id ' + runId + ' did not excecute correctly. The errormessage is: ' + errorMessage}"
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
      Get_Run_Id:
        x: 78
        'y': 206
        navigate:
          8fd4c71a-b50e-28a6-b089-4c009f4db6af:
            targetId: 48734142-780b-51fc-304d-c80150148fe4
            port: FAILURE
      send_mail:
        x: 259
        'y': 205
        navigate:
          65ab8a4b-0963-f8fc-de6d-cc035c49ca43:
            targetId: 48734142-780b-51fc-304d-c80150148fe4
            port: FAILURE
          b8bed16a-f1cf-d0cb-399d-52a9d439234d:
            targetId: ae416ff3-c392-1dbf-f585-fdf43959b36d
            port: SUCCESS
    results:
      FAILURE:
        48734142-780b-51fc-304d-c80150148fe4:
          x: 176
          'y': 422
      SUCCESS:
        ae416ff3-c392-1dbf-f585-fdf43959b36d:
          x: 457
          'y': 202
