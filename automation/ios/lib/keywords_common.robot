*** Keywords ***
# ---- Element ---- 
Click Login Error message confirm button
    [Documentation]    Click Login Error message confirm button
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="確認"]
    Click Element    //XCUIElementTypeButton[@name="確認"]
    
Click Login Button
    [Documentation]    Click loging button
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="登入"]
    Click Element    //XCUIElementTypeButton[@name="登入"]

Click Calender + Button
    [Documentation]    Click canlender + Button
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="AppointmentsScheduleViewController_addBtn"]
    Click Element    //XCUIElementTypeButton[@name="AppointmentsScheduleViewController_addBtn"]

Click Canlender Block Button
    [Documentation]    Click Canlender Block Button
    [Arguments]    ${index}=0
    sleep    5s
    Click Element    //XCUIElementTypeCell[@name="ScheduleEventCell_${index}"]

Click Window Close Button
    [Documentation]    Click Window Close Button
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="CancelBtnGray"]
    Click Element    //XCUIElementTypeButton[@name="CancelBtnGray"]

Clear Account Textfield
    [Documentation]    Clear Account Textfield
    Clear Text    //XCUIElementTypeApplication[@name="客立樂Pro-β"]/XCUIElementTypeWindow/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField

Clear Password Textfield
    [Documentation]    Clear Password Textfield
    Clear Text    //XCUIElementTypeApplication[@name="Vozaim"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeTextField[2]

Click Add Customer Button
    [Documentation]    Click Add Customer Button
    Wait Until Element Is Visible    //XCUIElementTypeCell[@name="AppointmentDetailCustomerCell_addCustomer"]
    Click Element    //XCUIElementTypeCell[@name="AppointmentDetailCustomerCell_addCustomer"]

Click Add New Customer Button
    [Documentation]    Click Add New Customer Button
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="新增顧客"]
    Click Element    //XCUIElementTypeButton[@name="新增顧客"]

Input Login Account
    [Documentation]    Input Login Account
    [Arguments]    ${account}
    Wait Until Element Is Visible    //XCUIElementTypeApplication[@name="客立樂Pro-β"]/XCUIElementTypeWindow/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
    Input Text    //XCUIElementTypeApplication[@name="客立樂Pro-β"]/XCUIElementTypeWindow/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField    ${account}

Input Login Password
    [Documentation]    Input Login Password
    [Arguments]    ${password}
    Input Text    //XCUIElementTypeApplication[@name="客立樂Pro-β"]/XCUIElementTypeWindow/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeSecureTextField    ${password}

Swipe Teaching Page
    [Documentation]    Swipe teaching page
    [Arguments]    ${start_x}=140    ${start_y}=126    ${offset_x}=20   ${offset_y}=126    ${duration}=100
    Swipe    ${start_x}    ${start_y}    ${offset_x}    ${offset_y}    ${duration}

# ---- Keywords ----
Create Random Variables
    ${firstName}    ${lastName} =    Create Random Female Name
    ${phoneNum} =    Create Random Phone Number
    Set Test Variable    ${firstName}
    Set Test Variable    ${lastName}
    Set Test Variable    ${phoneNum}

#  Create New User And Login
#     Create Random Variables
#     Get Athena Token
#     Add A New User Information    ${email}    ${randomName}
#     Open Default Application
#     Check System Board Display On Mobile
#     Check Privacy Should Be Selected
#     Login iOS Application    ${email}    ${videoToken}

Check System Board Display On Mobile
    [Documentation]    Confirm system board display on mobile
    Get System Board Information For Mobile
    ${length} =    Get Length    ${content}
    Run Keyword IF    ${length}!=0    Click Confirm Close System Board Button

Check Privacy Should Be Selected
    [Documentation]    Check privacy should be selected
    ${status} =    Run Keyword And Return Status    Verify Privacy Should Be Selected
    Run Keyword If    '${status}'=='${FALSE}'    Select Agree Privacy    

