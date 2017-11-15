import endpoints as ep

from flask import Flask, render_template, request, jsonify, g
from werkzeug import secure_filename
import sqlite3
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
    user_id = request.args.get("userId",'')
    max_num = request.args.get("max",'')
    offset = request.args.get("offset",'')

    if user_id == '':
        return "Must specify user id"
    if max_num == '':
        max_num = 20
    if offset == '':
        offset = 0

    return jsonify(ep.get_transactions(get_db(), user_id, max_num, offset))

@app.route('/receipt_img',methods=["GET"])
def receipt_img():
    transaction_id = request.args.get("transactionId",'')
    if transaction_id == '':
        return "Must specify transaction id"
   
    return jsonify(ep.get_receipt_img(get_db(), transaction_id))

@app.route('/receipts',methods=["GET"])
def receipts():
    user_id = request.args.get("userId",'')
    max_num = request.args.get("max",'')
    offset = request.args.get("offset",'')

    if user_id == '':
        return "Must specify user id"
    if max_num == '':
        max_num = 20
    if offset == '':
        offset = 0
    
    return jsonify(ep.get_receipts(get_db(), user_id, max_num, offset))


@app.route('/overview',methods=["GET"])
def overview():
    user_id = request.args.get("userId",'')
    weeks = request.args.get("weeks",'')

    if user_id == '':
        return "Must specify user id"
    if weeks == '':
        return "Must specify number of weeks"
    return jsonify(ep.get_overview(get_db(), user_id, weeks))

@app.route('/breakdown',methods=["GET"])
def breakdown():
    user_id = request.args.get("userId",'')
    weeks = request.args.get("weeks",'')

    if user_id == '':
        return "Must specify user id"
    if weeks == '':
        return "Must specify number of weeks"
    
    return jsonify(ep.get_breakdown(get_db(), user_id, weeks))

@app.route('/receipt',methods=["POST"])
def receive_image():
    json_data = request.get_json()

    if not 'userId' in json_data:
        return "Must specify user id"
    if not 'category' in json_data:
        return "Must specify category"
    if not 'data' in json_data:
        return "Must include image data"

    ep.post_receipt(get_db(), json_data['userId'], json_data['category'], json_data['data'])
    return "image_received"

@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

if __name__ == '__main__':
   # app.run(host="0.0.0.0")
   app.run(host="127.0.0.1")
