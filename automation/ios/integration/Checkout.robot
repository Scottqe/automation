*** Settings ***
Documentation    test app function
Resource    ../init.robot 

Suite Setup    SuiteSetup
Suite Teardown    SuiteTeardown

*** Test Cases ***
Checkout Should Success
    [Setup]    Add A New Appointment Without Customer
    Click Canlender Block Button    0
    Click Direct Checkout in Appointment View Page
    Verify Checkout Price   
    Swipe Checkout Button
    Verify Checkout Should Success
    [Teardown]    Close All Applications

Checkout With Discount Should Success
    # [Setup]    Add A New Appointment Without Customer
    Click Canlender Block Button    0
    Click Direct Checkout in Appointment View Page
    Click Choose Discount In Checkout Page
    Select Discount In Choose Discount Page
    Verify Discount Price (50% off)
    Swipe Checkout Button
    Verify Checkout Should Success
    [Teardown]    Close All Applications
    
*** Keywords ***
SuiteSetup
    Open Default Application
    # Login Qlieer APP

SuiteTeardown
    Close All Applications

Add A New Appointment Without Customer
    Click Calender + Button
    Click Add Appointment Button
    Click Add Item Button 
    Click Select Item Button
    Click Appointment Confirm Button
    