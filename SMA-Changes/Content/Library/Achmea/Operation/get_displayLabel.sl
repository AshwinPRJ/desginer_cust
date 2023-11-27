namespace: Achmea.Operation
operation:
  name: get_displayLabel
  inputs:
    - Proces
  python_action:
    use_jython: false
    script: "from datetime import date\r\n\r\ndef execute(Proces):\r\n        try:\r\n            strProces = Proces\r\n            today = date.today()\r\n            error_message = \"\"\r\n            return_code = '0'\r\n            displayLabel = \"Regressietest \" + strProces + \" \" + str(today)\r\n\r\n        except Exception as e:\r\n            error_message = str(e)\r\n            return_code = '-1'\r\n        return {\"return_result\": displayLabel, \"return_code\":return_code, \"error_message\":error_message}"
  outputs:
    - displayLabel: '${return_result}'
  results:
    - SUCCESS
