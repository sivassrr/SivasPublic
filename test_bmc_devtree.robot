*** Settings ***
Documentation       This suite is for Verifying BMC device tree

Resource            ../lib/rest_client.robot
Resource            ../lib/openbmc_ffdc.robot
Resource            ../lib/ipmi_client.robot
Library             String

Suite Setup         Open Connection And Log In
Suite Teardown      Close All Connections
Test Teardown       FFDC On Test Case Fail
Test Template       Template Check Property

*** Variables ***
${devicetree_base}  /sys/firmware/devicetree/base/
${bmc_model}        witherspoon

*** Test Cases ***
[TC-001]-Check BMC Model Property  Is Set   model
[TC-002]-Check BMC Name Property Is Set  name
[TC-003]-Check BMC Compatible Property Is Set  compatible
[TC-004]-Check BMC CPU Name Property Is Set  cpus/name
[TC-005]-Check BMC CPU Compatible Property Is Set  cpus/cpu@0/compatible
[TC-006]-Check BMC Memory Name Property Is Set  memory/name



*** Keywords ***

Template Check Property
[Arguments]   ${property}
    ${devicetree_path}=  Catenate  SEPARATOR=
    ...  ${devicetree_base}  ${property}
    ${output}   ${stderr}=  Execute Command  cat ${devicetree_path}
    ...  return_stderr=True
    Should Be Empty  ${stderr}
    Verify Property Length  ${output}
