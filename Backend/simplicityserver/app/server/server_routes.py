from endpoints import Endpoints

from flask import Flask, render_template, request, jsonify, g, abort
from werkzeug import secure_filename
import sqlite3
import os
import sys
app = Flask(__name__)

DBPATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "transactions.db")

def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        # print(DBPATH)
        db = g._database = sqlite3.connect(DBPATH)
    return db

def get_endpoints():
    ep = getattr(g, 'endpoints', None)
    if ep is None:
        ep = g.endpoints = Endpoints()
    return ep

@app.route('/')
def index():
   return "Let's go CS130!"

@app.route('/transactions',methods=["GET"])
def transactions():
    user_id = request.args.get("userId",'')
    max_num = request.args.get("max",'')
    offset = request.args.get("offset",'')

    if user_id == '':
        abort(400, "Must specify a user id")
    elif not user_id.isdigit():
        abort(400, "The parameter 'userId' must be an integer")
    if max_num == '':
        max_num = 20
    elif not max_num.isdigit():
        abort(400, "The parameter 'max' must be an integer")
    if offset == '':
        offset = 0
    elif not offset.isdigit():
        abort(400, "The parameter 'offset' must be an integer")

    return jsonify(get_endpoints().get_transactions(get_db(), user_id, max_num, offset))

@app.route('/receipt_img',methods=["GET"])
def receipt_img():
    transaction_id = request.args.get("transactionId",'')

    if transaction_id == '':
        abort(400, "Must specify a transaction id")
    elif not transaction_id.isdigit():
        abort(400, "The parameter 'transactionId' must be an integer")
   
    return jsonify(get_endpoints().get_receipt_img(get_db(), transaction_id))

@app.route('/receipts',methods=["GET"])
def receipts():
    user_id = request.args.get("userId",'')
    max_num = request.args.get("max",'')
    offset = request.args.get("offset",'')

    if user_id == '':
        abort(400, "Must specify a user id")
    elif not user_id.isdigit():
        abort(400, "The parameter 'userId' must be an integer")
    if max_num == '':
        max_num = 20
    elif not max_num.isdigit():
        abort(400, "The parameter 'max' must be an integer")
    if offset == '':
        offset = 0
    elif not offset.isdigit():
        abort(400, "The parameter 'offset' must be an integer")
    
    return jsonify(get_endpoints().get_receipts(get_db(), user_id, max_num, offset))


@app.route('/overview',methods=["GET"])
def overview():
    user_id = request.args.get("userId",'')
    weeks = request.args.get("weeks",'')

    if user_id == '':
        abort(400, "Must specify a user id")
    elif not user_id.isdigit():
        abort(400, "The parameter 'userId' must be an integer")
    if weeks == '':
        abort(400, "Must specify the number of weeks")
    elif not weeks.isdigit():
        abort(400, "The parameter 'weeks' must be an integer")

    return jsonify(get_endpoints().get_overview(get_db(), user_id, weeks))

@app.route('/breakdown',methods=["GET"])
def breakdown():
    user_id = request.args.get("userId",'')
    weeks = request.args.get("weeks",'')

    if user_id == '':
        abort(400, "Must specify a user id")
    elif not user_id.isdigit():
        abort(400, "The parameter 'userId' must be an integer")
    if weeks == '':
        abort(400, "Must specify the number of weeks")
    elif not user_id.isdigit():
        abort(400, "The parameter 'weeks' must be an integer")
    
    return jsonify(get_endpoints().get_breakdown(get_db(), user_id, weeks))

@app.route('/receipt',methods=["POST"])
def receive_image():
    json_data = request.get_json()

    if not 'userId' in json_data:
        abort(400, "Must specify user id")
    if not 'category' in json_data:
        abort(400, "Must specify category")
    if not 'description' in json_data:
        abort(400, "Must include description")
    if not 'data' in json_data:
        abort(400, "Must include image data") 

    return jsonify(get_endpoints().post_receipt(get_db(), json_data['userId'], json_data['category'], json_data['description'], json_data['data']))

@app.route('/update_transaction',methods=["POST"])
def update_transaction():
    json_data = request.get_json()

    if not 'transactionId' in json_data:
        abort(400, "Must specify transaction id")
    if not 'amount' in json_data:
        abort(400, "Must specify amount")

    get_endpoints().update_transaction(get_db(), json_data['transactionId'], json_data['amount'])
    return "updated transaction"

@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

if __name__ == '__main__':
   app.run()
