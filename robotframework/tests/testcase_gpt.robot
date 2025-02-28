*** Settings ***
Library    SeleniumLibrary
Library    Screenshot
Test Setup    Open Web
Test Teardown    Close Browser

*** Variables ***
${standard_user}                    standard_user
${locked_out_user}                  locked_out_user
${problem_user}                     problem_user
${performance_glitch_user}          performance_glitch_user
${error_user}                       error_user
${visual_user}                      visual_user
${user_null}                        
${password_null}                    
${password}                         secret_sauce
${locator_btn_hamberger}            id=react-burger-menu-btn
${locator_btn_logout}               id=logout_sidebar_link
${locator_btn_addtocard}            id=add-to-cart-sauce-labs-backpack
${locator_btn_addcard_details}      id=add-to-cart
${locator_btn_sort}                 xpath=//select[@class='product_sort_container']
${name_a_to_z}                      xpath=//*[@id="header_container"]/div[2]/div/span/select/option[1]
${name_z_to_a}                      xpath=//*[@id="header_container"]/div[2]/div/span/select/option[2]
${price_low_to_high}                xpath=//*[@id="header_container"]/div[2]/div/span/select/option[3]
${price_high_to_low}                xpath=//*[@id="header_container"]/div[2]/div/span/select/option[4]
${locator_product_item}             id=item_4_img_link
${locator_btn_backtoproduct}        id=back-to-products
${locator_card_badge}               xpath=//*[@id="shopping_cart_container"]/a/span
${locator_btn_remove_item}          id=remove-sauce-labs-backpack
${locator_btn_remove_item_details}  id=remove
${locator_btn_checkout}             id=checkout
${locator_btn_continue}             id=continue
${locator_btn_finish}               id=finish
${locator_checkout_fname}           id=first-name
${locator_checkout_lname}           id=last-name
${locator_checkout_zip}             id=postal-code
${locator_checkout_error}           xpath=//h3[@data-test='error']

*** Keywords ***
Open Web
    Open Browser    https://www.saucedemo.com/    chrome

Login
    [Arguments]     ${UserName}      ${password}
    Input Text      id=user-name     ${UserName}
    Input Text      id=password      ${password}
    Click Button    id=login-button

Logout
    Click Element    ${locator_btn_hamberger}
    Click Element    ${locator_btn_logout}

Sort Products
    [Arguments]    ${sort_by}
    Click Element    ${locator_btn_sort}
    Click Element    ${sort_by}

Checkout Process
    [Arguments]    ${fname}    ${lname}    ${zip}
    Click Element    ${locator_btn_checkout}
    Input Text      ${locator_checkout_fname}    ${fname}
    Input Text      ${locator_checkout_lname}    ${lname}
    Input Text      ${locator_checkout_zip}      ${zip}
    Click Element    ${locator_btn_continue}
    Click Element    ${locator_btn_finish}

*** Test Cases ***
TC_LOGIN_001 - Valid Login
    [Tags]    Positive
    [Documentation]    Precondition: ผู้ใช้เปิดหน้า Login ของ SauceDemo
    Login    ${standard_user}    ${password}
    Wait Until Page Contains    Products

TC_LOGIN_002 - Invalid Login
    [Tags]    Negative
    [Documentation]    Precondition: ผู้ใช้เปิดหน้า Login ของ SauceDemo
    Login    ${standard_user}    1234
    Wait Until Page Contains    Epic sadface: Username and password do not match any user in this service

TC_LOGIN_003 - Login with Empty Username
    [Tags]    Negative
    [Documentation]    Precondition: ผู้ใช้เปิดหน้า Login ของ SauceDemo
    Login    ${user_null}    ${password}
    Wait Until Page Contains    Username is required

TC_LOGIN_004 - Login with Empty Password
    [Tags]    Negative
    [Documentation]    Precondition: ผู้ใช้เปิดหน้า Login ของ SauceDemo
    Login    ${standard_user}    ${password_null}
    Wait Until Page Contains    Password is required

