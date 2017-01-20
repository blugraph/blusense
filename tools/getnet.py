
import netifaces as ni
import time
import requests
import json
import os
import subprocess
import re

#dev_ID="D1070"
#SERVER_ADDR="http://172.18.53.42:81/BluIEQ/sensorstatus.php""
#SERVER_ADDR="http://52.74.191.39/BluIEQ/sensorstatus.php"

with open('/home/arkbg/dev/dev_id.json', 'r') as config_file:
    # Convert JSON to DICT
    config = json.load(config_file)
print config['DEVICE_ID']
dev_ID=config['DEVICE_ID']

# Build destination server path
with open('/home/arkbg/dev/config/BG_Config.json', 'r') as config_file1:
    # Convert JSON to DICT
    config1 = json.load(config_file1)
SERVER_PATH = "http://" + config1['GETNET_PATH']
print SERVER_PATH

tofile=[]

from uuid import getnode as get_mac
mac = get_mac()
print hex(mac)
mac = hex(mac)

def findThisProcess( process_name ):
  ps     = subprocess.Popen("ps -eaf | grep "+process_name, shell=True, stdout=subprocess.PIPE)
  output = ps.stdout.read()
  ps.stdout.close()
  ps.wait()

  return output

def isThisRunning( process_name ):
  output = findThisProcess( process_name )

  if re.search('/home/arkbg/dev/'+process_name, output) is None:
    return False
  else:
    return True

if isThisRunning('sense.py') == False:
  print("Not running")
  state="Not running"
else:
  print("Running!")
  state="Running"


ni.ifaddresses('wlan0')
ip = ni.ifaddresses('wlan0')[2][0]['addr']
print ip

t = time.strftime("%Y-%m-%d %H:%M:%S")

print t

payload = {"deviceID":dev_ID, "ip": ip,"mac": mac, "status":state, "time":t}
tofile.append(payload)

try:
  r1 = requests.put(SERVER_PATH, data=json.dumps(tofile), timeout=0.1)
  print t,r1.status_code,": server response."
  del tofile[:]
except:
  print t,": Network Failed while uploading data buffer:"
  del tofile[:]

