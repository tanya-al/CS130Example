from flask import Flask, render_template, request, jsonify, g
from werkzeug import secure_filename
from PIL import Image, ImageOps
import sqlite3
import base64
import cStringIO
import json
app = Flask(__name__)

DATABASE = 'transactions.db'

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
    size = (100, 100)
    img = ImageOps.fit(img, size, Image.ANTIALIAS)
    return encode_b64(img)

@app.route('/')
def index():
   return "Let's go CS130!"

@app.route('/transactions',methods=["GET"])
def transactions():
    userId = request.args.get("userId",'')
    max_val = request.args.get("max",'')
    offset = request.args.get("offset",'')

    if userId == '' or max_val == '' or offset == '':
        return "wrong url"
    else:
        return jsonify(userId=userId,max=max_val,offset=offset)

@app.route('/receipt_img',methods=["GET"])
def get_receipt_img():
    transactionId = request.args.get("transactionId",'')
    if transactionId == '':
        return "Must specify transaction id"
   
    cur = get_db().cursor()
    cur.execute('SELECT image FROM transactions WHERE transaction_id=?', (transactionId,))
    return jsonify(img=cur.fetchone()[0])

@app.route('/receipts',methods=["GET"])
def get_receipts():
    user_id = request.args.get("userId",'')
    max_num = request.args.get("max",'')
    offset = request.args.get("offset",'')

    if user_id == '':
        return "Must specify user id"
    if max_num == '':
        max_num = 20
    if offset == '':
        offset = 0
    
    cur = get_db().cursor()
    cur.execute('SELECT transaction_id, user_id, date, image FROM transactions WHERE user_id=? ORDER BY date DESC LIMIT ? OFFSET ?;', (user_id, max_num, offset))
    dict_list = []
    for row in cur.fetchall():
        dict_list.append({
                'transactionId': row[0],
                'userId': row[1],
                'date': row[2],
                'thumbnailImageData': get_thumbnail(row[3])
            })
    print(dict_list)
    return jsonify(dict_list)


@app.route('/overview',methods=["GET"])
def get_overview():
    userId = request.args.get("userId",'')
    week = request.args.get("weeks",'')

    if userId == '' or week == '':
        return "wrong url"
    else:
        return jsonify(userId=userId,weeks=week)

@app.route('/breakdown',methods=["GET"])
def get_breakdown():
    userId = request.args.get("userId",'')
    week = request.args.get("weeks",'')

    if userId == '' or week == '':
        return "wrong url"
    else:
        return jsonify(userId=userId,weeks=week)

@app.route('/receipt',methods=["POST"])
def receive_image():
    return "image_received"

@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

if __name__ == '__main__':
   # app.run(host="0.0.0.0")
   app.run(host="127.0.0.1")
