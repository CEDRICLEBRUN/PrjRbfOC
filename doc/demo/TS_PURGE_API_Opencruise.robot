*** Settings ***
Library         Collections
Library         requests

Test Tags       tnr


*** Variables ***
${URL_OPENCRUISE}       http://opencruise-ko.sogeti-center.cloud
${TOKEN_ADMIN}          ${EMPTY}


*** Test Cases ***

Demo
    Log To Console    ${EMPTY}
    ${response}    GET    
    ...    url=https://cat-fact.herokuapp.com/facts/
    ...    verify=${False}
    Log To Console    REQUEST_URL=${response.request.url}
    Log To Console    REQUEST_HEADER=${response.request.headers}
    Log To Console    REQUEST_BODY=${response.request.body}
    Log To Console    RESPONSE_STATUS=${response.status_code}
    Log To Console    RESPONSE_BODY=${response.json()}



Purge Compte
    Log To Console    ${EMPTY}

    # GET ADMIN TOKEN
    ${response_signin}    Sign In    %{OPENCRUISE_ADMIN_USER}    %{OPENCRUISE_ADMIN_PWD}
    Set Global Variable    ${TOKEN_ADMIN}    ${response_signin}[token]

    # GET USER (utilisateur bloqué)
    ${liste_user}    List Users
    FOR    ${user}    IN    @{liste_user}
        IF    'admin'.upper() not in '''${user}[username]'''.upper() and 'sogeti'.upper() not in '''${user}[username]'''.upper()
            Delete User    ${user}[username]
        END
    END

    # GET USER (utilisateur actif, peuvent avoir un panier rempli)
    ${liste_user}    All Users
    FOR    ${user}    IN    @{liste_user}
        IF    'admin'.upper() not in '''${user}[username]'''.upper() and 'sogeti'.upper() not in '''${user}[username]'''.upper()
            Log To Console    ${user}[id] ${user}[nom] ${user}[prenom] ${user}[username]
            ${info_user}    Get User    ${user}[id]
            Collections.Set To Dictionary    ${info_user}    password=Formation33
            # Update password
            Update User    ${info_user}
            # suppression possible du compte que si le panier est vide
            ${response_signin_user}    Sign In    ${info_user}[username]    Formation33
            ${liste_panier}    Get Panier    ${response_signin_user}[token]
            FOR    ${article}    IN    @{liste_panier}
                Delete Panier    ${response_signin_user}[token]    ${article}[id]
            END
            Delete User    ${user}[username]
        END
    END


*** Keywords ***
Sign In
    [Arguments]    ${username}    ${password}
    ${param}    BuiltIn.Set Variable    username=${username}&password=${password}
    # Log To Console    ${param}
    ${response}    POST    ${URL_OPENCRUISE}/api/users/signin?${param}
    # Log To Console    URL=${response.request.url}
    # Log To Console    HEADER=${response.request.headers}
    # Log To Console    BODY=${response.request.body}
    BuiltIn.Should Be Equal As Integers    200    ${response.status_code}
    RETURN    ${response.json()}

List Users
    [Documentation]    Utilisateurs bloqués
    &{headers}    Create Dictionary    Authorization    Bearer ${TOKEN_ADMIN}
    ${response}    GET    url=${URL_OPENCRUISE}/api/users/ListUsers
    ...    headers=${headers}
    # Log To Console    URL=${response.request.url}
    # Log To Console    HEADER=${response.request.headers}
    # Log To Console    BODY=${response.request.body}
    BuiltIn.Should Be Equal As Integers    200    ${response.status_code}
    ${count}    Get Length    ${response.json()}
    Log To Console    COUNT UTILISATEURS BLOQUES=${count}
    RETURN    ${response.json()}

All Users
    [Documentation]    Utilisateurs actifs
    &{headers}    Create Dictionary    Authorization    Bearer ${TOKEN_ADMIN}
    ${response}    GET    url=${URL_OPENCRUISE}/api/users/allUsers
    ...    headers=${headers}
    # Log To Console    URL=${response.request.url}
    # Log To Console    HEADER=${response.request.headers}
    # Log To Console    BODY=${response.request.body}
    BuiltIn.Should Be Equal As Integers    200    ${response.status_code}
    ${count}    Get Length    ${response.json()}
    Log To Console    COUNT UTILISATEURS ACTIFS=${count}
    RETURN    ${response.json()}

Get User
    [Documentation]    Information utilisateur
    [Arguments]    ${user_id}
    &{headers}    Create Dictionary    Authorization    Bearer ${TOKEN_ADMIN}
    ${response}    GET    url=${URL_OPENCRUISE}/api/users/get/${user_id}
    ...    headers=${headers}
    # Log To Console    URL=${response.request.url}
    # Log To Console    HEADER=${response.request.headers}
    # Log To Console    BODY=${response.request.body}
    BuiltIn.Should Be Equal As Integers    200    ${response.status_code}
    RETURN    ${response.json()}

Update User
    [Documentation]    Mise à jour utilisateur
    [Arguments]    ${user_data}
    &{headers}    Create Dictionary    Authorization    Bearer ${TOKEN_ADMIN}
    ${response}    PUT    url=${URL_OPENCRUISE}/api/users/update
    ...    headers=${headers}
    ...    json=${user_data}
    # Log To Console    URL=${response.request.url}
    # Log To Console    HEADER=${response.request.headers}
    # Log To Console    BODY=${response.request.body}
    BuiltIn.Should Be Equal As Integers    200    ${response.status_code}

Get Panier
    [Documentation]    Information Reservation Panier
    [Arguments]    ${user_token}
    &{headers}    Create Dictionary    Authorization    Bearer ${user_token}
    ${response}    GET    url=${URL_OPENCRUISE}/api/reservation/panier
    ...    headers=${headers}
    # Log To Console    URL=${response.request.url}
    # Log To Console    HEADER=${response.request.headers}
    # Log To Console    BODY=${response.request.body}
    BuiltIn.Should Be Equal As Integers    200    ${response.status_code}
    RETURN    ${response.json()}

Delete Panier
    [Documentation]    Information Reservation Panier
    [Arguments]    ${user_token}    ${panier_id}
    &{headers}    Create Dictionary    Authorization    Bearer ${user_token}
    ${response}    DELETE    url=${URL_OPENCRUISE}/api/reservation/delete/${panier_id}
    ...    headers=${headers}
    # Log To Console    URL=${response.request.url}
    # Log To Console    HEADER=${response.request.headers}
    # Log To Console    BODY=${response.request.body}
    BuiltIn.Should Be Equal As Integers    200    ${response.status_code}

Delete User
    [Arguments]    ${user_name}
    &{headers}    Create Dictionary    Authorization    Bearer ${TOKEN_ADMIN}
    ${response_delete}    DELETE    url=${URL_OPENCRUISE}/api/users/delete/${user_name}    headers=${headers}
    # Log To Console    URL=${response.request.url}
    # Log To Console    HEADER=${response.request.headers}
    # Log To Console    BODY=${response.request.body}
    Log To Console    STATUS=${response_delete.status_code}
    Run Keyword And Continue On Failure
    ...    BuiltIn.Should Be Equal As Integers
    ...    200
    ...    ${response_delete.status_code}
    ...    msg=${user_name}
