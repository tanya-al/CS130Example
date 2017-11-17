import extractSpending
import unittest

class TestTextExtraction(unittest.TestCase):
	def setUp(self):
		self.image = "testImage.png";

	def test_grab_amount(self):
		s = extractSpending.read_image_text(self.image)
		num_list = extractSpending.grab_amount(s)
		self.assertTrue(6.75 in num_list)
		self.assertTrue(0.85 in num_list)
		self.assertTrue(7.6 in num_list)

	def test_process_text(self):
		s = extractSpending.read_image_text(self.image)
		max_amount = extractSpending.process_text(s)
		self.assertEqual(max_amount, 7.6)

	def test_corrupted_image(self):
		with self.assertRaises(OSError):
			s = extractSpending.read_image_text("corrupted_image.jpeg")
			self.assertEqual("", s)

if __name__ == '__main__':
    unittest.main()
