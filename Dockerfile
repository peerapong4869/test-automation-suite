# ใช้ Python base image
FROM python:3.10-slim

# ติดตั้ง dependencies ที่จำเป็นสำหรับ Selenium
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    chromium \
    chromium-driver \
    fonts-liberation \
    libatk-bridge2.0-0 \
    libatspi2.0-0 \
    libgtk-3-0 \
    libgbm-dev \
    libxkbcommon-x11-0 \
    libnss3 \
    libxshmfence1 \
    libwayland-server0 \
    libwayland-client0 \
    xvfb \
    && apt-get clean

# ตั้งค่า ENV เพื่อให้ Chrome ใช้ใน Docker ได้
ENV DISPLAY=:99
ENV PATH="/usr/lib/chromium-browser/:${PATH}"

# ติดตั้ง Robot Framework และ SeleniumLibrary
RUN pip install --no-cache-dir robotframework robotframework-requests robotframework-seleniumlibrary webdriver-manager

# สร้าง Working Directory
WORKDIR /tests

# คัดลอกไฟล์จาก Host ไปยัง Container
COPY tests/ /tests

# กำหนดให้ใช้ xvfb-run เพื่อรองรับ GUI Application
CMD ["sh", "-c", "xvfb-run robot --outputdir /tests/results /tests"]
