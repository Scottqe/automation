*** Settings ***
Documentation    test app function
Resource    ../init.robot 

Suite Setup    SuiteSetup
Suite Teardown    SuiteTeardown


*** Test Cases ***
Add Appointment Should Success
    [Tags]    C3906
    Click Calender + Button
    Click Add Appointment Button
    Add New Customer 
    Click Add Item Button 
    Click Select Item Button
    Click Appointment Confirm Button
    # Verify Add Appointment Should Success    

Edit Appointment Should Success
    [Tags]    C3907
    Click Canlender Block Button 
    Click ... Button In Appointment View Page
    Click Edit Appointment Button In Appointment View Page
    Click Add Item Button    
    Click Select Item Button
    Click Appointment Confirm Button    更新預約
    sleep    5s

Delete Item Should Success
    [Tags]    C2427
    Click Canlender Block Button 
    Click ... Button In Appointment View Page
    Click Edit Appointment Button In Appointment View Page
    Swipe Item To Delete
    Click Appointment Confirm Button    更新預約
    sleep    5s

Cancel Appointment Should Success
    [Tags]    C2463
    Click Canlender Block Button 
    Click ... Button In Appointment View Page
    Click Cancel Appointment In Appointment View Page
    Choose Cancel Reason
    Click Comfirm Cancel Appointment Button

*** Keywords ***
SuiteSetup
    Open Default Application
    # Login Qlieer APP

SuiteTeardown
    Close All Applications
    
    
    