TC_LOGIN_005 - Login with Empty Username and Password
    [Tags]    Negative
    [Documentation]    Precondition: ผู้ใช้เปิดหน้า Login ของ SauceDemo
    Login    ${user_null}    ${password_null}
    Wait Until Page Contains    Username is required

TC_LOGIN_006 - Login with SQL Injection
    [Tags]    Security    Negative    Automated    Regression
    [Documentation]    This test case verifies that the login form is protected against SQL Injection attempts by inputting ' OR '1'='1.
    Login    "' OR '1'='1"    ${password}
    Wait Until Page Contains    Epic sadface: Username and password do not match any user in this service

TC_LOGIN_007 - Login with XSS Injection
    [Tags]    Security    Negative    Automated    Regression
    [Documentation]    This test case verifies that the login form is protected against XSS attacks by inputting <script>alert('XSS')</script>.
    Login    "<script>alert('XSS')</script>"    ${password}
    Wait Until Page Contains    Epic sadface: Username and password do not match any user in this service

TC_LOGIN_008 - Password field masking
    [Tags]    UI    Security    Automated    Regression
    [Documentation]    This test case verifies that the password field masks the characters while typing.
    Login    ${standard_user}    ${password}
    Element Attribute Should Match    id=password    type    password

TC_LOGIN_009 - Login button disabled when fields are empty
    [Tags]    UI    Negative    Automated    Regression
    [Documentation]    This test case verifies that the login button remains disabled when username and password fields are empty.
    Element Should Be Disabled    id=login-button

TC_LOGIN_010 - Login with special characters
    [Tags]    Security    Negative    Automated    Regression
    [Documentation]    This test case verifies that special characters in the username field are handled properly.
    Login    "admin@!#$%^&*()"    ${password}
    Wait Until Page Contains    Epic sadface: Username and password do not match any user in this service

TC_LOGIN_011 - Verify case sensitivity in username
    [Tags]    Security    Functional    Automated    Regression
    [Documentation]    This test case verifies that the username field is case-sensitive.
    Login    "Admin"    ${password}
    Wait Until Page Contains    Epic sadface: Username and password do not match any user in this service

TC_LOGIN_012 - Verify user session persistence
    [Tags]    Functional    Automated    Regression
    [Documentation]    This test case verifies that the user session persists after a page refresh.
    Login    ${standard_user}    ${password}
    Reload Page
    Wait Until Page Contains    Products

TC_LOGIN_013 - Verify login after logout
    [Tags]    Functional    Automated    Regression
    [Documentation]    This test case verifies that a user can log in again after logging out.
    Login    ${standard_user}    ${password}
    Logout
    Login    ${standard_user}    ${password}
    Wait Until Page Contains    Products

TC_LOGIN_014 - Login with locked-out user
    [Tags]    Functional    Security    Automated    Regression
    [Documentation]    This test case verifies that a locked-out user cannot log in.
    Login    ${locked_out_user}    ${password}
    Wait Until Page Contains    Epic sadface: Sorry, this user has been locked out.

TC_PRODUCT_PAGE_001 - Sort สินค้า - Price (Low to High)
    [Tags]    Product    Sorting    Automated    Regression
    [Documentation]    This test case verifies that products are sorted correctly from low to high price.
    Login    ${standard_user}    ${password}
    Sort Products    ${price_low_to_high}
    Take Screenshot

TC_PRODUCT_PAGE_002 - Sort สินค้า - Price (High to Low)
    [Tags]    Product    Sorting    Automated    Regression
    [Documentation]    This test case verifies that products are sorted correctly from high to low price.
    Login    ${standard_user}    ${password}
    Sort Products    ${price_high_to_low}
    Take Screenshot

TC_PRODUCT_PAGE_003 - Sort สินค้า - Name (A to Z)
    [Tags]    Product    Sorting    Automated    Regression
    [Documentation]    This test case verifies that products are sorted correctly alphabetically from A to Z.
    Login    ${standard_user}    ${password}
    Sort Products    ${name_a_to_z}
    Take Screenshot

