import platform
import shutil
import subprocess
import threading
import urllib.request

import webview

IS_WINDOWS = platform.system() == "Windows"
IS_LINUX = platform.system() == "Linux"

try:
    if IS_WINDOWS:
        from win10toast import ToastNotifier
    else:
        ToastNotifier = None
except ImportError:
    ToastNotifier = None


APP_VERSION = "1.0.1"
VERSION_URL = "https://quotasocial.fr/version.txt"
DOWNLOAD_URL = "https://quotasocial.fr/app"
SITE_URL = "https://quotasocial.fr"
has_checked_update = False
window = None


def show_popup(message):
    if IS_WINDOWS:
        try:
            import ctypes

            ctypes.windll.user32.MessageBoxW(0, message, "Mise a jour disponible", 0x40)
            return
        except Exception:
            pass

    if IS_LINUX:
        for command in ("zenity", "kdialog", "xmessage"):
            if shutil.which(command):
                try:
                    if command == "zenity":
                        subprocess.Popen(
                            [command, "--info", "--title=Mise a jour disponible", f"--text={message}"]
                        )
                    elif command == "kdialog":
                        subprocess.Popen([command, "--title", "Mise a jour disponible", "--msgbox", message])
                    else:
                        subprocess.Popen([command, "-center", message])
                    return
                except Exception:
                    pass

    if window is not None:
        try:
            window.evaluate_js(f"alert({message!r})")
        except Exception:
            pass


def show_notification(title, message):
    if IS_WINDOWS and ToastNotifier is not None:
        try:
            ToastNotifier().show_toast(title, message, duration=10, threaded=True)
            return
        except Exception:
            pass

    if IS_LINUX and shutil.which("notify-send"):
        try:
            subprocess.Popen(["notify-send", title, message])
        except Exception:
            pass


def check_update():
    try:
        online_version = urllib.request.urlopen(VERSION_URL, timeout=3).read().decode().strip()
        if online_version != APP_VERSION:
            message = (
                "Cette version de Quota Social n'est plus a jour.\n\n"
                f"Version installee : {APP_VERSION}\n"
                f"Version disponible : {online_version}\n\n"
                f"Telecharge la nouvelle version ici : {DOWNLOAD_URL}"
            )

            show_popup(message)
            show_notification(
                "Mise a jour disponible",
                f"Quota Social {online_version} est disponible.",
            )
    except Exception:
        pass


def on_page_loaded():
    global has_checked_update

    if has_checked_update:
        return

    has_checked_update = True
    threading.Thread(target=check_update, daemon=True).start()


window = webview.create_window(
    "Quota Social",
    SITE_URL,
    width=1200,
    height=800,
)

window.events.loaded += on_page_loaded
webview.start()
