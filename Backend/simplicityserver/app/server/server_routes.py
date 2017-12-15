from endpoints import Endpoints

from flask import Flask, render_template, request, jsonify, g, abort
from werkzeug import secure_filename
import sqlite3
import os
import sys
app = Flask(__name__)

DBPATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "transactions.db")

def get_db():
    """
    Get the connection to the database if one already exists, otherwise create one and save it

    :returns: connection to the database
    """
    db = getattr(g, '_database', None)
    if db is None:
        # print(DBPATH)
        db = g._database = sqlite3.connect(DBPATH)
    return db

def get_endpoints():
    """
    Get the Endpoints class object if one already exists, otherwise create one and save it

    :returns: the Endpoints class object
    """
    ep = getattr(g, 'endpoints', None)
    if ep is None:
        ep = g.endpoints = Endpoints()
    return ep

@app.route('/')
def index():
    """
    Server route for the root directory of the server, which just returns some sample text

    :returns: a String with sample text
    """
    return "Let's go CS130!"

@app.route('/transactions',methods=["GET"])
def transactions():
    """
    Server route for the GET /transactions path of the server, which performs checks on the url parameters before passing them to the endpoint code

    :returns: a json object containing the transactions data for the user
    """
    user_id = request.args.get("userId",'')
    max_num = request.args.get("max",'')
    offset = request.args.get("offset",'')

    if user_id == '':
        abort(400, "Must specify a user id")
    elif not user_id.isdigit():
        abort(400, "The parameter 'userId' must be an integer")
    if max_num == '':
        max_num = -1
    elif not max_num.isdigit():
        abort(400, "The parameter 'max' must be an integer")
    if offset == '':
        offset = 0
    elif not offset.isdigit():
        abort(400, "The parameter 'offset' must be an integer")

    return jsonify(get_endpoints().get_transactions(get_db(), user_id, max_num, offset))

@app.route('/receipt_img',methods=["GET"])
def receipt_img():
    """
    Server route for the GET /receipt_img path of the server, which performs checks on the url parameters before passing them to the endpoint code

    :returns: a json object containing the receipt image data for the user
    """
    transaction_id = request.args.get("transactionId",'')

    if transaction_id == '':
        abort(400, "Must specify a transaction id")
    elif not transaction_id.isdigit():
        abort(400, "The parameter 'transactionId' must be an integer")
   
    return jsonify(get_endpoints().get_receipt_img(get_db(), transaction_id))

@app.route('/receipts',methods=["GET"])
def receipts():
    """
    Server route for the GET /receipts path of the server, which performs checks on the url parameters before passing them to the endpoint code

    :returns: a json object containing the receipts data for the user
    """
    user_id = request.args.get("userId",'')
    max_num = request.args.get("max",'')
    offset = request.args.get("offset",'')

    if user_id == '':
        abort(400, "Must specify a user id")
    elif not user_id.isdigit():
        abort(400, "The parameter 'userId' must be an integer")
    if max_num == '':
        max_num = -1
    elif not max_num.isdigit():
        abort(400, "The parameter 'max' must be an integer")
    if offset == '':
        offset = 0
    elif not offset.isdigit():
        abort(400, "The parameter 'offset' must be an integer")
    
    return jsonify(get_endpoints().get_receipts(get_db(), user_id, max_num, offset))


@app.route('/overview',methods=["GET"])
def overview():
    """
    Server route for the GET /overview path of the server, which performs checks on the url parameters before passing them to the endpoint code

    :returns: a json object containing the overview data for the user
    """
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
    """
    Server route for the GET /breakdown path of the server, which performs checks on the url parameters before passing them to the endpoint code

    :returns: a json object containing the breakdown data for the user
    """
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
    
    return jsonify(get_endpoints().get_breakdown(get_db(), user_id, weeks))

@app.route('/receipt',methods=["POST"])
def receive_image():
    """
    Server route for the POST /receipt path of the server, which performs checks on the json data from the user before passing it to the endpoint code

    :returns: a json object containing the transactionId and guessed amount for the user
    """
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
    """
    Server route for the POST /update_transaction path of the server, which performs checks on the json data from the user before passing it to the endpoint code

    :returns: a json object containing the message string
    """
    json_data = request.get_json()

    if not 'transactionId' in json_data:
        abort(400, "Must specify transaction id")
    if not 'amount' in json_data:
        abort(400, "Must specify amount")

    return get_endpoints().update_transaction(get_db(), json_data['transactionId'], json_data['amount'])

@app.teardown_appcontext
def close_connection(exception):
    """
    Teardown method that runs when the server is stopped, closes database connection
    """
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

if __name__ == '__main__':
   app.run()
