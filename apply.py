import sys, shutil, os

def is_oneof(s: str, *args):
    for arg in args:
        if s == arg: return True
    return False 

HOME_DIR = os.path.expanduser('~')

if __name__ == "__main__":
    flags = sys.argv[1:]
    for flag in flags:
        if is_oneof(flag, "--nvim", "-n"):
            shutil.copytree("./nvim", f"{HOME_DIR}/.config/nvim", dirs_exist_ok=True)
        else: print(f"unsupported argument: {flag}")
