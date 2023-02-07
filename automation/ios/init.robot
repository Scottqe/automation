*** Settings ***
Library    AppiumLibrary
Library    BuiltIn
Library    String
Library    Collections
Library    DateTime

Resource    ./lib/keywords_common.robot
Resource    ./lib/keywords_appointment.robot
Resource    ./lib/keywords_calendar.robot
Resource    ./lib/keywords_checkout.robot
Resource    ./lib/keywords_customerManagement.robot
# Resource    ./api_internal/lib/keywords_common.robot

Library    ./lib/JSONSchemaLibrary.py
Library    ./lib/ResourceName.py


Variables    ../settings.py