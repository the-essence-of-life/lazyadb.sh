from rich.progress import Progress
import os

Path=input("APK path:")

def Install():
    os.system("adb install %s >>/dev/null 2&>1 && rm -f ./1" % (Path))

with Progress(transient=True) as progress:
    progress.add_task("[blue]Installing...", total=None)
    Install()