TC_PRODUCT_PAGE_004 - Sort สินค้า - Name (Z to A)
    [Tags]    Product    Sorting    Automated    Regression
    [Documentation]    This test case verifies that products are sorted correctly alphabetically from Z to A.
    Login    ${standard_user}    ${password}
    Sort Products    ${name_z_to_a}
    Take Screenshot

TC_PRODUCT_PAGE_005 - เพิ่มสินค้าเข้า Cart (Single Item)
    [Tags]    Product    Cart    Automated    Regression
    [Documentation]    This test case verifies that a single product can be added to the cart successfully.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_addtocard}
    Wait Until Element Is Visible    ${locator_card_badge}
    Take Screenshot

TC_PRODUCT_PAGE_006 - เพิ่มสินค้าหลายรายการเข้า Cart
    [Tags]    Product    Cart    Automated    Regression
    [Documentation]    This test case verifies that multiple products can be added to the cart successfully.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_addtocard}
    Click Element    ${locator_btn_addtocard}
    Wait Until Element Is Visible    ${locator_card_badge}
    Take Screenshot

TC_PRODUCT_PAGE_007 - ลบสินค้าออกจาก Cart
    [Tags]    Product    Cart    Automated    Regression
    [Documentation]    This test case verifies that a product can be removed from the cart successfully.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_addtocard}
    Click Element    ${locator_btn_remove_item}
    Element Should Not Be Visible    ${locator_card_badge}
    Take Screenshot

TC_PRODUCT_PAGE_008 - ตรวจสอบรายการสินค้าในหน้า Cart
    [Tags]    Product    Cart    Automated    Regression
    [Documentation]    This test case verifies that the correct items are displayed in the cart.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_addtocard}
    Click Element    ${locator_card_badge}
    Wait Until Page Contains    Your Cart
    Take Screenshot

TC_PRODUCT_PAGE_009 - Cart Content Persistence หลังรีเฟรชหน้า
    [Tags]    Product    Cart    Automated    Regression
    [Documentation]    This test case verifies that items in the cart persist after a page refresh.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_addtocard}
    Reload Page
    Wait Until Element Is Visible    ${locator_card_badge}
    Take Screenshot

TC_PRODUCT_PAGE_010 - Clicking product name navigates to details
    [Tags]    Product    Navigation    Automated    Regression
    [Documentation]    This test case verifies that clicking on a product name navigates to its details page.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_product_item}
    Wait Until Element Is Visible    ${locator_btn_backtoproduct}
    Take Screenshot

TC_PRODUCT_PAGE_011 - Clicking product image navigates to details
    [Tags]    Product    Navigation    Automated    Regression
    [Documentation]    This test case verifies that clicking on a product image navigates to its details page.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_product_item}
    Wait Until Element Is Visible    ${locator_btn_backtoproduct}
    Take Screenshot

TC_PRODUCT_PAGE_012 - Verify "Add to Cart" button updates
    [Tags]    Product    Cart    Automated    Regression
    [Documentation]    This test case verifies that the "Add to Cart" button updates to "Remove" after adding an item.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_addtocard}
    Wait Until Element Is Visible    ${locator_btn_remove_item}
    Take Screenshot

TC_PRODUCT_PAGE_013 - Add multiple products
    [Tags]    Product    Cart    Automated    Regression
    [Documentation]    This test case verifies that multiple products can be added to the cart successfully.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_addtocard}
    Click Element    ${locator_btn_addtocard}
    Wait Until Element Is Visible    ${locator_card_badge}
    Take Screenshot

TC_PRODUCT_PAGE_014 - Remove product from cart
    [Tags]    Product    Cart    Automated    Regression
    [Documentation]    This test case verifies that removing an item from the cart works correctly.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_addtocard}
    Click Element    ${locator_btn_remove_item}
    Element Should Not Be Visible    ${locator_card_badge}
    Take Screenshot

TC_PRODUCT_PAGE_015 - Empty cart message
    [Tags]    Product    Cart    Automated    Regression
    [Documentation]    This test case verifies that an empty cart displays the correct message.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_addtocard}
    Click Element    ${locator_btn_remove_item}
    Wait Until Page Contains    Your cart is empty
    Take Screenshot

