print("Starting the program")

import ctypes
ctypes.cdll.LoadLibrary(r"./addLib.dll")
print("Ending the program")
