from PIL import Image
from collections import OrderedDict
import sqlite3
import base64
import cStringIO
import json
import os
import sys

# DBPATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../app/server/transactions.db")
RECEIPTSPATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "receipts")

def encode_b64(img):
    jpeg_image_buffer = cStringIO.StringIO()
    img.save(jpeg_image_buffer, format="JPEG")
    return base64.b64encode(jpeg_image_buffer.getvalue())

if __name__ == '__main__':
	dbpath = os.path.join(os.getcwd(), sys.argv[1])
	print("dbpath: " + dbpath)
	conn = sqlite3.connect(dbpath)
	cur = conn.cursor()

	# clear table
	cur.execute('DELETE FROM transactions')

	# insert values
	transaction_id = 1
	b64 = encode_b64(Image.open(os.path.join(RECEIPTSPATH, "1001-1.jpg")))
	cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
					VALUES (?, 1, "grocery", 722.52, "2017-10-15 12:30:45", ?)''', (transaction_id, b64))
	transaction_id += 1

	b64 = encode_b64(Image.open(os.path.join(RECEIPTSPATH, "1001-2.jpg")))
	cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
					VALUES (?, 1, "retail", 43.59, "2017-10-16 10:15:30", ?)''', (transaction_id, b64))
	transaction_id += 1

	b64 = encode_b64(Image.open(os.path.join(RECEIPTSPATH, "1001-3.jpg")))
	cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
					VALUES (?, 1, "grocery", 45.05, "2017-10-18 15:45:15", ?)''', (transaction_id, b64))
	transaction_id += 1

	b64 = encode_b64(Image.open(os.path.join(RECEIPTSPATH, "1002-1.jpg")))
	cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
					VALUES (?, 2, "grocery", 8.84, "2017-10-17 09:10:42", ?)''', (transaction_id, b64))
	transaction_id += 1

	b64 = encode_b64(Image.open(os.path.join(RECEIPTSPATH, "1002-2.jpg")))
	cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
					VALUES (?, 2, "transportation", 53.80, "2017-10-20 11:23:56", ?)''', (transaction_id, b64))
	transaction_id += 1

	b64 = encode_b64(Image.open(os.path.join(RECEIPTSPATH, "1002-3.jpg")))
	cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
					VALUES (?, 2, "food", 54.50, "2017-10-21 06:12:42", ?)''', (transaction_id, b64))
	transaction_id += 1

	b64 = encode_b64(Image.open(os.path.join(RECEIPTSPATH, "1002-4.jpg")))
	cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
					VALUES (?, 2, "food", 64.60, "2017-10-23 16:36:38", ?)''', (transaction_id, b64))
	transaction_id += 1

	b64 = encode_b64(Image.open(os.path.join(RECEIPTSPATH, "1003-1.jpg")))
	cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
					VALUES (?, 3, "food", 89.42, "2017-10-08 19:29:53", ?)''', (transaction_id, b64))
	transaction_id += 1

	b64 = encode_b64(Image.open(os.path.join(RECEIPTSPATH, "1003-2.jpg")))
	cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
					VALUES (?, 3, "transportation", 60.00, "2017-10-12 21:20:39", ?)''', (transaction_id, b64))
	transaction_id += 1

	#====================== overview dummy data ======================#
	cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
					VALUES (?, 42069, "Restaurant", 60.00, "2017-11-14 19:29:00", "image_b64")''', (transaction_id,))
	transaction_id += 1

	cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
					VALUES (?, 42069, "Transportation", 40.00, "2017-11-14 19:30:00", "image_b64")''', (transaction_id,))
	transaction_id += 1

	cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
					VALUES (?, 42069, "Textbook", 30.00, "2017-11-14 19:31:00", "image_b64")''', (transaction_id,))
	transaction_id += 1

	cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
					VALUES (?, 42069, "Grocery", 40.00, "2017-11-14 19:32:00", "image_b64")''', (transaction_id,))
	transaction_id += 1

	cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
					VALUES (?, 42069, "Other", 30.00, "2017-11-14 19:33:00", "image_b64")''', (transaction_id,))
	transaction_id += 1
	#==================== end overview dummy data ====================#

	conn.commit()

	cur.execute('SELECT transaction_id, user_id, date FROM transactions WHERE user_id=1001 ORDER BY date DESC LIMIT 3;')
	# res = cur.fetchall()

	# print(json.dumps(OrderedDict([
	# 	('transactionId', res[0]),
	# 	('userId', res[1]),
	# 	('date', res[2])
	# ]), sort_keys=False, indent=4))

	# dict_list = []
	# for row in cur.fetchall():
	# 	ordered_dict = OrderedDict([
	# 			('transactionId', row[0]),
	# 			('userId', row[1]),
	# 			('date', row[2])
	# 		])
	# 	dict_list.append(ordered_dict)

	# print(json.dumps(dict_list, indent=4))

	# print(cur.fetchall())