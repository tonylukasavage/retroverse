import json


def applyDiff(rom_data, diff_json_file):
    file = open(diff_json_file, "r")
    diff_json_text = file.read()
    diff_json = json.loads(diff_json_text)
    file.close()

    for diff in diff_json:
        loc, val = diff
        while len(rom_data) < loc + 1:
            rom_data.append(0xFF)
        rom_data[loc] = val
