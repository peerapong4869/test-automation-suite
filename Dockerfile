# ใช้ Python base image
FROM python:3.10-slim

# ติดตั้ง Robot Framework และไลบรารีที่ต้องการ
RUN pip install --no-cache-dir robotframework robotframework-requests

# สร้าง Working Directory
WORKDIR /tests

# คัดลอกไฟล์จาก Host ไปยัง Container
COPY tests/ /tests

# รันคำสั่งสำหรับรันเทส
CMD ["robot", "--outputdir", "/tests/results", "/tests"]