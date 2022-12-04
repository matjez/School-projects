from tkinter import *
from ctypes import windll
from tkinter import filedialog, messagebox
from PIL import ImageTk, Image
import steganography
import cv2


encode_opened = False
decode_opened = False
help_opened = False
windows = True
file_path = ""
file_path_2 = ""


def open_encode_window():
    global encode_opened
    if not encode_opened:
        encode_window = Toplevel(window)
        encode_window.title("Encode")
        encode_window.geometry('800x650')
        encode_window.resizable(False, False)
        encode_window.transient(window)
        if windows:
            windll.shcore.SetProcessDpiAwareness(1)

        raw_image_label = Label(encode_window, text="Select Image to hide file", height=20, width=50, relief="solid",
                                bg="#FFFFFF")
        raw_image_label.place(x=20, y=20)

        raw_image_label_2 = Label(encode_window, text="Select file to hide", height=20, width=50, relief="solid",
                                bg="#FFFFFF")
        raw_image_label_2.place(x=400, y=20)

        browse_image_btn_2 = Button(encode_window, text="Browse File", width=29, cursor="hand2",
                                  command=lambda: browse_image(raw_image_label_2))
        browse_image_btn_2.config(font=("Open Sans", 15), bg="#36923B", fg="white", borderwidth=0)
        browse_image_btn_2.place(x=400, y=400)


        browse_image_btn = Button(encode_window, text="Browse Image", width=29, cursor="hand2",
                                  command=lambda: browse_image(raw_image_label))
        browse_image_btn.config(font=("Open Sans", 15), bg="#36923B", fg="white", borderwidth=0)
        browse_image_btn.place(x=20, y=400)

        check_image = Button(encode_window, text="Check image", width=29, cursor="hand2",
                                  command=lambda: check_image_window())
        check_image.config(font=("Open Sans", 15), bg="#06026B", fg="white", borderwidth=0)
        check_image.place(x=20, y=460)

        test_image = Button(encode_window, text="Test image", width=29, cursor="hand2",
                                  command=lambda: test_image_window())
        test_image.config(font=("Open Sans", 15), bg="#06026B", fg="white", borderwidth=0)
        test_image.place(x=20, y=520)

        encode_image_btn = Button(encode_window, text="Encode", width=15, cursor="hand2",
                                  command=lambda: encode())
        encode_image_btn.config(font=("Open Sans", 15), bg="#503066", fg="white", borderwidth=0)
        encode_image_btn.place(x=400, y=450)

        encode_opened = True
        encode_window.protocol("WM_DELETE_WINDOW", lambda: close_encode_window(encode_window))

def check_image_window():
    check_image_window = Toplevel(window)
    check_image_window.title("Check image")
    check_image_window.geometry('400x150')
    check_image_window.resizable(False, False)
    check_image_window.transient(window)

    text_label = Label(check_image_window, text="Coded information: ", font=("Courier", 14),
                            bg="#FFFFFF")
    text_label.place(x=10, y=35)

    number_of_bytes_label = Label(check_image_window, text=str("None"), font=("Courier", 14),
                            bg="#FFFFFF")
    number_of_bytes_label.place(x=220, y=35)


def test_image_window():
    image = cv2.imread(file_path)

    check_image_window = Toplevel(window)
    check_image_window.title("Test image")
    check_image_window.geometry('400x150')
    check_image_window.resizable(False, False)
    check_image_window.transient(window)

    n_bytes = image.shape[0] * image.shape[1] * 3 // 8

    text_label = Label(check_image_window, text="Bytes to encode: ", font=("Courier", 16), bg="#FFFFFF")
    text_label.place(x=10, y=35)

    number_of_bytes_label = Label(check_image_window, text=str(n_bytes), font=("Courier", 16), bg="#FFFFFF")
    number_of_bytes_label.place(x=220, y=35)


def encode():
    steg = steganography.LSBSteg(cv2.imread(file_path))
    data = open(file_path_2, "rb").read()
    new_img = steg.encode_binary(data)
    cv2.imwrite("new_image.bmp", new_img)

    img = cv2.imread(file_path)
    cv2.imshow("Old image", img)

    img2 = cv2.imread('new_image.bmp')
    cv2.imshow("New image", img2)


