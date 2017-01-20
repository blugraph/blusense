import netifaces as ni
import time
import requests
import json
import os
import subprocess
import re
import shutil
WPA_DIR="/etc/wpa_supplicant"
WPA_FILE="wpa_supplicant.conf"

def line_num_for_phrase_in_file(phrase,filename):
    with open(filename,'r') as f:
        for (i, line) in enumerate(f):
            if phrase in line:
                return i
    return -1

with open('/home/arkbg/dev/dev_id.json', 'r') as config_file:
    # Convert JSON to DICT
    config = json.load(config_file)
print config['DEVICE_ID']
dev_ID=config['DEVICE_ID']

with open('/home/arkbg/dev/config/BG_Config.json', 'r') as config_file1:
    config1 = json.load(config_file1)

WIFI_UPDATE_URL = "http://" + config1['WIFI_PATH']
WIFI_UPL= "http://" + config1['WIFI_UP']
payload=[{"stationID":dev_ID}]

try:
#Requests the wifi password, if available comes
  r1 = requests.put(WIFI_UPL, json.dumps(payload), timeout=0.1)
  wfdata= json.loads(r1.content)
  print wfdata
  dir_name="/etc/wpa_supplicant"
  base_filename=(time.strftime("%Y-%m-%d_%H_%M_%S")+"." + "bak")
  abs_file_name=os.path.join(dir_name, base_filename)
  curr_file='/etc/wpa_supplicant/wpa_supplicant.conf'
  try:
        shutil.copy2(curr_file, abs_file_name)
  except:
        print "File copy failed"
  k= line_num_for_phrase_in_file('identity="NUSSTF\SVCSENSOR"', '/etc/wpa_supplicant/wpa_supplicant.conf')
  with open('/etc/wpa_supplicant/wpa_supplicant.conf', 'r') as file:
     data = file.readlines()
     file.close()
  data[k+1] = ("\tpassword="+"\""+str(wfdata[0])+"\""+"\n")
  with open('/etc/wpa_supplicant/wpa_supplicant.conf', 'w') as file:
     file.writelines( data )
     file.close()
# This resets the flag
  try:
    r1 = requests.put(WIFI_UPDATE_URL, json.dumps(payload), timeout=0.1)
    wfdata= json.loads(r1.content)
    print wfdata
  except:
    print "WiFi Feedback Failed"

except:
  print "There is no WIFI update data"
