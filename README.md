# CS130

### Server Routes Tests
#### server_routes_test_case.py contains the following 10 tests for the transactions, receipt_img, and overview endpoints
###### located at https://github.com/theAnthonyLai/CS130/blob/master/Backend/simplicityserver/test/server_routes_test_case.py. To run, the user must first execute ```export PYTHONPATH=${PYTHONPATH}:<path to Backend directory>```

##### transactions tests

1. ```test_transactions_existing_user```: tests whether the transaction data stored on the database is returned by the transactions server endpoint in the correct format when it is requested for an existing user with valid request parameters
   - Success: the transactions endpoint returns a correctly sorted and formatted json object containing the transaction data of the specified user with the specified limit and offset
   - Failure: the transactions endpoint returns a json object with missing or not properly sorted data, or including data from another user

2. ```test_transactions_non_existing_user```: tests whether the transactions server endpoint returns an empty json object when the client requests transaction data for a user that does not exist in the database
   - Success: the transactions endpoint returns an empty list
   - Failure: the transactions endpoint returns a json object with data in it (non-empty)

3. ```test_transactions_invalid_parameters```: tests whether the transactions server endpoint returns error code 400 (Bad Request) when the client passes bad input parameters in the url, such as a letter for userId, which should be an integer
   - Success: the transactions endpoint returns error code 400 for each of the bad requests
   - Failure: the transactions endpoint returns anything besides the 400 error code for any of the bad requests, such as a 200 success code

##### receipt_img tests

4. ```test_receipt_img_existing_transactions```: tests whether the receipt_img server endpoint returns the correct receipt image data for the transaction specified by the client that exists in the database
   - Success: the receipt_img endpoint returns a json object containing the image data corresponding to the transaction id specified by the client
   - Failure: the receipt_img endpoint returns anything other than the json object containing the correct image data

5. ```test_receipt_img_non_existing_transaction```: tests whether the receipt_img server endpoint returns None when the client requests the receipt image for a transaction that does not exist in the database
   - Success: the receipt_img endpoint returns None
   - Failure: the receipt_img endpoint returns anything other than None

6. ```test_receipt_img_invalid_parameters```: tests whether the receipt_img server endpoint returns error code 400 (Bad Request) when the client passes bad input parameters in the url, such as a letter for transactionId, which should be an integer
   - Success: the receipt_img endpoint returns error code 400 for each of the bad requests
   - Failure: the receipt_img endpoint returns anything besides the 400 error code for any of the bad requests, such as a 200 success code

##### overview tests

7. ```test_overview_existing_user```: tests whether the overview server endpoint returns the correct overview data for the user and weeks specified by the client that exists in the database
   - Success: the overview endpoint returns a json object containing the overview data corresponding to the user id and weeks specified by the client
   - Failure: the overview endpoint returns anything other than the json object containing the correct overview data

8. ```test_overview_weeks```: tests whether the overview server endpoint returns the correct overview data for the specified number of weeks, specifically if the data is older than x weeks, then that data is not returned when only x weeks are requested
   - Success: the overview endpoint returns an empty json object when the data is older than the number of weeks specified by the client, and returns the correct json object when it is within that number of weeks
   - Failure: the overview endpoint returns data despite it being older than the number of weeks specified

9. ```test_overview_non_existing_user```: tests whether the overview server endpoint returns an empty json object when the client requests overview data for a user that does not exist in the database
   - Success: the overview endpoint returns an empty list
   - Failure: the overview endpoint returns a json object with data in it (non-empty)

10. ```test_overview_invalid_parameters```: tests whether the overview server endpoint returns error code 400 (Bad Request) when the client passes bad input parameters in the url, such as a letter for userId or weeks, which should be an integer
    - Success: the overview endpoint returns error code 400 for each of the bad requests
    - Failure: the overview endpoint returns anything besides the 400 error code for any of the bad requests, such as a 200 success code


### Text Extraction Tests
#### testTextExtraction contains the three test cases for text extraction.
###### located at https://github.com/theAnthonyLai/CS130/blob/master/tesseract/testTextExtraction.py

1. ```test_grab_amount```: tests whether all the numbers in the format of money(XX.XX) on the receipt are recognized by asserting that all the amounts appears in the receipt are in the list returned by grab_amount function.
   - Success: returns all amounts of money on the receipt.
   - Failure: some amounts ignored by the script

2. ```test_process_text```: tests whether the function returns the maximum amount of money given an receipt image by asserting that it equals to the total amount of spending on the receipt.
   - Success: returns the total amount of spending
   - Failure: returns some other amount (might recognize the phone number as a larger number than the total spending)

3. ```test_corrupted_image```: tests whether the function handles a corrupted image elegantly, which is the case where exception occurs.
   - Success: the function runs smoothly, returns an empty string
   - Failure: the program aborts because of exception.
