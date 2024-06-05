*** Settings ***
Documentation       Step Definitions Souscription

Library             String
Library             Collections
Library             DateTime
Library             JSONLibrary    # Trouver la librairie et faire un pip install dans votre venv
Library             FakerLibrary    locale=fr_FR
Library             %{PROJECT_FOLDER}/libs/Common.py
Resource            %{PROJECT_FOLDER}/tests/page-objects/PageSouscription.resource
Resource            %{PROJECT_FOLDER}/tests/BaseTests.resource


*** Keywords ***
Charger Compte
    [Documentation]    Charger Compte
    [Arguments]    ${json_file}
    Log To Console    Charger Compte ${json_file}
    ${compte}    Load JSON From File    %{PROJECT_FOLDER}/tests/data-env/${json_file}    encoding=utf-8
    RETURN    ${compte}

Generation Mail Aleatoire
    [Documentation]    Generation Mail Aleatoire
    [Arguments]    ${compte}
    ${email}    FakerLibrary.Email    domain=robot.framework.faker.dev
    Log To Console    Generation Mail Aleatoire %{COMPUTERNAME}.%{USERNAME}.${email}
    Set To Dictionary    ${compte}    username=%{COMPUTERNAME}.%{USERNAME}.${email}
    RETURN    ${compte}

Saisir Compte Partie Commune
    [Documentation]    Saisir Compte Partie Commune
    [Arguments]    ${compte}
    Log To Console    Saisir Compte Partie Commune ${compte}
    PageSouscription.Click Register
    PageSouscription.Set Type    ${compte}[type]
    PageSouscription.Set Prenom    ${compte}[prenom]
    PageSouscription.Set Nom    ${compte}[nom]
    # firefox YYYY-MM-DD chromium DDMMYYYY (default)
    IF    '${BROWSER.upper()}' == 'FIREFOX'
        ${compte}[dateNaissance]    Convert Date    ${compte}[dateNaissance]
        ...    date_format=%d%m%Y
        ...    result_format=%Y-%m-%d
    END
    PageSouscription.Set Date Naissance    ${compte}[dateNaissance]
    PageSouscription.Set Adresse    ${compte}[adresse]
    PageSouscription.Set Pays    ${compte}[pays]
    PageSouscription.Set Ville    ${compte}[ville]
    PageSouscription.Set Code Postal    ${compte}[codePostal]
    PageSouscription.Set Passport    ${compte}[passport]
    PageSouscription.Set Cin    ${compte}[cin]
    PageSouscription.Set Email    ${compte}[username]
    PageSouscription.Set Tel    ${compte}[tel]
    PageSouscription.Set Password    ${compte}[password]

Saisir Compte Partie Part
    [Documentation]    Saisir Compte Partie Part
    [Arguments]    ${compte}
    Log To Console    Saisir Compte Partie Part
    PageSouscription.Set Nom Conjoint    ${compte}[nomConjoint]
    PageSouscription.Set Prenom Conjoint    ${compte}[prenomConjoint]
    PageSouscription.Set Date Naissance Conjoint    ${compte}[prenomConjoint]
    Capture Step ScreenShot    SOUSCRIPTION

Saisir Compte Partie Pro
    [Documentation]    Saisir Compte Partie Pro
    [Arguments]    ${compte}
    Log To Console    Saisir Compte Partie Pro
    PageSouscription.Set Raison Sociale    ${compte}[raisonSociale]
    PageSouscription.Set Siret    ${compte}[siret]
    PageSouscription.Set Nombre Salarie    ${compte}[nombreSalarie]
    Capture Step ScreenShot    SOUSCRIPTION

Valider Souscription
    [Documentation]    Valider Souscription
    Log To Console    Valider Souscription
    PageSouscription.Validate Success

Verifier Souscription Ko
    [Documentation]    Verifier Souscription Ko
    ...    CNX_ERROR_00006 email déjà utilisé
    [Arguments]    ${code_erreur}
    Log To Console    Verifier Souscription Ko
    PageSouscription.Validate Error
    BasePages.Check Message Erreur    ${TRANSLATE}[exception][connexion][${code_erreur}]

Valider Messages Champs Obligatoires
    [Documentation]    Valider Messages Champs Obligatoires
    Log To Console    Valider Messages Champs Obligatoires
    PageSouscription.Click Register
    PageSouscription.Validate Error
    ${mapping}    JSONLibrary.Load Json From File
    ...    %{PROJECT_FOLDER}/tests/data-env/fieldsSoucriptionError.json    encoding=utf-8
    FOR    ${element}    IN    @{mapping.keys()}
        ${formcontrolname}    Set Variable    ${element}
        ${tanslate_key}    Set Variable    ${mapping}[${element}]
        ${expected_message}    Set Variable    ${TRANSLATE}[registerPage][error][${tanslate_key}]
        ${locator_field}    Set Variable    xpath=//*[@formcontrolname='${formcontrolname}']
        ${locator_msg}    Set Variable    ${locator_field}/..//div[@class="invalid-feedback"]
        Log To Console    VERIFY FIELD=${locator_msg} EXPECTED=${expected_message}
        ${present}    Run Keyword And Return Status
        ...    SeleniumLibrary.Wait Until Page Contains Element
        ...    ${locator_msg}
        IF    ${present}
            Run Keyword And Continue On Failure    SeleniumLibrary.Wait Until Element Is Visible    ${locator_msg}
            ...    error=ERROR MESSAGE NOT VISIBLE\nLOCATOR=${locator_field}
            ${actual_message}    SeleniumLibrary.Get Text    ${locator_msg}
            Run Keyword And Continue On Failure
            ...    Should Be Equal As Strings
            ...    ${expected_message}
            ...    ${actual_message}
            ...    msg=ERROR VERIFY TEXT\nLOCATOR=${locator_field}\nEXPECT=${expected_message}\nACTUAL=${actual_message}
            ...    values=${False}
        ELSE
            Run Keyword And Continue On Failure    Fail    ERROR MESSAGE NOT PRESENT\nLOCATOR=${locator_field}
        END
    END
