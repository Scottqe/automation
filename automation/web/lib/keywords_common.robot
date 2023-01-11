**** Keywords ****
# ---- Element ---- #
Input Store Code
    [Documentation]    Input Store Code
    [Arguments]    ${text}
    Wait Until Element Is Enabled    //*[@id="__BVID__6"]
    Input Text    //*[@id="__BVID__6"]    ${text}

Input Login Account
    [Documentation]    Input Login Code
    [Arguments]    ${text}    
    Wait Until Element Is Enabled    //*[@id="__BVID__6"]
    Input Text    //*[@id="__BVID__9"]    ${text}
       
Input Login Password
    [Documentation]    Input Login Password
    [Arguments]    ${text}
    Wait Until Element Is Enabled    //*[@id="__BVID__6"]
    Input Text    //*[@id="__BVID__11"]    ${text}

Click Login Button
    [Documentation]    Click Login Button
    Wait Until Element Is Enabled    //button[@class="btn btn-primary btn-block"]//span[contains(.,"登入")]
    Click Element    //button[@class="btn btn-primary btn-block"]//span[contains(.,"登入")]
    


# ---- Keywords ---- #
Open Default Browser
    [Documentation]    Open Default Browser
    [Arguments]    ${browserURL}=${EMPTY}
    ${browserURL} =    Set Variable    ${HOST}${browserURL}
    Run Keyword IF    '${REMOTE}'!='None'    Open Remote Browser    ${browserURL}
    ...    ELSE IF    '${BROWSER_PORT}'!='None'    Open Docker Browser    ${browserURL}
    ...    ELSE    Open Local Browser    ${browserURL}
    Maximize Browser Window
    Set Selenium Speed    0.1s

Open Remote Browser
    [Documentation]    Open Remote Browser
    [Arguments]    ${browserURL}    ${browserName}=${NONE}
    ${capabilities} =    Create Dictionary
    Set To Dictionary    ${capabilities}    browserName    ${DEFAULT_BROWSER}
    Set To Dictionary    ${capabilities}    platform    Mac OS
    Set To Dictionary    ${capabilities}    screenResolution    1366x768
    ${executor} =    Evaluate    str("http://${CBT_EMAIL}:${CBT_AUTHKEY}@hub.crossbrowsertesting.com:80/wd/hub")
    ${webdriver} =    Create Webdriver    Remote    alias=${browserName}    desired_capabilities=${capabilities}    command_executor=${executor}
    Go to    ${browserURL}

Open Docker Browser
    [Documentation]    Open Docker Browser
    [Arguments]    ${browserURL}    ${browserName}=${NONE}
    ${capabilities} =    Create Dictionary
    Set To Dictionary    ${capabilities}    browserName    ${DEFAULT_BROWSER}
    ${executor} =    Evaluate    str("http://127.0.0.1:${BROWSER_PORT}/wd/hub")
    ${webdriver} =    Create Webdriver    Remote    alias=${browserName}    desired_capabilities=${capabilities}    command_executor=${executor}
    Go to    ${browserURL}

Open Local Browser
    [Documentation]    Open Local Browser
    [Arguments]    ${url}    ${browserName}=${DEFAULT_BROWSER}
    ${browserOptions} =    RUN Keyword IF    '${browserName}'=='chrome'    Set Chrome Browser Options    \\
    ...    ELSE IF    '${browserName}'=='firefox'    Set Firefox Browser Options    \\
    Open Browser    ${url}    ${browserName}    options=${browserOptions}

Set Chrome Browser Options
    [Arguments]    ${divider}
    ${now} =    Get Time    epoch
    Set Global Variable    ${DOWNLOAD_DIR}    ${CURDIR}${divider}download${now}
    ${chromeOptions}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${prefs} =    Create Dictionary    download.default_directory=${CURDIR}${divider}download${now}
    Call Method    ${chromeOptions}    add_experimental_option    prefs    ${prefs}
    Call Method    ${chromeOptions}    add_argument    --incognito    #開啟無痕
    [Return]    ${chromeOptions}
    
# ---- Verify ----
Verify Login Should Success
    Page Should Contain    ${AUTOTEST_USER}
    Page Should Contain    即時報表



