*** Keywords ***
# ---- Element ---- 
Click Previous Day Button
    [Documentation]    Click Previous Day Button
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="AppointmentsScheduleViewController_leftArrowBtn"]
    Click Element    //XCUIElementTypeButton[@name="AppointmentsScheduleViewController_leftArrowBtn"]

Click Next Day Button
    [Documentation]    Click Next Day Button
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="AppointmentsScheduleViewController_rightArrowBtn"]
    Click Element    //XCUIElementTypeButton[@name="AppointmentsScheduleViewController_rightArrowBtn"]

Click Return Today Button
    [Documentation]    Click Return Today Button
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="AppointmentsScheduleViewController_todayBtn"]
    Click Element    //XCUIElementTypeButton[@name="AppointmentsScheduleViewController_todayBtn"]

Click Weekly Mode Button
    [Documentation]    Click Weekly Mode Button
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="AppointmentsScheduleViewController_weekBtn"]
    Click Element    //XCUIElementTypeButton[@name="AppointmentsScheduleViewController_weekBtn"]

Click Notification Button
    [Documentation]    Click Notification Button    
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="AppointmentsScheduleViewController_notifyBtn"]
    Click Element    //XCUIElementTypeButton[@name="AppointmentsScheduleViewController_notifyBtn"]

Click Side Calender Button 
    [Documentation]    Click Side Calender Button 
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="AppointmentsScheduleViewController_expandBtn"]
    Click Element    //XCUIElementTypeButton[@name="AppointmentsScheduleViewController_expandBtn"]

Swipe To Next Day
    [Documentation]    Swipe To Next Day
    [Arguments]    ${start_x}=600    ${start_y}=450    ${offset_x}=100    ${offset_y}=0    ${duration}=300    ${index}=0
    sleep    5s
    Swipe    ${start_x}    ${start_y}    ${offset_x}    ${offset_y}    ${duration}
    
Swipe To Previous Day
    [Documentation]    Swipe To Previous Day
    [Arguments]    ${start_x}=100    ${start_y}=450    ${offset_x}=600    ${offset_y}=0    ${duration}=300    ${index}=0
    sleep    5s
    Swipe    ${start_x}    ${start_y}    ${offset_x}    ${offset_y}    ${duration}



# ---- Verify ----
Verify Date Should As Expected
    [Documentation]    Verify Date Should As Expected
    ${date} =    Get Current Date 
    Add Time To Date    ${date.day}    5
    Wait Until Element Is Visible    //XCUIElementTypeStaticText[@name="${date}日"]
    