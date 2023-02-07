*** Keywords ***
# ---- Element ---- 
Click Add Appointment Button
    [Documentation]    Click Add Appointment Button
    Wait Until Element Is Visible    //XCUIElementTypeCell[@name="AppointmentsScheduleViewController_addAppointment"]
    Click Element    //XCUIElementTypeCell[@name="AppointmentsScheduleViewController_addAppointment"]

Click Add Item Button 
    [Documentation]    Click Add Item Button 
    sleep    5s
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="AddEventsCollectionViewCell_addBtn"]
    Click Element   //XCUIElementTypeButton[@name="AddEventsCollectionViewCell_addBtn"]

Click Appointment Confirm Button
    [Documentation]    Click Appointment Confirm Button
    [Arguments]    ${buttonName}=確認新增
    Wait Until Element Is Visible    //XCUIElementTypeStaticText[@name="${buttonName}"]
    Click Element   //XCUIElementTypeStaticText[@name="${buttonName}"]

Click Cancel Appointment In Appointment View Page
    [Documentation]    Click Cancel Appointment In Appointment View Page
    Wait Until Element Is Visible    //XCUIElementTypeCell[@name="AppointmentPreview_cancelAppointment"]
    Click Element    //XCUIElementTypeCell[@name="AppointmentPreview_cancelAppointment"]

Choose Cancel Reason
    [Documentation]    Choose Cancel Reason
    [Arguments]    ${text}=顧客致電取消
    Wait Until Element Is Visible    //XCUIElementTypeStaticText[@name="${text}"]
    Click Element    //XCUIElementTypeStaticText[@name="${text}"]

Click Comfirm Cancel Appointment Button
    [Documentation]    Click Comfirm Cancel Appointment Button
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="CancelAppointmentViewController_confirmBtn"]
    Click Element    //XCUIElementTypeButton[@name="CancelAppointmentViewController_confirmBtn"]

Click Edit Appointment Button In Appointment View Page
    [Documentation]    Click Edit Appointment Button In Appointment View Page
    Wait Until Element Is Visible    //XCUIElementTypeCell[@name="AppointmentPreview_editAppointment"]
    Click Element    //XCUIElementTypeCell[@name="AppointmentPreview_editAppointment"]

Click No Show Button In Appointment View Page
    [Documentation]    Click No Show Button In Appointment View Page
    Wait Until Element Is Visible    //XCUIElementTypeCell[@name="AppointmentPreview_noShowAppointment"]
    Click Element    //XCUIElementTypeCell[@name="AppointmentPreview_noShowAppointment"]

Click Select Item Button
    [Documentation]    Click Select Item Button
    [Arguments]    ${index}=1   ${index2}=1
    Wait Until Element Is Visible    //XCUIElementTypeCell[@name="ProductListCell_productSelectionList_${index}"]
    ${text} =    Get Text    name=ProductListCell_priceLabel_${index2}
    ${item1} =    Evaluate    '${text}'.replace('$','').strip()
    Set Test Variable    ${item1}
    Click Element   //XCUIElementTypeCell[@name="ProductListCell_productSelectionList_${index}"]

Click Selected Item In Appointment View Page
    [Documentation]    Click Selected Item In Appointment View Page
    [Arguments]    ${index}=0
    Wait Until Element Is Visible    //XCUIElementTypeCell[@name="AppointmentEditorDetailsVC_appointmentEventsListCell_${index}"]
    Click Element    //XCUIElementTypeCell[@name="AppointmentEditorDetailsVC_appointmentEventsListCell_${index}"]

Click ... Button In Appointment View Page
    [Documentation]    Click ... Button In Appointment View Page
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="AppointmentPreview_optionBtn"]
    Click Element    //XCUIElementTypeButton[@name="AppointmentPreview_optionBtn"]

Click Save Customer Button In Appointment Page
    [Documentation]    Click Save Customer Button In Appointment Page
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="CustomerSimpleEditorViewController_saveBtn"]
    Click Element    //XCUIElementTypeButton[@name="CustomerSimpleEditorViewController_saveBtn"]