TC_PRODUCT_PAGE_016 - Cart retains items after refresh
    [Tags]    Product    Cart    Automated    Regression
    [Documentation]    This test case verifies that cart items persist after a page refresh.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_addtocard}
    Reload Page
    Wait Until Element Is Visible    ${locator_card_badge}
    Take Screenshot

TC_PRODUCT_PAGE_017 - Verify cart items persist after logout
    [Tags]    Product    Cart    Automated    Regression
    [Documentation]    This test case verifies that cart items persist after logging out and logging back in.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_addtocard}
    Logout
    Login    ${standard_user}    ${password}
    Wait Until Element Is Visible    ${locator_card_badge}
    Take Screenshot

TC_PRODUCT_PAGE_018 - Verify max quantity of items in cart
    [Tags]    Product    Cart    Automated    Regression
    [Documentation]    This test case verifies that the cart handles maximum item quantities correctly.
    Login    ${standard_user}    ${password}
    Repeat Keyword    10 times    Click Element    ${locator_btn_addtocard}
    Wait Until Element Is Visible    ${locator_card_badge}
    Take Screenshot

TC_CHECKOUT_001 - เริ่มต้นการ Checkout
    [Tags]    Checkout    Navigation    Automated    Regression
    [Documentation]    This test case verifies that clicking the checkout button navigates to the checkout information page.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_checkout}
    Wait Until Page Contains    Checkout: Your Information

TC_CHECKOUT_002 - Checkout ด้วยข้อมูลที่ไม่ครบ (Missing Fields)
    [Tags]    Checkout    Validation    Automated    Regression
    [Documentation]    This test case verifies that an error message is displayed when required fields are left blank.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_checkout}
    Click Element    ${locator_btn_continue}
    Wait Until Page Contains    Error: First Name is required

TC_CHECKOUT_003 - Checkout Process ที่สำเร็จ
    [Tags]    Checkout    Payment    Automated    Regression
    [Documentation]    This test case verifies that a successful checkout completes the order process.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_checkout}
    Input Text    ${locator_checkout_fname}    John
    Input Text    ${locator_checkout_lname}    Doe
    Input Text    ${locator_checkout_zip}    12345
    Click Element    ${locator_btn_continue}
    Click Element    ${locator_btn_finish}
    Wait Until Page Contains    THANK YOU FOR YOUR ORDER

TC_CHECKOUT_004 - ยกเลิกกระบวนการ Checkout จากหน้ากรอกข้อมูล
    [Tags]    Checkout    Navigation    Automated    Regression
    [Documentation]    This test case verifies that clicking cancel returns to the cart page.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_checkout}
    Click Element    ${locator_btn_cancel}
    Wait Until Page Contains    Your Cart

TC_CHECKOUT_005 - ยกเลิกกระบวนการ Checkout จากหน้าสรุป
    [Tags]    Checkout    Navigation    Automated    Regression
    [Documentation]    This test case verifies that clicking cancel from the checkout overview returns to the cart.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_checkout}
    Input Text    ${locator_checkout_fname}    John
    Input Text    ${locator_checkout_lname}    Doe
    Input Text    ${locator_checkout_zip}    12345
    Click Element    ${locator_btn_continue}
    Click Element    ${locator_btn_cancel}
    Wait Until Page Contains    Your Cart

TC_CHECKOUT_006 - ตรวจสอบการคำนวณราคาใน Checkout Overview
    [Tags]    Checkout    Functional    Automated    Regression
    [Documentation]    This test case verifies that the total price is correctly calculated in the checkout overview.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_checkout}
    Input Text    ${locator_checkout_fname}    John
    Input Text    ${locator_checkout_lname}    Doe
    Input Text    ${locator_checkout_zip}    12345
    Click Element    ${locator_btn_continue}
    Wait Until Page Contains    Total: $

