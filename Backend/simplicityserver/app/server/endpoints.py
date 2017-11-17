from utils import Utils
from datetime import datetime, timedelta
import math

class Endpoints():
    def get_transactions(self, db, user_id, limit, offset):
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

    def get_receipt_img(self, db, transaction_id):
        cur = db.cursor()
        cur.execute('SELECT image FROM transactions WHERE transaction_id=?', (transaction_id,))
        ret = cur.fetchone()
        if ret == None:
            return None
        else:
            return {'img': ret[0]}

    def get_receipts(self, db, user_id, limit, offset):
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
                    'thumbnailImageData': Utils().get_thumbnail(row[3])
                })
        return dict_list

    def get_overview(self, db, user_id, weeks):
        days = int(weeks) * 7
        target_date = (datetime.now() - timedelta(days=days)).strftime('%Y-%m-%d %H:%M:%S')
        cur = db.cursor()
        cur.execute('''SELECT category, amount FROM transactions
                     WHERE user_id=? 
                     AND CAST(strftime('%s', date) AS integer) 
                         > CAST(strftime('%s', ?) AS integer);'''
                     , (user_id, target_date))
        dict_list = []
        for row in cur.fetchall():
            # check if this category already exists
            existed = False
            for d in dict_list:
                if d["category"] == row[0]:
                    existed = True
                    d["amount"] = round(row[1] + d["amount"],2)
            if not existed:
                dict_list.append({
                        'category': row[0],
                        'amount': row[1],
                    })
        
        # calculate total
        total = 0.0
        for transaction in dict_list:
            # print(transaction)
            total += transaction['amount']

        # append percentage
        for transaction in dict_list:
            transaction['percentage'] = round(transaction['amount']/total * 100,2)

        # print(dict_list)
        return dict_list

    def get_breakdown(self, db, user_id, weeks):
        weeklist = [7 * (i+1) for i in range(int(weeks))]
        target_dates = [(datetime.now() - timedelta(days=d)).strftime('%Y-%m-%d %H:%M:%S') for d in weeklist]
        dict_list = []
        cur = db.cursor()
        i = 1
        for date in target_dates:
            cur.execute('''SELECT category, amount FROM transactions
                         WHERE user_id=? 
                         AND CAST(strftime('%s', date) AS integer) 
                             > CAST(strftime('%s', ?) AS integer);'''
                         , (user_id, date))
            breakdown = []
            for row in cur.fetchall():
                # check if this category already exists
                existed = False
                for d in breakdown:
                    if d["category"] == row[0]:
                        existed = True
                        d["amount"] = round(row[1] + d["amount"],2)
                if not existed:
                    breakdown.append({
                            'category': row[0],
                            'amount': row[1],
                        })

            # calculate total
            total = 0.0
            for transaction in breakdown:
                # print(transaction)
                total += transaction['amount']

            # append percentage
            for transaction in breakdown:
                transaction['percentage'] = round(transaction['amount']/total * 100,2)

            dict_list.append({
                'week': i,
                'categories': breakdown})
            i += 1

        # print(dict_list)
        return dict_list

    def post_receipt(self, db, user_id, category, image_data):
        cur = db.cursor()
        cur.execute('SELECT MAX(transaction_id) FROM transactions')
        transaction_id = int(cur.fetchone()[0]) + 1
        # replace with call to tesseract API
        amount = 99.99  
        date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        cur.execute(''' INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
                        VALUES (?, ?, ?, ?, ?, ?)''', (transaction_id, user_id, category, amount, date, image_data))
        db.commit()