Input Name In Add New Customer Page
    [Documentation]    Input Name In Add New Customer Page
    [Arguments]    ${text}
    Wait Until Element Is Visible    //XCUIElementTypeCell[@name="InputBoxEditingCell_name"]
    Input Text    //XCUIElementTypeCell[@name="InputBoxEditingCell_name"]    ${text}

Input Nick Name In Add New Customer Page
    [Documentation]    Input Nick Name In Add New Customer Page
    [Arguments]    ${text}
    Wait Until Element Is Visible    //XCUIElementTypeCell[@name="InputBoxEditingCell_nickName"]
    Input Text    //XCUIElementTypeCell[@name="InputBoxEditingCell_nickName"]    ${text}

Input Phone Number In Add Customer Page
    [Documentation]    Input Phone Number In Add Customer Page
    [Arguments]    ${text}
    Wait Until Element Is Visible    //XCUIElementTypeCell[@name="InputBoxEditingCell_phone"]
    Input Text    //XCUIElementTypeCell[@name="InputBoxEditingCell_phone"]    ${text}

Input Note In Add Customer Page
    [Documentation]    Input Note In Add Customer Page
    [Arguments]    ${text}=I'm not a bot
    Wait Until Element Is Visible    //XCUIElementTypeCell[@name="NoteEditingCollectionViewCell_note"]
    Input Text    //XCUIElementTypeCell[@name="NoteEditingCollectionViewCell_note"]    ${text}
    Hide Keyboard

Select Gender In Add New Customer Page
    [Documentation]    Select Gender In Add New Customer Page
    [Arguments]    ${text}=先生
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="InputBoxEditingCell_rightSideBtn"]
    Click Element    //XCUIElementTypeButton[@name="InputBoxEditingCell_rightSideBtn"]
    Click Element    //XCUIElementTypeStaticText[@name="${text}"]

Select Customer Resourse In Customer Page
    [Documentation]    Select Customer Resourse In Customer Page
    [Arguments]    ${text}=網路預約
    Hide Keyboard
    Wait Until Element Is Visible    //XCUIElementTypeCell[@name="SelectionEditingCell_source"]
    Click Element    //XCUIElementTypeCell[@name="SelectionEditingCell_source"]
    Click Element    //XCUIElementTypeStaticText[@name="${text}"]

Select Customer In Appointment Page
    [Arguments]    ${index}=0
    [Documentation]    Select Customer In Appointment Page
    Wait Until Element Is Visible    //XCUIElementTypeCell[@name="AddCustomersViewController_AddCustomersListCell_${index}"]
    Click Element    //XCUIElementTypeCell[@name="AddCustomersViewController_AddCustomersListCell_${index}"]

Swipe Item To Delete
    [Arguments]    ${start_x}=550    ${start_y}=260    ${offset_x}=50    ${offset_y}=0    ${duration}=300    ${index}=0
    sleep    5s
    Swipe    ${start_x}    ${start_y}    ${offset_x}    ${offset_y}    ${duration}


# ---- Keywords ----
Add New Customer
    Create Random Variables
    Click Add Customer Button
    Click Add New Customer Button In Appointment Page
    Select Gender In Add New Customer Page
    Input Name In Add New Customer Page    ${firstName}
    Input Nick Name In Add New Customer Page    ${lastName}
    Input Phone Number In Add Customer Page    ${phoneNum}
    Select Customer Resourse In Customer Page
    Input Note In Add Customer Page
    Click Save Customer Button In Appointment Page

# ---- Verify ----

Verify Customer Should Be Created
    Page Should Contain Text    ${lastName}
    Page Should Contain Text    ${phoneNum}
    Page Should Contain Text    先生

# Verify Add Appointment Should Success
    # Wait Until Page Contains    //XCUIElementTypeStaticText[@name="剪髮"]
    #Wait Until Element Is Visible   //XCUIElementTypeApplication[@name="客立樂Pro-β"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeCollectionView/XCUIElementTypeCell[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeStaticText[@name="${customerName}"]