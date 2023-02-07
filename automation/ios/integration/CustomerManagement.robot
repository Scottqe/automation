*** Settings ***
Documentation    test app function
Resource    ../init.robot 

Suite Setup    SuiteSetup
Suite Teardown    SuiteTeardown

*** Test Cases ***
Add Customer With Full Info Should Success
    [Setup]    Go To CustomerManagement Page
    Click Add New Customer Button In Customer Management Page
    Input Name In Add Customer Page  
    sleep    5s


*** Keywords ***
SuiteSetup
    Open Default Application
    # Login Qlieer APP

SuiteTeardown
    Close All Applications

Go To CustomerManagement Page
    Click Menu Bar
    Click Customer Management Button
    