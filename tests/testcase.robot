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
    ${chrome_options}=    Create List    --headless --disable-gpu --no-sandbox --disable-dev-shm-usage
    Open Browser    https://www.saucedemo.com/    browser=chrome    options=${chrome_options}

Open Google
    ${chrome_options}=    Create List    --headless --disable-gpu --no-sandbox --disable-dev-shm-usage
    Open Browser    https://www.google.com    browser=chrome    options=${chrome_options}
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
