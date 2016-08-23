*** Settings ***

Documentation   This testsuite is for testing the Boot Device Functions

Resource        ../lib/rest_client.robot
Resource        ../lib/ipmi_client.robot

Suite Setup     Open Connection And Log In
Suite Teardown  Close All Connections
*** Variables ***
${dbuscmd} =    dbus-send --system --print-reply --dest=org.openbmc.settings.Host   /org/openbmc/settings/host0  org.freedesktop.DBus.Properties.Get string:"org.openbmc.settings.Host" string:"boot_flags"




*** Test Cases ***

Set the Boot Device as Default using REST API
   [Documentation]   This testcase is to set the boot device as Default using REST
   ...               URI. The Boot device is read using REST API and ipmitool.

    ${bootDevice} =   Set Variable   Default
    ${valueDict} =   create dictionary   data=${bootDevice}
    Write Attribute    /org/openbmc/settings/host0   boot_flags   data=${valueDict}
    Read the Attribute  /org/openbmc/settings/host0    boot_flags
    Response Should Be Equal   Default
    ${output} =    Run IPMI command  0x00 0x09 0x05 0x00 0x00
#    ${output} =    Run IPMI Standard command   chassis bootparam get 5
    ${output}   ${stderr}=  Execute Command  ${dbuscmd}  return_stderr=True
    Should Be Empty     ${stderr}
    Log to Console   \n ${output}
    Should Contain   ${output}   Default

Set the Boot Device as Default using ipmitool
   [Documentation]   This testcase is to set the boot device as Default using
   ...               ipmitool. The Boot device is read using REST API and
   ...               ipmitool.

    Run IPMI command   0x0 0x8 0x05 0x80 0x00 0x00 0x00 0x00
    Read the Attribute   /org/openbmc/settings/host0   boot_flags
    Response Should Be Equal   Default
#    ${output} =   Run IPMI Standard command   chassis bootparam get 5
    ${output} =    Run IPMI command  0x00 0x09 0x05 0x00 0x00
    ${output}   ${stderr}=  Execute Command  ${dbuscmd}  return_stderr=True
    Should Be Empty     ${stderr}
    Log to Console   \n ${output}
    Should Contain   ${output}   Default

Set the Boot Device as Network using REST API
   [Documentation]   This testcase is to set the boot device as Network using REST
   ...               URI. The Boot device is read using REST API and ipmitool.

    ${bootDevice} =   Set Variable   Network
    ${valueDict} =   create dictionary   data=${bootDevice}
    Write Attribute    /org/openbmc/settings/host0   boot_flags   data=${valueDict}
    Read the Attribute  /org/openbmc/settings/host0    boot_flags
    Response Should Be Equal   Network
#    ${output} =    Run IPMI Standard command   chassis bootparam get 5
    ${output} =    Run IPMI command  0x00 0x09 0x05 0x00 0x00
    ${output}   ${stderr}=  Execute Command  ${dbuscmd}   return_stderr=True
    Log to Console   \n ${output}
    Should Be Empty     ${stderr}
    Should Contain   ${output}    Network

Set the Boot Device as Network using ipmitool
   [Documentation]   This testcase is to set the boot device as Network using
   ...               ipmitool. The Boot device is read using REST API and
   ...               ipmitool.

    Run IPMI command   0x0 0x8 0x05 0x80 0x04 0x00 0x00 0x00
    Read the Attribute   /org/openbmc/settings/host0   boot_flags
    Response Should Be Equal   Network
#    ${output} =   Run IPMI Standard command   chassis bootparam get 5
    ${output}   ${stderr}=  Execute Command  ${dbuscmd}  return_stderr=True
    Log to Console   \n ${output}
    Should Be Empty     ${stderr}
    Should Contain   ${output}    Network

Set the Boot Device as Disk using REST API
   [Documentation]   This testcase is to set the boot device as Disk using REST
   ...               URI. The Boot device is read using REST API and ipmitool.

    ${bootDevice} =   Set Variable   Disk
    ${valueDict} =   create dictionary   data=${bootDevice}
    Write Attribute    /org/openbmc/settings/host0   boot_flags   data=${valueDict}
    Read the Attribute  /org/openbmc/settings/host0    boot_flags
    Response Should Be Equal   Disk
#    ${output} =    Run IPMI Standard command   chassis bootparam get 5
    ${output} =    Run IPMI command  0x00 0x09 0x05 0x00 0x00
    ${output}   ${stderr}=  Execute Command  ${dbuscmd}  return_stderr=True
    Log to Console   \n ${output}
    Should Be Empty     ${stderr}
    Should Contain   ${output}    Disk

Set the Boot Device as Disk using ipmitool
   [Documentation]   This testcase is to set the boot device as Disk using
   ...               ipmitool. The Boot device is read using REST API and
   ...               ipmitool.

    Run IPMI command   0x0 0x8 0x05 0x80 0x08 0x00 0x00 0x00
    Read the Attribute   /org/openbmc/settings/host0   boot_flags
    Response Should Be Equal   Disk
#    ${output} =   Run IPMI Standard command   chassis bootparam get 5
    ${output} =    Run IPMI command  0x00 0x09 0x05 0x00 0x00
    ${output}   ${stderr}=  Execute Command  ${dbuscmd}  return_stderr=True
    Log to Console   \n ${output}
    Should Be Empty     ${stderr}
    Should Contain   ${output}    Disk

