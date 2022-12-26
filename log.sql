-- Find the Description of the crime that happened
SELECT * FROM crime_scene_reports WHERE year = "2021" AND month = "7" AND day = "28" AND street = "Humphrey Street";
-- Theft occured at 10:15am(id 295), interview mentions bakery

-- Find out what the 3 interview transcripts are
SELECT * FROM interviews WHERE year = "2021" AND month = "7" AND day = "28" AND transcript LIKE "%bakery%";
-- within 10mins of theft, thief got into a car and left
-- Earlier in the morning, at Emma's bakery by the ATM on Leggett Street, thief was withdrawing money
-- As thief left, he called someone for less than a min. take earliest flight out of fiftyville tomorrow. other person bought

-- Look at the bakery security logs at the timeframe of theft
SELECT * FROM bakery_security_logs WHERE year = "2021" AND month = "7" AND day = "28"
AND hour = "10" AND minute >= "15" AND minute <= "25";
-- license_plate

-- Look at the call logs
SELECT * FROM phone_calls WHERE year = "2021" AND month = "7" AND day = "28" AND duration < "60";
-- caller

-- look for people whose phone number and license plate match the potential suspects
SELECT name FROM people WHERE phone_number IN
(SELECT caller FROM phone_calls WHERE year = "2021" AND month = "7" AND day = "28" AND duration < "60") AND
license_plate IN
(SELECT license_plate FROM bakery_security_logs WHERE year = "2021" AND month = "7" AND day = "28" AND hour = "10"
AND minute >= "15" AND minute <= "25");
-- Sofia, Diana, Kelsey, Bruce

-- look for who withdrew at the time
SELECT * FROM atm_transactions WHERE year = "2021" AND month = "7" AND day = "28"
AND atm_location = "Leggett Street" AND transaction_type = "withdraw"
-- 8 potential bank accounts

-- cross compare bank accounts with the 4 identified people
SELECT name FROM people WHERE id IN
(SELECT person_id FROM bank_accounts WHERE account_number IN
(SELECT account_number FROM atm_transactions WHERE year = "2021" AND month = "7" AND day = "28"
AND atm_location = "Leggett Street" AND transaction_type = "withdraw")
AND
person_id IN
(SELECT id FROM people WHERE name IN ("Sofia", "Diana", "Kelsey", "Bruce")));
-- thief is Diana OR Bruce

-- whomever Diana Bruce called is the accomplice
SELECT * FROM phone_calls WHERE year = "2021" AND month = "7" AND day = "28" AND duration < "60" AND caller IN
(SELECT phone_number FROM people WHERE name IN ("Diana", "Bruce"));
-- caller id (770) 555-1861 diana, receiver = (725) 555-3243 philip
-- caller id (367) 555-5533 bruce, receiver = (375) 555-8161 robin

-- find the flights Diana and Bruce took
SELECT * FROM passengers WHERE passport_number IN (SELECT passport_number FROM people WHERE name IN ("Diana", "Bruce"));
-- id 18, 24, 36, 54

-- find out fiftyville's airport
SELECT * FROM airports WHERE city = "Fiftyville";
-- id = 8, abv = CSF

-- look at flight from fiftyville on the 29th
SELECT * FROM flights WHERE year = "2021" AND month = "7" AND day = "29" AND origin_airport_id = "8" AND id IN ("18", "24", "36", "54");
-- flight id 18, 36

-- Look at flight 18 and 36
SELECT * FROM flights WHERE id IN ("18", "36");
-- flight 36 is earlier

-- Who took the flight
SELECT name FROM people WHERE passport_number = (SELECT passport_number FROM passengers WHERE flight_id = "36"
AND passport_number IN (SELECT passport_number FROM people WHERE name IN ("Diana", "Bruce")));
-- Bruce is the Thief, His accomplice is Robin (as listed above by the receiver)

-- Find the destination of flight 36
SELECT city FROM airports WHERE id = (SELECT destination_airport_id FROM flights WHERE id ="36");
-- New York City