*** Settings ***
Documentation    Test login function
Resource    ../init.robot

Suite Setup    SuiteSetup
Suite Teardown    SuiteTeardown

Test Timeout    ${TIMEOUT}

*** Test Cases ***
Login Should Success
    Input Store Code    ${AUTOTEST_SRORE_CODE}
    Input Login Account    ${AUTOTEST_USER}
    Input Login Password    ${AUTOTEST_PASSWORD}
    Click Login Button
    Verify Login Should Success

*** Keywords ***
SuiteSetup
    Open Default Browser  

SuiteTeardown
    Close All Browsers