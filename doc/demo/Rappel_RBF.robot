*** Settings ***
Documentation       Permet d'avoir des exemples d'utilisation de Robot Framework
...                 \nC'est un condensé de tout ce que l'on doit connaitre avant de faire des tests Selenium/Appium
...                 \nC'est un résumé du User Guide et des keywords indispensables de la librairie Builtin
Metadata            Version    1.0
Metadata            Date    18/10/2020
Metadata            Author    eric.mersier@sogeti.com

Library             OperatingSystem
Library             Collections
Library             String
Library             DateTime

Suite Setup         Log Report And Console    Global Suite Setup
Suite Teardown      Log Report And Console    Global Suite Teardown
Test Setup          testSetup
Test Teardown       testTeardown

# permet de forcer un tag sur tous les tests
Force Tags          tnr


*** Variables ***
${myString}         TEST
${myString1}        VALUE
${myString2}        c'est mon test
${myNumber}         ${2}
${myNumber1}        ${4}
${myNumber2}        ${7}
${myFloat}          ${3.14}
${myBoolean}        ${TRUE}
${global_var}
@{MANY_LIST}        un    deux    trois    quatre
&{DICT1}            un=${1}    deux=${2}    ${3}=trois    TEST=XXXXX    xx=56
&{DICT2}            A=w    B=x    C=y    D=z
${NOM PRENOM}       DUPOND JEAN
${CLEF}             NOM
@{LIST0}            D    4
@{LIST1}            one    two    three
@{LIST2}            robot framework    selenium    appium    gherkin
@{LIST3}            Good Element 1    Break On Me    Good Element 2
${ENV}              DEV
&{REC_COMPTE}       prenom=Jean    nom=DUPOND    mail=jean.dupond@test.com    mdp=27xuPnR6    dateNaissance=10/10/2000
&{DEV_COMPTE}       prenom=Hugo    nom=DUPONT    mail=hugo.dupont@test.com    mdp=nbeBy2Hg    dateNaissance=03/03/1990
&{OK_COMPTE}        prenom=Hugo    nom=DUPONT    mail=hugo.dupont@test.com    mdp=nbeBy2Hg    dateNaissance=03/03/1990
@{IBAN}             FR7630001007941234567890185    FR7630004000031234567890143    FR7630006000011234567890189
...                 FR7610107001011234567890129    FR7611315000011234567890138    FR7630002032531234567890168
...                 FR7630056009271234567890182    FR7611808009101234567890147    FR7610011000201234567890188
...                 FR7630076020821234567890186    FR7614410000011234567890163    FR7612548029981234567890161
...                 FR7630007000111234567890144    FR7642559000011234567890121    FR7641199110541234567890180


*** Test Cases ***
TC Log
    [Documentation]    Utilisation des logs
    Log    hello
    BuiltIn.Log    <b>Hello</b>, <font color="red">world!</font>    html=True
    BuiltIn.Log    TEST    level=WARN    html=False    console=True
    Log To Console    message
    Log Report And Console    TEST

