# SivasPublic
python -m robot -v OPENBMC_HOST:9.3.23.32 -v ITERATION:2 FullSuiteRegression.robot 
==============================================================================
FullSuiteRegression :: This suite is for testing Fullsuite (Rest API Stabil...
==============================================================================
Run Tests Multiple Time                                               
barreleye
." 
Iteration:"0
" 
Iteration:"1
Run Tests Multiple Time                                               | PASS |
------------------------------------------------------------------------------
FullSuiteRegression :: This suite is for testing Fullsuite (Rest A... | PASS |
1 critical test, 1 passed, 0 failed
1 test total, 1 passed, 0 failed
==============================================================================
Output:  /gsa/ausgsa-h1/00/srsiva/openbmc/openbmc17Jun2016/openbmc-automation/output.xml
Log:     /gsa/ausgsa-h1/00/srsiva/openbmc/openbmc17Jun2016/openbmc-automation/log.html
Report:  /gsa/ausgsa-h1/00/srsiva/openbmc/openbmc17Jun2016/openbmc-automation/report.html
bash-4.1$ python -m robot -v OPENBMC_HOST:9.3.23.32 -v ITERATION:2 FullSuiteRegression.robot 
==============================================================================
FullSuiteRegression :: This suite is for testing Fullsuite (Rest API Stabil...
==============================================================================
Run Tests Multiple Time                                               
barreleye
.
Iteration:0

Iteration:1
Run Tests Multiple Time                                               | PASS |
------------------------------------------------------------------------------
FullSuiteRegression :: This suite is for testing Fullsuite (Rest A... | PASS |
1 critical test, 1 passed, 0 failed
1 test total, 1 passed, 0 failed
==============================================================================
Output:  /gsa/ausgsa-h1/00/srsiva/openbmc/openbmc17Jun2016/openbmc-automation/output.xml
Log:     /gsa/ausgsa-h1/00/srsiva/openbmc/openbmc17Jun2016/openbmc-automation/log.html
Report:  /gsa/ausgsa-h1/00/srsiva/openbmc/openbmc17Jun2016/openbmc-automation/report.html


#openbmc-automation

Quickstart
----------

To run openbmc-automation first you need to install the prerequisite python
packages which will help to invoke tests through tox.  Note that tox
version 2.3.1 or greater is required.

Install the python dependencies for tox
```shell
    $ easy_install tox
    $ easy_install pip
```

Initilize the following environment variable which will used while testing
```shell
    $ export OPENBMC_HOST=<openbmc machine ip address>
    $ export OPENBMC_PASSWORD=<openbmc password>
    $ export OPENBMC_USERNAME=<openbmc username>
    $ export OPENBMC_MODEL=[./data/Barreleye.py, ./data/Palmetto.py, etc]
    $ export IPMI_COMMAND=<Dbus/External>
    $ export IPMI_PASSWORD=<External IPMI password>
```

There are two different set of test suite existing based on the usage.
The test suites are distinctly separated by directory as under
    tests/
    extended/

`tests`: directory contains the general test cases

`extended`: directory contains the use cases for new IP network testing,PDU,
BIOS and BMC code update.

```shell
Use Following Variables for networking test cases
===========================================================
    $export NEW_BMC_IP=<openbmc machine ip address>
    $export NEW_SUBNET_MASK=<openbmc new subnet mask>
    $export NEW_GATEWAY=<openbmc new gateway>
==========================================================

    Use following parameters for PDU:
    $ export PDU_IP=<PDU IP address>
    $ export PDU_USERNAME=<PDU username>
    $ export PDU_PASSWORD=<PDU password>
    $ export PDU_TYPE=<PDU type>
    $ export PDU_SLOT_NO=<SLOT number>

    for PDU_TYPE we support only synaccess at the moment

Use following variables for syslog test cases
==========================================================
    $ export SYSLOG_IP_ADDRESS=<remote syslog system ip>
    $ export SYSLOG_PORT=<remote syslog system port>

Use the following variables for Qemu test run
==========================================================
    $ export SSH_PORT=<ssh port number>
    $ export HTTPS_PORT=<https port number>

Use the following variables for BIOS update testing
==========================================================
    $ export PNOR_IMAGE_PATH=<path to>/<machine>.pnor

```

Run tests
```shell
    $ tox -e tests
```

How to test individual test
```shell
    One specific test
    $ tox -e custom -- -t '"DIMM0 no fault"' tests/test_sensors.robot

    No preset environment variables, one test case from one test suite
    $ OPENBMC_HOST=x.x.x.x tox -e barreleye -- -t '"DIMM0 no fault"' tests/test_sensors.robot

    No preset environment variables, one test suite  for a palmetto system
    $ OPENBMC_HOST=x.x.x.x tox -e palmetto -- tests/test_sensors.robot

    No preset environment variables, the entire test suite for a barreleye system
    $ OPENBMC_HOST=x.x.x.x tox -e barreleye -- tests

    No preset environment variables, the entire test suite excluding test
    cases using argument file.
    $ OPENBMC_HOST=x.x.x.x tox -e barreleye -- --argumentfile test_lists/skip_test tests
```

It can also be run by pasing variables from the cli...
```shell
    Run one test suite using using pybot
    $  pybot -v OPENBMC_HOST:<ip> -v OPENBMC_USERNAME:root -v OPENBMC_PASSWORD:0penBmc -v OPENBMC_MODEL:<model path> tests/test_time.robot

    Run entire test suite using using pybot
    $  pybot -v OPENBMC_HOST:<ip> -v OPENBMC_USERNAME:root -v OPENBMC_PASSWORD:0penBmc -v OPENBMC_MODEL:<model path> tests

    Run entire test suite using external ipmitool
    $  pybot -v OPENBMC_HOST:<ip> -v OPENBMC_USERNAME:root -v OPENBMC_PASSWORD:0penBmc -v IPMI_COMMAND:External -v IPMI_PASSWORD:PASSW0RD -v OPENBMC_MODEL:<model path> tests
```

Run extended tests
```shell
    Set the preset environment variables, run test suite for a barreleye system
    $ OPENBMC_HOST=x.x.x.x tox -e barreleye -- extended/test_power_restore.robot

    Similarly for Network, PDU and update BIOS

    For BMC code update, download the system type *.all.tar image from https://openpower.xyz
    and run as follows:

    For Barreleye system
    python -m robot -v OPENBMC_HOST:x.x.x.x -v FILE_PATH:downloaded_path/barreleye-xxxx.all.tar  extended/code_update/update_bmc.robot

    For loop test (Default iteration is 10)
    python -m robot -v OPENBMC_HOST:x.x.x.x -v OPENBMC_SYSTEMMODEL:xxxxxx -v ITERATION:n -v LOOP_TEST_COMMAND:xxxxxx extended/full_suite_regression.robot
```

Jenkins jobs tox commands
```shell
    HW CI tox command
    Set the preset environment variables, run HW CI test for a barreleye system
    $ OPENBMC_HOST=x.x.x.x tox -e barreleye -- --argumentfile test_lists/HW_CI tests

```