def decode():
    steg = steganography.LSBSteg(cv2.imread(file_path))
    binary = steg.decode_binary()
    with open("recovered.bmp", "wb") as f:
        f.write(binary)


def save_image(stego_image):
    save_path = filedialog.asksaveasfile(initialfile="old_encryptstego.png",
                                         mode="wb",
                                         defaultextension=".png",
                                         filetypes=(("Image File", "*.png"),
                                                    ("All Files", "*.*")))
    stego_image.save(save_path)


def open_decode_window():
    global decode_opened
    if not decode_opened:
        decode_window = Toplevel(window)
        decode_window.title("Encryptstego - Decode")
        decode_window.geometry('800x500')
        decode_window.resizable(False, False)
        decode_window.transient(window)
        if windows:
            windll.shcore.SetProcessDpiAwareness(1)

        stego_image_label = Label(decode_window,
                                  text="Browse Image to Decode",
                                  height=20,
                                  width=50,
                                  relief="solid",
                                  bg="#FFFFFF")
        stego_image_label.place(x=20, y=20)

        browse_stego_btn = Button(decode_window,
                                  text="Browse Image to Decode",
                                  width=29,
                                  cursor="hand2",
                                  command=lambda: browse_image(stego_image_label))

        browse_stego_btn.config(font=("Open Sans", 15),
                                bg="#503066",
                                fg="white",
                                borderwidth=0)
        browse_stego_btn.place(x=20, y=350)

        decode_stego_btn = Button(decode_window,
                                  text="Decode",
                                  width=15,
                                  cursor="hand2",
                                  command=lambda: decode())

        decode_stego_btn.config(font=("Open Sans", 15),
                                bg="#36923B",
                                fg="white",
                                borderwidth=0)

        decode_stego_btn.place(x=592, y=420)
        decode_opened = True
        decode_window.protocol("WM_DELETE_WINDOW", lambda: close_decode_window(decode_window))



def browse_image(image_frame):
    global file_path, file_path_2, data_to_encode
    path = filedialog.askopenfilename(title="Choose an Image",
                                      filetypes=(("Image Files", "*.bmp"),
                                      ("All Files", "*.*")))

    if image_frame.cget("text") == "Select Image to hide file" or image_frame.cget("text") == "Browse Image to Decode":
        file_path = path
        selected_image = Image.open(path)
        max_width = 350
        aspect_ratio = max_width / float(selected_image.size[0])
        max_height = int((float(selected_image.size[1]) * float(aspect_ratio)))
        selected_image = selected_image.resize((max_width, max_height), Image.ANTIALIAS)
        selected_image = ImageTk.PhotoImage(selected_image)
        image_frame.config(image=selected_image, height=304, width=354)
        image_frame.image = selected_image

    else:
        file_path_2 = path


def close_encode_window(encode_window):
    global encode_opened

    encode_window.destroy()
    encode_opened = False


def close_help_window(help_window):
    global help_opened

    help_window.destroy()
    help_opened = False


def close_decode_window(decode_window):
    global decode_opened

    decode_window.destroy()
    decode_opened = False


window = Tk()
window.title("Steganography")
window.geometry('800x500')
window.resizable(False, False)

if windows:
    windll.shcore.SetProcessDpiAwareness(1)


title_label = Label(window, text="Steganography")
title_label.pack()
title_label.config(font=("Open Sans", 32))

encode_btn = Button(window,
                    text="Encode",
                    height=2,
                    width=15,
                    bg="#503066",
                    fg="white",
                    cursor="hand2",
                    borderwidth=0,
                    command=open_encode_window)

encode_btn.config(font=("Open Sans", 15, "bold"))
encode_btn.pack(side=LEFT, padx=50)

decode_btn = Button(window,
                    text="Decode",
                    height=2,
                    width=15,
                    bg="#36923B",
                    fg="white",
                    cursor="hand2",
                    borderwidth=0,
                    command=open_decode_window)

decode_btn.config(font=("Open Sans", 15, "bold"))
decode_btn.pack(side=RIGHT, padx=50)


footer_label = Label(window, text="Mateusz Jeziorowski")
footer_label.pack(side=BOTTOM, pady=20)

window.mainloop()