TC Acces Variables And Log Variables
    [Documentation]    Utilisation des variables
    [Tags]    tnr    var
    # Variables natives à Robot Framework
    Log Report And Console    ${/}
    Log Report And Console    ${:}
    Log Report And Console    ${\n}
    Log Report And Console    ${CURDIR}
    Log Report And Console    ${TEMPDIR}
    Log Report And Console    ${EXECDIR}
    Log Report And Console    ${OUTPUT DIR}
    Log Report And Console    ${SUITE NAME}
    Log Report And Console    ${TEST NAME}
    Log Report And Console    ${TEST DOCUMENTATION}
    Log Report And Console    ${TEST TAGS}
    Log Report And Console    ${EMPTY}
    Log Report And Console    (${EMPTY})
    Log Report And Console    (${SPACE})
    Log Report And Console    XXXX${SPACE * 5}XXXX
    Log Report And Console    ${NONE} and ${NULL}
    # Acces aux variables définies en variables globales
    Log Report And Console    ${myString} ${myNumber} ${myFloat} ${myBoolean}
    ${typeFloat}    BuiltIn.Evaluate    type(${myFloat})
    Log Report And Console    ${typeFloat}
    # acces aux listes
    Log Report And Console    ${MANY_LIST}
    Log Report And Console    ${MANY_LIST}[0]
    Log Report And Console    ${myString}\[0]
    Log Report And Console    ${MANY_LIST}[${myNumber}]
    # commence à l'index 1
    Log Report And Console    ${MANY_LIST}[1:]
    # termine à l'index 2
    Log Report And Console    ${MANY_LIST}[:2]
    # commence à l'index 2 et fini à l'avant dernier index
    Log Report And Console    ${MANY_LIST}[2:-1]
    # commence à l'index 1 et fini à l'avant avant dernier index
    Log Report And Console    ${MANY_LIST}[1:-1:2]
    # enlève les index multiples de 2
    Log Report And Console    ${MANY_LIST}[::2]
    # acces aux dictionnaires
    Log Report And Console    ${DICT1}
    Log Report And Console    ${DICT1.deux}
    Log Report And Console    ${DICT1}[deux]
    Log Report And Console    ${${CLEF} PRENOM}
    Log Report And Console    ${DICT1.${myString}}
    # définir une variable locale
    ${local_var}    BuiltIn.Set Variable    TEST
    # exposer la variable locale en variable globale ayant le même nom
    BuiltIn.Set Global Variable    ${local_var}
    # exposer la variable locale en variable globale ayant un nom différent
    BuiltIn.Set Global Variable    ${global_var}    ${local_var}
    BuiltIn.Set Global Variable    ${global_var}    NEW VALUE

TC Get Environment Variable
    [Documentation]    Utilisation des variables d'environnement
    # depuis la librairie OperatingSystem
    ${OS1}    OperatingSystem.Get Environment Variable    OS
    ${COMPUTERNAME1}    OperatingSystem.Get Environment Variable    COMPUTERNAME
    Log Report And Console    ${OS1}, ${COMPUTERNAME1}
    # depuis un accès direct par %{envname}
    Log Report And Console    %{OS}, %{COMPUTERNAME}

TC Run Keyword If
    [Documentation]    Utilisation des conditions
    ...    Les conditions sont des expressions python
    ...    Les résultats des conditions doivent renvoyer un booléen (${True} / ${False})
    ...    Voir les opérateurs ==, !=, <, >, <=, >=
    ...    Voir les opérateurs and et or pour de multiples conditions
    ...    Permet d'utiliser toutes les méthodes python d'évaluations / comparaisons
    ...    type("test").__name__ == "str"
    ...    isinstance("test", str)
    ...    isinstance(True, bool)
    ...    isinstance(5, int)
    ...    isinstance(3.1415, float)
    ...    isinstance(["kk", "yy", 5], list)
    IF    ${True}    Log Report And Console    OK
    IF    not(${False})    Log Report And Console    OK
    BuiltIn.Run Keyword Unless    ${False}    Log Report And Console    OK
    IF    '${myString}' == 'TEST'    Log Report And Console    OK
    IF    '${myString}' == '${myString}'    Log    message

    BuiltIn.Run Keyword Unless    '${myString}' != 'TEST'    Log Report And Console    OK
    # mettre des triples quottes pour protéger les chaines contenant des quottes
    IF    '''${myString2}''' == '''c'est mon test'''
        Log Report And Console    OK
    END
    # la condition se fait si une sous chaine de caractère existe dans une autre chaine de caractère
    IF    """c'est""" in """${myString2}"""    Log Report And Console    OK
    # la condition se fait si la chaine de caractère existe dans une liste
    IF    'un' in @{MANY_LIST}    Log Report And Console    OK
    # combiner les conditions
    IF    ('un' in @{MANY_LIST} and ('${myString}' == 'X' or '${myString}' == 'TEST'))
        Log Report And Console    OK
    END

