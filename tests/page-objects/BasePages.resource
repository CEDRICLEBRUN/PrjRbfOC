*** Settings ***
Library     SeleniumLibrary


*** Variables ***
${LOCATOR_BUTTON_MENU}      xpath=//button[@id="dropdownMenu2"]
${LOCATOR_BUTTON_LOGOFF}    xpath=//button[text()="Se déconnecter"]
${LOCATOR_ALERT_DIALOG}     xpath=//div[@role="alertdialog"]
${LOCATOR_BUTTON_CONFIG}    id=adminConfig


*** Keywords ***
Check Connection
    [Arguments]    ${texte}
    Wait Until Page Contains Element    ${LOCATOR_BUTTON_MENU}
    ${actual_text}    SeleniumLibrary.Get Text    ${LOCATOR_BUTTON_MENU}
    Run Keyword And Continue On Failure    Should Be Equal    ${texte}    ${actual_text}

Check Message Erreur
    [Arguments]    ${texte}
    Wait Until Element Contains    ${LOCATOR_ALERT_DIALOG}    ${texte}
    Click Element    ${LOCATOR_ALERT_DIALOG}
    Wait Until Page Does Not Contain    ${texte}    timeout=15s

Access Config
    Click Element    ${LOCATOR_BUTTON_CONFIG}

Log Off
    Click Element    ${LOCATOR_BUTTON_MENU}
    Click Element    ${LOCATOR_BUTTON_LOGOFF}
    Wait Until Location Contains    /login    message=La déconnexion a échoué
