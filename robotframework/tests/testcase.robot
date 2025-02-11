*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${standard_user}              standard_user
${locked_out_user}            locked_out_user
${problem_user}               problem_user
${performance_glitch_user}    performance_glitch_user
${error_user}                 error_user
${visual_user}                visual_user
${password}                   secret_sauce

*** Keywords ***
Open Web
    Open Browser    https://www.saucedemo.com/    chrome    options=add_argument("--headless")

Login
    [Arguments]    ${UserName}    ${password}
    Input Text    id=user-name    ${UserName}
    Input Text    id=password    ${password}
    Click Button    id=login-button

*** Test Cases ***
Verify valid login
    Open Web
    Login    ${standard_user}    ${password}
    Wait Until Page Contains    Swag Labs
    Close Browser

Verify login User invalid 
    Open Web
    Login    ${standard_user}    1234
    Wait Until Page Contains    Epic sadface: Username and password do not match any user in this service
    Close Browser

Verify login Password invalid
    Open Web
    Login    Peerapong    ${password}
    Wait Until Page Contains    Epic sadface: Username and password do not match any user in this service
    Close Browser

Verify locked-out user login
    Open Web
    Login    ${locked_out_user}    ${password}
    Close Browser