Get System Board Information For Mobile
    [Documentation]    Get System board information for mobile
    ${resp} =    Video Get Notice Get
    Set Suite Variable    ${content}    ${resp.json()['result']}

Into Preview Question Page
    Create New User And Login
    Click Record Resume Button
    Repeat Keyword    4    Swipe Teaching Page
    Click Next Button

Into Ready To Record Page
    Into Preview Question Page
    Click Record Start Button

Login Qlieer APP
    [Documentation]    Login Qlieer APP
    Input Login Account    ${AUTOTEST_ACCOUNT}
    Input Login Password    ${AUTOTEST_PASSWORD}  
    Click Login Button
    Click Window Close Button
    Verify Login Should Success    

Login iOS Application 
    [Arguments]    ${email}=${NULL}    ${code}=${NULL}
    Run Keyword If    '${code}'!='${NULL}'    Input Intervewee Email    ${email}
    Run Keyword If    '${code}'!='${NULL}'    Input Verification Code    ${code}
    Close Keyboard Window
    Click Login Button

Upload Step For Video
    ${height} =    Get Window Height
    Set Test Variable    ${height}
    Run Keyword If    900 > ${height} > 800    
    ...    Upload Step For XR Window
    ...    ELSE IF    801 > ${height} > 700    
    ...    Upload Step For 8plus Window
    ...    ELSE IF    701 > ${height} > 500   
    ...    Upload Step For SE Window

Upload Step For XR Window
    Click A Point    36    712    100
    Click Upload Script Languages button
    Click A Point    36    788    100

Upload Step For 8plus Window
    Click A Point    189    571    100
    Click Upload Script Languages button
    Click A Point    191    649    100

Upload Step For SE Window
    Click A Point    36    548    100
    Click Upload Script Languages button
    Click A Point    36    624    100

Open Default Application
    Run Keyword If    '${REMOTE}'=='${NONE}'    Open Local Application
    ...    ELSE    Open Remote Application

Open Remote Application
    Open Application  https://cloud.seetest.io/wd/hub    automationName=${ANDROID_AUTOMATION_NAME}    
    ...    platformName=${ANDROID_PLATFORM_NAME}    appPackage=com.experitest.ExperiBank    appActivity=.LoginActivity
    ...    accessKey=${ACCESS_KEY}

Open Local Application
    [Arguments]    ${automationName}=XCUITest    ${platformName}=ios
    Open Application    http://localhost:4723/wd/hub    automationName=${automationName}
    ...    platformName=${platformName}    bundleId=com.qlieer.aphrodite.pos.stage    xcodeOrgId=QRP2NT8BR4    xcodeSigningId=Apple Developement
    ...    udid=6c67ec2bae7e1612598107197e721b5bca87243f    deviceName=iPad    platformVersion=14.8    newCommandTimeout=0   

Save The Company Question
    ${parentXPath} =    Set Variable    //XCUIElementTypeApplication[@name="Vozaim"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther
    Wait Until Element Is Visible    ${parentXPath}
    ${question1} =    Get Text    //XCUIElementTypeStaticText[@name="準備一段自我介紹"]
    Set Test Variable    ${question1}

SuiteTeardown
    Close All Applications

# ---- Verify ----
Verify Current Date Should As Expected
    [Documentation]    Verify Date Should As Expected
    ${date}    Evaluate  '{dt.day}'.format(dt=datetime.datetime.now())    modules=datetime
    Wait Until Element Is Visible    //XCUIElementTypeStaticText[@name="${date}日"]

Verify Username Format Wrong Message Should As Expected
    [Documentation]    Verify Username Format Wrong Message Should As Expected
    Wait Until Element Is Visible    //XCUIElementTypeStaticText[@name="很抱歉，該電子信箱不存在"]

Verify Password Format Wrong Message Should As Expected
    [Documentation]    Verify Password Format Wrong Message Should As Expected
    Wait Until Element Is Visible   //XCUIElementTypeStaticText[@name="您所輸入的密碼錯誤"]