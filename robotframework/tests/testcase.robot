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


#1. การทดสอบหน้า Login
TC_LOGIN_001 - Valid Login
    [Documentation]    Precondition: ผู้ใช้เปิดหน้า Login ของ SauceDemo
    Login    ${standard_user}    ${password}
# Test Step: ป้อน username “standard_user”, ป้อน password “secret_sauce”, คลิกปุ่ม Login
# Expected: นำทางไปที่หน้า Products แสดงรายการสินค้าทั้งหมด

TC_LOGIN_002 - Invalid Login
    Login    ${standard_user}    ${password}
# Test Step: ป้อน username “invalid_user”, ป้อน password “wrong_password”, คลิกปุ่ม Login
# Expected: แสดงข้อความ error แจ้ง “Username and password do not match any user in this service.”

TC_LOGIN_003 - Login ด้วย Username ว่าง
    Login    ${standard_user}    ${password}
# Test Step: ปล่อยช่อง username ว่าง, ป้อน password “secret_sauce”, คลิกปุ่ม Login
# Expected: แสดงข้อความ “Username is required”

TC_LOGIN_004 - ด้วย Password ว่าง
    Login    ${standard_user}    ${password}
# Test Step: ป้อน username “standard_user”, ปล่อยช่อง password ว่าง, คลิกปุ่ม Login
# Expected: แสดงข้อความ “Password is required”

TC_LOGIN_005 - Login ด้วยผู้ใช้ที่ถูกล็อก (Locked Out User)
    Login    ${standard_user}    ${password}
# Test Step: ป้อน username “locked_out_user”, ป้อน password “secret_sauce”, คลิกปุ่ม Login
# Expected: แสดงข้อความ “Epic sadface: Sorry, this user has been locked out.”

# Login with empty fields	ไม่กรอกข้อมูล	แจ้งเตือนให้กรอก Username/Password
# 5.1	SQL Injection	Security	ควรป้องกันการโจมตี
# 5.2	XSS Injection	Security	ควรป้องกันการรันสคริปต์
# Password field masking	ตรวจสอบรหัสผ่านขณะพิมพ์	แสดง ******
# Login button disabled when fields are empty	ไม่กรอกข้อมูลแล้วตรวจสอบปุ่ม	ปุ่ม Login ควรเป็น disabled
# 1.7	Login with special characters	กรอก admin@!#$%^&*()	ควรไม่อนุญาต
# 1.8	Login with SQL Injection	กรอก ' OR '1'='1	ควรไม่อนุญาต
# 1.9	Login with JavaScript Injection	กรอก <script>alert('XSS')</script>	ควรไม่อนุญาต
# 1.10	Verify case sensitivity in username	Admin และ admin	ถ้า Case Sensitive ต้องแสดง error
# 1.11	Verify user session persistence	Login > Refresh หน้า	ยังคงอยู่ในระบบ
# 1.12	Verify session timeout	Login > ปล่อย 30 นาที	ควร Logout อัตโนมัติ
# 1.13	Verify login after logout	Login > Logout > Login ใหม่	ควรเข้าใช้งานได้
# 1.14	Verify login across multiple devices	Login บนอุปกรณ์อื่น	ควร Login ได้โดยไม่มีปัญหา
# 1.15	Verify incorrect password attempt lockout	กรอกรหัสผ่านผิด 5 ครั้ง	ระบบควรล็อกบัญชีชั่วคราว



TC_PRODUCT_PAGE_001 - Sort สินค้า - Price (Low to High)
    Login    ${standard_user}    ${password}
# Test Step: หลังจาก Login แล้ว เปิด dropdown Sort, เลือก “Price (low to high)”
# Expected: รายการสินค้าจัดเรียงจากราคาต่ำไปสูง

TC_PRODUCT_PAGE_002 - Sort สินค้า - Price (High to Low)
    Login    ${standard_user}    ${password}
# Test Step: หลังจาก Login แล้ว เปิด dropdown Sort, เลือก “Price (high to low)”
# Expected: รายการสินค้าจัดเรียงจากราคาสูงไปต่ำ

TC_PRODUCT_PAGE_003 - Sort สินค้า - Name (A to Z)
    Login    ${standard_user}    ${password}
