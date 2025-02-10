# ใช้ Official Image ที่มี Chrome และ Selenium
FROM ppodgorsek/robot-framework:latest

# สร้าง Working Directory
WORKDIR /tests

# คัดลอกไฟล์จาก Host ไปยัง Container
COPY tests/ /tests

# ใช้ WebDriver Manager ให้ ChromeDriver อัปเดตอัตโนมัติ
RUN pip install --no-cache-dir webdriver-manager

# กำหนด Environment Variable ให้ Chrome ใช้ Headless Mode
ENV ROBOT_OPTIONS="--variable HEADLESS:True"

# รัน Robot Framework
CMD ["sh", "-c", "robot --outputdir /tests/results /tests"]
