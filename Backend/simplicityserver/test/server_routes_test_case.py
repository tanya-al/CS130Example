import simplicityserver.app.server.server_routes as server_routes
import unittest
import os
import sys
import sqlite3
import json
from datetime import datetime, timedelta, date
from operator import itemgetter
from PIL import Image
import base64
import cStringIO

# Before running: export PYTHONPATH=${PYTHONPATH}:<path to Backend directory>
# To run (from the Backend directory): python2 simplicityserver/test/server_routes_test_case.py

TESTDBPATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "test.db")
TESTIMGPATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "test_img.jpg")
TESTTHUMBPATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "test_thumb.jpg")
TEMPTHUMBPATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "temp_thumb.jpg")

def encode_b64(img):
    jpeg_image_buffer = cStringIO.StringIO()
    img.save(jpeg_image_buffer, format="JPEG")
    return base64.b64encode(jpeg_image_buffer.getvalue())

def decode_b64(b64string):
    return Image.open(cStringIO.StringIO(base64.b64decode(b64string)))

class ServerRoutesTestCase(unittest.TestCase):
	#===================== set up and tear down =====================#
	@classmethod
	def setUpClass(cls):
		server_routes.app.testing = True
		server_routes.DBPATH = TESTDBPATH
		cls._app = server_routes.app.test_client()
		cls._conn = sqlite3.connect(TESTDBPATH)
		cur = cls._conn.cursor()
		cur.execute('DROP TABLE IF EXISTS transactions')
		cur.execute('''CREATE TABLE transactions (
						transaction_id integer PRIMARY KEY,
						user_id integer NOT NULL,
					  	category text NOT NULL,
					  	amount real NOT NULL,
					  	date text NOT NULL,
					  	description text NOT NULL,
  						image text NOT NULL,
  						thumbnail text NOT NULL)''')

	@classmethod
	def tearDownClass(cls):
		cls._conn.close()
		if os.path.exists(TESTDBPATH):
			os.remove(TESTDBPATH)
		if os.path.exists(TEMPTHUMBPATH):
			os.remove(TEMPTHUMBPATH)

	def tearDown(self):
		cur = self._conn.cursor()
		cur.execute('DELETE FROM transactions')
		self._conn.commit()

	#====================== transactions tests ======================#
	def test_transactions_existing_user(self):
		cur = self._conn.cursor()
		cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, description, image, thumbnail)
						VALUES 	(1, 1, "cat1", 10.01, "2000-01-01 00:00:00", "desc1", "img1", "thumb1"),
								(2, 1, "cat2", 20.02, "2000-01-02 00:00:00", "desc2", "img2", "thumb2"),
								(3, 1, "cat3", 30.03, "2000-01-03 00:00:00", "desc3", "img3", "thumb3")''')
		self._conn.commit()
		rv = self._app.get('/transactions?userId=1&max=2&offset=1')
		rvdata = json.loads(rv.data)

		self.assertEqual(len(rvdata), 2)

		self.assertEqual(rvdata[0]['transactionId'], 2)
		self.assertEqual(rvdata[0]['userId'], 1)
		self.assertEqual(rvdata[0]['category'], "cat2")
		self.assertEqual(rvdata[0]['amount'], 20.02)
		self.assertEqual(rvdata[0]['date'], "2000-01-02 00:00:00")
		self.assertEqual(rvdata[0]['description'], "desc2")

		self.assertEqual(rvdata[1]['transactionId'], 1)
		self.assertEqual(rvdata[1]['userId'], 1)
		self.assertEqual(rvdata[1]['category'], "cat1")
		self.assertEqual(rvdata[1]['amount'], 10.01)
		self.assertEqual(rvdata[1]['date'], "2000-01-01 00:00:00")
		self.assertEqual(rvdata[1]['description'], "desc1")

	def test_transactions_non_existing_user(self):
		rv = self._app.get('/transactions?userId=1')
		rvdata = json.loads(rv.data)
		self.assertEqual(len(rvdata), 0)

	def test_transactions_invalid_parameters(self):
		rv = self._app.get('/transactions')
		self.assertEqual(rv._status_code, 400)

		rv = self._app.get('/transactions?userId=a')
		self.assertEqual(rv._status_code, 400)

		rv = self._app.get('/transactions?userId=1&max=b')
		self.assertEqual(rv._status_code, 400)

		rv = self._app.get('/transactions?userId=1&max=1&offset=c')
		self.assertEqual(rv._status_code, 400)

	#====================== receipt_img tests =======================#
	def test_receipt_img_existing_transactions(self):
		cur = self._conn.cursor()
		cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, description, image, thumbnail)
						VALUES 	(1, 1, "cat1", 10.01, "2000-01-01 00:00:00", "desc1", "img1", "thumb1"),
								(2, 1, "cat2", 20.02, "2000-01-02 00:00:00", "desc2", "img2", "thumb2")''')
		self._conn.commit()
		rv = self._app.get('/receipt_img?transactionId=1')
		rvdata = json.loads(rv.data)
		self.assertEqual(rvdata['img'], "img1")

		rv = self._app.get('/receipt_img?transactionId=2')
		rvdata = json.loads(rv.data)
		self.assertEqual(rvdata['img'], "img2")

	def test_receipt_img_non_existing_transaction(self):
		rv = self._app.get('/receipt_img?transactionId=1')
		rvdata = json.loads(rv.data)
		self.assertEqual(rvdata, None)

	def test_receipt_img_invalid_parameters(self):
		rv = self._app.get('/receipt_img')
		self.assertEqual(rv._status_code, 400)

		rv = self._app.get('/receipt_img?transactionId=a')
		self.assertEqual(rv._status_code, 400)

	#======================= receipts tests =========================#
	def test_receipts_existing_transactions(self):
		cur = self._conn.cursor()
		cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, description, image, thumbnail)
						VALUES 	(1, 1, "cat1", 10.01, "2000-01-01 00:00:00", "desc1", "img1", "thumb1"),
								(2, 1, "cat2", 20.02, "2000-01-02 00:00:00", "desc2", "img2", "thumb2"),
								(3, 1, "cat3", 30.03, "2000-01-03 00:00:00", "desc3", "img3", "thumb3")''')
		self._conn.commit()
		rv = self._app.get('/receipts?userId=1&max=2&offset=1')
		rvdata = json.loads(rv.data)

		self.assertEqual(len(rvdata), 2)

		self.assertEqual(rvdata[0]['transactionId'], 2)
		self.assertEqual(rvdata[0]['userId'], 1)
		self.assertEqual(rvdata[0]['date'], "2000-01-02 00:00:00")
		self.assertEqual(rvdata[0]['thumbnailImageData'], "thumb2")

		self.assertEqual(rvdata[1]['transactionId'], 1)
		self.assertEqual(rvdata[1]['userId'], 1)
		self.assertEqual(rvdata[1]['date'], "2000-01-01 00:00:00")
		self.assertEqual(rvdata[1]['thumbnailImageData'], "thumb1")

	def test_receipts_non_existing_user(self):
		rv = self._app.get('/receipts?userId=1')
		rvdata = json.loads(rv.data)
		self.assertEqual(len(rvdata), 0)

	def test_receipts_invalid_parameters(self):
		rv = self._app.get('/receipts')
		self.assertEqual(rv._status_code, 400)

		rv = self._app.get('/receipts?userId=a')
		self.assertEqual(rv._status_code, 400)

		rv = self._app.get('/receipts?userId=1&max=b')
		self.assertEqual(rv._status_code, 400)

		rv = self._app.get('/receipts?userId=1&max=1&offset=c')
		self.assertEqual(rv._status_code, 400)

	#======================== overview tests ========================#
	def test_overview_existing_user(self):
		cur = self._conn.cursor()
		date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
		cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, description, image, thumbnail)
						VALUES 	(1, 1, "cat1", 10.00, ?, "desc1", "img1", "thumb1"),
								(2, 1, "cat2", 15.00, ?, "desc2", "img2", "thumb2"),
								(3, 1, "cat2", 25.00, ?, "desc3", "img3", "thumb3")''', (date, date, date))
		self._conn.commit()
		rv = self._app.get('/overview?userId=1&weeks=1')
		rvdata = json.loads(rv.data)
		sorteddata = sorted(rvdata, key=itemgetter('category'))

		self.assertEqual(len(sorteddata), 2)

		self.assertEqual(sorteddata[0]['category'], "cat1")
		self.assertEqual(sorteddata[0]['amount'], 10.0)
		self.assertEqual(sorteddata[0]['percentage'], 20.0)

		self.assertEqual(sorteddata[1]['category'], "cat2")
		self.assertEqual(sorteddata[1]['amount'], 40.0)
		self.assertEqual(sorteddata[1]['percentage'], 80.0)

	def test_overview_weeks(self):
		cur = self._conn.cursor()
		today = date.today()
		ninedaysago = today - timedelta(days=9)
		cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, description, image, thumbnail)
						VALUES 	(1, 1, "cat1", 10.01, ?, "desc1", "img1", "thumb1")''', (ninedaysago,))
		self._conn.commit()
		rv = self._app.get('/overview?userId=1&weeks=1')
		rvdata = json.loads(rv.data)
		self.assertEqual(len(rvdata), 0)

		rv = self._app.get('/overview?userId=1&weeks=2')
		rvdata = json.loads(rv.data)
		self.assertEqual(len(rvdata), 1)

	def test_overview_non_existing_user(self):
		rv = self._app.get('/overview?userId=1&weeks=1')
		rvdata = json.loads(rv.data)
		self.assertEqual(len(rvdata), 0)

	def test_overview_invalid_parameters(self):
		rv = self._app.get('/overview')
		self.assertEqual(rv._status_code, 400)

		rv = self._app.get('/overview?userId=1')
		self.assertEqual(rv._status_code, 400)

		rv = self._app.get('/overview?userId=1&weeks=a')
		self.assertEqual(rv._status_code, 400)

	#======================= breakdown tests ========================#
	def test_breakdown_existing_user(self):
		cur = self._conn.cursor()
		today = date.today()
		today_formatted = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
		ninedaysago = today - timedelta(days=9)
		cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, description, image, thumbnail)
						VALUES 	(1, 1, "cat1", 10.00, ?, "desc1", "img1", "thumb1"),
								(2, 1, "cat2", 15.00, ?, "desc2", "img2", "thumb2"),
								(3, 1, "cat2", 25.00, ?, "desc3", "img3", "thumb3")''', (today_formatted, today_formatted, ninedaysago))
		self._conn.commit()
		rv = self._app.get('/breakdown?userId=1&weeks=2')
		rvdata = json.loads(rv.data)

		self.assertEqual(rvdata['userId'], 1)
		self.assertEqual(rvdata['weeks'], 2)

		sortedbreakdowns = sorted(rvdata['breakdowns'], key=itemgetter('category'))

		self.assertEqual(len(sortedbreakdowns), 2)

		self.assertEqual(sortedbreakdowns[0]['category'], "cat1")
		self.assertEqual(sortedbreakdowns[0]['amounts'], [10.00, 0])

		self.assertEqual(sortedbreakdowns[1]['category'], "cat2")
		self.assertEqual(sortedbreakdowns[1]['amounts'], [15.00, 25.00])

	def test_breakdown_non_existing_user(self):
		rv = self._app.get('/breakdown?userId=1&weeks=1')
		rvdata = json.loads(rv.data)
		self.assertEqual(len(rvdata['breakdowns']), 0)

	def test_breakdown_invalid_parameters(self):
		rv = self._app.get('/breakdown')
		self.assertEqual(rv._status_code, 400)

		rv = self._app.get('/breakdown?userId=1')
		self.assertEqual(rv._status_code, 400)

		rv = self._app.get('/breakdown?userId=1&weeks=a')
		self.assertEqual(rv._status_code, 400)

	#======================== receipt tests ========================#
	def test_receipt_post_non_existing_user(self):
		imgData = encode_b64(Image.open(TESTIMGPATH))
		thumbData = encode_b64(Image.open(TESTTHUMBPATH))
		data = {
			'userId': 1,
			'category': 'cat1',
			'description': 'desc1',
			'data': imgData
		}

		rv = self._app.post('/receipt', data=json.dumps(data), content_type='application/json')
		rvdata = json.loads(rv.data)

		self.assertEqual(rvdata['transactionId'], 1)
		self.assertEqual(rvdata['amount'], 54.50)

		cur = self._conn.cursor()
		cur.execute(''' SELECT transaction_id, user_id, category, amount, description, image, thumbnail FROM transactions 
                        WHERE transaction_id=1''')
		rows = cur.fetchall()
		self.assertEqual(len(rows), 1)
		row = rows[0]

		self.assertEqual(row[0], 1)
		self.assertEqual(row[1], 1)
		self.assertEqual(row[2], 'cat1')
		self.assertEqual(row[3], 54.50)
		self.assertEqual(row[4], 'desc1')
		self.assertEqual(row[5], imgData)

		# save and load thumbnail to turn it into exactly same format as test thumbnail
		decode_b64(row[6]).save(TEMPTHUMBPATH, format="JPEG")
		returned_thumb = encode_b64(Image.open(TEMPTHUMBPATH))
		self.assertEqual(returned_thumb, thumbData)

	def test_receipt_post_existing_user(self):
		cur = self._conn.cursor()
		cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, description, image, thumbnail)
						VALUES 	(1, 1, "cat1", 10.01, "2000-01-01 00:00:00", "desc1", "img1", "thumb1")''')
		self._conn.commit()

		imgData = encode_b64(Image.open(TESTIMGPATH))
		thumbData = encode_b64(Image.open(TESTTHUMBPATH))
		data = {
			'userId': 1,
			'category': 'cat2',
			'description': 'desc2',
			'data': imgData
		}

		rv = self._app.post('/receipt', data=json.dumps(data), content_type='application/json')
		rvdata = json.loads(rv.data)

		self.assertEqual(rvdata['transactionId'], 2)
		self.assertEqual(rvdata['amount'], 54.50)

		cur = self._conn.cursor()
		cur.execute(''' SELECT transaction_id, user_id, category, amount, description, image, thumbnail FROM transactions 
                        WHERE transaction_id=2''')
		rows = cur.fetchall()
		self.assertEqual(len(rows), 1)
		row = rows[0]

		self.assertEqual(row[0], 2)
		self.assertEqual(row[1], 1)
		self.assertEqual(row[2], 'cat2')
		self.assertEqual(row[3], 54.50)
		self.assertEqual(row[4], 'desc2')
		self.assertEqual(row[5], imgData)

		# save and load thumbnail to turn it into exactly same format as test thumbnail
		decode_b64(row[6]).save(TEMPTHUMBPATH, format="JPEG")
		returned_thumb = encode_b64(Image.open(TEMPTHUMBPATH))
		self.assertEqual(returned_thumb, thumbData)

	def test_receipt_post_invalid_json(self):
		data = {}
		rv = self._app.post('/receipt', data=json.dumps(data), content_type='application/json')
		self.assertEqual(rv._status_code, 400)

		data = {
			'userId': 1
		}
		rv = self._app.post('/receipt', data=json.dumps(data), content_type='application/json')
		self.assertEqual(rv._status_code, 400)

		data = {
			'userId': 1,
			'category': 'cat1'
		}
		rv = self._app.post('/receipt', data=json.dumps(data), content_type='application/json')
		self.assertEqual(rv._status_code, 400)

		data = {
			'userId': 1,
			'category': 'cat1',
			'description': 'desc1'
		}
		rv = self._app.post('/receipt', data=json.dumps(data), content_type='application/json')
		self.assertEqual(rv._status_code, 400)

	#=================== update_transaction tests ===================#
	def test_update_transaction_existing_transaction(self):
		cur = self._conn.cursor()
		cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, description, image, thumbnail)
						VALUES 	(1, 1, "cat1", 10.01, "2000-01-01 00:00:00", "desc1", "img1", "thumb1")''')
		self._conn.commit()
		data = {
			'transactionId': 1,
			'amount': 20.02
		}
		rv = self._app.post('/update_transaction', data=json.dumps(data), content_type='application/json')
		self.assertEqual(rv.data, "updated transaction")

		cur = self._conn.cursor()
		cur.execute(''' SELECT amount FROM transactions 
                        WHERE transaction_id=1''')
		rows = cur.fetchall()
		self.assertEqual(len(rows), 1)
		self.assertEqual(rows[0][0], 20.02)

	def test_update_transaction_non_existing_transaction(self):
		data = {
			'transactionId': 1,
			'amount': 20.02
		}
		rv = self._app.post('/update_transaction', data=json.dumps(data), content_type='application/json')
		self.assertEqual(rv.data, "transaction with id 1 does not exist")

	def test_update_transaction_invalid_json(self):
		data = {}
		rv = self._app.post('/update_transaction', data=json.dumps(data), content_type='application/json')
		self.assertEqual(rv._status_code, 400)

		data = {
			'transactionId': 1
		}
		rv = self._app.post('/update_transaction', data=json.dumps(data), content_type='application/json')
		self.assertEqual(rv._status_code, 400)

		data = {
			'amount': 20.02
		}
		rv = self._app.post('/update_transaction', data=json.dumps(data), content_type='application/json')
		self.assertEqual(rv._status_code, 400)


if __name__ == '__main__':
    unittest.main()
