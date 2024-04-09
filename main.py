import tkinter as tk
from pynput import keyboard
import pystray
from PIL import Image
from pystray import MenuItem


def create_window():
    root = tk.Tk()
    root.overrideredirect(True)
    root.configure(background='black')
    root.attributes('-alpha', 0.5)
    root.attributes('-topmost', True)

    window_width = 200
    window_height = 300

    screen_width = root.winfo_screenwidth()
    screen_height = root.winfo_screenheight()

    x = screen_width - window_width
    y = (screen_height - window_height) // 2
    root.geometry(f'{window_width}x{window_height}+{x}+{y}')

    labels = ["Main", "Common", "Statistics", "Controls", "Info", "Exit"]
    for label in labels:
        tk.Label(root, text=label, background='black', foreground='white', anchor='e').pack(fill='x', pady=5)

    # Function to show/hide the window
    def toggle_window():
        if root.winfo_viewable():
            root.withdraw()  # Hide the window
        else:
            root.deiconify()  # Show the window

    # Define a function to be called on key press
    def on_press(key):
        try:
            if key.char == 'x':  # Check if the key is "x"
                toggle_window()
        except AttributeError:
            pass

    # Listen for keyboard events in a non-blocking manner
    listener = keyboard.Listener(on_press=on_press)
    listener.start()

    root.mainloop()


def create_system_tray_icon():
    # Load the icon image (ensure the path to the icon is correct)
    icon_image = Image.open("keyboard.ico")

    # Create and run the system tray icon
    tray_icon = pystray.Icon("tray_icon", icon_image, "My Tray Icon")
    tray_icon.title = "Tutla"

    def callback():
        print("Hello world")
        pass

    tray_icon.menu = pystray.Menu(MenuItem("Exit",callback))

    tray_icon.run()



if __name__ == "__main__":
    create_system_tray_icon()
    create_window()

