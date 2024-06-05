*** Settings ***
Library             SeleniumLibrary

Test Teardown       SeleniumLibrary.Close Browser


*** Variables ***
# variable SUT
${URL}                      https://todomvc.com/examples/angular/dist/browser/#/all
# ${URL}                    https://todomvc.com/examples/vue/dist/#/
# ${URL}                    https://todomvc.com/examples/react/dist/

# variable CONF
${BROWSER}                  chrome
# page object model
${LOCATOR_TITLE}            YOU_CAN_DO_IT_LOCATOR
${LOCATOR_INPUT_NEWTODO}    YOU_CAN_DO_IT_LOCATOR
${LOCATOR_BUTTON_CLEAR}     YOU_CAN_DO_IT_LOCATOR


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
    YOU_CAN_DO_IT_KEYWORD    ${OUTPUT_DIR}/step01-initial.png
    Add Todo    SELENIUM
    Add Todo    APPIUM
    Add Todo    PYTHON
    YOU_CAN_DO_IT_KEYWORD    ${OUTPUT_DIR}/step02-addTodo.png
    Select Todo    APPIUM
    YOU_CAN_DO_IT_KEYWORD    ${OUTPUT_DIR}/step03-selectTodo.png
    Clear Todo
    YOU_CAN_DO_IT_KEYWORD    ${OUTPUT_DIR}/step04-clearTodo.png
    Delete Todo    PYTHON
    YOU_CAN_DO_IT_KEYWORD    ${OUTPUT_DIR}/step04-clearTodo.png
    # VERIFICATION A REALISER


*** Keywords ***
# page object model

YOU_CAN_DO_IT_KEYWORD
    [Arguments]    @{arg}
    Log    ${arg}

Launch Todo
    # Ouvrir navigateur
    YOU_CAN_DO_IT_KEYWORD    ${URL}    ${BROWSER}
    # implicit wait
    YOU_CAN_DO_IT_KEYWORD    1s
    # attendre que l'url contient 
    YOU_CAN_DO_IT_KEYWORD    angular
    # attendre que l'élément contient 
    YOU_CAN_DO_IT_KEYWORD    ${LOCATOR_TITLE}    Todos    timeout=5s

Add Todo
    [Arguments]    ${todo_name}
    # Saisir un todo
    YOU_CAN_DO_IT_KEYWORD    ${LOCATOR_INPUT_NEWTODO}    ${todo_name}
    # Soumettre le formulaire
    YOU_CAN_DO_IT_KEYWORD    ${LOCATOR_INPUT_NEWTODO}    TODO_KEY_RETURN
    # attendre que la page contient notre saisie
    YOU_CAN_DO_IT_KEYWORD    ${todo_name}

Select Todo
    [Arguments]    ${todo_name}
    # cliquer sur notre checkbox de sélection de tache
    YOU_CAN_DO_IT_KEYWORD    YOU_CAN_DO_IT_DYNAMIC_LOCATOR_INPUT_CHECKBOX_LI_CONTAINS_USERNAME


Clear Todo
    # cliquer sur clear completed
    YOU_CAN_DO_IT_KEYWORD    ${LOCATOR_BUTTON_CLEAR}

Delete Todo
    [Arguments]    ${todo_name}
    # cliquer sur supprimer la todo
    YOU_CAN_DO_IT_KEYWORD    ${LOCATOR_BUTTON_CLEAR}