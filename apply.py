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

HOME_DIR = os.path.expanduser('~')

if __name__ == "__main__":
    flags = sys.argv[1:]
    for flag in flags:
        if is_oneof(flag, "--nvim", "-n"):
            copy("./nvim", f"{HOME_DIR}/.config/nvim")
            # shutil.copytree("./nvim", f"{HOME_DIR}/.config/nvim", dirs_exist_ok=True)
        else: print(f"unsupported argument: {flag}")
