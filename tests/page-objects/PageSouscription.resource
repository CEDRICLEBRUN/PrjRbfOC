*** Settings ***
Resource    BasePages.resource


*** Variables ***
## FORMULAIRE SOUSCRIPTION
${LOCATOR_LINK_REGISTER}                    //a[@href="/register"]
${LOCATOR_INPUT_PRENOM}                     //input[@formcontrolname="nom"]
${LOCATOR_INPUT_NOM}                        //input[@formcontrolname="prenom"]
${LOCATOR_INPUT_DATENAISSANCE}              //input[@formcontrolname="dateNaissance"]
${LOCATOR_INPUT_ADRESSE}                    //input[@formcontrolname="adresse"]
${LOCATOR_SELECT_PAYS}                      //select[@formcontrolname="currentPays"]
${LOCATOR_SELECT_VILLE}                     //select[@formcontrolname="ville"]
${LOCATOR_INPUT_CP}                         //input[@formcontrolname="codePostal"]
${LOCATOR_INPUT_PASSPORT}                   //input[@formcontrolname="passport"]
${LOCATOR_INPUT_CIN}                        //input[@formcontrolname="cin"]
${LOCATOR_INPUT_USERNAME}                   //input[@formcontrolname="username"]
${LOCATOR_INPUT_TEL}                        //input[@formcontrolname="tel"]
${LOCATOR_INPUT_PASSWORD}                   //input[@formcontrolname="password"]
${LOCATOR_INPUT_CONFIRMPASSWORD}            //input[@formcontrolname="confirmPassword"]
## PART
${LOCATOR_INPUT_NOMCONJOINT}                //input[@formcontrolname="nomConjoint"]
${LOCATOR_INPUT_PRENOMCONJOINT}             //input[@formcontrolname="prenomConjoint"]
${LOCATOR_INPUT_DATENAISSANCECONJOINT}      //input[@formcontrolname="dateNaissanceConjoint"]
# PRO
${LOCATOR_SELECT_RAISONSOCIALE}             //select[@formcontrolname="raisonSociale"]
${LOCATOR_INPUT_SIRET}                      //input[@formcontrolname="siret"]
${LOCATOR_SELECT_NOMBRESALARIE}             //select[@formcontrolname="nombreSalarie"]
#
# SOUSCRIRE
${LOCATOR_BUTTON_VALIDER}                   //button[@class="btn btn-primary"]


*** Keywords ***
Click Register
    Click Element    ${LOCATOR_LINK_REGISTER}

Set Type
    [Arguments]    ${index}
    Select Radio Button    type    ${index}

Set Prenom
    [Arguments]    ${texte}
    Input Text    ${LOCATOR_INPUT_PRENOM}    ${texte}

Set Nom
    [Arguments]    ${texte}
    Input Text    ${LOCATOR_INPUT_NOM}    ${texte}

Set Date Naissance
    [Arguments]    ${texte}
    Input Text    ${LOCATOR_INPUT_DATENAISSANCE}    ${texte}

Set Adresse
    [Arguments]    ${texte}
    Input Text    ${LOCATOR_INPUT_ADRESSE}    ${texte}

Set Pays
    [Arguments]    ${texte}
    Select From List By Label    ${LOCATOR_SELECT_PAYS}    ${texte}

Set Ville
    [Arguments]    ${texte}
    Select From List By Label    ${LOCATOR_SELECT_VILLE}    ${texte}

Set Code Postal
    [Arguments]    ${texte}
    Input Text    ${LOCATOR_INPUT_CP}    ${texte}

Set Passport
    [Arguments]    ${texte}
    Input Text    ${LOCATOR_INPUT_PASSPORT}    ${texte}

Set Cin
    [Arguments]    ${texte}
    Input Text    ${LOCATOR_INPUT_CIN}    ${texte}

Set Email
    [Arguments]    ${texte}
    Input Text    ${LOCATOR_INPUT_USERNAME}    ${texte}

Set Tel
    [Arguments]    ${texte}
    Input Text    ${LOCATOR_INPUT_TEL}    ${texte}

Set Password
    [Arguments]    ${texte}
    Input Text    ${LOCATOR_INPUT_PASSWORD}    ${texte}
    Input Text    ${LOCATOR_INPUT_CONFIRMPASSWORD}    ${texte}

Set Nom Conjoint
    [Arguments]    ${texte}
    Input Text    ${LOCATOR_INPUT_NOMCONJOINT}    ${texte}

Set Prenom Conjoint
    [Arguments]    ${texte}
    Input Text    ${LOCATOR_INPUT_PRENOMCONJOINT}    ${texte}

Set Date Naissance Conjoint
    [Arguments]    ${texte}
    Input Text    ${LOCATOR_INPUT_DATENAISSANCECONJOINT}    ${texte}

Set Raison Sociale
    [Arguments]    ${texte}
    Select From List By Label    ${LOCATOR_SELECT_RAISONSOCIALE}    ${texte}

Set Siret
    [Arguments]    ${texte}
    Input Text    ${LOCATOR_INPUT_SIRET}    ${texte}

Set Nombre Salarie
    [Arguments]    ${texte}
    Select From List By Label    ${LOCATOR_SELECT_NOMBRESALARIE}    ${texte}

Validate Success
    Click Element    ${LOCATOR_BUTTON_VALIDER}
    Wait Until Location Contains
    ...    /login
    ...    message=La souscription a échoué car nous sommes pas revenu sur la page de login

Validate Error
    Click Element    ${LOCATOR_BUTTON_VALIDER}
    Wait Until Location Contains    /register
