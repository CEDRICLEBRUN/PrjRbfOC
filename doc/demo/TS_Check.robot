*** Settings ***
Library         SeleniumLibrary
Library         OperatingSystem

Test Tags      tnr

Test Setup       Set Global Variable    ${BROWSER_HEADLESS}    no
Test Teardown    Close All Browsers

*** Variables ***
# chrome | chromeperf | chromemobileemulation | edge | firefox
${BROWSER}          chrome
# no | yes (case insensitive, default no if <> yes)
${BROWSER_HEADLESS}    NO

${URL}    http://www.qwant.fr

*** Test Cases ***
Test Web Chrome
    [Documentation]    Test Web Chrome
    Log To Console    \n je lance mon test sur Chrome
    Openchrome
    Step Qwant

Test Web Chrome Headless
    [Documentation]    Test Web Chrome Headless
    Log To Console    \n je lance mon test sur Chrome Headless
    Set Global Variable    ${BROWSER_HEADLESS}    yes
    Openchrome
    Step Qwant

Test Web Chrome Mobile Emulation
    [Documentation]    Test Web Chrome Mobile Emulation
    Log To Console    \n je lance mon test sur Chrome Mobile Emulation
    Openchromemobileemulation
    Step Qwant


Test Web Edge
    [Documentation]    Test Web Edge
    Log To Console    \n je lance mon test sur Edge
    Openedge
    Step Qwant

Test Web Edge Headless
    [Documentation]    Test Web Edge Headless
    Log To Console    \n je lance mon test sur Edge Headless
    Set Global Variable    ${BROWSER_HEADLESS}    yes
    Openedge
    Step Qwant

Test Web Firefox
    [Documentation]    Test Web Firefox
    Log To Console    \n je lance mon test sur Firefox
    Openfirefox
    Step Qwant

Test Web Firefox Headless
    [Documentation]    Test Web Firefox Headless
    Log To Console    \n je lance mon test sur Firefox Headless
    Set Global Variable    ${BROWSER_HEADLESS}    yes
    Openfirefox
    Step Qwant

*** Keywords ***
Step Qwant
    Input Text    name:q    APPIUM
    Element Attribute Value Should Be    name:q    value    APPIUM
    ${testname}    Evaluate    re.sub(r'[\\/*?:"<>| ]',"",'''${TEST_NAME}''')    modules=re
    Capture Page Screenshot    ${OUTPUT_DIR}/${testname}-END.png

Openchrome
    ${options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    incognito    
    Call Method    ${options}    add_argument    ignore-certificate-errors
    ${excludeSwitches}    Create List    enable-automation    enable-logging    disable-popup-blocking
    Call Method    ${options}    add_experimental_option    excludeSwitches    ${excludeSwitches}
    ${browser}    Set Variable If    '''${BROWSER_HEADLESS}'''.upper() == 'YES'    headlesschrome    chrome
    Open Browser
    ...    url=${URL}
    ...    browser=${browser}
    ...    options=${options}

Openchromemobileemulation
    ${options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    incognito    
    Call Method    ${options}    add_argument    ignore-certificate-errors
    ${excludeSwitches}    Create List    enable-automation    enable-logging    disable-popup-blocking
    Call Method    ${options}    add_experimental_option    excludeSwitches    ${excludeSwitches}
    &{mobile_emulation}    Create Dictionary    deviceName    Nexus 7
    Call Method    ${options}    add_experimental_option    mobileEmulation    ${mobile_emulation}
    Open Browser
    ...    url=${URL}
    ...    browser=chrome
    ...    options=${options}

Openedge
    ${options}    Evaluate    sys.modules['selenium.webdriver'].EdgeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    incognito
    Call Method    ${options}    add_argument    ignore-certificate-errors
    ${excludeSwitches}    Create List    enable-automation    enable-logging    disable-popup-blocking
    Call Method    ${options}    add_experimental_option    excludeSwitches    ${excludeSwitches}
    IF    '''${BROWSER_HEADLESS}'''.upper() == 'YES'
        Call Method    ${options}    add_argument    headless
    END
    Open Browser
    ...    url=${URL}
    ...    browser=edge
    ...    options=${options}

Openfirefox
    ${options}    Evaluate    sys.modules['selenium.webdriver'].FirefoxOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    -private
    ${browser}    Set Variable If    '''${BROWSER_HEADLESS}'''.upper() == 'YES'    headlessfirefox    firefox
    Open Browser
    ...    url=${URL}
    ...    browser=${browser}
    ...    options=${options}