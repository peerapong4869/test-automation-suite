# ใช้ Python base image
FROM python:3.10-slim

# กำหนดเวอร์ชันของ Chrome และ ChromeDriver ที่ต้องการใช้
ENV CHROME_VERSION=123.0.6312.45-1
ENV CHROMEDRIVER_VERSION=123.0.6312.45

# ติดตั้ง dependencies ที่จำเป็นสำหรับ Selenium
RUN apt-get update && apt-get install -y \
    wget unzip curl gnupg2 ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# ติดตั้ง Google Chrome เวอร์ชันที่ต้องการ
RUN curl -sSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable=${CHROME_VERSION} \
    && rm -rf /var/lib/apt/lists/*

# ติดตั้ง ChromeDriver ที่ตรงกับเวอร์ชันของ Google Chrome
RUN wget -q https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && mv chromedriver /usr/bin/chromedriver \
    && chmod +x /usr/bin/chromedriver \
    && rm chromedriver_linux64.zip

# ติดตั้ง Robot Framework และ SeleniumLibrary
RUN pip install --no-cache-dir \
    robotframework \
    robotframework-requests \
    robotframework-seleniumlibrary

# ตั้งค่าตัวแปรสภาพแวดล้อม
ENV ROBOT_BROWSER=chrome
ENV PATH="/usr/bin/chromedriver:${PATH}"

# สร้าง Working Directory
WORKDIR /tests

# คัดลอกไฟล์จาก Host ไปยัง Container
COPY tests/ /tests

# รันคำสั่งสำหรับรันเทส
CMD ["robot", "--outputdir", "/tests/results", "/tests"]
