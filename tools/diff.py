import sys
import json

src = sys.argv[1]
dst = sys.argv[2]
target = sys.argv[3]


def loadData(file_path):
    file = open(file_path, "rb")
    data = bytearray(file.read())
    file.close()
    return data


src_data = loadData(src)
dst_data = loadData(dst)

diff = []
count = max(len(src_data), len(dst_data))

while len(src_data) < count:
    src_data.append(0xFF)

for i in range(0, count):
    if src_data[i] != dst_data[i]:
        diff.append([i, dst_data[i]])

with open(target, "w") as file_out:
    file_out.write(json.dumps(diff))
    file_out.close()
