*** Settings ***
Documentation   This module is for IPMI client for copying ipmitool to
...             openbmc box and execute ipmitool commands.

Resource        ../lib/resource.txt
Resource        ../lib/connection_client.robot
Library         String
Library                SSHLibrary
Library                OperatingSystem
Library                Process

*** Variables ***
${dbushostipmicmd1} =   dbus-send --system --type=signal --dest=org.openbmc.HostIpmi
${dbushostipmicmd2} =   /org/openbmc/HostIpmi/1 org.openbmc.HostIpmi.ReceivedMessage
${netfnByte}
${cmdByte}
${arraybyte} =       array:byte:

*** Keywords ***
Run IPMI Command
    [arguments]    ${args}
    Log to Console  \n ${args}
#    Below 3 statements are for dbus-way for hostIpmi interface
#    ${valueinbytes} = Byte Conversion ${args}
#    ${output}   ${stderr}=  Execute Command  ${dbushostipmicmd1} ${dbushostipmicmd2} ${valueinbytes}  return_stderr=True
#    Should Be Empty     ${stderr}
    ${output}   ${stderr}=  Execute Command  echo ${args} > /tmp/ipmirawcmd.txt  return_stderr=True
    ${output}   ${stderr}=  Start Command  /tmp/ipmi_cmdexec.py < /tmp/ipmirawcmd.txt
    Sleep  7s
    set test variable    ${OUTPUT}     "${output}"

Run IPMI Standard Command
    [arguments]    ${args}
#    Copy ipmitool
    ${valueinbytes} =   Byte Conversion  ${args}
    Log to Console  \n ${dbushostipmicmd1}
    Log to Console  \n ${dbushostipmicmd2}
    Log to Console  \n ${valueinbytes}
    ${stdout}    ${stderr}    ${output}=  Execute Command   /tmp/ipmi_cmdexec.py ${args}  return_stdout=True    return_stderr= True    return_rc=True
    Should Be Equal    ${output}    ${0}    msg=${stderr}
    [return]    ${stdout}

Byte Conversion
    [arguments]     ${args1}
    ${length} =   Get Length  ${args1}
    Log to Console  \n Lenth is ${length}
    ${arraybyte1}    Set Variable   array:byte:
    Set Global Variable  ${arraybyte}   ${arraybyte1}
    @{args2} =   Split String  ${args1}  ${SPACE}  12
    ${index} =   Set Variable   ${0}
    :FOR   ${word}   in   @{args2}
    \    Run Keyword if   ${index} == 0   Set NetFn Byte  ${word}
    \    Run Keyword if   ${index} == 1   Set Cmd Byte   ${word}
    \    Run Keyword if   ${index} > 1     Set Array Byte   ${word}
    \    ${index} =    Set Variable    ${index + 1}
     Log to Console   \n Arraybte:
    ${length} =   Get Length  ${arraybyte}
    ${length} =   Evaluate  ${length} - 1
    ${arraybyte1} =  Get Substring  ${arraybyte}  0   ${length}
    Set Global Variable  ${arraybyte}   ${arraybyte1}
    ${valueinbytes1} =   Catenate  byte:0x00   ${netfnByte}  byte:0x00  ${cmdByte}  ${arraybyte}
    log to Console   ${valueinbytes1}
    [return]    ${valueinbytes1}

Set NetFn Byte
   [arguments]    ${word}
   ${netfnByte1} =  Catenate   byte:${word}
   Set Global Variable  ${netfnByte}  ${netfnByte1}

Set Cmd Byte
   [arguments]    ${word}
   ${cmdByte1} =  Catenate   byte:${word}
   Set Global Variable  ${cmdByte}  ${cmdByte1}

Set Array Byte
   [arguments]    ${word}
   ${arraybyte1} =   Catenate   SEPARATOR=  ${arraybyte}  ${word}
   ${arraybyte1} =   Catenate   SEPARATOR=  ${arraybyte1}   ,
   Set Global Variable  ${arraybyte}   ${arraybyte1}
