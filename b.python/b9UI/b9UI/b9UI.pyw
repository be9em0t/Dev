import Tkinter as tk # Python 2
from PIL import Image, ImageTk
root = tk.Tk()

# The image must be stored to Tk or it will be garbage collected.
# no antialiasing is supported
# GIF images are default
#root.image = tk.PhotoImage(file='a.gif')
#label = tk.Label(root, image=root.image, bg='white')

#To use other formats we need to convert them using PIL
image1 = Image.open('a.png')
image2 = Image.open('b.png')
tkpi1 = ImageTk.PhotoImage(image1)
tkpi2 = ImageTk.PhotoImage(image2)
label_image1 = tk.Label(root, image=tkpi1, bg='white')
label_image2 = tk.Label(root, image=tkpi2, bg='white')

#label_image.place(x=0,y=0,width=image1.size[0],height=image1.size[1])


root.overrideredirect(True)
#root.withdraw()
root.geometry("+250+250")
root.lift()
root.wm_attributes("-topmost", True)
root.wm_attributes("-disabled", True)
root.wm_attributes("-transparentcolor", "white")
#label.pack()
label_image1.pack()
label_image2.pack()
#label.mainloop()
label_image1.mainloop()
label_image2.mainloop()