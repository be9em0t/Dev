import Tkinter as tk # Python 2
from PIL import Image, ImageTk
root = tk.Tk()

#png = Image.open("a.png")
photo = ImageTk.PhotoImage(file='a.png')

print photo

#label = Label(image=photo)
#label.image = photo # keep a reference!
#label.pack()

# The image must be stored to Tk or it will be garbage collected.
#root.image = tk.PhotoImage(file='a.png')
root.image = tk.PhotoImage(photo)
label = tk.Label(root, image=root.image, bg='white')
root.overrideredirect(True)
root.geometry("+250+250")
root.lift()
root.wm_attributes("-topmost", True)
root.wm_attributes("-disabled", True)
root.wm_attributes("-transparentcolor", "white")
label.pack()
label.mainloop()

#from Tkinter import Tk # or(from Tkinter import Tk) on Python 2.x
#root = Tk()
#root.wait_visibility(root)
#root.wm_attributes('-alpha',0.3)
#root.mainloop()