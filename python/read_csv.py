import csv

with open("test_data.csv", newline='') as file:
    reader = csv.reader(file)
    for row in reader:
        print(row)  # แสดงข้อมูลแต่ละแถว
