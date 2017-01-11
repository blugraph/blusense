<<<<<<< HEAD
=======

>>>>>>> b23f393ac7758673e457eefcb2e0ac1e352b854e
#! /bin/bash
echo "Uploading Log File."
curl -X POST -T /var/log/syslog.1 https://logs-01.loggly.com/bulk/212069f8-45ba-440c-90c0-34b06bda43f8/tag/file_upload
echo "Log File uploaded."

