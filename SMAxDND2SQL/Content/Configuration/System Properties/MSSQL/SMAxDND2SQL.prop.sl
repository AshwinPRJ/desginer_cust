########################################################################################################################
#!!
#! @system_property SQL_DataFileSize: The DataFile size for the new database
#! @system_property SQL_IndexFileSize: The IndexFile size for the new database
#! @system_property SQL_Instance_Port: The portnumber for the database instance
#! @system_property SQL_LogFileSize: The LogFile size for the new database
#!!#
########################################################################################################################
namespace: MSSQL
properties:
  - SQL_DataFileSize:
      value: '50'
      sensitive: false
  - SQL_IndexFileSize:
      value: '50'
      sensitive: false
  - SQL_Instance_Port:
      value: '44400'
      sensitive: false
  - SQL_LogFileSize:
      value: '25'
      sensitive: false
  - SQL_Management_Database: dbsmonitordatabases
  - SQL_Management_Host: AISRV64820
  - SQL_Management_Instance: LIMA_DBA_TST
  - SQL_DBS_User: usr_OO_auto
  - SQL_Password:
      value: 89x2XWjwt3cEXDuDKup8
      sensitive: true
