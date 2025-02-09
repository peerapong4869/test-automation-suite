*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${standard_user}              standard_user
${locked_out_user}            locked_out_user
${problem_user}               problem_user
${performance_glitch_user}    performance_glitch_user
${error_user}                 error_user
${visual_user}                visual_user

*** Keywords ***
Open Web
    Open Browser    https://www.saucedemo.com/    Chrome

Login standard_user
    Input Text    id=user-name    standard_user
    Input Text    id=password    secret_sauce
    Click Button    id=login-button
    Location Should Contain    /inventory.html

locked_out_user
    Input Text    id=user-name    standard_user
    Input Text    id=password    secret_sauce
    Click Button    id=login-button
    Location Should Contain    /inventory.html

*** Test Cases ***
Login Test
    Open Web
    Login standard_user
    Close Browser

Login Test2s
    Open Web
    Login standard_user
    Close Browser