*** Settings ***
Library    SeleniumLibrary
Library    Screenshot
Suite Setup    Open Web
Suite Teardown    Close Browser

*** Variables ***
${standard_user}                    standard_user
${locked_out_user}                  locked_out_user
${problem_user}                     problem_user
${performance_glitch_user}          performance_glitch_user
${error_user}                       error_user
${visual_user}                      visual_user
${password}                         secret_sauce
${locator_btn_hamberger}            id=react-burger-menu-btn
${locator_btn_logout}               id=logout_sidebar_link
${locator_btn_addtocard}            id=add-to-cart-sauce-labs-backpack
${locator_btn_addcard_details}      id=add-to-cart
${locator_btn_sort}                 xpath=//select[@class='product_sort_container']
${name_a_to_z}                      xpath=//*[@id="header_container"]/div[2]/div/span/select/option[1]
${name_z_to_a}                      xpath=//*[@id="header_container"]/div[2]/div/span/select/option[2]
${price_low_to_hight}               xpath=//*[@id="header_container"]/div[2]/div/span/select/option[3]
${price_hight_to_low}               xpath=//*[@id="header_container"]/div[2]/div/span/select/option[4]
${locator_product_item}             id=item_4_img_link
${locator_btn_backtoproduct}        id=back-to-products
${locator_card_badge}               xpath=//*[@id="shopping_cart_container"]/a/span
${locator_btn_remove_item}          id=remove-sauce-labs-backpack
${locator_btn_remove_item_details}  id=remove

*** Keywords ***
Open Web
    Open Browser    https://www.saucedemo.com/    chrome

Open Web --headless
    Open Browser    https://www.saucedemo.com/    chrome    options=add_argument("--headless")

Login
    [Arguments]     ${UserName}      ${password}
    Input Text      id=user-name     ${UserName}
    Input Text      id=password      ${password}
    Click Button    id=login-button

logout
    Click Element    ${locator_btn_hamberger}
    Click Element    ${locator_btn_logout}

product sort
    [Arguments]    ${sort_by}
    Click Element    ${locator_btn_sort}
    Click Element    ${sort_by} 

*** Test Cases ***
TC-LP-001 Verify valid login
    Login    ${standard_user}    ${password}
    Wait Until Page Contains    Products

TC-LP-002 Verify login User invalid 
    Login    ${standard_user}    1234
    Wait Until Page Contains    Epic sadface: Username and password do not match any user in this service

TC-LP-003 Verify login Password invalid
    Login    Peerapong    ${password}
    Wait Until Page Contains    Epic sadface: Username and password do not match any user in this service

TC-LP-004 Verify locked-out user login
    Login    ${locked_out_user}    ${password}

TC-LP-005 Verify logout functionality
    Login    ${standard_user}    ${password}
    logout
    Wait Until Page Contains    Swag Labs

TC-PLP-001 Verify product list is displayed
    Login    ${standard_user}    ${password}
    Wait Until Element Is Visible    ${locator_btn_addtocard}
    Take Screenshot
    logout

TC-PLP-002 Verify product sorting (Price Low to High)
    Login    ${standard_user}    ${password}
    Wait Until Page Contains    Products
    product sort    ${price_low_to_hight}
    Take Screenshot

TC-PLP-003 Verify product sorting (Price High to Low)
    Login    ${standard_user}    ${password}
    Wait Until Page Contains    Products
    product sort    ${price_hight_to_low}
    Take Screenshot

TC-PLP-004 Verify product details page
    Login    ${standard_user}    ${password}
    Wait Until Page Contains    Products
    Click Element    ${locator_product_item}
    Wait Until Element Is Visible    ${locator_btn_backtoproduct}
    Capture Page Screenshot    Products_Details.png

TC-PLP-005 Verify add to cart from product page
    Login    ${standard_user}    ${password}
    Wait Until Page Contains    Products
    Click Element    ${locator_product_item}
    Click Element    ${locator_btn_addcard_details}
    Wait Until Element Is Visible    ${locator_card_badge}
    Capture Page Screenshot    Products_Add_prolduct.png
    Click Element    ${locator_btn_remove_item_details}

TC-SC-001 Verify adding item to cart
    Login    ${standard_user}    ${password}
    Wait Until Page Contains    Products

TC-SC-002 Verify removing item from cart
    Login    ${standard_user}    ${password}

TC-SC-003 Verify cart icon updates correctly
    Login    ${standard_user}    ${password}

TC-TP-001 Verify checkout with valid data
    Login    ${standard_user}    ${password}

TC-TP-002 Verify checkout with missing fields
    Login    ${standard_user}    ${password}

TC-TP-003 Verify user can cancel checkout
    Login    ${standard_user}    ${password}

TC-OC-001 Verify order completion
    Login    ${standard_user}    ${password}

TC-OC-002 Verify order reset after completion
    Login    ${standard_user}    ${password}

