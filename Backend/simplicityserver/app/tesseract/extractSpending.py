from PIL import Image
import pytesseract as pya
import sys,os
import argparse
import cv2
import base64

# set $PATH to tesseract
pya.pytesseract.tesseract_cmdtesseract_cmd = '/usr/local/Cellar/tesseract/3.05.01/bin/tesseract'

def read_image_text(image):
	'''Reads the text on the image
	@param image 	the whole path to the image, including the image name
	@return     	a string that has all words on the image processed by tesseract
	@throws			OSError if the file is not found or cannot be opened, and return empty string
	'''
	try:
		im = Image.open(image)
	except cv2.error as e:
		print("Cannot open file {0}".format(image))
		return ""
	# call to tesseract
	string = pya.image_to_string(im)
	return string

def is_number(s):
	'''Check if the whole string is a number
	@param s 		the variable to be checked
	@return 		True if the variable is a number, false otherwise
	@throws			ValueError if the variable is not a number
	'''
	try:
		float(s)
		return True
	except ValueError:
		return False


def is_digit(s, index):
	'''Check if the char is valid to appear in amount
	@param s 		the string containing the char that is checked
	@param index 	the index of char that is checked
	@return			True if the char is valid. i.e,: number, or '.', or ' ' right next to '.'
	'''
	if s[index].isdigit() or s[index] == ' ' or s[index] == '.':
		if s[index] == ' ' and ((index < len(s)-1 and s[index+1] == '.') or (index > 0 and s[index-1] == '.')):
			return True
		elif s[index] != ' ':
			return True
		else:
			return False
	return False


def grab_amount(row):
	'''Extract all valid amount of money(number of the form $xx.xx) in the given string
	@param row		the string from which it extract money
	@return 		a list containing all valid money
	'''
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
	'''Extract the maximum amount of money in the given string
	@param string 	the text to extract money from
	@return			the maximum amount of money if there is any valid money, -1 if there is no valid amount
	@throws			ValueError if there is no valid amount of money in the string
	'''
	num_list = []

	# add all amounts into the valid spending list
	num_list = grab_amount(string)

	# debugging info	
	#print(num_list)

	# find the maximum spending (total cost)
	total = -1
	try:
		total = max(num_list)
	except ValueError:
		print("No vaild spending recognized")

	return total

# functions below might be modified according to the input of the script
def parse_arg():
	ap = argparse.ArgumentParser()
	ap.add_argument("-i", "--image", required=True,
	help="path to input image to be OCR'd")
	ap.add_argument("-p", "--preprocess", type=str, default="thresh",
	help="type of preprocessing to be done")
	args = vars(ap.parse_args())
	return args

def preprocess_img(args):
	
	# convert base64 encoding to actual image
	image_64_decode = base64.decodestring(args[1]) 
	image_decode = "{0}decode.jpeg".format(os.getpid())
	image_result = open(image_decode, 'wb') # create a writable image and write the decoding result
	image_result.write(image_64_decode)

	# load the example image
	image = cv2.imread(image_decode)

	# check to see if we should apply thresholding to preprocess the
	# image
	if args[0] == "thresh":
		gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
		gray = cv2.threshold(gray, 0, 255,
			cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]
 
	# make a check to see if median blurring should be done to remove
	# noise
	elif args[0] == "blur":
		gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
		gray = cv2.medianBlur(gray, 3)

	elif args[0] == "grayscale":
		gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

	else:
		return args["image"]
 
	# write the grayscale image to disk as a temporary file so we can
	# apply OCR to it
	filename = "{0}{1}.png".format(os.getpid(), args[0])
	cv2.imwrite(filename, gray)
	return filename, image_decode

def remove_temp_files(img, imgdecode):
	os.remove(img)
	os.remove(imgdecode)

def apply_tesseract(encoding)
	args = ["thresh", encoding]
	img, imgdecode = preprocess_img(args)
	string = read_image_text(img)
	total_spending = process_text(string)
	print(total_spending)
	remove_temp_files(img, imgdecode)


# if __name__ == "__main__":
	# args = ["thresh", encoding]
	# img, imgdecode = preprocess_img(args)
	# string = read_image_text(img)
	# total_spending = process_text(string)
	# print(total_spending)
	# remove_temp_files(img, imgdecode)

