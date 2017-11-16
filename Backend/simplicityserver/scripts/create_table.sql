CREATE TABLE transactions (
  transaction_id integer PRIMARY KEY,
  user_id integer NOT NULL,
  category text NOT NULL,
  amount real NOT NULL,
  date text NOT NULL,
  image text NOT NULL
);