TC Run Keyword If And Set Variable
    [Documentation]    Combiner deux keywords Run Keyword If et Set Variable
    # Assigner une variable avec une condition
    IF    ${myNumber} > 0
        ${myString1}    BuiltIn.Set Variable    NEW_VALUE
    ELSE
        ${myString1}    Set Variable    ${None}
    END
    # si la condition est fausse, on perd la valeur initiale
    IF    ${myNumber} < 0
        ${myString1}    BuiltIn.Set Variable    NEW_VALUE
    ELSE
        ${myString1}    Set Variable    ${None}
    END
    # dans ce cas faire le ELSE pour réaffecter la valeur initiale de la même variable
    IF    ${FALSE}
        ${myString1}    BuiltIn.Set Variable    NEW_VALUE
    ELSE
        ${myString1}    BuiltIn.Set Variable    ${myString1}
    END
    # ou affecter une nouvelle valeur
    IF    ${FALSE}
        ${myString1}    BuiltIn.Set Variable    NEW_VALUE
    ELSE
        ${myString1}    BuiltIn.Set Variable    SECOND_VALUE
    END

    IF    ${True}
        ${myTestFalse}    test_return
    ELSE
        ${myTestFalse}    Set Variable    ${None}
    END
    IF    ${False}
        ${myTestTrue}    test_return
    ELSE
        ${myTestTrue}    BuiltIn.Set Variable    NULL
    END

TC Set Variable If
    [Documentation]    Plus simple pour assigner une variable suivant une condition, le second paramètre remplace le ELSE
    ${myString1}    BuiltIn.Set Variable If    ${TRUE}    VALUE_TRUE    VALUE_FALSE    # VALUE_TRUE
    ${myString1}    BuiltIn.Set Variable If    ${FALSE}    VALUE_TRUE    # NONE
    ${myString1}    BuiltIn.Set Variable If    ${FALSE}    VALUE_TRUE    VALUE_FALSE    # VALUE_FALSE
    ${myString1}    BuiltIn.Set Variable If    ${FALSE}    VALUE_TRUE    ${myString1}    # conserve la valeur initiale

TC Should Contain PASS
    [Documentation]    Les keywords commençant par Should permettent de mettre des points de vérification
    BuiltIn.Should Be Equal    ${myString}    ${myString}
    BuiltIn.Should Be Equal    TEST    test    ignore_case=True
    BuiltIn.Should Be Equal As Strings    ${myString}    ${myString}
    BuiltIn.Should Be Equal As Integers    ${myNumber}    ${myNumber}

TC Should Contain FAIL1
    [Documentation]    Les keywords commençant par Should permettent de mettre des points de vérification
    ...    Si la condition est fausse, l'instruction est en erreur et cela arrête le test en mettant un statut FAIL et en affichant l'erreur
    BuiltIn.Should Be Equal    ${myNumber}    ${myString}

TC Should Contain FAIL2
    [Documentation]    Les keywords commençant par Should permettent de mettre des points de vérification
    ...    Si la condition est fausse, l'instruction est en erreur et cela arrête le test en mettant un statut FAIL et en affichant l'erreur
    BuiltIn.Should Be Equal As Integers    ${myNumber}    ${myString}

TC Should Contain FAIL3
    [Documentation]    Les keywords commençant par Should permettent de mettre des points de vérification
    ...    Si la condition est fausse, l'instruction est en erreur et cela arrête le test en mettant un statut FAIL et en affichant l'erreur
    ...    On peut définir notre propre message msg=message spécifique    values=False pour ne pas afficher le résultat standard de comparaison
    BuiltIn.Should Be Equal
    ...    ${myNumber}
    ...    ${myString}
    ...    msg=Les deux valeurs sont différentes : ${myNumber} <> ${myString}
    ...    values=False

TC Run Keyword And Return Status
    [Documentation]    Gérer les erreurs (exemple sur les Should)
    ...    Le Run Keyword And Return Status renvoi un booléen True/False permettant de gérer l'exception
    ${contains}    BuiltIn.Run Keyword And Return Status    BuiltIn.Should Contain    ${myString1}    VALUE
    ${status}    BuiltIn.Run Keyword And Return Status    BuiltIn.Should Be Equal As Strings    first    second
    # gestion de l'erreur
    IF    ${status} == ${False}
        Log Report And Console    ACTION A REALISER EN CAS D'ERREUR
    END
    # plus simple avec Unless (contraire de if)
    BuiltIn.Run Keyword Unless    ${status}    Log Report And Console    ACTION A REALISER EN CAS D'ERREUR

