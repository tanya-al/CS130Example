import simplicityserver.app.tesseract.extractSpending as extract_spending
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
        target_dates = [datetime.now().strftime('%Y-%m-%d %H:%M:%S')] + target_dates
        cur = db.cursor()
        weekdicts = []
        for i in range(1, len(target_dates)):
            cur.execute('''SELECT category, amount FROM transactions
                         WHERE user_id=? 
                         AND date <= ?
                         AND date > ?;'''
                         , (user_id, target_dates[i-1], target_dates[i]))
            transactions = cur.fetchall()
            categories = {}
            for t in transactions:
                if t[0] in categories:
                    categories[t[0]] += t[1]
                else:
                    categories[t[0]] = t[1]
            weekdicts.append(categories)

        breakdown = {}
        for i in range(len(weekdicts)):
            for category in weekdicts[i]:
                if not category in breakdown:
                    breakdown[category] = [0] * len(weekdicts)
                breakdown[category][i] = weekdicts[i][category]

        breakdown_list = []
        for category in breakdown:
            d = {
                "category": category,
                "amounts": breakdown[category]
            }
            breakdown_list.append(d)

        return {
            "userId": user_id,
            "weeks": weeks,
            "breakdowns": breakdown_list
        }

    def post_receipt(self, db, user_id, category, image_data):
        print("here1")
        cur = db.cursor()
        cur.execute('SELECT MAX(transaction_id) FROM transactions')
        transaction_id = int(cur.fetchone()[0]) + 1
        print("here2")
        amount = extract_spending.extract_receipt_total(Utils().decode_b64(image_data))
        print("here3")
        date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        cur.execute(''' INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
                        VALUES (?, ?, ?, ?, ?, ?)''', (transaction_id, user_id, category, amount, date, image_data))
        db.commit()
        return {'transactionId': transaction_id, 'amount': amount}

    def update_transaction(self, db, transaction_id, amount):
        cur = db.cursor()
        cur.execute(''' UPDATE transactions 
                        SET amount=? 
                        WHERE transaction_id=?; '''
                        , (amount, transaction_id))
        
        db.commit()
        return "done"