from PIL import Image
import pytesseract as pya
import sys,os
import argparse
import cv2
import numpy

# set $PATH to tesseract
pya.pytesseract.tesseract_cmdtesseract_cmd = '/usr/local/Cellar/tesseract/3.05.01/bin/tesseract'

PREPROCESS_METHOD = "thresh"

def extract_receipt_total(pil_image):
	"""
	Extracts the total amount from the receipt

	:param pil_image: the receipt image in PIL Image format
	:returns: the total money amount on the receipt
	"""
	preprocessed_img = preprocess_img(pil_image.convert('RGB'), PREPROCESS_METHOD)
	string = pya.image_to_string(preprocessed_img)
	total_spending = process_text(string)
	return total_spending

def read_image_text(image):
	"""
	Reads the text on the image

	:param image: the whole path to the image, including the image name
	:returns: a string that has all words on the image processed by tesseract
	:raises	OSError: if the file is not found or cannot be opened, and return empty string
	"""
	try:
		im = Image.open(image)
	except cv2.error as e:
		print("Cannot open file {0}".format(image))
		return ""
	# call to tesseract
	string = pya.image_to_string(im)
	return string

def is_number(s):
	"""
	Check if the whole string is a number

	:param s: the variable to be checked
	:returns: True if the variable is a number, false otherwise
	:raises	ValueError: if the variable is not a number
	"""
	try:
		float(s)
		return True
	except ValueError:
		return False


def is_digit(s, index):
	"""
	Check if the char is valid to appear in amount

	:param s: the string containing the char that is checked
	:param index: the index of char that is checked
	:returns: True if the char is valid. i.e number, or ``.``, or space right next to ``.``
	"""
	if s[index].isdigit() or s[index] == ' ' or s[index] == '.':
		if s[index] == ' ' and ((index < len(s)-1 and s[index+1] == '.') or (index > 0 and s[index-1] == '.')):
			return True
		elif s[index] != ' ':
			return True
		else:
			return False
	return False


def grab_amount(row):
	"""
	Extract all valid amount of money (number of the form ``$xx.xx``) in the given string

	:param row: the string from which it extract money
	:returns: a list containing all valid money
	"""
	size = len(row)
	num_list = []
	i = 0
	while i < size:
		num = ""
		index_of_decimal = 0
		is_spending = False;
		while i < size and is_digit(row, i):
			# ignore space in the amount
			if row[i] != ' ':
				num+=row[i]
			if row[i] == '.':
				index_of_decimal = len(num)
			i += 1

		# if num is a valid number and has two decimal precision ($xx.xx)
		# debugging info
		# if num != "":
		# 	print('--------')
		# 	print('num: {2}, len: {0},  decimal: {1}'.format(len(num), index_of_decimal, num))
		# 	print('--------')
		if is_number(num) and len(num)-index_of_decimal == 2 and index_of_decimal != 0:
			num_list.append(float(num))
		i+=1

	return num_list

def process_text(string):
	"""
	Extract the maximum amount of money in the given string

	:param string: the text to extract money from
	:returns: the maximum amount of money if there is any valid money, -1 if there is no valid amount
	:raises ValueError: if there is no valid amount of money in the string
	"""
	num_list = []

	# add all amounts into the valid spending list
	num_list = grab_amount(string)

	# debugging info	
	#print(num_list)

	# find the maximum spending (total cost, when there is no valid spending, return -1
	total = -1
	if len(num_list) == 0:
		total = -1
	else:
		total = max(num_list)

	return total

# functions below might be modified according to the input of the script
def parse_arg():
	"""
	Parses commandline arguments

	:returns: parsed list of arguments to the program
	"""
	ap = argparse.ArgumentParser()
	ap.add_argument("-i", "--image", required=True,
	help="path to input image to be OCR'd")
	ap.add_argument("-p", "--preprocess", type=str, default="thresh",
	help="type of preprocessing to be done")
	args = vars(ap.parse_args())
	return args

def preprocess_img(pil_img, ppmethod):
	"""
	Applies preproccesing method ``ppmethod`` to the ``pil_img``

	:param pil_img: the image to preprocess in PIL Image format
	:param ppmethod: String denoting which preprocessing method to use, e.g. "thresh", "blur", or "greyscale"
	:returns: image after applying preprocessing method in PIL Image format
	"""
	# convert pil image to open cv image
	image = cv2.cvtColor(numpy.array(pil_img), cv2.COLOR_RGB2BGR)

	# check to see if we should apply thresholding to preprocess the
	# image
	if ppmethod == "thresh":
		gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
		gray = cv2.threshold(gray, 0, 255,
			cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]
 
	# make a check to see if median blurring should be done to remove
	# noise
	elif ppmethod == "blur":
		gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
		gray = cv2.medianBlur(gray, 3)

	elif ppmethod == "grayscale":
		gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

	else:
		return pil_img
 
 	# convert back to pil format
	return Image.fromarray(cv2.cvtColor(gray, cv2.COLOR_GRAY2RGB))

# if __name__ == "__main__":
# 	if len(sys.argv) <= 2:
# 		print("Usage: python3 extractSpending.py --image imagename --preprocess processmethod")
# 		exit(1)

# 	args = parse_arg()
# 	img = preprocess_img(args)

# 	string = read_image_text(img)
# 	total_spending = process_text(string)
# 	print(total_spending)
