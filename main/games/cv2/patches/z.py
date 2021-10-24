def execute(data):
    bytes = [0x1A, 0x1A, 0x1A, 0x1A, 0x1A, 0x1A, 0x1A, 0x1A, 0x1A]
    loc = 0x0101A2
    data[loc: loc + len(bytes)] = bytes


patch = {
    'name': 'Z\'s',
    'desc': 'Write a bunch of Z\'s to the title screen',
    'deps': [],
    'execute': execute
}
