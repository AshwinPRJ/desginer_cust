namespace: Achmea.Shared.Operations
operation:
  name: isUserLdapGroupMember
  inputs:
    - LDAP_Server
    - LDAP_Base
    - GroupName
    - UserDN
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      import ldapSession

      def execute(LDAP_Server,LDAP_Base,GroupName,UserDN):
          ldapSession = ldap..initialize(LDAP_Server)
  results:
    - SUCCESS
