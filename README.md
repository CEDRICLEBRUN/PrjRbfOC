# PROJET ROBOT FRAMEWORK SELENIUM

Ce projet est un modèle de test automatisés sur  
[Robot Framework](https://robotframework.org/)  
[Robot Framework Documentation](https://robotframework.org/robotframework/)  
[SeleniumLibrary Documentation](https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html)  
En utilisant l'IDE Visual Studio Code et l'extension Robot Framework Langage Server   
[Visual Studio Code](https://code.visualstudio.com/)  
[Robot Framework Langage Server](https://marketplace.visualstudio.com/items?itemName=robocorp.robotframework-lsp)  

# INSTALLATION

**projet validé avec python 3.11**  
**Selenium 4.11.0 qui ne nécessite plus de télécharger le webdriver**  
https://www.selenium.dev/blog/2023/whats-new-in-selenium-manager-with-selenium-4.11.0/  
Les drivers seront téléchargés automatiquement ici  
%USERPROFILE%\.cache\selenium  


Vous devez créer un environnement virtuel Python nommé venv à la racine du projet  
```
py -m venv venv
```
Vous devez activer l'environnement virtuel et installer les packages de requirements.txt   
```
venv\Scripts\activate
py -m pip install -U pip setuptools wheel
py -m pip install -r requirements.txt
```

# UTILISATION


Il est important de déclarer deux variables d'environnement contenant les informations du compte ADMIN  

- OPENCRUISE_ADMIN_USER
- OPENCRUISE_ADMIN_PWD

la commande setx permet de se passer des écrans Windows, les variables seront enregistrer de manière permanente contrairement à la commande set   

```
setx OPENCRUISE_ADMIN_USER admin@formation.com  
setx OPENCRUISE_ADMIN_PWD leMotDePasse  
```

Les fichiers de configuration sous .vscode permettent de lancer les tests depuis l'IDE  
 
- settings.json
- launch.json


Pour lancer les tests en ligne de commande (utilisez set à la place de setx)  
Vous devez déclarer PROJECT_FOLDER  

En PS  
```
$env:PROJECT_FOLDER = $pwd  
```
En CMD  
```
set PROJECT_FOLDER=%CD%  
```

```
venv\Scripts\activate

py -m robot --outputdir output --variable BROWSER:chrome --include web tests\testsuites
ou
robot -d output -v BROWSER:edge -i jira-01 tests\testsuites

```