TC Run Keyword And Ignore Error PASS
    [Documentation]    Gérer les erreurs (exemple sur les Should)
    ...    Le Run Keyword And Ignore Error ne renvoi pas un booléen
    ...    Il renvoi deux valeurs
    ...    Un statut en String PASS ou FAIL
    ...    La valeur renvoyée par le keyword appelé, si ce keyword renvoit bien une valeur depuis son bloc Return
    ${status}    ${value}    BuiltIn.Run Keyword And Ignore Error    BuiltIn.Should Contain    ${myString2}    XXX
    Log Report And Console    statut=${status}, message=${value}
    IF    '${status}' == 'FAIL'
        Log Report And Console    ACTION A REALISER EN CAS D'ERREUR
    END

TC Run Keyword And Ignore Error FAIL
    [Documentation]    Gérer les erreurs (exemple sur les Should)
    ...    On utilise maintenant le Keyword Fail pour mettre le test en erreur
    ...    On peut mémoriser les différentes erreurs et décider à tout moment de mettre le test en erreur
    ${status1}    ${value1}    BuiltIn.Run Keyword And Ignore Error    BuiltIn.Should Contain    ${myString}    XXX
    # d'autres actions
    # ...
    # ...
    ${status2}    ${value2}    BuiltIn.Run Keyword And Ignore Error    BuiltIn.Should Contain    ${myString}    YYY
    # ...
    IF    '${status1}' == 'FAIL' and '${status2}' == 'FAIL'
        BuiltIn.Fail    TEST EN ERREUR\nstatut1=${status1}, message1=${value1}\nstatut2=${status2}, message2=${value2}
    END

TC Run Keyword And Continue On Failure FAIL
    [Documentation]    Gérer les erreurs (exemple sur les Should)
    BuiltIn.Run Keyword And Continue On Failure    BuiltIn.Should Contain    ${myString}    XXX
    # le test continu
    BuiltIn.Should Contain    ${myString}    TEST
    # le test récupère automatiquement l'erreur de la première étape

TC For In Range
    [Documentation]    Utilisation des boucles IN RANGE
    ...    ne plus utiliser l'ancienne syntaxe :FOR et \
    ...    utiliser FOR et END
    ...    l'index de fin est exclu, si l'index de début est omis on commence à 0
    FOR    ${INDEX}    IN RANGE    3
        Log Report And Console    ${INDEX}
    END
    FOR    ${INDEX}    IN RANGE    3
        Log Report And Console    ${INDEX}
    END
    FOR    ${INDEX}    IN RANGE    1    3
        Log Report And Console    ${INDEX}
    END
    ${count}    BuiltIn.Get Length    ${LIST1}
    FOR    ${INDEX}    IN RANGE    0    ${count}
        Log Report And Console    index=${INDEX} : valeur=${LIST1}[${INDEX}]
    END

TC For In List
    [Documentation]    Utilisation des boucles IN List
    ...    nous parcourons les éléments de la liste sans connaitre l'index
    FOR    ${ELEMENT}    IN    @{IBAN}
        Log Report And Console    ${ELEMENT}
    END
    FOR    ${ELEMENT}    IN    @{LIST3}
        Log Report And Console    ${ELEMENT}
        IF    '${ELEMENT}' == 'Break On Me'    BREAK
        Log Report And Console    Do more actions here ...
    END
    # sur la liste des variables d'environnements
    &{env_dict}    OperatingSystem.Get Environment Variables
    @{env_list}    Collections.Get Dictionary Items    ${env_dict}
    FOR    ${key}    ${value}    IN    @{env_list}
        Log Report And Console    Clef='${key}' \t Valeur='${value}'
    END

