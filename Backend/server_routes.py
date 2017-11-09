from flask import Flask, render_template, request, jsonify
from werkzeug import secure_filename
app = Flask(__name__)

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
        return jsonify(transactionId=transactionId)

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

if __name__ == '__main__':
   app.run(host="0.0.0.0")
