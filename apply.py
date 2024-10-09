import sys, shutil, os

BACKUP_DIRECTORY = "restore"

def is_oneof(s: str, *args):
    for arg in args:
        if s == arg: return True
    return False 

def copy(path_from: str, path_to: str):
    if os.path.exists(path_from):
        shutil.copytree(path_to, f"{BACKUP_DIRECTORY}/{os.path.basename(path_from)}", dirs_exist_ok=True)
    shutil.copytree(path_from, path_to, dirs_exist_ok=True)

def copy_file(path_from: str, path_to: str):
    if os.path.exists(path_from):
        shutil.copy(path_to, f"{BACKUP_DIRECTORY}/{os.path.basename(path_from)}")
    shutil.copy(path_from, path_to)


HOME_DIR = os.path.expanduser('~')

if __name__ == "__main__":
    flags = sys.argv[1:]
    for flag in flags:
        if is_oneof(flag, "--nvim", "-n"):
            copy("./nvim", f"{HOME_DIR}/.config/nvim")
        elif is_oneof(flag, "--zshrc", "-z"):
            copy_file("./.zshrc", f"{HOME_DIR}/.zshrc")
        elif is_oneof(flag, "--alacritty", "-a"):
            copy("./alacritty", f"{HOME_DIR}/.config/alacritty")
        else: print(f"unsupported argument: {flag}")
