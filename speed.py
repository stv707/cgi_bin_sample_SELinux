#!/usr/bin/python
import cgi
import os
import sys

print '''Content-type: text/html

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Web Server response time</title>
    </head>
    <body>
        <h1>Web Server Response Time</h1>
'''

form = cgi.FieldStorage()
if "host2test" not in form:
    print '''
    <b>Please fill in the "Web Server to test\" field.</b><br/>
    <a href="/speed.html">Go Back</a>
    </body>
    <html>'''
    sys.exit(0)

print '<h2>Response time for ' + form["host2test"].value + '</h2>'
sys.stdout.flush()

ret = os.system("/usr/bin/curl -w 'Connection time %{time_connect} seconds<br/>Total time: %{time_total} seconds<br/>' -s --output /dev/null http://" + form["host2test"].value) 
if ret:
  print '<br/><b style="color:white;background:red;">' + form["host2test"].value + " is not responding</b><br/>"

print '''
    <br/>
    <a href="/speed.html">Go Back</a>
  </body>
<html>
'''