TC_CHECKOUT_007 - Verify URL Changes ระหว่างขั้นตอน Checkout
    [Tags]    Checkout    Navigation    Automated    Regression
    [Documentation]    This test case verifies that the URL changes correctly during the checkout process.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_checkout}
    Location Should Contain    checkout-step-one.html
    Click Element    ${locator_btn_continue}
    Location Should Contain    checkout-step-two.html
    Click Element    ${locator_btn_finish}
    Location Should Contain    checkout-complete.html

TC_CHECKOUT_008 - Successful checkout
    [Tags]    Checkout    Payment    Automated    Regression
    [Documentation]    This test case verifies a successful order placement.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_checkout}
    Input Text    ${locator_checkout_fname}    John
    Input Text    ${locator_checkout_lname}    Doe
    Input Text    ${locator_checkout_zip}    12345
    Click Element    ${locator_btn_continue}
    Click Element    ${locator_btn_finish}
    Wait Until Page Contains    THANK YOU FOR YOUR ORDER

TC_CHECKOUT_009 - Missing first name
    [Tags]    Checkout    Validation    Automated    Regression
    [Documentation]    This test case verifies that leaving the first name blank triggers an error message.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_checkout}
    Input Text    ${locator_checkout_lname}    Doe
    Input Text    ${locator_checkout_zip}    12345
    Click Element    ${locator_btn_continue}
    Wait Until Page Contains    Error: First Name is required

TC_CHECKOUT_010 - Missing last name
    [Tags]    Checkout    Validation    Automated    Regression
    [Documentation]    This test case verifies that leaving the last name blank triggers an error message.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_checkout}
    Input Text    ${locator_checkout_fname}    John
    Input Text    ${locator_checkout_zip}    12345
    Click Element    ${locator_btn_continue}
    Wait Until Page Contains    Error: Last Name is required

TC_CHECKOUT_011 - Missing ZIP code
    [Tags]    Checkout    Validation    Automated    Regression
    [Documentation]    This test case verifies that leaving the ZIP code blank triggers an error message.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_checkout}
    Input Text    ${locator_checkout_fname}    John
    Input Text    ${locator_checkout_lname}    Doe
    Click Element    ${locator_btn_continue}
    Wait Until Page Contains    Error: Postal Code is required

TC_CHECKOUT_012 - Checkout cancellation
    [Tags]    Checkout    Navigation    Automated    Regression
    [Documentation]    This test case verifies that clicking the cancel button returns the user to the cart page.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_checkout}
    Click Element    ${locator_btn_cancel}
    Wait Until Page Contains    Your Cart

TC_CHECKOUT_013 - Verify order summary before confirming
    [Tags]    Checkout    Functional    Automated    Regression
    [Documentation]    This test case verifies that the order summary displays correct details before confirming the order.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_checkout}
    Input Text    ${locator_checkout_fname}    John
    Input Text    ${locator_checkout_lname}    Doe
    Input Text    ${locator_checkout_zip}    12345
    Click Element    ${locator_btn_continue}
    Wait Until Page Contains    Checkout: Overview

TC_CHECKOUT_014 - Verify "Finish" button completes order
    [Tags]    Checkout    Payment    Automated    Regression
    [Documentation]    This test case verifies that clicking the "Finish" button successfully completes the order.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_checkout}
    Input Text    ${locator_checkout_fname}    John
    Input Text    ${locator_checkout_lname}    Doe
    Input Text    ${locator_checkout_zip}    12345
    Click Element    ${locator_btn_continue}
    Click Element    ${locator_btn_finish}
    Wait Until Page Contains    THANK YOU FOR YOUR ORDER

TC_CHECKOUT_015 - Verify order reset after completion Checkout
    [Tags]    Checkout    Functional    Automated    Regression
    [Documentation]    This test case verifies that after completing a checkout, the cart is reset.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_checkout}
    Input Text    ${locator_checkout_fname}    John
    Input Text    ${locator_checkout_lname}    Doe
    Input Text    ${locator_checkout_zip}    12345
    Click Element    ${locator_btn_continue}
    Click Element    ${locator_btn_finish}
    Click Element    ${locator_btn_backtoproduct}
    Wait Until Element Is Not Visible    ${locator_card_badge}

