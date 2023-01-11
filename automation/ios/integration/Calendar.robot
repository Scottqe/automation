*** Settings ***
Documentation    test app function
Resource    ../init.robot 

Suite Setup    SuiteSetup
Suite Teardown    SuiteTeardown


*** Test Cases ***
Click Next/Previous Button Should Success
    [Tags]    C2378	
    Repeat Keyword    5    Click Next Day Button
    Click Return Today Button
    Repeat Keyword    5    Click Previous Day Button
    Click Return Today Button
    Verify Current Date Should As Expected

Swipe Next/Previous Button Should Success
    [Tags]    C3908
    Repeat Keyword    5    Swipe To Next Day
    Click Return Today Button
    Repeat Keyword    5    Swipe To Previous Day
    Click Return Today Button
    Verify Current Date Should As Expected
    [Teardown]    Close All Applications

*** Keywords ***
SuiteSetup
    Open Default Application
    # Login Qlieer APP

SuiteTeardown
    Close All Applications