import simplicityserver.app.server.server_routes as server_routes
import unittest
import os
import sys
import sqlite3
import json
from datetime import datetime, timedelta, date
from operator import itemgetter

# Before running: export PYTHONPATH=${PYTHONPATH}:<path to Backend directory>
# To run (from the Backend directory): python2 simplicityserver/test/server_routes_test_case.py

TESTDBPATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "test.db")

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
					  	image text NOT NULL)''')

	@classmethod
	def tearDownClass(cls):
		cls._conn.close()
		os.remove(TESTDBPATH)

	def tearDown(self):
		cur = self._conn.cursor()
		cur.execute('DELETE FROM transactions')
		self._conn.commit()

	#====================== transactions tests ======================#
	def test_transactions_existing_user(self):
		cur = self._conn.cursor()
		cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
						VALUES 	(1, 1, "cat1", 10.01, "2000-01-01 00:00:00", "img1"),
								(2, 1, "cat2", 20.02, "2000-01-02 00:00:00", "img2"),
								(3, 1, "cat3", 30.03, "2000-01-03 00:00:00", "img3")''')
		self._conn.commit()
		rv = self._app.get('/transactions?userId=1&max=2&offset=1')
		rvdata = json.loads(rv.data)

		self.assertEqual(len(rvdata), 2)

		self.assertEqual(rvdata[0]['transactionId'], 2)
		self.assertEqual(rvdata[0]['userId'], 1)
		self.assertEqual(rvdata[0]['category'], "cat2")
		self.assertEqual(rvdata[0]['amount'], 20.02)
		self.assertEqual(rvdata[0]['date'], "2000-01-02 00:00:00")

		self.assertEqual(rvdata[1]['transactionId'], 1)
		self.assertEqual(rvdata[1]['userId'], 1)
		self.assertEqual(rvdata[1]['category'], "cat1")
		self.assertEqual(rvdata[1]['amount'], 10.01)
		self.assertEqual(rvdata[1]['date'], "2000-01-01 00:00:00")

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
		cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
						VALUES 	(1, 1, "cat1", 10.01, "2000-01-01 00:00:00", "img1"),
								(2, 1, "cat2", 20.02, "2000-01-02 00:00:00", "img2")''')
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

	#======================== overview tests ========================#
	def test_overview_existing_user(self):
		cur = self._conn.cursor()
		date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
		cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
						VALUES 	(1, 1, "cat1", 10.00, ?, "img1"),
								(2, 1, "cat2", 15.00, ?, "img2"),
								(3, 1, "cat2", 25.00, ?, "img3")''', (date, date, date))
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
		cur.execute('''	INSERT INTO transactions (transaction_id, user_id, category, amount, date, image)
						VALUES 	(1, 1, "cat1", 10.01, ?, "img1")''', (ninedaysago,))
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

if __name__ == '__main__':
    unittest.main()
