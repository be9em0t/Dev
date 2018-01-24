import pyautogui
pyautogui.FAILSAFE = True

screenWidth, screenHeight = pyautogui.size()
pyautogui.moveTo(screenWidth / 2, screenHeight / 2)