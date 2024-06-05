*** Settings ***
Library         RequestsLibrary

Test Tags       tnr    api


*** Variables ***
${ENV}          ok
${BASE_URL}     https://opencruise-${ENV}.sogeti-center.cloud


*** Test Cases ***
TC Get Villes
    # SAVOIR FAIRE UN GET SANS PARAMETRES
    Log To Console    \n********************\nGET /api/helper/villes
    ${response}    RequestsLibrary.GET    ${BASE_URL}/api/helper/villes    expected_status=200
    Should Be Equal    ${response.json()}[0][nom]    Casablanca
    Should Be Equal    ${response.json()}[0][pays][nom]    Maroc
    FOR    ${element}    IN    @{response.json()}
        Log To Console    VILLE/PAYS=${element}[nom] ${element}[pays][nom]
    END

TC Get Users Token
    # SAVOIR FAIRE UN POST AVEC PARAMETRES QUERY
    Log To Console    \n********************\nPOST /api/users/signin
    ${response}    RequestsLibrary.POST
    ...    ${BASE_URL}/api/users/signin?username\=%{OPENCRUISE_ADMIN_USER}&password\=%{OPENCRUISE_ADMIN_PWD}
    ...    expected_status=any
    RequestsLibrary.Request Should Be Successful    # succes status 1xx, 2xx
    RequestsLibrary.Status Should Be    200    # ou 4xx, 5xx pour tester un cas négatif (erreur)
    ${token}    BuiltIn.Set Variable    ${response.json()}[token]
    Log To Console    \nTOKEN=\n${token}
    # SAVOIR FAIRE UN GET AVEC PARAMETRES HEADER
    Log To Console    \n********************\nPOST /api/users/allUsers
    &{headers}    Create Dictionary    Authorization    Bearer ${token}
    ${response}    RequestsLibrary.GET    ${BASE_URL}/api/users/allUsers    headers=${headers}    expected_status=200
    Log To Console    \nRESPONSE FIRST USERNAME =${response.json()}[0][username]\n
