*** Settings ***
# Dans notre launch.json,
# on a paramétré de lancer que les tests tagué tnr
Force Tags      tnr


*** Variables ***
@{LIST1}    Un    Deux    Trois    Quatre    Cinq    six    sept
@{LIST2}    Un    Deux    Trois    Quatro    Cinq    N/A    sept



*** Test Cases ***
Test01 Log
    Log To Console    Hello Word

Test02 Log
    Log Bold Welcome

Test03 Log
    Log Welcome Name    Julien
    Log Welcome Name    Julie
    Log Bold And Color    WELCOME${SPACE*4}%{USERNAME}
    Log Bold And Color    WELCOME %{USERNAME}    blue
    Log Bold And Color    WELCOME %{USERNAME}    \#b562cc

Test11 Division
    ${resultat}    Division    10    2
    Should Be Equal As Numbers    5    ${resultat}

Test12 Division
    ${resultat}    Division    10    3
    Should Be Equal As Numbers    3    ${resultat}

Test13 Division
    ${resultat}    Division    10    2
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    5    ${resultat}
    ${resultat}    Division    10    3
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    3    ${resultat}
    ${resultat}    Division    27    9
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    3    ${resultat}
	
Test13 Bis Division
    ${resultat}    Division    10    2
    Compare Two Numbers    5    ${resultat}
    ${resultat}    Division    10    3
    Compare Two Numbers    3    ${resultat}
    ${resultat}    Division    27    9
    Compare Two Numbers    3    ${resultat}

Test20 Boucle Methode1
    [Documentation]    la méthode la plus simple et la plus robuste car prend la longuer du tableau la plus faible
    FOR    ${el1}    ${el2}    IN ZIP    ${LIST1}    ${LIST2}
        Exit For Loop If    '${el1}' == 'N/A' or '${el2}' == 'N/A'
        Run Keyword And Continue On Failure    Should Be Equal As Strings    ${el1}    ${el2}
    END

Test20 Boucle Methode2
    # TODO penser à déterminer la plus petite taille des deux listes
    ${length1}    Get Length    ${LIST1}
    ${length2}    Get Length    ${LIST2}
    ${length}    Evaluate    min([${length1},${length2}])
    # ou en une seule ligne python
    ${lengh}    Evaluate    min([len(${LIST1}),len(${LIST2})])
    FOR    ${index}    IN RANGE    ${length}
    # on peut aussi faire un break à la place du Exit For Loop If
        IF    '${LIST1}[${index}]' == 'N/A' or '${LIST2}[${index}]' == 'N/A'    BREAK
        Run Keyword And Continue On Failure    Should Be Equal As Strings    ${LIST1}[${index}]    ${LIST2}[${index}]
    END

Test20 Boucle Methode3
    ${length2}    Get Length    ${LIST2}
    FOR    ${INDEX}    ${VALUE1}    IN ENUMERATE    @{LIST1}
        # si length2 = 3, les index possibles sont 0,1,2 donc à 3 on sort pour éviter index out of range
        Exit For Loop If    ${INDEX} == ${length2}
        Log To Console    \nindex=${INDEX}
        ${VALUE2}    Set Variable    ${LIST2}[${INDEX}]
        Log To Console    value1=${VALUE1} value2=${VALUE2}
        Exit For Loop If    '${VALUE1}' == 'N/A' or '${VALUE2}' == 'N/A'
        Run Keyword And Continue On Failure    Should Be Equal As Strings    ${VALUE1}    ${VALUE2}
    END

Test30 Square
    ${my_result}    Square    5
    Should Be Equal As Numbers    25    ${my_result}


*** Keywords ***
Log Bold Welcome
    Log    <b ><font style='color:red;'>Welcome</font> %{USERNAME}<b>    html=True

Log Welcome Name
    [Arguments]    ${name}
    Log    Bonjour ${name}

Log Bold And Color
    [Arguments]    ${message}    ${color}=red
    Log    <b style='color:${color};'>${message}</b>    html=True

Division
    [Arguments]    ${nombre1}    ${nombre2}
    ${result}    Evaluate    int(${nombre1}) / int(${nombre2})
    RETURN    ${result}

Square
    [Arguments]    ${number}
    ${result}    Evaluate    int(${number}) ** 2
    RETURN    ${result}
	
Compare Two Numbers
    [Documentation]    converti en nombre mes deux variables
    ...    compare deux nombres avec un message spécifique en cas d'erreur
    ...    Verify : le test continu
    [Arguments]    ${result_expected}    ${result_actual}
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    
    ...    ${result_expected}
    ...    ${result_actual}
    ...    msg=EXPECTED=${result_expected} <> ACTUAL=${result_actual}
    ...    values=${False}    # masque le resultat par defaut exemple 3.0 != 3.333333
