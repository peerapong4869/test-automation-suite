# ใช้ Python base image
FROM python:3.10-slim

# ติดตั้ง dependencies และ WebDriver
RUN apt-get update && apt-get install -y \
    wget unzip curl chromium chromium-driver \
    && rm -rf /var/lib/apt/lists/*

# ติดตั้ง Robot Framework และไลบรารีที่ต้องการ
RUN pip install --no-cache-dir \
    robotframework \
    robotframework-requests \
    robotframework-seleniumlibrary

# ตั้งค่า WebDriver Path
ENV PATH="/usr/lib/chromium:${PATH}"

# สร้าง Working Directory
WORKDIR /tests

# คัดลอกไฟล์จาก Host ไปยัง Container
COPY tests/ /tests

# รันคำสั่งสำหรับรันเทส
CMD ["robot", "--outputdir", "/tests/results", "/tests"]