TC For In Dictionary
    [Documentation]    Utilisation des boucles IN Dictionary
    ...    nous parcourons les clefs / valeurs
    FOR    ${key}    ${value}    IN    &{DICT1}
        Log Report And Console    Clef='${key}' Valeur='${value}'
    END
    FOR    ${item}    IN    &{DICT2}
        Log Report And Console    Clef='${item}[0]' Valeur='${item}[1]'
    END

TC For In Zip
    [Documentation]    Utilisation des boucles IN ZIP
    ...    Permet de boucler sur le même index de plusieurs liste
    ...    Se base sur la liste ayant le moins d'éléments
    FOR    ${a}    ${b}    ${c}    IN ZIP    ${LIST1}    ${LIST2}    ${LIST3}
        Log Report And Console    ${a}, ${b}, ${c}
    END
    FOR    ${items}    IN ZIP    ${LIST1}    ${LIST2}    ${LIST3}
        Log Report And Console    ${items}[0], ${items}[1], ${items}[2]
    END

TC For In Enumerate
    [Documentation]    Utilisation des boucles IN ENUMERATE
    ...    Permet de récupérer l'index
    FOR    ${index}    ${item}    IN ENUMERATE    @{LIST1}
        Log Report And Console    index=${index} : valeur=${item}
    END
    # si on récupère qu'un item alors fusion des deux listes
    FOR    ${index}    ${item}    IN ENUMERATE    @{LIST1}    @{LIST2}
        Log Report And Console    index=${index} : valeur=${item}
    END
    # sinon on parcourt les deux listes en // mais il faut que les deux listes soient de même taille
    FOR    ${index}    ${item1}    ${item2}    IN ENUMERATE    @{LIST1}    @{LIST3}
        Log Report And Console    index=${index} : valeur1=${item1} : valeur2=${item2}
    END
    # sur les dictionnaires
    FOR    ${item}    IN ENUMERATE    &{DICT2}
        Log Report And Console    Index=${item}[0] Clef='${item}[1]' Clef='${item}[2]'
    END
    FOR    ${index}    ${item}    IN ENUMERATE    &{DICT2}
        Log Report And Console    Index=${index} Clef='${item}[0]' Clef='${item}[1]'
    END

TC Exit For Loop
    [Documentation]    Utilisation de Exit For Loop If
    FOR    ${INDEX}    IN RANGE    10
        Log Report And Console    ${INDEX}
        IF    ${INDEX} == 3    BREAK
    END

TC Repeat Keyword
    BuiltIn.Repeat Keyword    2    Log Report And Console    Repeating this ...

TC Random
    [Documentation]    Utilisation du random
    ${randomNumber}    String.Generate Random String    5    [NUMBERS]
    ${randomNumber}    Generate random string    13    123456789
    ${randomEmail}    BuiltIn.Set Variable    %{COMPUTERNAME}_${randomNumber}@yopmail.com
    ${ret}    Generate Random String
    ${low}    Generate Random String    12    [LOWER]
    ${bin}    Generate Random String    8    01
    ${hex}    Generate Random String    20    [NUMBERS]xy

TC Evaluate
    [Documentation]    Utilisation d'évaluation d'instructions python
    ${resultat}    BuiltIn.Evaluate    ${myNumber1}+${myNumber2}
    ${resultat}    BuiltIn.Set Variable    ${myNumber} + 10
    ${randomNumber}    Evaluate    random.randint(0,9)    modules=random
    ${randomNumberList}    Evaluate    random.sample(range(1, 11), 4)    modules=random
    ${min}    BuiltIn.Set Variable    ${1}
    ${max}    BuiltIn.Set Variable    ${10}
    ${random}    Evaluate    random.randint(${min}, ${max})    modules=random, sys
    ${testTitle}    BuiltIn.Evaluate    'g'=='l'
    ${testPrice}    BuiltIn.Evaluate    'h'=='h'
    ${testAll}    BuiltIn.Evaluate    ${testTitle} and ${testPrice}
    ${mail}    BuiltIn.Set Variable    test@sogeti.com
    # En python : import urllib
    ${urlEncoded2}    Evaluate    urllib.parse.quote("${mail}")    modules=urllib
    ${url}    BuiltIn.Set Variable    http://www.cwi.nl:80/%7Eguido/Python.html
    # En python : from urllib.parse import urlparse
    ${hostname}    Evaluate    urllib.parse.urlparse("${url}").hostname    modules=urllib, urllib.parse

