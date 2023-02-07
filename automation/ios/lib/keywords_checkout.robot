*** Keywords ***
# ---- Element ---- 
Click Direct Checkout in Appointment View Page
    [Documentation]    Click Direct Checkout in Appointment View Page
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="AppointmentPreview_directCheckout"]
    Click Element    //XCUIElementTypeButton[@name="AppointmentPreview_directCheckout"]

Click Choose Discount In Checkout Page
    [Documentation]    Click Choose Discount In Checkout Page
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="AddOtherCell_detailBtn_discount"]
    Click Element    //XCUIElementTypeButton[@name="AddOtherCell_detailBtn_discount"]

Click Choose Voucher In Checkout Page
    [Documentation]    Click Choose Voucher In Checkout Page
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="AddOtherCell_detailBtn_voucher"]
    Click Element   //XCUIElementTypeButton[@name="AddOtherCell_detailBtn_voucher"]

Select Discount In Choose Discount Page
    [Documentation]    Choose Discount In Full Item Discount Page
    Wait Until Element Is Visible    //XCUIElementTypeCell[@name="SelectionDiscountsViewController_discountCell_0"]
    Click Element    //XCUIElementTypeCell[@name="SelectionDiscountsViewController_discountCell_0"]
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="SelectionDiscountsViewController_confirmBtn"]
    Click Element    //XCUIElementTypeButton[@name="SelectionDiscountsViewController_confirmBtn"]

Select Voucher In Choose Voucher Page
    [Documentation]    Select Voucher In Choose Voucher Page
    [Arguments]    ${text}
    Wait Until Element Is Visible    //XCUIElementTypeStaticText[@name="${text}"]
    Click Element    //XCUIElementTypeStaticText[@name="${text}"]

Click Stored-Value Card In Checkout Page
    [Documentation]    Click Stored-Value Card In Checkout Page
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="AddOtherCell_detailBtn_valueCard"]
    Click Element    //XCUIElementTypeButton[@name="AddOtherCell_detailBtn_valueCard"]

Swipe Checkout Button
    [Documentation]    Swipe Checkout Button
    [Arguments]    ${start_x}=848    ${start_y}=710    ${offset_x}=1200    ${offset_y}=0    ${duration}=500    ${index}=0
    sleep    3s
    Swipe    ${start_x}    ${start_y}    ${offset_x}    ${offset_y}    ${duration}

# ---- Verify ----
Verify Checkout Price
    [Documentation]    Verify Checkout Price
    ${text} =    Get Text    //XCUIElementTypeStaticText[@name="CheckoutViewController_totalAmountPriceLabel"]
    ${total} =    Evaluate    '${text}'.replace('$','').strip()
    Set Test Variable    ${total}
    Should Be Equal As Strings    ${item1}    ${total}

Verify Discount Price (50% off)
    [Documentation]    Verify Checkout Price
    ${text} =    Get Text    ///XCUIElementTypeStaticText[@name="CheckoutViewController_totalAmountPriceLabel"]
    ${total} =    Evaluate    '${text}'.replace('$','').strip()
    Set Test Variable    ${total}
    ${item1} =    Evaluate    int(0.5*${item1})
    Should Be Equal As Strings    ${item1}    ${total}

Verify Checkout Should Success
    [Documentation]    Verify Checkout Should Success
    Wait Until Element Is Visible    //XCUIElementTypeStaticText[@name="付款完成"]
    Click Element    //XCUIElementTypeButton[@name="CheckoutResultViewController_completeBtn"]
    Element Should Be Enabled    //XCUIElementTypeOther[@name="ScheduleEventCell_0"]/XCUIElementTypeOther/XCUIElementTypeOther
    