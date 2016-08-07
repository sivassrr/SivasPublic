*** Settings ***
Documentation     This module is for SSH connection override to QEMU
...               based openbmc systems.

Library           SSHLibrary
Library           OperatingSystem

*** Variables ***

*** Keywords ***
Open Connection And Log In
    Run Keyword If   '${SSH_PORT}' != '${EMPTY}' and '${HTTPS_PORT}' != '${EMPTY}'
    ...   User input SSH and HTTPs Ports

    Run Keyword If  '${SSH_PORT}' == '${EMPTY}'    Open connection     ${OPENBMC_HOST}
    ...    ELSE  Run Keyword   Open connection     ${OPENBMC_HOST}    port=${SSH_PORT}

    Login   ${OPENBMC_USERNAME}    ${OPENBMC_PASSWORD}
    copy ipmi_comdexec.py

User input SSH and HTTPs Ports
    [Documentation]   Update the global SSH and HTTPs port variable for QEMU
    ${port_num}=    Convert To Integer    ${SSH_PORT}
    ${SSH_PORT}=    Replace Variables     ${port_num}

    ${https_num}=   Convert To Integer    ${HTTPS_PORT}
    Set Global Variable     ${AUTH_URI}    https://${OPENBMC_HOST}:${https_num}

Copy ipmi_comdexec.py
    OperatingSystem.File Should Exist   lib/ipmi_cmdexec.py      msg=The ipmi cmdexec program could not be found in the tools directory. It is not part of the automation code by default. You must manually copy or link the correct openbmc version of the tool in to the tools directory in order to run this test suite.

    Import Library      SCPLibrary      WITH NAME       scp
    scp.Open connection     ${OPENBMC_HOST}     username=${OPENBMC_USERNAME}      password=${OPENBMC_PASSWORD}
    scp.Put File    lib/ipmi_cmdexec.py   /tmp
    SSHLibrary.Open Connection     ${OPENBMC_HOST}
    Login   ${OPENBMC_USERNAME}    ${OPENBMC_PASSWORD}
    Execute Command     chmod +x /tmp/ipmi_cmdexec.py
