import os
import time
import json
from os import listdir
from os.path import isfile, join
import glob, os
import requests
import cPickle as pickle


file_list = []

#SERVER_ADDR = "172.18.53.42:81"
SERVER_ADDR = "52.74.191.39"
RUN_DIR = "/home/arkbg/dev/"

dir_name = RUN_DIR + time.strftime("%Y-%m-%d")

os.chdir(dir_name)
for file in glob.glob("*.dat"):
    file_list.append(file)

print "There are " + str(len(file_list)) + " files in the directory"

# print file_list

if len(file_list) == 0:
    print "There are no files in the directory"

for k in range(0, len(file_list)):
    try:
	data2 = []
        print file_list[k]
        with open(file_list[k], 'r') as input:
            print "File opened for reading."
            #payload = pickle.load(input)
	    data2  = pickle.load(input) 
            #data2_j = "[" + json.dumps(payload) + "]"
            #for i in range(pickle.load(input)):
        #	data2.append(pickle.load(input))
    	    for w in data2:
                print w
	    #print payload
    except OSError as err:
        print "The file can not be read"
        print err

    try:
        #svc_url = "http://" + SERVER_ADDR + "/BluIEQ/sensordata.php" + "?id=" + dev_ID
        svc_url = "http://" + SERVER_ADDR + "/BluIEQ/sensordata.php"
        data2_j = "[" + json.dumps(payload) + "]"
        #print data2_j
        #r1 = requests.put(svc_url, data2_j, timeout=0.1)
        #r1 = requests.put(svc_url, data=json.dumps(payload), timeout=0.1)
        print r1.status_code
        try:
            #os.remove(file_list[k])
	    print "Not writing here"	
        except OSError, e:  ## if failed, report it back to the user ##
            print ("Error: %s - %s." % (e.filename, e.strerror))

    except:
        print "Network Failed Error:"
