import simplicityserver.app.tesseract.extractSpending as extractSpending
import unittest
import os

TESTIMGPATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "testImage.png")
CORRUPTIMGPATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "corrupted_image.jpeg")

class TestTextExtraction(unittest.TestCase):
	def setUp(self):
		"""
		Set up method that runs before each test, sets the image to the test image
		"""
		self.image = TESTIMGPATH

	def test_grab_amount(self):
		"""
		Tests whether all the numbers in the format of money(``XX.XX``) on the receipt are recognized by asserting that all the amounts appears in the receipt are in the list returned by grab_amount function.

		* **Success:** returns all amounts of money on the receipt.
		* **Failure:** some amounts ignored by the script
		"""
		s = extractSpending.read_image_text(self.image)
		num_list = extractSpending.grab_amount(s)
		self.assertTrue(6.75 in num_list)
		self.assertTrue(0.85 in num_list)
		self.assertTrue(7.6 in num_list)

	def test_process_text(self):
		"""
		Tests whether the function returns the maximum amount of money given an receipt image by asserting that it equals to the total amount of spending on the receipt.

		* **Success:** returns the total amount of spending
		* **Failure:** returns some other amount (might recognize the phone number as a larger number than the total spending)
		"""
		s = extractSpending.read_image_text(self.image)
		max_amount = extractSpending.process_text(s)
		self.assertEqual(max_amount, 7.6)

	def test_corrupted_image(self):
		"""
		Tests whether the function handles a corrupted image elegantly, which is the case where exception occurs.

		* **Success:** the function runs smoothly, returns an empty string
		* **Failure:** the program aborts because of exception.
		"""
		with self.assertRaises(OSError):
			s = extractSpending.read_image_text(CORRUPTIMGPATH)
			self.assertEqual("", s)

if __name__ == '__main__':
    unittest.main()
