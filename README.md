# CS130 - Simplicity

## Backend API

#### **get_transactions**

```dict get_transactions(Connection db, int user_id, int limit, int offset)```

Given the inputs user_id (user we want to grab transactions for), limit
and offset (filtering the query), we want to return a dict containing
the user’s {‘transactionId’, ‘userId’, ‘category’, ‘amount’, ‘date’}

This function will use the parameters to make a sql query, and reformat
the returned rows into the dict that the frontend expects.

**Parameters:**

```db``` - database connection

```user_id``` - the id of the user we want to query fields for

```limit``` - max number of rows we want to return

```offset``` - offset of the rows we want to return

**Returns:**

List of {‘transactionId’, ‘userId’, ‘category’, ‘amount’, ‘date’}

---
#### **get_receipt_img**

```dict get_receipt_img(Connection db, int transaction_id)```

Given the transactionId, this function will return the receipt image
associated with it.

This function will use the parameters to make a sql query, and reformat
the returned rows into the dict that the frontend expects.

**Parameters:**

```db``` - database connection

```transaction_id``` - id of the transaction we want to retrieve the image of

**Returns:**

Base64 encoded image associated with the parameter’s transactionId

---
#### **get_receipts**

```dict get_receipts(Connection db, int user_id, int limit, int offset)```

Given the inputs user_id (user we want to grab transactions for), limit
and offset (filtering the query), we want to return a dict containing
the user’s {‘transactionId’, ‘userId’, date, ‘thumbnailImageData’}. The
thumbnailImageData is a conversion of the original receipt image to
thumbnail size.

This function will use the parameters to make a sql query, and reformat
the returned rows into the dict that the frontend expects.

**Parameters:**

```db``` - database connection

```user_id``` - the id of the user we want to query fields for

```limit``` - max number of rows we want to return

```offset``` - offset of the rows we want to return

**Returns:**

List of {‘transactionId’, ‘userId’, date, ‘thumbnailImageData’}

---
#### **get_overview**

```dict get_overview(Connection db, int user_id, int weeks)```

Given the user_id and the amount of weeks ago we want to look, we want
to return a dict containing each of the categories of spending the user
has spent on, and the percentage of his/her expenditures on each
category.

This function will use the parameters to make a sql query, and reformat
the returned rows into the dict that the frontend expects.

**Parameters:**

```db``` - database connection

```user_id``` - the id of the user we want to query fields for

```weeks``` - weeks ago we want to look back in the database

**Returns:**

List of {‘category’, ‘amount’, ‘percentage’}

---
#### **get_breakdown**

```dict get_breakdown(Connection db, int user_id, int weeks)```

See “get_overview”. This function will get the breakdown *per week* for
the set amount of weeks

**Parameters:**

```db``` - database connection

```user_id``` - the id of the user we want to query fields for

```weeks``` - weeks ago we want to look back in the database

**Returns:**

List of {‘category’, ‘amount’, ‘percentage’} for each week.

---
#### **post_receipt**

```void post_receipt(Connection db, int user_id, string category, string image_data)```

Given the user_id, category, and the image, this function will use
pytesseract to find the amount, and write into the database this
transaction.

This function will use the parameters to make a sql query, and store the
necessary information into the database.

**Parameters:**

```db``` - database connection

```user_id``` - the id of the user we want to query fields for

```category``` - name of the category this transaction belongs in

```image_data``` - base64 encoded string containing the image

**Returns:**

Returns nothing.

---
## Image Processing API

#### **preprocess_img**

```def preprocess_img(image)```

Given the image, this function will add preprocessing to the old image
and generate a new preprocessed one

This function do thresh, blur, grayscale preprocessing and save the one
with best result

**Parameters:**

```image``` - the image that require preprocessing

**Returns:**

Returns nothing.

---
#### **read_image_text**

```def read_image_text(image)```

Given the image, this function applies tesseract to the processed image
and read the text on it

**Parameters:**

```image``` - the image to extract text from

**Returns:**

string of the words extracted from image

---
#### **process_text**

```def process_text(string)```

Given a string, this function calls grab_amount extract the maximum
amount of money in the given string.

**Parameters:**

```image``` - the image to extract text from

**Returns:**

double of maximum amount of money in the string

**See Also:**

```grab_amount```

---
#### **grab_amount**

```def grab_amount(row)```

Given a row of string, this function calls extract all valid amount of
money(number of the form $xx.xx) in the given string.

**Parameters:**

```row``` - the row of string to extract all amount of money from

**Returns:**

A list of double amount of money

---
## Frontend API

#### **getOverviewWithUserIdAndNumberOfWeeks**

```void getOverviewWithUserIdAndNumberOfWeeks(int userId, int numberOfWeeks, onSuccess(JSON), onFailure(Error))```

Given the userId and numberOfWeeks, make the request call to the
backend, and call the onSuccess or onFailure completion block based on
whether the request succeed or not.

**Parameters:**

```userId``` - id of the user we want to make request on

```numberOfWeeks``` - number of weeks we want to accumulate data on

```onSuccess``` - completion block on success

```onFailure``` - completion block on failure

**Returns:**

Void

---
#### **getOverviewWithUserIdAndNumberOfWeeks**

```void getBreakdownWithUserIdAndNumberOfWeeks(int userId, int numberOfWeeks, onSuccess(JSON), onFailure(Error))```

Given the userId and numberOfWeeks, make the request call to the
backend, and call the onSuccess or onFailure completion block based on
whether the request succeed or not.

**Parameters:**

```userId``` - id of the user we want to make request on

```numberOfWeeks``` - number of weeks we want to accumulate data on

