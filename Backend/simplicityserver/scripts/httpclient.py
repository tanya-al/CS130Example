#!/usr/bin/env python

from PIL import Image
import base64
import cStringIO
import httplib
import sys
import json


def decode_b64(b64string):
    return Image.open(cStringIO.StringIO(base64.b64decode(b64string)))

#get http server ip
http_server = sys.argv[1]
#create a connection
conn = httplib.HTTPConnection(http_server)

while 1:
  cmd = raw_input('input command (ex. GET index.html): ')
  cmd = cmd.split()

  if cmd[0] == 'exit': #tipe exit to end it
    break

  if cmd[0] == 'GET':
    #request command to server
    conn.request(cmd[0], cmd[1])

    #get response from server
    rsp = conn.getresponse()
    
    #print server response and data
    print(rsp.status, rsp.reason)
    data_received = rsp.read()
    print(data_received)

  if cmd[0] == 'POST':
    data = {'userId': 1, 'category': 'food', 'data': 'image data encoded as base64'}
    headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}

    #request command to server
    conn.request(cmd[0], cmd[1], json.dumps(data), headers)

    #get response from server
    rsp = conn.getresponse()
    
    #print server response and data
    print(rsp.status, rsp.reason)
    data_received = rsp.read()
    print(data_received)

  # decode_b64(json.loads(data_received)[0]['thumbnailImageData']).save("received.jpg", quality=95)

  # print(cmd[1].split("/"))

  # if cmd[1].split("/")[0] == "transactions":
  #   print(data_received)
  # elif cmd[1].split("/")[0] == "receipts":
  #   with open("data_received.jpg", "wb") as file:
  #     file.write(data_received)
  
conn.close()