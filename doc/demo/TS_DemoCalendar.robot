*** Settings ***
Library         SeleniumLibrary
Library         %{PROJECT_FOLDER}/libs/ManageDate.py

Force Tags      tnr


*** Variables ***
${URL}      http://demo.seleniumeasy.com/bootstrap-date-picker-demo.html


*** Test Cases ***
Demo Selenium Easy Calandar
    ${date}    Initialise Date    deltadays=${-60}    local_language=en_US
    Log To Console    \n ${date}
    Open Browser    ${URL}    chrome
    ...    options=add_experimental_option('excludeSwitches', ['enable-logging'])
    SeleniumLibrary.Maximize Browser Window
    SeleniumLibrary.Set Selenium Speed    0.5s
    Click Element    //div[@id=\"sandbox-container1\"]//span
    Calendrier Selectionner Date    ${date}
    ${value}    Get Element Attribute    //div[@id="sandbox-container1"]//input    value
    Should Be Equal    ${date}[newdate][d/m/Y]    ${value}
    Capture Page Screenshot
    [Teardown]    Close All Browsers


*** Keywords ***
Calendrier Selectionner Date
    [Documentation]    Permet de sélectionner une date depuis le Calendrier
    [Arguments]    ${date}
    # Vérifier d'être sur la date du jour
    Wait Until Element Contains
    ...    //div[@class="datepicker-days"]//th[@class="datepicker-switch"]
    ...    ${date}[now][month_long] ${date}[now][year]
    # Si on est un week end la date du jour est grisée
    IF    ${date}[now][isWeekends] == True
        Wait Until Element Contains
        ...    //div[@class="datepicker-days"]//td[@class="today disabled disabled-date day"]
        ...    ${date}[now][day]
        # Sinon la date du jour est sélectionnable
    ELSE
        Wait Until Element Contains
        ...    //div[@class="datepicker-days"]//td[@class="today day"]
        ...    ${date}[now][day]
    END
    # Si la date choisi est la date du jour, on la sélectionne
    IF    ${date}[deltadays] == 0
        Click Element
        ...    //div[@class="datepicker-days"]//td[@class="today day" and text()="${date}[now][day]"]
        # Sinon on détermine le décallage en mois, pour compter le nombre de click
        # pour naviguer sur les mois précédents
    ELSE
        # on boucle
        ${loop}    Evaluate    abs(${date}[deltamonth])
        Repeat Keyword    ${loop} times    Click Element
        ...    //div[@class="datepicker-days"]//th[@class="prev"]
        # on vérifie d'être sur le bon mois / année avant de sélectionner la date choisie
        Wait Until Element Contains
        ...    //div[@class="datepicker-days"]//th[@class="datepicker-switch"]
        ...    ${date}[newdate][month_long] ${date}[newdate][year]
        Click Element
        ...    //div[@class="datepicker-days"]//td[@class="day" and text()="${date}[newdate][day]"]
    END
