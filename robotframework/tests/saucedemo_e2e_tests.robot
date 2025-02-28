TC_E2E_001 - Complete Purchase Flow

    [Tags]    E2E    Functional    Automated    Regression
    [Documentation]    This test case verifies the complete end-to-end purchase flow, including:
    ...    - Login
    ...    - Product selection
    ...    - Checkout process
    ...    - Order confirmation
    ...    - Logout

    *** Test Steps ***
    # Step 1: Login
    Login    ${standard_user}    ${password}
    Wait Until Page Contains    Products

    # Step 2: Select and Add Product to Cart
    Click Element    ${locator_btn_addtocard}
    Click Element    ${locator_card_badge}
    Wait Until Page Contains    Your Cart

    # Step 3: Proceed to Checkout
    Click Element    ${locator_btn_checkout}
    Input Text    ${locator_checkout_fname}    John
    Input Text    ${locator_checkout_lname}    Doe
    Input Text    ${locator_checkout_zip}    12345
    Click Element    ${locator_btn_continue}
    Wait Until Page Contains    Checkout: Overview

    # Step 4: Complete the Order
    Click Element    ${locator_btn_finish}
    Wait Until Page Contains    THANK YOU FOR YOUR ORDER

    # Step 5: Logout
    Click Element    ${locator_btn_logout}
    Wait Until Page Contains    Swag Labs

TC_E2E_002 - Cart Persistence After Logout

    [Tags]    E2E    Functional    Automated    Regression
    [Documentation]    This test case verifies that items remain in the cart after logging out and logging back in.

    *** Test Steps ***
    # Step 1: Login and Add Product to Cart
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_addtocard}
    Click Element    ${locator_card_badge}
    Wait Until Page Contains    Your Cart

    # Step 2: Logout and Login Again
    Click Element    ${locator_btn_logout}
    Wait Until Page Contains    Swag Labs
    Login    ${standard_user}    ${password}
    Click Element    ${locator_card_badge}
    Wait Until Page Contains    Your Cart

    # Step 3: Verify Cart Items Persist
    Element Should Be Visible    ${locator_btn_remove_item}

TC_E2E_003 - Failed Checkout Due to Missing Info

    [Tags]    E2E    Functional    Negative    Automated    Regression
    [Documentation]    This test case verifies that an error is displayed when required checkout fields are left blank.

    *** Test Steps ***
    # Step 1: Login and Add Product to Cart
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_addtocard}
    Click Element    ${locator_card_badge}
    Wait Until Page Contains    Your Cart

    # Step 2: Proceed to Checkout Without Entering Information
    Click Element    ${locator_btn_checkout}
    Click Element    ${locator_btn_continue}

    # Step 3: Verify Error Message
    Wait Until Page Contains    Error: First Name is required

TC_E2E_004 - Cancel Checkout Flow

    [Tags]    E2E    Functional    Automated    Regression
    [Documentation]    This test case verifies that canceling the checkout process returns the user to the cart page.

    *** Test Steps ***
    # Step 1: Login and Add Product to Cart
    Login    ${standard_user}    ${password}
    Click Element    ${locator_btn_addtocard}
    Click Element    ${locator_card_badge}
    Wait Until Page Contains    Your Cart

    # Step 2: Start Checkout and Cancel
    Click Element    ${locator_btn_checkout}
    Click Element    ${locator_btn_cancel}

    # Step 3: Verify User is Returned to Cart
    Wait Until Page Contains    Your Cart