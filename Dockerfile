# ใช้ Robot Framework Base Image ที่มี Chrome & Selenium
FROM ppodgorsek/robot-framework:latest

# ตั้งค่า user เป็น root ชั่วคราวเพื่อให้ pip install ผ่าน
USER root
RUN pip install --no-cache-dir --user webdriver-manager --break-system-packages
USER robot

# ตั้งค่าตัวแปรแวดล้อมให้ Chrome ใช้ Headless Mode
ENV ROBOT_OPTIONS="--variable HEADLESS:True"

# ตั้งค่า Working Directory
WORKDIR /tests
COPY tests/ /tests

# รัน Robot Framework Tests
CMD ["sh", "-c", "robot --outputdir /tests/results /tests"]
