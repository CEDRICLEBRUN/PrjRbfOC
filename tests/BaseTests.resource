*** Settings ***
Library     OperatingSystem
Library     SeleniumLibrary
Library     JSONLibrary
Library     RequestsLibrary
Library     %{PROJECT_FOLDER}/libs/Common.py
Resource    %{PROJECT_FOLDER}/tests/data-env/env.resource


*** Variables ***
# chrome | chromemobileemulation | edge | firefox
${BROWSER}              chrome
# no | yes (case insensitive, default no if <> yes)
${BROWSER_HEADLESS}     yes
# OK | KO
${ENV}                  OK
# ----------------------------------------------------------------------
# Chargé dans le suite setup
${COMPTE_ADMIN}         ${EMPTY}
${TRANSLATE}            ${EMPTY}
# Chargé dans le test setup
# Un contexte pour ne pas écraser les captures si on merge avec rebot différents résultats de run
# A utiliser pour tous les artefacts (exemple le nom d'un pdf qu'on télécharge)
${FILENAME}             ${EMPTY}


*** Keywords ***
Log Context
    [Documentation]    Log Context
    Log To Console    ${EMPTY}
    Log To Console    ================================================================== SUITE SETUP
    Log To Console    CURDIR____________\t${CURDIR}
    Log To Console    EXECDIR___________\t${EXECDIR}
    Log To Console    OUTPUT DIR________\t${OUTPUT DIR}
    Log To Console    ENV_______________\t${ENV}
    Log To Console    BROWSER___________\t${BROWSER}
    Log To Console    BROWSER_HEADLESS__\t${BROWSER_HEADLESS}
    Log To Console    URL_______________\t${URL_OPENCRUISE_${ENV}}
    Log To Console    ${EMPTY}

Suite Setup
    [Documentation]    Suite Setup
    Log Context
    RequestsLibrary.GET    ${URL_OPENCRUISE_${ENV}}/api/helper/villes    expected_status=200
    ${compte_admin}    Create Dictionary
    ...    username=%{OPENCRUISE_ADMIN_USER}    # créer les variables d'environnement
    ...    password=%{OPENCRUISE_ADMIN_PWD}
    ...    nom=formation
    ...    prenom=admin
    Set Global Variable    ${COMPTE_ADMIN}    ${compte_admin}
    # chargement de la traduction par défaut en FR
    ${translate}    JSONLibrary.Load Json From File    %{PROJECT_FOLDER}/tests/data-env/lang-fr.json    encoding=utf-8
    Set Global Variable    ${TRANSLATE}    ${translate}

Test Setup
    [Documentation]    Test Setup
    Log To Console    ${EMPTY}
    Log To Console    ================================================================== TEST SETUP
    ${filename}    Common.Clean String Filename    ${TEST NAME}_Env${ENV}_${BROWSER}
    Set Global Variable    ${FILENAME}    ${filename}

    Register Keyword To Run On Failure    NONE
    Run Keyword    Open${BROWSER}
    Set Browser Implicit Wait    5
    Maximize Browser Window

Openchrome
    [Documentation]    Openchrome
    ${options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    incognito
    ${excludeSwitches}    Create List    enable-automation    enable-logging    disable-popup-blocking
    Call Method    ${options}    add_experimental_option    excludeSwitches    ${excludeSwitches}
    IF    '''${BROWSER_HEADLESS}'''.upper() == 'YES'
        Call Method    ${options}    add_argument    headless
    END
    Open Browser
    ...    url=${URL_OPENCRUISE_${ENV}}
    ...    browser=chrome
    ...    options=${options}

Openchromemobileemulation
    [Documentation]    Openchromemobileemulation
    ${options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    &{mobile_emulation}    Create Dictionary    deviceName=Nexus 7
    Call Method    ${options}    add_experimental_option    mobileEmulation    ${mobile_emulation}
    Call Method    ${options}    add_argument    incognito
    ${excludeSwitches}    Create List    enable-automation    enable-logging    disable-popup-blocking
    Call Method    ${options}    add_experimental_option    excludeSwitches    ${excludeSwitches}
    IF    '''${BROWSER_HEADLESS}'''.upper() == 'YES'
        Call Method    ${options}    add_argument    headless
    END
    Open Browser
    ...    url=${URL_OPENCRUISE_${ENV}}
    ...    browser=chrome
    ...    options=${options}

Openedge
    [Documentation]    Openedge
    ${options}    Evaluate    sys.modules['selenium.webdriver'].EdgeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    incognito
    IF    '''${BROWSER_HEADLESS}'''.upper() == 'YES'
        Call Method    ${options}    add_argument    headless
    END
    Open Browser
    ...    url=${URL_OPENCRUISE_${ENV}}
    ...    browser=edge
    ...    options=${options}

Openfirefox
    [Documentation]    Openfirefox
    ${options}    Evaluate    sys.modules['selenium.webdriver'].FirefoxOptions()    sys, selenium.webdriver
    # Call Method    ${options}    add_argument    private
    ${firefox}    Set Variable If    '''${BROWSER_HEADLESS}'''.upper() == 'YES'    headlessfirefox    firefox
    Open Browser
    ...    url=${URL_OPENCRUISE_${ENV}}
    ...    browser=${firefox}
    ...    options=${options}

Capture Step ScreenShot
    [Documentation]    Capture avec règle de nommage du fichier
    ...    Le step permet d'identifier l'étape et de faire plusieurs captures par test
    [Arguments]    ${step}
    SeleniumLibrary.Capture Page Screenshot    ${OUTPUT DIR}${/}${FILENAME}_${step}.png
    IF    '''${step}''' == 'FAIL'
        ${html}    SeleniumLibrary.Get Source
        OperatingSystem.Create File
        ...    path=${OUTPUT DIR}${/}${FILENAME}_${step}.html
        ...    content=${html}
        ...    encoding=UTF-8
    END

Capture Step Element ScreenShot
    [Documentation]    Capture avec règle de nommage du fichier
    ...    Le step permet d'identifier l'étape et de faire plusieurs captures par test
    [Arguments]    ${step}    ${locator}
    SeleniumLibrary.Capture Element Screenshot    ${locator}    ${OUTPUT DIR}${/}${FILENAME}_${step}.png

Test Teardown
    [Documentation]    Test Teardown
    # Reload translate FR
    ${translate}    JSONLibrary.Load Json From File    %{PROJECT_FOLDER}/tests/data-env/lang-fr.json    encoding=utf-8
    Set Global Variable    ${TRANSLATE}    ${translate}
    Capture Step ScreenShot    ${TEST_STATUS}
    Close All Browsers

Suite Teardown
    [Documentation]    Suite Teardown
    Log To Console    ${EMPTY}
