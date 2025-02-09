# ใช้ Python base image
FROM python:3.10-slim

# ติดตั้ง dependencies ที่จำเป็น
RUN apt-get update && apt-get install -y \
    wget unzip curl gnupg2 ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# ดาวน์โหลดและติดตั้ง Google Chrome เวอร์ชันล่าสุดที่รองรับ
RUN wget -q -O google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome.deb || apt-get -fy install \
    && rm google-chrome.deb

# ดึงเวอร์ชันของ Google Chrome ที่ติดตั้งอยู่
RUN CHROME_VERSION=$(google-chrome --version | awk '{print $3}') \
    && CHROMEDRIVER_VERSION=$(curl -sSL "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION") \
    && wget -q "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" \
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