Set the Boot Device as Safe using REST API
   [Documentation]   This testcase is to set the boot device as Safe using REST
   ...               URI. The Boot device is read using REST API and ipmitool.

    ${bootDevice} =   Set Variable   Safe
    ${valueDict} =   create dictionary   data=${bootDevice}
    Write Attribute    /org/openbmc/settings/host0   boot_flags   data=${valueDict}
    Read the Attribute  /org/openbmc/settings/host0    boot_flags
    Response Should Be Equal   Safe
#    ${output} =    Run IPMI Standard command   chassis bootparam get 5
    ${output} =    Run IPMI command  0x00 0x09 0x05 0x00 0x00
    ${output}   ${stderr}=  Execute Command  ${dbuscmd}  return_stderr=True
    Log to Console   \n ${output}
    Should Be Empty     ${stderr}
    Should Contain   ${output}   Safe

Set the Boot Device as Safe using ipmitool
   [Documentation]   This testcase is to set the boot device as Safe using
   ...               ipmitool. The Boot device is read using REST API and
   ...               ipmitool.

    Run IPMI command   0x0 0x8 0x05 0x80 0x0C 0x00 0x00 0x00
    Read the Attribute   /org/openbmc/settings/host0   boot_flags
    Response Should Be Equal   Safe
#    ${output} =   Run IPMI Standard command   chassis bootparam get 5
    ${output} =    Run IPMI command  0x00 0x09 0x05 0x00 0x00
    ${output}   ${stderr}=  Execute Command  ${dbuscmd}   return_stderr=True
    Log to Console   \n ${output}
    Should Be Empty     ${stderr}
    Should Contain   ${output}   Safe

Set the Boot Device as CDROM using REST API
   [Documentation]   This testcase is to set the boot device as CDROM using REST
   ...               URI. The Boot device is read using REST API and ipmitool.

    ${bootDevice} =   Set Variable   CDROM
    ${valueDict} =   create dictionary   data=${bootDevice}
    Write Attribute    /org/openbmc/settings/host0   boot_flags   data=${valueDict}
    Read the Attribute  /org/openbmc/settings/host0    boot_flags
    Response Should Be Equal   CDROM
#    ${output} =    Run IPMI Standard command   chassis bootparam get 5
    ${output} =    Run IPMI command  0x00 0x09 0x05 0x00 0x00
    ${output}   ${stderr}=  Execute Command  ${dbuscmd}  return_stderr=True
    Log to Console   \n ${output}
    Should Be Empty     ${stderr}
    Should Contain   ${output}   CDROM

Set the Boot Device as CDROM using ipmitool
   [Documentation]   This testcase is to set the boot device as CDROM using
   ...               ipmitool. The Boot device is read using REST API and
   ...               ipmitool.

    Run IPMI command   0x0 0x8 0x05 0x80 0x14 0x00 0x00 0x00
    Read the Attribute   /org/openbmc/settings/host0   boot_flags
    Response Should Be Equal   CDROM
#    ${output} =   Run IPMI Standard command   chassis bootparam get 5
    ${output} =    Run IPMI command  0x00 0x09 0x05 0x00 0x00
    ${output}   ${stderr}=  Execute Command  ${dbuscmd}  return_stderr=True
    Log to Console   \n ${output}
    Should Be Empty     ${stderr}
    Should Contain   ${output}   CDROM

Set the Boot Device as Setup using REST API
   [Documentation]   This testcase is to set the boot device as Setup using REST
   ...               URI. The Boot device is read using REST API and ipmitool.

    ${bootDevice} =   Set Variable   Setup
    ${valueDict} =   create dictionary   data=${bootDevice}
    Write Attribute    /org/openbmc/settings/host0   boot_flags   data=${valueDict}
    Read the Attribute  /org/openbmc/settings/host0    boot_flags
    Response Should Be Equal   Setup
#    ${output} =    Run IPMI Standard command   chassis bootparam get 5
    ${output} =    Run IPMI command  0x00 0x09 0x05 0x00 0x00
    ${output}   ${stderr}=  Execute Command  ${dbuscmd}  return_stderr=True
    Log to Console   \n ${output}
    Should Be Empty     ${stderr}
    Should Contain   ${output}   Setup

Set the Boot Device as Setup using ipmitool
   [Documentation]   This testcase is to set the boot device as Setup using
   ...               ipmitool. The Boot device is read using REST API and
   ...               ipmitool.

    Run IPMI command   0x0 0x8 0x05 0x80 0x18 0x00 0x00 0x00
    Read the Attribute   /org/openbmc/settings/host0   boot_flags
    Response Should Be Equal   Setup
#    ${output} =   Run IPMI Standard command   chassis bootparam get 5
    ${output} =    Run IPMI command  0x00 0x09 0x05 0x00 0x00
    ${output}   ${stderr}=  Execute Command  ${dbuscmd}   return_stderr=True
    Log to Console   \n ${output}
    Should Be Empty     ${stderr}
    Should Contain   ${output}   Setup

*** Keywords ***

Response Should Be Equal
    [arguments]    ${args}
    Should Be Equal    ${OUTPUT}    ${args}

Read the Attribute
    [arguments]    ${uri}    ${parm}
    ${output} =     Read Attribute      ${uri}    ${parm}
    set test variable    ${OUTPUT}     ${output}
