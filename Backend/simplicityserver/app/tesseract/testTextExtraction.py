import extractSpending
import unittest

class TestTextExtraction(unittest.TestCase):
	def setUp(self):
		"""
		Set up method that runs before each test, sets the image to the test image
		"""
		self.image = "testImage.png";

	def test_grab_amount(self):
		"""
		Test extracting the dollar amounts from the image
		"""
		s = extractSpending.read_image_text(self.image)
		num_list = extractSpending.grab_amount(s)
		self.assertTrue(6.75 in num_list)
		self.assertTrue(0.85 in num_list)
		self.assertTrue(7.6 in num_list)

	def test_process_text(self):
		"""
		Test getting the maximum amount from the image
		"""
		s = extractSpending.read_image_text(self.image)
		max_amount = extractSpending.process_text(s)
		self.assertEqual(max_amount, 7.6)

	def test_corrupted_image(self):
		"""
		Test that passing in a corrupted image causes an ``OSError``
		"""
		with self.assertRaises(OSError):
			s = extractSpending.read_image_text("corrupted_image.jpeg")
			self.assertEqual("", s)

if __name__ == '__main__':
    unittest.main()