# Test Step: หลังจาก Login แล้ว เปิด dropdown Sort, เลือก “Name (A to Z)”
# Expected: รายการสินค้าจัดเรียงตามลำดับตัวอักษร A ถึง Z

TC_PRODUCT_PAGE_004 - Sort สินค้า - Name (Z to A)
    Login    ${standard_user}    ${password}
# Test Step: หลังจาก Login แล้ว เปิด dropdown Sort, เลือก “Name (Z to A)”
# Expected: รายการสินค้าจัดเรียงตามลำดับตัวอักษร Z ถึง A

TC_PRODUCT_PAGE_005 - เพิ่มสินค้าเข้า Cart (Single Item)
    Login    ${standard_user}    ${password}
# Test Step: หลังจาก Login แล้ว คลิกปุ่ม “Add to cart” บนสินค้าหนึ่งรายการ
# Expected: ปุ่มเปลี่ยนเป็น “Remove” และไอคอน Cart แสดงจำนวนสินค้าเพิ่มขึ้นเป็น 1

TC_PRODUCT_PAGE_006 - เพิ่มสินค้าหลายรายการเข้า Cart
    Login    ${standard_user}    ${password}
# Test Step: หลังจาก Login แล้ว คลิก “Add to cart” สำหรับสินค้าหลายรายการ (เช่น 3 รายการ)
# Expected: ไอคอน Cart แสดงจำนวนสินค้าตามจำนวนที่เพิ่ม

TC_PRODUCT_PAGE_007 - ลบสินค้าออกจาก Cart
    Login    ${standard_user}    ${password}
# Test Step: หลังจากเพิ่มสินค้าแล้ว คลิกปุ่ม “Remove” ของสินค้ารายการใดรายการหนึ่ง
# Expected: ปุ่มกลับเป็น “Add to cart” และจำนวนสินค้าที่แสดงใน Cart ลดลง

TC_PRODUCT_PAGE_008 - ตรวจสอบรายการสินค้าในหน้า Cart
    Login    ${standard_user}    ${password}
# Test Step: หลังจากเพิ่มสินค้าแล้ว คลิกที่ไอคอน Cart
# Expected: หน้าจอแสดงรายละเอียดสินค้าที่ถูกเพิ่ม (ชื่อสินค้า, ราคา ฯลฯ)

TC_PRODUCT_PAGE_009 - Cart Content Persistence หลังรีเฟรชหน้า
    Login    ${standard_user}    ${password}
# Test Step: หลังจากเพิ่มสินค้าใน Cart, รีเฟรชหน้าเว็บ
# Expected: รายการสินค้าใน Cart ยังคงอยู่

# 2.1	Display all products	Login และไปที่หน้า Product Page	สินค้าทั้งหมดต้องแสดงถูกต้อง
# 2.2	Product images load correctly	ตรวจสอบรูปสินค้า	ไม่มีรูปที่โหลดไม่ขึ้น
# 2.3	Sorting by name (A-Z)	เลือก "Name (A to Z)"	รายการเรียง A-Z
# 2.4	Sorting by name (Z-A)	เลือก "Name (Z to A)"	รายการเรียง Z-A
# 2.5	Sorting by price (Low to High)	เลือก "Price (low to high)"	ราคาต่ำสุดอยู่บนสุด
# 2.6	Sorting by price (High to Low)	เลือก "Price (high to low)"	ราคาแพงสุดอยู่บนสุด
# 2.7	Clicking product name navigates to details	คลิกชื่อสินค้า	ไปยังหน้า Product Details
# 2.8	Clicking product image navigates to details	คลิกที่รูปสินค้า	ไปยังหน้า Product Details
# 2.9	Verify "Add to Cart" button updates	คลิก "Add to Cart"	ปุ่มเปลี่ยนเป็น "Remove"
# 2.10	Verify product descriptions	ตรวจสอบรายละเอียดสินค้า	ข้อมูลครบถ้วน

    # Shopping 