TC Date
    [Documentation]    Utilisation des dates
    ${date_format}    BuiltIn.Set Variable    %d/%m/%Y %H:%M:%S
    ${result_format}    BuiltIn.Set Variable    %Y-%m-%d %H:%M:%S.%mil
    ${date}    DateTime.Get Current Date
    ${date}    DateTime.Subtract Time From Date    ${date}    10000 days    result_format=%d%m%Y
    ${date2}    DateTime.Get Current Date    result_format=${date_format}
    ${date2}    DateTime.Convert Date    ${date2}    date_format=${date_format}    result_format=${result_format}
    ${date3}    DateTime.Get Current Date
    ${date3}    DateTime.Add Time To Date    ${date3}    1 days    result_format=%d/%m/%Y

TC Keyword with parameters In - Out
    [Documentation]    Utilisation des keywords avec paramètres IN/OUT
    ${resultat}    SOMME    ${4}    ${5}
    Log Report And Console    ${resultat}

TC Timeout FAIL
    [Documentation]    Permet de mettre un timeout sur le keyword
    ...    Peut aussi être placé sur le test
    Keyword Teardown
    timeout

TC Local Setup Teardown
    [Documentation]    Permet de mettre voir que les setup teardown globaux sont ignorés, on ne voit que les locaux
    ...    On a pas la combinaison des deux
    ...    Donc si on fait du spécifique et qu'on veut aussi utiliser le global, il faut intégrer les instructions du global
    [Setup]    Log Report And Console    \nLocal Test Setup
    Log Report And Console    Les étapes de test
    [Teardown]    Log Report And Console    Local Test Teardown

TC Use Template With Keyword Arguments
    [Template]    Template Keyword with arguments
    # on peut passer une liste si elle a bien le même nombre d'éléments attentus par le template (ici 2)
    A    1
    B    2
    C    3
    @{LIST0}
    E    5

TC Use Template With Keyword Embeded Arguments
    [Template]    Template Keyword ${x} And ${y}
    A    1
    B    2
    C    3
    D    4
    E    5

TC Check Common Tags
    [Documentation]    vérifier les Tags
    [Tags]    ta    tb    tc
    IF    'TA' in ${TEST TAGS}
        Log Report And Console    'TA' Exist in ${TEST TAGS}
    END
    ${status}    ${commonTag}    Return Common Tag    ['TA','TY']
    ${status}    ${commonTag}    Return Common Tag    ['TX','TY']

TC Ecrire les tests avec le minimum de variables
    [Documentation]    Utilisation des dictionnaires pour limiter le nombre de variables
    ...    Si un keyword utilise plusieurs arguments nom, prénom, mail, etc ...
    ...    Il parait évident de les regrouper dans un dictionnaire car cela correspond à un objet informations du compte
    ...    Les avantages seront :
    ...    Plus besoins de modifier le nombre d'argument sur tous les tests qui appellent ce keyword quand son nombre d'arguments évolue
    ...    Rend les tests plus lisibles
    ...    Permet de simplifier la mise à jour de l'objet compte, le dictionnaire aura une nouvelle Clef/valeur
    Collections.Log Dictionary    ${REC_COMPTE}
    # le keyword reçoit la variable globale du dictionnaire compte et renvoi un nouveau dictionnaire compte qui est une variable locale
    ${local_compte}    Mise a jour de compte    ${REC_COMPTE}
    # la variable locale est bien à jour mais pas la variable globale, ce qui est utile à l'intérieur du test
    Collections.Log Dictionary    ${local_compte}
    Collections.Log Dictionary    ${REC_COMPTE}
    # si je veux rendre disponible cette MAJ pour tous les tests je mets les données de la variable locale dans la variable globale
    # cette pratique est rarement utilisée car chaque test doit être indépendant en termes de données
    BuiltIn.Set Global Variable    ${REC_COMPTE}    ${local_compte}
    # je peux aussi utiliser l'astuce pour évaluer le nom de ma variable compte en fonction de l'environnement choisi
    # cette pratique est fortement utilisée quand vous créez des variables par environnement
    Log Report And Console    ${ENV}
    Collections.Log Dictionary    ${DEV_COMPTE}
    Collections.Log Dictionary    ${${ENV}_COMPTE}
    ${local_compte}    Mise a jour de compte    ${${ENV}_COMPTE}
    Collections.Log Dictionary    ${local_compte}


