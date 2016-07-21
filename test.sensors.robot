*** Settings ***
Documentation          This example demonstrates executing commands on a remote machine
...                    and getting their output and the return code.
...
...                    Notice how connections are handled as part of the suite setup and
...                    teardown. This saves some time when executing several test cases.

Resource        ../lib/rest_client.robot
Library                SSHLibrary
Library         ../data/model.py

Suite Setup            Open Connection And Log In
Suite Teardown         Close All Connections


*** Variables ***
${model} =    ${OPENBMC_MODEL}

*** Test Cases ***
Execute Set Sensor boot count
    ${uri} =    Set Variable    /org/openbmc/sensors/host/BootCount
    ${COUNT}=   Set Variable    ${3}
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setValue      data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=     Read Attribute      ${uri}   value
    Should Be Equal     ${content}      ${COUNT}


Set Sensor Boot progressSivas
    ${uri} =    Set Variable    /org/openbmc/sensors/host/BootProgress
    ${COUNT}=   Set Variable     FW Progress, Baseboard Init
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setValue     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}   value
    Should Be Equal   ${content}     FW Progress, Baseboard Init


Set Sensor Boot progress Longest stringSivas
    ${uri} =    Set Variable    /org/openbmc/sensors/host/BootProgress
    ${COUNT}=   Set Variable    FW Progress, Docking station attachment
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setValue     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}   value
    Should Be Equal   ${content}     FW Progress, Docking station attachment


Bootprogress Sensor FW Hang Unspecified ErrorSivas
    ${uri} =    Set Variable    /org/openbmc/sensors/host/BootProgress
    ${COUNT}=   Set Variable     FW Hang, Unspecified
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setValue     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}   value
    Should Be Equal   ${content}     FW Hang, Unspecified


Bootprogress FW Hang stateSivas
    ${uri} =    Set Variable    /org/openbmc/sensors/host/BootProgress
    ${COUNT}=   Set Variable    POST Error, unknown
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setValue    data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}   value
    Should Be Equal   ${content}    POST Error, unknown

OperatingSystemStatus Sensor boot completed progressSivas
    ${uri} =    Set Variable    /org/openbmc/sensors/host/OperatingSystemStatus
    ${COUNT}=   Set Variable    Boot completed (00)
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setValue     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}   value
    Should Be Equal   ${content}    Boot completed (00)

OperatingSystemStatus Sensor progressSivas
    ${uri} =    Set Variable    /org/openbmc/sensors/host/OperatingSystemStatus
    ${COUNT}=   Set Variable    PXE boot completed
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setValue     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}   value
    Should Be Equal   ${content}    PXE boot completed



OCC Active Sensor on disabledSivas
    ${uri} =    Set Variable    /org/openbmc/sensors/host/cpu0/OccStatus
    ${COUNT}=   Set Variable    Disabled
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setValue    data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}   value
    Should Be Equal   ${content}    Disabled


CPU PresentSivas
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/cpu0
    ${COUNT}=   Set Variable    True
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setPresent   data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  present
    Should Be Equal   ${content}    True


CPU not PresentSivas
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/cpu0
    ${COUNT}=   Set Variable    False
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setPresent    data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  present
    Should Be Equal   ${content}    False


CPU faultSivas
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/cpu0
    ${COUNT}=   Set Variable    True
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/actioni/setFault     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  fault
    Should Be Equal   ${content}    True


core PresentSivas
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/cpu0/core11
    ${COUNT}=   Set Variable    True
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setPresent    data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  present
    Should Be Equal   ${content}    True


core not PresentSivas
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/cpu0/core11
    ${COUNT}=   Set Variable     False
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setPresent     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  present
    Should Be Equal   ${content}   False

core faultSivas
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/cpu0/core11
    ${COUNT}=   Set Variable    True
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setfault   data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  fault
    Should Be Equal   ${content}   True

core no faultSivas
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/cpu0/core11
    ${COUNT}=   Set Variable    False
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setfault     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  fault
    Should Be Equal   ${content}    False


DIMM3 PresentSivas
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/dimm3
    ${COUNT}=   Set Variable    True
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setPresent     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  present
    Should Be Equal   ${content}    True


DIMM3 not PresentSivas
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/dimm3
    ${COUNT}=   Set Variable    False
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setPresent     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  present
    Should Be Equal   ${content}    False


DIMM0 faultSivas
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/dimm0
    ${COUNT}=   Set Variable    True
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setFault    data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  fault
    Should Be Equal   ${content}    True


DIMM0 no faultSivas
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/dimm0
    ${COUNT}=   Set Variable    False
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setFault      data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  fault
    Should Be Equal   ${content}    False


Centaur0 PresentSivas
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/membuf0
    ${COUNT}=   Set Variable    True
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setPresent     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  present
    Should Be Equal   ${content}    True

Centaur0 not PresentSivas
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/membuf0
    ${COUNT}=   Set Variable    False
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setPresent     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  present
    Should Be Equal   ${content}    False


Centaur0 faultSivas
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/membuf0
    ${COUNT}=   Set Variable    True
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setFault     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  fault
    Should Be Equal   ${content}    True

Centaur0 no faultSivas
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/membuf0
    ${COUNT}=   Set Variable    False
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setFault    data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  fault
    Should Be Equal   ${content}    False


System Present
    Read The Attribute   /org/openbmc/inventory/system    present
    Response Should Be Equal    True

System Fault
    Read The Attribute   /org/openbmc/inventory/system    fault
    Response Should Be Equal    False

Chassis Present
    Read The Attribute   /org/openbmc/inventory/system/chassis    present
    Response Should Be Equal    True

Chassis Fault
    Read The Attribute   /org/openbmc/inventory/system/chassis    fault
    Response Should Be Equal    False

io_board Present
    Read The Attribute   /org/openbmc/inventory/system/chassis/io_board    present
    Response Should Be Equal    True

io_board Fault
    Read The Attribute   /org/openbmc/inventory/system/chassis/io_board    fault
    Response Should Be Equal    False


OCC Active Sensor on enabledSivas
    ${uri} =    Set Variable    /org/openbmc/sensors/host/cpu0/OccStatus
    ${COUNT}=   Set Variable     Enabled
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc get request    ${uri}
    ${resp} =   openbmc post request    ${uri}/action/setValue    data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}   value
    Should Be Equal   ${content}    Enabled

*** Keywords ***
Open Connection And Log In
    Open connection     ${OPENBMC_HOST}
    Login   ${OPENBMC_USERNAME}    ${OPENBMC_PASSWORD}

response Should Be Equal
    [arguments]    ${args}
    Should Be Equal    ${OUTPUT}    ${args}

Response Should Be Empty
    Should Be Empty    ${OUTPUT}

Read the Attribute
    [arguments]    ${uri}    ${parm}
    ${output} =     Read Attribute      ${uri}    ${parm}
    set test variable    ${OUTPUT}     ${output}

Get Sensor Number
    [arguments]  ${name}
    ${x} =       get sensor   ${OPENBMC_MODEL}   ${name}
    [return]     ${x}

Get Inventory Sensor Number
    [arguments]  ${name}
    ${x} =       get inventory sensor   ${OPENBMC_MODEL}   ${name}
    [return]     ${x}
