from datetime import datetime
from pathlib import Path
import os

apk = 'build/app/outputs/flutter-apk/app-release.apk'

date_string = datetime.now().strftime('%Y%m%H%M')

new_apk_name = 'build/app/outputs/flutter-apk/app-release-'+ date_string +'.apk'

os.rename(apk, new_apk_name)
