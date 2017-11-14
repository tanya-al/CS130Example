from flask import Flask, render_template, request, jsonify, g
from werkzeug import secure_filename
from PIL import Image
import sqlite3
import base64
import cStringIO
app = Flask(__name__)

def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
    return db

def encode_b64(img):
    jpeg_image_buffer = cStringIO.StringIO()
    img.save(jpeg_image_buffer, format="JPEG")
    return base64.b64encode(jpeg_image_buffer.getvalue())

def decode_b64(b64string):
    return Image.open(cStringIO.StringIO(base64.b64decode(b64string)))

def get_thumbnail(b64string):
    img = decode_b64(b64string)
    img = img.resize((100, 100), Image.ANTIALIAS)
    return encode_b64(img)

decode_b64(get_thumbnail(encode_b64(Image.open("1001-2.jpg")))).save("thumbnail_test.jpg", quality=95)