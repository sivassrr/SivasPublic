*** Settings ***
Documentation      This suite is for testing Fullsuite (Rest API Stability is the focus). Copy the log.html and output.xml. Down the line we can merge output as well

Library           String
Library           OperatingSystem
Library           SSHLibrary

Suite Teardown    Close All Connections

*** Variables *** 
${t_HOSTBMC_LOGIN}        root
${t_HOSTBMC_PASSWD}       0penBmc
${SYSTEMTYPE}          

*** Test Cases ***
Run Tests Multiple Time

   ${SYSTEMTYPE}=   Open Connection And Log In
   : FOR    ${INDEX}    IN RANGE    0    ${ITERATION} 
    \    Log To Console     \n Iteration:   no_newline=True
    \    Log To Console    ${INDEX}
    \    Run  OPENBMC_HOST=${OPENBMC_HOST} tox -e ${SYSTEMTYPE} -- tests
    \    Copy File    output.xml   ./output${INDEX}.xml
    \    Copy File    log.html   ./log${INDEX}.html


*** Keywords ***
Open Connection And Log In
    [Documentation]   Returns  the system type 

    Open connection    ${OPENBMC_HOST}
    Login   ${t_HOSTBMC_LOGIN}   ${t_HOSTBMC_PASSWD}
    ${output}  ${stderr}=   Execute Command  hostname   return_stderr=True
    Should Be Empty     ${stderr}
    set test variable   ${t_SYSTEMTYPE}     ${output}
    Log to Console   \n ${t_SYSTEMTYPE}
    [return]   ${t_SYSTEMTYPE}
