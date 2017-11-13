from flask import Flask, render_template, request, jsonify, g
from werkzeug import secure_filename
from PIL import Image
import sqlite3
import base64
app = Flask(__name__)

DATABASE = 'transactions.db'

def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
    return db

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
        return "wrong url"
    else:
        cur = get_db().cursor()
        cur.execute('SELECT image FROM transactions WHERE transaction_id=?', transactionId)
        return jsonify(img=cur.fetchone()[0])

@app.route('/receipts',methods=["GET"])
def get_receipts():
    userId = request.args.get("userId",'')
    max_val = request.args.get("max",'')
    offset = request.args.get("offset",'')

    if userId == '' or max_val == '' or offset == '':
        return "wrong url"
    else:
        return jsonify(userId=userId,max=max_val,offset=offset)


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