# 3.1	Add multiple products	เพิ่มสินค้าหลายรายการ	Cart ต้องอัปเดต
# 3.2	Remove product from cart	ลบสินค้าจาก Cart	ต้องหายไปจาก Cart
# 3.3	Empty cart message	ลบสินค้าทั้งหมด	แสดงข้อความ "Your cart is empty"
# 3.4	Cart retains items after refresh	เพิ่มสินค้า > รีเฟรช	สินค้าต้องยังอยู่
# 3.5	Cart updates correctly	เพิ่มและลบสินค้า	จำนวนสินค้าต้องถูกต้อง
# 3.6	Navigate to checkout page	ไปที่ Cart > คลิก "Checkout"	ไปยังหน้า Checkout
# 3.7	Verify cart item details	ตรวจสอบข้อมูลใน Cart	ชื่อ, ราคา, จำนวน ถูกต้อง
# 3.8	Verify cart icon updates	เพิ่มสินค้า	ไอคอน Cart อัปเดตตามจำนวนสินค้า
# 3.9	Verify cart items persist after logout	เพิ่มสินค้า > Logout > Login ใหม่	ควรยังมีสินค้าอยู่
# 3.10	Verify max quantity of items in cart	เพิ่มสินค้าจนถึงจำนวนสูงสุด	ระบบควรแจ้งเตือนถ้ามีลิมิต

TC_CHECKOUT_001 - เริ่มต้นการ Checkout
    Login    ${standard_user}    ${password}
# Test Step: จากหน้า Cart คลิกปุ่ม “Checkout”
# Expected: นำทางไปที่หน้า “Checkout: Your Information” พร้อมฟิลด์กรอกข้อมูล

TC_CHECKOUT_002 - Checkout ด้วยข้อมูลที่ไม่ครบ (Missing Fields)
    Login    ${standard_user}    ${password}
# Test Step: ในหน้า “Checkout: Your Information” ปล่อยช่องกรอกข้อมูล (เช่น First Name ว่าง), คลิก “Continue”
# Expected: แสดงข้อความ error เช่น “Error: First Name is required”

TC_CHECKOUT_003 - Checkout Process ที่สำเร็จ
    Login    ${standard_user}    ${password}
# Test Step: ในหน้า “Checkout: Your Information” กรอกข้อมูลครบ (First Name, Last Name, Postal Code), คลิก “Continue”, ตรวจสอบหน้าสรุป “Checkout: Overview”, คลิก “Finish”
# Expected: แสดงหน้าการสั่งซื้อเสร็จสมบูรณ์ พร้อมข้อความ “THANK YOU FOR YOUR ORDER”

TC_CHECKOUT_004 - ยกเลิกกระบวนการ Checkout จากหน้ากรอกข้อมูล
    Login    ${standard_user}    ${password}
# Test Step: ในหน้า “Checkout: Your Information” คลิกปุ่ม “Cancel”
# Expected: นำกลับไปที่หน้า Cart หรือหน้า Products โดยไม่มีการบันทึกข้อมูล

TC_CHECKOUT_005 - ยกเลิกกระบวนการ Checkout จากหน้าสรุป
    Login    ${standard_user}    ${password}
# Test Step: ในหน้า “Checkout: Overview” คลิกปุ่ม “Cancel”
# Expected: นำกลับไปที่หน้า Cart โดยไม่มีการสั่งซื้อ

TC_CHECKOUT_006 - ตรวจสอบการคำนวณราคาใน Checkout Overview
    Login    ${standard_user}    ${password}
# Test Step: ในหน้า “Checkout: Overview” ตรวจสอบรายการสินค้า, ราคาสินค้า, ภาษี และยอดรวม
# Expected: ยอดรวมถูกคำนวณจากราคาสินค้าและภาษีอย่างถูกต้อง

TC_CHECKOUT_007 - Verify URL Changes ระหว่างขั้นตอน Checkout
    Login    ${standard_user}    ${password}
# Test Step: ตรวจสอบ URL เมื่อเปลี่ยนจาก “Checkout: Your Information” ไปยัง “Checkout: Overview” และ “Checkout Complete”
# Expected: URL เปลี่ยนแสดงสถานะขั้นตอน (เช่น /checkout-step-one.html, /checkout-step-two.html, /checkout-complete.html)

