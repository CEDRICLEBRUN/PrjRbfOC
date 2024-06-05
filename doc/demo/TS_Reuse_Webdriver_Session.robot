*** Settings ***
Library      SeleniumLibrary
Test Tags    tnr

*** Test Cases ***
Test Reused Webdriver Session
    ${options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_experimental_option    debuggerAddress    127.0.0.1:9999
    SeleniumLibrary.Open Browser
    ...    https://www.qwant.com
    ...    chrome
    ...    remote_url=http://127.0.0.1:9515
    ...    options=${options}