*** Keywords ***
Log
    [Arguments]    ${message}
    BuiltIn.Log    ${message}

SOMME
    [Documentation]    Création d'un keyword avec [Arguments] et [Return]
    [Arguments]    ${myNumber1}    ${myNumber2}
    ${resultat}    BuiltIn.Evaluate    ${myNumber1}+${myNumber2}
    RETURN    ${resultat}

Log Report And Console
    [Arguments]    ${message}    ${level}=INFO
    BuiltIn.Log    ${message}    level=${level}    console=True

Return Common Tag
    [Documentation]    Savoir et retrouver les éléments commun entre deux listes
    ...    Astuce en PYTHON permettant de comparer les deux listes en une seule instruction
    ...    len([match for match in ['TA','TY'] if match in ${TEST TAGS}]) > 0
    [Arguments]    ${listTag}
    ${commonTag}    BuiltIn.Evaluate    [match for match in ${listTag} if match in ${TEST TAGS}]
    ${status}    BuiltIn.Evaluate    len(${commonTag}) > 0
    RETURN    ${status}    ${commonTag}

Mise a jour de compte
    [Arguments]    ${compte}
    # etapes de création du compte
    # ... Input Text, Click Element
    # etapes de récupération du numéro du compte créé
    # ... Get Text
    ${randomNumber}    String.Generate Random String    10    [NUMBERS]
    Collections.Set To Dictionary    ${compte}    numeroCompte    ${randomNumber}
    RETURN    ${compte}

testSetup
    # bug dans la console qui ne fait pas de retour à la ligne sur le premier log du test
    Log Report And Console    ${EMPTY}
    Log Report And Console    Global Test Setup

testTeardown
    Log Report And Console    Global Test Teardown
    Log Report And Console    ${TEST STATUS}
    Log Report And Console    ${TEST MESSAGE}
    # permet de mettre aussi un message en cas de test PASS dans la synthèse du rapport
    # en cas de test FAIL vous avez bien sur l'erreur qui est affiché
    IF    '${TEST STATUS}' == 'PASS'
        BuiltIn.Set Test Message    Test OK\nOn pourait mettre la synthèse des étapes/vérificarions effectuées
    END

Keyword Teardown
    [Documentation]    Keyword Teardown
    Log Report And Console    Début Keyword
    [Teardown]    Log Report And Console    Fin Keyword

timeout
    [Documentation]    On peut remarquer que le teardown n'est pas déclenché en cas de timeout
    [Timeout]    0.5s
    BuiltIn.Sleep    1s
    [Teardown]    Erreur Timeout

Erreur Timeout
    Log Report And Console    Erreur de timeout

Template Keyword with arguments
    [Arguments]    ${a}    ${b}
    Log    ${a} ${b}

Template Keyword ${a} And ${b}
    Log    ${a} ${b}

test_return
    RETURN    XXXXXXX

#################################### les paramètres d'exécution
#
# Dans vos run configuration pensez à ajouter le répertoire de sortie --outputdir ./OUTPUT
#
# Voici un exemple de lanceur en ligne de commande
# Le dernier paramètre étant le répertoire ou se situe les test (ne précisez pas le nom de la suite)
# La sélection des tests se fera par les TAGS à l'aide de --include
#
# py -m robot --nostatusrc --outputdir ./OUTPUT --xunit ./TEST-result.xml --include rappel_rbf ./SOCLE/Demo
#
# --variable name:value pour redéfinir vos variables globales (piloter le choix de l'environnement et de la plateforme)
#
