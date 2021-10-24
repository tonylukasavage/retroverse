import os
# from games.cv2 import banks
# from injector import insertFunction
import games.cv2.patch

# print(games.cv2.patch)
games.cv2.patch.init()

# file_in = open(".\\roms\\cv2.nes", "rb")
# data = file_in.read()
# file_in.close()


# with open(".\\tmp\\cv2-edit.nes", "wb") as file_out:
#     file_out.write(data)

#     # z's in the title
#     file_out.seek(0x0101A2)
#     file_out.write(
#         bytearray([0x1A, 0x1A, 0x1A, 0x1A, 0x1A, 0x1A, 0x1A, 0x1A, 0x1A]))

#     # stop door entry
#     insertFunction(file_out, 0xC80E, 3, [0x68, 0x68, 0x4C, 0x4A, 0x87], 0)
#     # file_out.seek(0xC80E)
#     # file_out.write(bytearray([0x4C, 0x4A, 0x87]))

#     # stop door entry
#     # file_out.seek(0xC7AF)
#     # file_out.write(bytearray([0x4C, 0x4A, 0x87]))

#     file_out.close()
