import os


def mkdirp(path):
    os.makedirs(path, 511, True)


def writeFile(filepath, content, flags="wb"):
    with open(filepath, flags) as file_out:
        file_out.write(content)
        file_out.close()
