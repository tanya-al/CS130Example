import simplicityserver.app.server.server_routes as server_routes
import unittest
import os
import sys

TESTDBPATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "test.db")

class ServerRoutesTestCase(unittest.TestCase):
	def setUp(self):
		server_routes.app.testing = True
		server_routes.DBPATH = TESTDBPATH
		self.app = server_routes.app.test_client()

	def test_transactions(self):
		rv = self.app.get('/transactions?userId=1')
		# print(os.path.join(os.path.dirname(os.path.abspath(sys.argv[0])), "test.db"))
		print(rv.data)

if __name__ == '__main__':
    unittest.main()