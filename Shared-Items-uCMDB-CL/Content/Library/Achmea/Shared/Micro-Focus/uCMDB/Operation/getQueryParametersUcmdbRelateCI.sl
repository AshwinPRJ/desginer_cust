namespace: Achmea.Shared.Micro-Focus.uCMDB.Operation
operation:
  name: getQueryParametersUcmdbRelateCI
  inputs:
    - force_temporary_id
    - ignore_existing
    - is_global
    - update_if_exact_match
    - is_global_id
    - with_icons
    - include_attributes_qualifiers
    - export_format
  python_action:
    use_jython: false
    script: "def execute(force_temporary_id, ignore_existing, is_global, update_if_exact_match, is_global_id, with_icons, include_attributes_qualifiers, export_format):\r\n    query_params = \"\"\r\n    return_code = 0\r\n    error_message = \"\"\r\n    \r\n    try:\r\n        if force_temporary_id:\r\n            query_params = \"forceTemporaryId=\" + force_temporary_id\r\n        \r\n        if ignore_existing and query_params:\r\n            query_params = query_params + \"&ignoreExisting=\" + ignore_existing\r\n        elif ignore_existing and not query_params:\r\n            query_params = \"ignoreExisting=\" + ignore_existing\r\n    \r\n        if is_global and query_params:\r\n            query_params = query_params + \"&isGlobal=\" + is_global\r\n        elif is_global and not query_params:\r\n            query_params = \"isGlobal=\" + is_global\r\n    \r\n        if is_global_id and query_params:\r\n            query_params = query_params + \"&isGlobalId=\" + is_global_id\r\n        elif is_global_id and not query_params:\r\n            query_params = \"isGlobalId=\" + is_global_id\r\n        \r\n        if update_if_exact_match and query_params:\r\n            query_params = query_params + \"&updateIfExactMatch=\" + update_if_exact_match\r\n        elif update_if_exact_match and not query_params:\r\n            query_params = \"updateIfExactMatch=\" + update_if_exact_match\r\n        \r\n        if with_icons and query_params:\r\n            query_params = query_params + \"&withIcons=\" + with_icons\r\n        elif with_icons and not query_params:\r\n            query_params = \"withIcons=\" + with_icons\r\n        \r\n        if include_attributes_qualifiers and query_params:\r\n            query_params = query_params + \"&includeAttributesQualifiers=\" + include_attributes_qualifiers\r\n        elif include_attributes_qualifiers and not query_params:\r\n            query_params = \"includeAttributesQualifiers=\" + include_attributes_qualifiers\r\n        \r\n        if export_format and query_params:\r\n            query_params = query_params + \"&exportFormat=\" + export_format\r\n        elif export_format and not query_params:\r\n            query_params = \"exportFormat=\" + export_format\r\n    except Exception as e:\r\n        return_code = 1\r\n        error_message = str(e)\r\n        \r\n    return {\"query_params\": query_params, \"return_code\":return_code, \"error_message\":error_message}"
  outputs:
    - query_params
    - return_code
    - error_message
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
