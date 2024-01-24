# Database Consistency and Concurrency

## Description

In this exercise, you will practice the definition and manipulation of transactions and the locking features in concurrent PostgreSQL transactions. You will also explore how transactions work and analyze different situations and errors produced.

## Data

For this exercise you will use a database to manage the member's bookings of a sports center. Each member adds money to their account and then they can use the facilities by simply consuming the deposited money.

Execute the SQL statements you will find in the file [data.sql](data.sql). These will create and populate the following tables:

```
CREATE TABLE facility (
    id serial PRIMARY KEY,
    name character varying(100) NOT NULL,
    membercost numeric NOT NULL,
    guestcost numeric NOT NULL
);

CREATE TABLE member (
    id serial PRIMARY KEY,
    name character varying(100) NOT NULL,
    join_date timestamp without time zone NOT NULL,
    recommended_by integer,
    balance numeric NOT NULL DEFAULT 0,
    FOREIGN KEY (recommended_by) REFERENCES member(id) ON DELETE SET NULL
);

CREATE TABLE booking (
    id serial PRIMARY KEY,
    facility_id integer NOT NULL,
    member_id integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    slots integer NOT NULL,
    FOREIGN KEY (facility_id) REFERENCES facility(id),
    FOREIGN KEY (member_id) REFERENCES member(id)
);
```

Execute the statements and explore the tables to have a better idea of their contents.

## Tasks

### Task 1

`Noah Wilson` wants to book the `Squash Court` for two hours (`2` slots) starting right now (`CURRENT_TIMESTAMP`). This is a transaction that consists of two operations:

1. Adding a new record on the table booking.
2. Subtracting the member cost of the squash court (multiplied by the number of slots) from Noah's account balance.

Write down those two SQL statements and define them as a single transaction.

> Do not hard-code the ids of the member and facility in the transaction. Instead, use subqueries to retrieve the id based on the name of the member or facility.
>
> You can use `CURRENT_TIMESTAMP` to get the current time.

Noah starts the day with 183 euros in his account. When the transaction ends **Noah's balance should be 176 euros**.

### Task 2

`Mia Ali` wants to book the `Tennis Court` for `3` hours, starting right now (`CURRENT_TIMESTAMP`).

Use the same query as before, but change the values to exactly the ones provided in the previous sentence.

**Briefly explain the output. More specifically, answer the following questions:**

- What does the error mean and why does it occur?
- What property of ACID transactions is involved in the error description?

### Task 3

Now, `Alice Peters` wants to book the `Tennis Court 1` for `3` hours, starting right now (`CURRENT_TIMESTAMP`), but `Noah Wilson` is inviting her and the money should be subtracted from his account.

Use the same transaction you have with the new values, but this time change the order of the operations: first subtract the cost from Noah's balance and then insert Alice's booking.

Execute the transaction.

**Briefly explain the output. More specifically, answer the following questions:**

- What does the error mean and why does it occur?
- The first operation executed without an error. Did Noah get charged? Why?

### Task 4

The previous unexpected errors left you a bit wary and first you just want to test some other transaction. But, because this is just a test, you don't want anybody actually being charged nor any booking be made.

Use the same transaction as before, but now use `Noah Wilson` for both charging and booking. Then, make sure the transaction does not save the changes when it reaches the end.

Execute the transaction.

No error should be produced, no money should be charged to Noah and no booking should be added.

### Task 5

Now, the manager wants to boost the revenue and she thinks it may be a good idea to reward those who have brought new members in, by adding 50 cents to their balance every time someone they recommended books a facility.

The feature has not been made public and the reward should not be credited, yet, but you want to test the new transaction in real situations. So, you will add the new operation to the current transaction and you will add the means to test if it works but not execute it, while executing and saving the changes from the other two remaining operations in the same transaction (charging and registering the booking).

A new booking just arrived and it is the right moment to test the new transaction with this data. `Ella Lee` wants to book the `Massage Room 1` for `1` hour right now (`CURRENT_TIMESTAMP`). Ella came recommended by another member (Olivia Muller).

Check the balance of Ella and Olivia before executing the transaction. Then execute the transaction and check again the balance of both.

**The transaction should return no error. Ella's balance should be 35 euros less than before. Olivia's balance should be the same.**

### Task 6

Reuse the query from the task 4, but this time save the changes. You will also simulate an unexpected delay in the response. You will do it by adding the following line after subtracting the cost from Noah's balance and before inserting the new booking:

```
SELECT pg_sleep(5);
```

This line will delay the transaction 5 seconds, it should be enough time to execute another query in a separate terminal (if you are using the terminal) or query window (if you are using pgAdmin).

So, before executing your transaction, open another PostgreSQL console in a new terminal (or open a new query window in pgAdmin) and type the following query.

```
SELECT balance FROM member WHERE name = 'Noah Wilson';
```

Execute it, to see what is Noah's balance before running the transaction, it should be 176 euros.

Then execute the booking transaction and keep executing the `SELECT` query above to see what happens.

**Briefly explain what you see. More specifically, answer the following questions:**

- Can you read the member table while the booking transaction is running? Why?
- When does the `SELECT` query see the changes from the transaction? Why? Explain it in terms of which ACID properties are playing a role on this.

### Task 7

Do exactly the same exercise as before, but now manually add a lock at the beginning of the transaction to prevent any kind of access to the table member.

> Keep the sleeping function. Open another window and write the query to query Noah's balance.

**Briefly explain what you see. More specifically, answer the following question:**

- Can you read the member table while the booking transaction is running? Why?
- What error do you get if the transaction is still running?
- What instruction did you use to release the lock?

### Task 8

Use exactly the same transaction as in task 6 (i.e. remove the lock added in task 7).

In the other window, instead of checking Noah's balance execute a query that adds a new field named `city` as text to the `member` table.

**Briefly explain what you see. More specifically, answer the following question:**

- What is the observed difference between this case and the one on task 6? and why do you think that happens?
