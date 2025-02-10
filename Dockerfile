# ใช้ Python base image
FROM python:3.10-slim

# ติดตั้ง dependencies ที่จำเป็นสำหรับ Selenium
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    chromium \
    chromium-driver \
    xvfb \
    && apt-get clean

# ตั้งค่า Environment Variables สำหรับ Chrome
ENV DISPLAY=:99
ENV PATH="/usr/lib/chromium-browser/:${PATH}"

# ติดตั้ง Robot Framework และ SeleniumLibrary
RUN pip install --no-cache-dir robotframework robotframework-requests robotframework-seleniumlibrary webdriver-manager

# สร้าง Working Directory
WORKDIR /tests

# คัดลอกไฟล์จาก Host ไปยัง Container
COPY tests/ /tests

# ใช้ xvfb-run เพื่อให้ Chrome ทำงานได้แบบ Headless
CMD ["sh", "-c", "xvfb-run robot --outputdir /tests/results /tests"]