```onSuccess``` - completion block on success

```onFailure``` - completion block on failure

**Returns:**

Void

---
#### **getTransactionsWithUserId**

void getTransactionsWithUserId(int userId, onSuccess(JSON),
onFailure(Error))

Given the userId, make the request call to the backend to get a list of
transactions uploaded by this user. Call the onSuccess or onFailure
completion block based on whether the request succeed or not.

**Parameters:**

```userId``` - id of the user we want to make request on

```onSuccess``` - completion block on success

```onFailure``` - completion block on failure

**Returns:**

Void

---
#### **getReceiptsWithUserId**

void getTransactionsWithUserId(int userId, int maxNumber, int offset, onSuccess(JSON),
onFailure(Error))

Given the userId, maxNumber, and offset make the request call to the backend to get a list of receipts uploaded by this user. Call the onSuccess or onFailure completion block based on whether the request succeed or not.

**Parameters:**

```userId``` - id of the user we want to make request on

```maxNumber``` - max number of receipt images to return

```offset``` - the offset of the number of receipts

```onSuccess``` - completion block on success

```onFailure``` - completion block on failure

**Returns:**

Void

---
void getReceiptImageWithTransactionId(int transactionId, onSuccess(JSON),
onFailure(Error))

Given the transactionId, make the request call to the backend to get the receipt image uploaded by this user. Call the onSuccess or onFailure
completion block based on whether the request succeed or not.

**Parameters:**

```transactionId``` - id of the user we want to make request on

```onSuccess``` - completion block on success

```onFailure``` - completion block on failure

**Returns:**

Void

---
void postReceiptImgWithUserIdCategoryDescriptionData(int userId, String category, String description, String imgData, onSuccess(JSON),
onFailure(Error))

Given the userId and other info, make the request call to the backend to post 
the transaction uploaded by this user. Call the onSuccess or onFailure
completion block based on whether the request succeed or not.

**Parameters:**

```userId``` - id of the user we want to make request on

```category``` - the category of the expense

```description``` - description of the expense

```imgData``` - the base64 encoded string of receipt image data

```onSuccess``` - completion block on success

```onFailure``` - completion block on failure

**Returns:**

Void

---
void postUpdateTransaction(int transactionId, Double amount, onSuccess(JSON),
onFailure(Error))

Given the transactionId and amount, make the request call to the backend to post the updated transaction amount set by this user. Call the onSuccess or onFailure completion block based on whether the request succeed or not.

**Parameters:**

```transactionId``` - id of the transaction we want to make request on

```amount``` - cost of the expense that we want to set

```onSuccess``` - completion block on success

```onFailure``` - completion block on failure

**Returns:**

Void

---
#### **getOverviewAsync**

```void getOverviewsAsync(onSuccess([Overview]), onFailure(Error))```

Get a list of Overview with the current application’s userId, and call
the onSuccess or onFailure completion block based on whether the request
succeed or not.

**Parameters:**

```onSuccess``` - completion block on success

```onFailure``` - completion block on failure

**Returns:**

Void

---
#### **getBreakdownsAsync**

```void getBreakdownsAsync(onSuccess([Breakdown]), onFailure(Error))```

Get a list of Breakdown with the current application’s userId, and call
the onSuccess or onFailure completion block based on whether the request
succeed or not.

**Parameters:**

```onSuccess``` - completion block on success

```onFailure``` - completion block on failure

**Returns:**

Void

---
#### **getTransactionsAsync**

```void getTransactionsAsync(onSuccess([Transaction]), onFailure(Error))```

Get a list of Transaction with the current application’s userId, and call
the onSuccess or onFailure completion block based on whether the request
succeed or not.

**Parameters:**

```onSuccess``` - completion block on success

```onFailure``` - completion block on failure

**Returns:**

Void

---
#### **getReceiptsAsync**

```void getReceiptsAsync(onSuccess([Receipt]), onFailure(Error))```

Get a list of Receipt with the current application’s userId, and call
the onSuccess or onFailure completion block based on whether the request
succeed or not.

**Parameters:**

```onSuccess``` - completion block on success

```onFailure``` - completion block on failure

**Returns:**

Void

---
#### **getReceiptImgAsync**

```void getReceiptImgAsync(onSuccess([ReceiptImg]), onFailure(Error))```

Get a ReceiptImg with the current application’s userId, and call
the onSuccess or onFailure completion block based on whether the request
succeed or not.

**Parameters:**

```onSuccess``` - completion block on success

```onFailure``` - completion block on failure

**Returns:**

Void

---
#### **postReceiptImgAsync**

```void postReceiptImgAsync(Swift.String categoryField, Swift.String descriptionField, Swift.String imageData, onSuccess([ReceiptTransactionAmount]), onFailure(Error))```

Post a transaction with the current application’s userId and transaction data, and call the onSuccess or onFailure completion block based on whether the request succeed or not.

**Parameters:**

```categoryField``` - category of expense

```descriptionField``` - description of expense

```imageData``` - base64 encoded image data of expense

```onSuccess``` - completion block on success

```onFailure``` - completion block on failure

**Returns:**

Void

---
#### **postUpdateTransactionAsync**

```void postUpdateTransactionAsync(int transactionId, double amount, onSuccess([ReceiptTransactionAmount]), onFailure(Error))```

Post a transaction amount update with the current application’s userId and transactionId and updated amount, and call the onSuccess or onFailure completion block based on whether the request succeed or not.

**Parameters:**

```transactionId``` - id of the user's transaction

```amount``` - updated cost of expense

```onSuccess``` - completion block on success

```onFailure``` - completion block on failure

**Returns:**

Void

---
---

## Testing

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
