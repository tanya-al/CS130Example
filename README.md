# CS130
### testTextExtraction contains the three test cases for text extraction.

1. ```test_grab_amount```: tests whether all the numbers in the format of money(XX.XX) on the receipt are recognized by asserting that all the amounts appears in the receipt are in the list returned by grab_amount function.
- Success: returns all amounts of money on the receipt.
- Failure: some amounts ignored by the script

2. ```test_process_text```: tests whether the function returns the maximum amount of money given an receipt image by asserting that it equals to the total amount of spending on the receipt.
- Success: returns the total amount of spending
- Failure: returns some other amount (might recognize the phone number as a larger number than the total spending)

3. ```test_corrupted_image```: tests whether the function handles a corrupted image elegantly, which is the case where exception occurs.
- Success: the function runs smoothly, returns an empty string
- Failure: the program aborts because of exception.
