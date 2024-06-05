*** Settings ***
Resource    BasePages.resource
Resource    ../BaseTests.resource


*** Variables ***
${LOCATOR_BUTTON_USER}          xpath=//a[@routerlink="/admin/utilisateur"]
${LOCATOR_BUTTON_USER_LIST}     xpath=//a[@routerlink="/admin/userList"]


*** Keywords ***
Access Users
    Click Element    ${LOCATOR_BUTTON_USER}

Access Users List
    Click Element    ${LOCATOR_BUTTON_USER_LIST}

Activate Account
    [Arguments]    ${username}
    # Click Element    xpath=//tr[contains(.,'${username}')]//*[contains(text(), 'Approuver')]
    ${ele}    Get WebElement    xpath=//tr[contains(.,'${username}')]//*[contains(text(), 'Approuver')]/..
    Execute Javascript    arguments[0].click();    ARGUMENTS    ${ele}
    Wait Until Element Is Visible    xpath=//tr[contains(.,'${username}')]//*[contains(text(), 'Bloquer')]
    Capture Step Element ScreenShot    ACTIVATION    xpath=//tr[contains(.,'${username}')]
