*** Keywords ***
# ---- Element ---- 
Click Add New Customer Button In Customer Management Page
    [Documentation]    Click Add New Customer Button In Customer Management Page
    Wait Until Element Is Visible    //XCUIElementTypeButton[@name="新增顧客"]
    Click Element    //XCUIElementTypeButton[@name="新增顧客"]

Input Name In Add Customer Page
    [Documentation]    Input Nmae In Add Customer Page
    [Arguments]    ${text} = Hello
    Wait Until Element Is Visible    class=**/XCUIElementTypeTextField[`value == "請輸入名稱"`]
    Input Text    class=**/XCUIElementTypeTextField[`value == "請輸入名稱"`]    ${text}


# ---- Keywords ---- 