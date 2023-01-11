*** Settings ***
Documentation    test app function
Resource    ../init.robot 

Suite Setup    SuiteSetup
Suite Teardown    SuiteTeardown

*** Test Cases ***
Input Wrong Username Should As Expected
    [Tags]    C3664	
    [Template]    Input Username And Verify Format
    testtt
    t e s t@gmail.com
    ＴＥＳＴ＠gmail.com
    test.gmail.com    
    測試@gmail.com
    !#$%^&*()@gmail.com

Input Wrong Password Should As Expected
    [Tags]    C3663
    [Template]    Input Password And Verify Format
    1234556
    888 888
    a  
    !#$%^^
    88888888888888888

Login Should Success
    [Tags]    C3905
    Input Login Account    ${AUTOTEST_ACCOUNT}
    Input Login Password    ${AUTOTEST_PASSWORD}  
    Click Login Button
    Click Window Close Button
    Verify Current Date Should As Expected
    [Teardown]    Close All Applications
    
*** Keywords ***
Input Username And Verify Format
    [Arguments]    ${email}
    Input Login Account    ${email}
    Input Login Password    ${AUTOTEST_PASSWORD}
    Click Login Button
    Verify Username Format Wrong Message Should As Expected
    Click Login Error message confirm button
    Clear Account Textfield

Input Password And Verify Format
    [Arguments]    ${password}
    Input Login Account    ${AUTOTEST_ACCOUNT}
    Input Login Password    ${password}
    Click Login Button
    Verify Password Format Wrong Message Should As Expected
    Click Login Error message confirm button
    Clear Account Textfield

TestSetupForCreateNewUser
    Create Random Variables
    Add A New User Information    ${email}    ${randomName}
    Login iOS Application    ${email}    ${videoToken}

SuiteSetup
    Open Default Application

SuiteTeardown
    Close All Applications