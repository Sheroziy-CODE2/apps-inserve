from datetime import datetime
from pathlib import Path
import os

apk = 'build/app/outputs/flutter-apk/app-release.apk'

build_name = sys.argv[1]

build_number = sys.argv[2]

new_apk_name = 'build/app/outputs/flutter-apk/inserve-app-release-'+ build_name + "("+build_number+")" +'.apk'

os.rename(apk, new_apk_name)
