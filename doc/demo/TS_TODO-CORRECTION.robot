*** Settings ***
Library             SeleniumLibrary

Test Teardown       SeleniumLibrary.Close Browser

Test Tags           tnr

*** Variables ***
# variable SUT
${URL}                      https://todomvc.com/examples/angular/dist/browser/#/all
# ${URL}                    https://todomvc.com/examples/vue/dist/#/
# ${URL}                    https://todomvc.com/examples/react/dist/

# variable CONF
${BROWSER}                  chrome
# page object model
${LOCATOR_TITLE}            xpath://h1
${LOCATOR_INPUT_NEWTODO}    css:input.new-todo
${LOCATOR_BUTTON_CLEAR}     css:button.clear-completed
${LOCATOR_TODO_COUNT}       css:.todo-count


*** Test Cases ***
Sceanrio TODO
    [Documentation]
    ...    \n0) Exercices sur le site angular
    ...    \n1) scenario d'ajout de 3 todo
    ...    \n2) traitement d'une tache
    ...    \n3) supression d'une tache
    ...    \n4) contrôle supplémentaire
    ...    \n5) tester sur d'autres sites react/vue
    Launch Todo
    SeleniumLibrary.Capture Page Screenshot    ${OUTPUT_DIR}/step01-initial.png
    Add Todo    SELENIUM
    Add Todo    APPIUM
    Add Todo    PYTHON
    SeleniumLibrary.Capture Page Screenshot    ${OUTPUT_DIR}/step02-addTodo.png
    SeleniumLibrary.Wait Until Element Contains    ${LOCATOR_TODO_COUNT}    3 items left
    Select Todo    APPIUM
    SeleniumLibrary.Capture Page Screenshot    ${OUTPUT_DIR}/step03-selectTodo.png
    Clear Todo
    SeleniumLibrary.Capture Page Screenshot    ${OUTPUT_DIR}/step04-clearTodo.png
    SeleniumLibrary.Wait Until Element Contains    ${LOCATOR_TODO_COUNT}    2 items left
    Delete Todo    PYTHON
    SeleniumLibrary.Capture Page Screenshot    ${OUTPUT_DIR}/step05-deleteTodo.png
    SeleniumLibrary.Wait Until Element Contains    ${LOCATOR_TODO_COUNT}    1 item left

*** Keywords ***
# page object model

Launch Todo
    SeleniumLibrary.Open Browser    ${URL}    ${BROWSER}
    SeleniumLibrary.Set Browser Implicit Wait    1s
    SeleniumLibrary.Wait Until Location Contains    angular
    SeleniumLibrary.Wait Until Element Contains    ${LOCATOR_TITLE}    Todos    timeout=5s

Add Todo
    [Arguments]    ${todo_name}
    SeleniumLibrary.Input Text    ${LOCATOR_INPUT_NEWTODO}    ${todo_name}
    SeleniumLibrary.Press Keys    ${LOCATOR_INPUT_NEWTODO}    RETURN
    SeleniumLibrary.Wait Until Element Contains    xpath://ul    ${todo_name}

Select Todo
    [Arguments]    ${todo_name}
    SeleniumLibrary.Click Element    //li[contains(.,"${todo_name}")]//input[@type="checkbox"]


Clear Todo
    SeleniumLibrary.Click Element    ${LOCATOR_BUTTON_CLEAR}

Delete Todo
    [Arguments]    ${todo_name}
    SeleniumLibrary.Mouse Over    //li[contains(.,"${todo_name}")]
    SeleniumLibrary.Click Element    //li[contains(.,"${todo_name}")]//button[@class="destroy"]