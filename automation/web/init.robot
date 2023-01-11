*** Settings ****
Library    SeleniumLibrary    30    10
Library    String
Library    BuiltIn
Library    OperatingSystem
Library    DateTime
Library    Collections

Variables    ../settings.py

Resource    ./lib/keywords_common.robot