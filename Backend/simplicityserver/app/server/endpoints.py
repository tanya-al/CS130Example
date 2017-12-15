# -*- coding: utf-8 -*-

import simplicityserver.app.tesseract.extractSpending as extract_spending
from utils import Utils
from datetime import datetime, timedelta
import math

class Endpoints():
    """
    Contains all of the backend server endpoints
    """

    def get_transactions(self, db, user_id, limit, offset):
        """
        Get an array of transactions sorted by date (most recent first), with the specified ``userId`` and a maximum of ``max`` transactions in the array, with an offset of ``offset``

        :param db: database connection
        :param user_id: the id of the user we want to query fields for
        :param limit: max number of rows we want to return
        :param offset: offset of the rows we want to return
        :returns: dict of ``{‘transactionId’, ‘userId’, ‘category’, ‘amount’, ‘date’, 'description'}``
        """
        cur = db.cursor()
        cur.execute(''' SELECT transaction_id, user_id, category, amount, date, description FROM transactions 
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
                    'date': row[4],
                    'description': row[5],
                })
        return dict_list

    def get_receipt_img(self, db, transaction_id):
        """
        Get the receipt image associated with the ``transaction_id``
        
        :param db: database connection
        :param transaction_id: id of the transaction we want to retrieve the image of
        :returns: base64 encoded image associated with the ``transaction_id``
        """
        cur = db.cursor()
        cur.execute('SELECT image FROM transactions WHERE transaction_id=?', (transaction_id,))
        ret = cur.fetchone()
        if ret == None:
            return None
        else:
            return {'img': ret[0]}

    def get_receipts(self, db, user_id, limit, offset):
        """
        Get an array of receipts sorted by date (most recent first), with the specified ``userId``, and receipt images compressed into thumbnail versions

        :param db: database connection
        :param user_id: the id of the user we want to query fields for
        :param limit: max number of rows we want to return
        :param offset: offset of the rows we want to return
        :returns: list of ``{‘transactionId’, ‘userId’, date, ‘thumbnailImageData’}``
        """
        cur = db.cursor()
        cur.execute(''' SELECT transaction_id, user_id, date, thumbnail FROM transactions 
                        WHERE user_id=? 
                        ORDER BY date DESC 
                        LIMIT ? OFFSET ?;''', (user_id, limit, offset))
        dict_list = []
        for row in cur.fetchall():
            dict_list.append({
                    'transactionId': row[0],
                    'userId': row[1],
                    'date': row[2],
                    'thumbnailImageData': row[3]
                })
        return dict_list

    def get_overview(self, db, user_id, weeks):
        """
        Get an overview describing how much the user with ``userId`` spent on each category over the past ``weeks``, by both amount and percentage of total spending.
        
        :param db: database connection
        :param user_id: the id of the user we want to query fields for
        :param weeks: weeks ago we want to look back in the database
        :returns: list of ``{‘category’, ‘amount’, ‘percentage’}``
        """
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
        """
        Get the weekly breakdown by category for past ``weeks`` for ``userId``
        
        :param db: database connection
        :param user_id: the id of the user we want to query fields for
        :param weeks: weeks ago we want to look back in the database
        :returns: dict containing list of breakdown for each category, containing category name and list of amounts per week
        """
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
            "userId": int(user_id),
            "weeks": int(weeks),
            "breakdowns": breakdown_list
        }

    def post_receipt(self, db, user_id, category, description, image_data):
        """
        Use pytesseract to find the amount, and create a transaction for this purchase in the database.
        
        :param db: database connection
        :param user_id: the id of the user we want to query fields for
        :param category: name of the category this transaction belongs in
        :param image_data: base64 encoded string containing the image
        :returns: dict of ``{'transactionId', 'amount'}``
        """
        cur = db.cursor()
        cur.execute('SELECT MAX(transaction_id) FROM transactions')
        maxtransaction = cur.fetchone()[0]
        if(maxtransaction == None):
            transaction_id = 1
        else:
            transaction_id = int(maxtransaction) + 1
        amount = extract_spending.extract_receipt_total(Utils().decode_b64(image_data))
        date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        cur.execute(''' INSERT INTO transactions (transaction_id, user_id, category, amount, date, description, image, thumbnail)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?)''', (transaction_id, user_id, category, amount, date, description, image_data, Utils().get_thumbnail(image_data)))
        db.commit()
        return {'transactionId': transaction_id, 'amount': amount}

    def update_transaction(self, db, transaction_id, amount):
        """
        Check if the transaction exists in the database, and if so then store the amount into that transaction's database entry.

        :param db: database connection
        :param transaction_id: the id of the transaction the user wants to update the amount of
        :param amount: the new amount that the user wants to store into the transaction
        :returns: a string saying that the transaction does not exist, or if it does exist then a string saying 'updated transaction'
        """
        cur = db.cursor()
        cur.execute(''' SELECT transaction_id FROM transactions
                        WHERE transaction_id=?;''', (transaction_id,))
        if len(cur.fetchall()) < 1:
            return 'transaction with id %d does not exist' % transaction_id

        cur.execute(''' UPDATE transactions 
                        SET amount=? 
                        WHERE transaction_id=?; '''
                        , (amount, transaction_id))
        
        db.commit()
        return 'updated transaction'