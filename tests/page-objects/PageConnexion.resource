*** Settings ***
Resource    BasePages.resource


*** Variables ***
${LOCATOR_INPUT_USERNAME}       xpath=//input[@formcontrolname="username"]
${LOCATOR_INPUT_PASSWORD}       xpath=//input[@formcontrolname="password" and @type="password"]
${LOCATOR_BUTTON_LOGIN}         css=.btn
${LOCATOR_SELECT_LANG}          xpath=//div[@class="login-form"]/select


*** Keywords ***
Set Language
    [Arguments]    ${texte}
    Select From List By Value    ${LOCATOR_SELECT_LANG}    ${texte}

Set Username
    [Arguments]    ${texte}
    Input Text    ${LOCATOR_INPUT_USERNAME}    ${texte}

Set Password
    [Arguments]    ${texte}
    Input Password    ${LOCATOR_INPUT_PASSWORD}    ${texte}

Sign In
    Click Element    ${LOCATOR_BUTTON_LOGIN}
