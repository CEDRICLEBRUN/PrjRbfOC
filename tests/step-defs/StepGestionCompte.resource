*** Settings ***
Documentation       Step Definitions Gestion Compte

Resource            %{PROJECT_FOLDER}/tests/page-objects/PageGestionCompte.resource


*** Keywords ***
Activer Compte
    [Documentation]    Activer Compte
    [Arguments]    ${compte}
    Log To Console    Activer Compte ${compte}
    BasePages.Access Config
    PageGestionCompte.Access Users
    PageGestionCompte.Access Users List
    PageGestionCompte.Activate Account    ${compte}[username]
