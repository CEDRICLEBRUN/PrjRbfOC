*** Settings ***
Documentation       Step Definitions Connexion

Resource            %{PROJECT_FOLDER}/tests/BaseTests.resource
Resource            %{PROJECT_FOLDER}/tests/page-objects/PageConnexion.resource


*** Keywords ***
Choisir Langue
    [Documentation]    Choisir Langue
    [Arguments]    ${language}
    Log To Console    Choisir Langue ${language}
    Set Language    ${language}
    ${translate}    JSONLibrary.Load Json From File
    ...    %{PROJECT_FOLDER}/tests/data-env/lang-${language}.json
    ...    encoding=utf-8
    Set Global Variable    ${TRANSLATE}    ${translate}

Se Connecter
    [Documentation]    Se Connecter
    [Arguments]    ${compte}
    Log To Console    Se connecter ${compte}[username]
    PageConnexion.Set Username    ${compte}[username]
    PageConnexion.Set Password    ${compte}[password]
    PageConnexion.Sign In

Verifier Connexion Ok
    [Documentation]    Verifier Connexion Ok
    [Arguments]    ${compte}
    Log To Console    Verifier Connexion Ok ${compte}[username]
    # Check Connection    Bienvenue formation admin
    BasePages.Check Connection    ${TRANSLATE}[common][header][welcome] ${compte}[nom] ${compte}[prenom]

Verifier Connexion Ko
    [Documentation]    Verifier Connexion Ko
    ...    CNX_ERROR_00001 identifiant invalide
    ...    CNX_ERROR_00003 compte bloqué
    [Arguments]    ${code_erreur}
    Log To Console    Verifier Connexion Ko
    BasePages.Check Message Erreur    ${TRANSLATE}[exception][connexion][${code_erreur}]

Se Deconnecter
    [Documentation]    Se Deconnecter
    Log To Console    Se Deconnecter
    BasePages.Log Off