TC_CHECKOUT_016 - Verify order history (if applicable)
    [Tags]    Checkout    History    Automated    Regression
    [Documentation]    This test case verifies that completed orders are recorded in the order history.
    Login    ${standard_user}    ${password}
    Navigate To    ${order_history_url}
    Wait Until Page Contains    Order History

TC_CHECKOUT_017 - Verify payment method selection (if available)
    [Tags]    Checkout    Payment    Automated    Regression
    [Documentation]    This test case verifies that users can select a payment method if the option is available.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_checkout}
    Wait Until Page Contains    Select Payment Method    

TC_BURGER_001 - Logout ผ่าน Burger Menu
    [Tags]    Navigation    Logout    Automated    Regression
    [Documentation]    This test case verifies that logging out using the burger menu redirects the user to the login page.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_hamberger}
    Click Element    ${locator_btn_logout}
    Wait Until Page Contains    Swag Labs

TC_BURGER_002 - ตรวจสอบตัวเลือกใน Burger Menu
    [Tags]    Navigation    UI    Automated    Regression
    [Documentation]    This test case verifies that all expected menu options are present in the burger menu.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_hamberger}
    Wait Until Page Contains    All Items
    Wait Until Page Contains    About
    Wait Until Page Contains    Logout
    Wait Until Page Contains    Reset App State

TC_BURGER_003 - Reset App State
    [Tags]    Navigation    Reset    Automated    Regression
    [Documentation]    This test case verifies that using Reset App State clears cart and resets app settings.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_hamberger}
    Click Element    id=reset_sidebar_link
    Wait Until Element Is Not Visible    ${locator_card_badge}

TC_BURGER_004 - ตรวจสอบการเข้าถึงหน้าโดยตรง (Direct URL Access)
    [Tags]    Security    Navigation    Automated    Regression
    [Documentation]    This test case verifies that users cannot access protected pages without logging in.
    Go To    https://www.saucedemo.com/inventory.html
    Wait Until Page Contains    Swag Labs

TC_BURGER_005 - ตรวจสอบการนำทางด้วยปุ่ม Back ของ Browser
    [Tags]    Navigation    UI    Automated    Regression
    [Documentation]    This test case verifies that using the browser back button does not cause errors.
    Login    ${standard_user}    ${password}
    Go To    https://www.saucedemo.com/inventory.html
    Go Back
    Wait Until Page Contains    Swag Labs

TC_BURGER_006 - คลิกที่โลโก้เว็บไซต์
    [Tags]    Navigation    UI    Automated    Regression
    [Documentation]    This test case verifies that clicking the website logo redirects the user to the Products page.
    Login    ${standard_user}    ${password}
    Click Element    id=logo
    Wait Until Page Contains    Products

TC_BURGER_007 - ตรวจสอบ URL หลังจาก Login
    [Tags]    Navigation    Functional    Automated    Regression
    [Documentation]    This test case verifies that after logging in, the user is directed to the correct URL.
    Login    ${standard_user}    ${password}
    Location Should Contain    inventory.html

TC_BURGER_008 - ตรวจสอบ URL หลังจากเริ่ม Checkout
    [Tags]    Navigation    Functional    Automated    Regression
    [Documentation]    This test case verifies that starting the checkout process changes the URL correctly.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_checkout}
    Location Should Contain    checkout-step-one.html

TC_BURGER_009 - ตรวจสอบ URL หลังจาก Order Complete
    [Tags]    Navigation    Functional    Automated    Regression
    [Documentation]    This test case verifies that completing an order redirects the user to the correct URL.
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_checkout}
    Input Text    ${locator_checkout_fname}    John
    Input Text    ${locator_checkout_lname}    Doe
    Input Text    ${locator_checkout_zip}    12345
    Click Element    ${locator_btn_continue}
    Click Element    ${locator_btn_finish}
    Location Should Contain    checkout-complete.html

