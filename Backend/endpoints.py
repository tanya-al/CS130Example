import utils
from datetime import datetime

def get_transactions(db, user_id, limit, offset):
    cur = db.cursor()
    cur.execute(''' SELECT transaction_id, user_id, category, amount, date FROM transactions 
                    WHERE user_id=? 
                    ORDER BY date DESC 
                    LIMIT ? OFFSET ?;''', (user_id, limit, offset))
    dict_list = []
    for row in cur.fetchall():
        dict_list.append({
                'transactionId': row[0],
                'userId': row[1],
                'category': row[2],
                'amount': row[3],
                'date': row[4]
            })
    return dict_list

def get_receipt_img(db, transaction_id):
    cur = db.cursor()
    cur.execute('SELECT image FROM transactions WHERE transaction_id=?', (transaction_id,))
    return {'img': cur.fetchone()[0]}

def get_receipts(db, user_id, limit, offset):
    cur = db.cursor()
    cur.execute(''' SELECT transaction_id, user_id, date, image FROM transactions 
                    WHERE user_id=? 
                    ORDER BY date DESC 
                    LIMIT ? OFFSET ?;''', (user_id, limit, offset))
    dict_list = []
    for row in cur.fetchall():
        dict_list.append({
                'transactionId': row[0],
                'userId': row[1],
                'date': row[2],
                'thumbnailImageData': utils.get_thumbnail(row[3])
            })
    return dict_list

def get_overview(db, user_id, weeks):
    # TODO: implement
    return {'userId': user_id, 'weeks': weeks}

def get_breakdown(db, user_id, weeks):
    # TODO: implement
    return {'userId': user_id, 'weeks': weeks}

def post_receipt(db, user_id, category, image_data):
    cur = db.cursor()
    cur.execute('SELECT MAX(transaction_id) FROM transactions')
    transaction_id = int(cur.fetchone()[0]) + 1
    # replace with call to tesseract API
    amount = 99.99  
    date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    cur.execute(''' INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
                    VALUES (?, ?, ?, ?, ?, ?)''', (transaction_id, user_id, category, amount, date, image_data))
    db.commit()