# 4.1	Successful checkout	กรอกข้อมูลถูกต้อง	ไปยัง Order Confirmation
# 4.2	Missing first name	ไม่กรอก First Name	ระบบแจ้งเตือน
# 4.3	Missing last name	ไม่กรอก Last Name	ระบบแจ้งเตือน
# 4.4	Missing ZIP code	ไม่กรอก ZIP	ระบบแจ้งเตือน
# 4.5	Checkout cancellation	คลิก "Cancel"	กลับไปที่ Cart
# 4.6	Verify order summary before confirming	ตรวจสอบรายการสินค้า	รายละเอียดถูกต้อง
# 4.7	Verify "Finish" button completes order	คลิก "Finish"	แสดง "Thank you for your order"
# 4.8	Verify order reset after completion	Checkout สำเร็จ > กลับไปหน้า Home	Cart ว่างเปล่า
# 4.9	Verify order history (if applicable)	ตรวจสอบคำสั่งซื้อที่ทำเสร็จแล้ว	ต้องมีข้อมูลคำสั่งซื้อ
# 4.10	Verify payment method selection (if available)	เลือกวิธีจ่ายเงิน	ต้องเลือกได้

TC_BURGER _001 - Logout ผ่าน Burger Menu
    Login    ${standard_user}    ${password}
# Test Step: หลังจาก Login แล้ว เปิด Burger Menu, คลิก “Logout”
# Expected: นำกลับไปที่หน้า Login และออกจากระบบ

TC_BURGER _002 - ตรวจสอบตัวเลือกใน Burger Menu
    Login    ${standard_user}    ${password}
# Test Step: หลังจาก Login แล้ว เปิด Burger Menu
# Expected: แสดงตัวเลือก “All Items”, “About”, “Logout” และ “Reset App State”

TC_BURGER _003 - Reset App State
    Login    ${standard_user}    ${password}
# Test Step: หลังจาก Login และเพิ่มสินค้าใน Cart, เปิด Burger Menu แล้วคลิก “Reset App State”
# Expected: เคลียร์ข้อมูล Cart และรีเซ็ตการตั้งค่าต่าง ๆ ของแอป

TC_BURGER _004 - ตรวจสอบการเข้าถึงหน้าโดยตรง (Direct URL Access)
    Login    ${standard_user}    ${password}
# Test Step: ป้อน URL ของหน้าต่าง ๆ (เช่น /inventory.html, /cart.html, /checkout-step-one.html) โดยที่ยังไม่ได้ Login
# Expected: นำผู้ใช้กลับไปที่หน้า Login หรือแสดงข้อความแจ้งให้ Login ก่อน

TC_BURGER _005 - ตรวจสอบการนำทางด้วยปุ่ม Back ของ Browser
    Login    ${standard_user}    ${password}
# Test Step: หลังจากเข้าสู่หน้า Products หรือ Checkout ใช้ปุ่ม Back ของ Browser
# Expected: ระบบจัดการนำผู้ใช้ไปยังหน้าที่เหมาะสมโดยไม่มีข้อผิดพลาด

TC_BURGER _006 - คลิกที่โลโก้เว็บไซต์
    Login    ${standard_user}    ${password}
# Test Step: หลังจาก Login แล้ว คลิกที่โลโก้ของเว็บไซต์
# Expected: นำกลับไปที่หน้า Products หรือหน้า Home

TC_BURGER _007 - ตรวจสอบ URL หลังจาก Login
    Login    ${standard_user}    ${password}
# Test Step: หลังจาก Login สำเร็จ สังเกต URL ที่เปลี่ยนไป
# Expected: URL เปลี่ยนไปเป็น /inventory.html หรือ URL ที่กำหนดสำหรับหน้า Products

TC_BURGER _008 - ตรวจสอบ URL หลังจากเริ่ม Checkout
    Login    ${standard_user}    ${password}
# Test Step: ในหน้า “Checkout: Your Information”
# Expected: URL เปลี่ยนไปแสดงสถานะของขั้นตอนการ Checkout (เช่น /checkout-step-one.html)

TC_BURGER _009 - ตรวจสอบ URL หลังจาก Order Complete
    Login    ${standard_user}    ${password}
# Test Step: หลังจากคลิก “Finish” ใน Checkout
# Expected: URL เปลี่ยนเป็น /checkout-complete.html

