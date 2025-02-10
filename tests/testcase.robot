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
    Open Browser    https://www.saucedemo.com/    chrome    options=add_argument("--headless")

Open Google
    Open Browser    https://www.google.com    chrome    options=add_argument("--headless")
    Close Browser

Login standard_user
    Input Text    id=user-name    ${standard_user}
    Input Text    id=password    secret_sauce
    Click Button    id=login-button

Login locked_out_user
    Input Text    id=user-name    ${locked_out_user}
    Input Text    id=password    secret_sauce
    Click Button    id=login-button

*** Test Cases ***
Login Test
    Open Web
    Login standard_user
    Close Browser

Login Test2s
    Open Web
    Login locked_out_user
    Close Browser

Open
    Open Google

