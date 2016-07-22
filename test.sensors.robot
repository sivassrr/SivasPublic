*** Settings ***
Documentation          This example demonstrates executing commands on a remote machine
...                    and getting their output and the return code.
...
...                    Notice how connections are handled as part of the suite setup and
...                    teardown. This saves some time when executing several test cases.

Resource        ../lib/rest_client.robot
Library         SSHLibrary
Library         ../data/model.py
Library 	OperatingSystem

Suite Setup            Open Connection And Log In
Suite Teardown         Close All Connections


*** Variables ***
${model} =    ${OPENBMC_MODEL}

*** Test Cases ***
Execute Set Sensor boot count
    ${uri} =    Set Variable    /org/openbmc/sensors/host/BootCount
    ${valuetoset}=   Set Variable    ${3}
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setValue      data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=     Read Attribute      ${uri}   value
    Should Be Equal     ${content}      ${valuetoset}

Set Sensor Boot progress
    ${uri} =    Set Variable    /org/openbmc/sensors/host/BootProgress
    ${valuetoset}=   Set Variable     FW Progress, Baseboard Init
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setValue     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}   value
    Should Be Equal   ${content}     ${valuetoset}

Set Sensor Boot progress Longest string
    ${uri} =    Set Variable    /org/openbmc/sensors/host/BootProgress
    ${valuetoset}=   Set Variable    FW Progress, Docking station attachment
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setValue     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}   value
    Should Be Equal   ${content}     ${valuetoset}

Bootprogress Sensor FW Hang Unspecified Error
    ${uri} =    Set Variable    /org/openbmc/sensors/host/BootProgress
    ${valuetoset}=   Set Variable     FW Hang, Unspecified
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setValue     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}   value
    Should Be Equal   ${content}     ${valuetoset}


Bootprogress FW Hang state
    ${uri} =    Set Variable    /org/openbmc/sensors/host/BootProgress
    ${valuetoset}=   Set Variable    POST Error, unknown
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setValue    data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}   value
    Should Be Equal   ${content}     ${valuetoset}

OperatingSystemStatus Sensor boot completed progress
    ${uri} =    Set Variable    /org/openbmc/sensors/host/OperatingSystemStatus
    ${valuetoset}=   Set Variable    Boot completed (00)
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setValue     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}   value
    Should Be Equal   ${content}     ${valuetoset}

OperatingSystemStatus Sensor progress
    ${uri} =    Set Variable    /org/openbmc/sensors/host/OperatingSystemStatus
    ${valuetoset}=   Set Variable    PXE boot completed
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setValue     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}   value
    Should Be Equal   ${content}     ${valuetoset}

OCC Active Sensor on disabled
    ${uri} =    Set Variable    /org/openbmc/sensors/host/cpu0/OccStatus
    ${valuetoset}=   Set Variable    Disabled
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setValue    data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}   value
    Should Be Equal   ${content}     ${valuetoset}


CPU Present
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/cpu0
    ${valuetoset}=   Set Variable    True
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setPresent   data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  present
    Should Be Equal   ${content}     ${valuetoset}


CPU not Present
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/cpu0
    ${valuetoset}=   Set Variable    False
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setPresent    data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  present
    Should Be Equal   ${content}     ${valuetoset}


CPU fault
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/cpu0
    ${valuetoset}=   Set Variable    True
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/actioni/setFault     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  fault
    Should Be Equal   ${content}     ${valuetoset}


core Present
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/cpu0/core11
    ${valuetoset}=   Set Variable    True
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setPresent    data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  present
    Should Be Equal   ${content}     ${valuetoset}


core not Present
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/cpu0/core11
    ${valuetoset}=   Set Variable     False
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setPresent     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  present
    Should Be Equal   ${content}     ${valuetoset}

core fault
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/cpu0/core11
    ${valuetoset}=   Set Variable    True
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setfault   data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  fault
    Should Be Equal   ${content}     ${valuetoset}

core no fault
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/cpu0/core11
    ${valuetoset}=   Set Variable    False
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setfault     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  fault
    Should Be Equal   ${content}     ${valuetoset}


DIMM3 Present
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/dimm3
    ${valuetoset}=   Set Variable    True
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setPresent     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  present
    Should Be Equal   ${content}     ${valuetoset}


DIMM3 not Present
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/dimm3
    ${valuetoset}=   Set Variable    False
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setPresent     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  present
    Should Be Equal   ${content}     ${valuetoset}


DIMM0 fault
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/dimm0
    ${valuetoset}=   Set Variable    True
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setFault    data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  fault
    Should Be Equal   ${content}     ${valuetoset}


DIMM0 no fault
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/dimm0
    ${valuetoset}=   Set Variable    False
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setFault      data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  fault
    Should Be Equal   ${content}     ${valuetoset}


Centaur0 Present
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/membuf0
    ${valuetoset}=   Set Variable    True
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setPresent     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  present
    Should Be Equal   ${content}     ${valuetoset}

Centaur0 not Present
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/membuf0
    ${valuetoset}=   Set Variable    False
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setPresent     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  present
    Should Be Equal   ${content}     ${valuetoset}


Centaur0 fault
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/membuf0
    ${valuetoset}=   Set Variable    True
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setFault     data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  fault
    Should Be Equal   ${content}     ${valuetoset}

Centaur0 no fault
    ${uri} =    Set Variable    /org/openbmc/inventory/system/chassis/motherboard/membuf0
    ${valuetoset}=   Set Variable    False
    @{count_list} =   Create List     ${valuetoset}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setFault    data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=    Read Attribute      ${uri}  fault
    Should Be Equal   ${content}     ${valuetoset}


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


OCC Active Sensor on enabled
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
    [return]     ${x
