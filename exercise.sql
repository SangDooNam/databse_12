/*BEGIN;
INSERT INTO booking (facility_id, member_id, start_time, slots) VALUES (7, 74, CURRENT_TIMESTAMP, 2);
COMMIT;

BEGIN;
UPDATE MEMBER 
SET balance = balance - 
(SELECT booking.slots FROM booking WHERE booking.id = 697) * 
(SELECT facility.membercost FROM facility WHERE id = 7) WHERE id = 74;
COMMIT;*/


/*BEGIN;
INSERT INTO booking (facility_id, member_id, start_time, slots)
VALUES (1, 14, CURRENT_TIMESTAMP, 3);

UPDATE MEMBER SET balance = balance - (SELECT booking.slots FROM booking WHERE id = 698)
* (SELECT facility.membercost FROM facility WHERE id = 1) WHERE id = 14;

COMMIT;*/

/*
BEGIN;
INSERT INTO MEMBER (name, join_date, recommended_by, balance)
VALUES ('Alice Peters', CURRENT_TIMESTAMP, 74, 0);
COMMIT;


BEGIN;
UPDATE MEMBER SET balance = balance - 3 * (SELECT facility.membercost FROM facility WHERE id = 1) 
WHERE MEMBER.id = (SELECT MEMBER.recommended_by FROM MEMBER WHERE id = 85 AND name = 'Alice Peters');

INSERT INTO booking (facility_id, member_id, start_time, slots)
VALUES (1, 85 , CURRENT_TIMESTAMP, 3);

COMMIT;
*/


/*
BEGIN;
INSERT INTO MEMBER (name, join_date, recommended_by, balance)
VALUES ('Alice Peters', CURRENT_TIMESTAMP, 74, 0);
ROLLBACK;


BEGIN;
UPDATE MEMBER SET balance = balance - 3 * (SELECT facility.membercost FROM facility WHERE id = 1) 
WHERE MEMBER.id = (SELECT MEMBER.recommended_by FROM MEMBER WHERE id = 85 AND name = 'Alice Peters');

INSERT INTO booking (facility_id, member_id, start_time, slots)
VALUES (1, 85 , CURRENT_TIMESTAMP, 3);
ROLLBACK;
*/


/*

BEGIN;
INSERT INTO booking (facility_id, member_id, start_time, slots)
VALUES (5, 31, CURRENT_TIMESTAMP, 1);

UPDATE MEMBER SET balance = balance - (SELECT booking.slots * (SELECT facility.membercost FROM facility WHERE id = 5)
FROM booking WHERE member_id = 31 AND facility_id = 5 AND start_time = current_timestamp) WHERE id = 31;


UPDATE MEMBER SET balance = balance + 0.5 WHERE id = (SELECT MEMBER.recommended_by FROM MEMBER WHERE id = 31);

ROLLBACK;
*/

/*

BEGIN;
INSERT INTO MEMBER (name, join_date, recommended_by, balance)
VALUES ('Alice Peters', CURRENT_TIMESTAMP, 74, 0);


UPDATE MEMBER SET balance = balance - 3 * (SELECT facility.membercost FROM facility WHERE id = 1) 
WHERE MEMBER.id = (SELECT MEMBER.recommended_by FROM MEMBER WHERE id = 85 AND name = 'Alice Peters');

INSERT INTO booking (facility_id, member_id, start_time, slots)
VALUES (1, 85 , CURRENT_TIMESTAMP, 3);

SELECT pg_sleep(5)
ROLLBACK;*/

SELECT balance FROM member WHERE name = 'Noah Wilson';



/*BEGIN;
LOCK TABLE MEMBER
	IN EXCLUSIVE MODE;

INSERT INTO MEMBER (name, join_date, recommended_by, balance)
VALUES ('Alice Peters', CURRENT_TIMESTAMP, 74, 0);


UPDATE MEMBER SET balance = balance - 3 * (SELECT facility.membercost FROM facility WHERE id = 1) 
WHERE MEMBER.id = (SELECT MEMBER.recommended_by FROM MEMBER WHERE id = 85 AND name = 'Alice Peters');

INSERT INTO booking (facility_id, member_id, start_time, slots)
VALUES (1, 85 , CURRENT_TIMESTAMP, 3);

SELECT pg_sleep(5);
ROLLBACK;


SELECT balance FROM member WHERE name = 'Noah Wilson';*/


BEGIN;

INSERT INTO MEMBER (name, join_date, recommended_by, balance)
VALUES ('Alice Peters', CURRENT_TIMESTAMP, 74, 0);


UPDATE MEMBER SET balance = balance - 3 * (SELECT facility.membercost FROM facility WHERE id = 1) 
WHERE MEMBER.id = (SELECT MEMBER.recommended_by FROM MEMBER WHERE id = 85 AND name = 'Alice Peters');

INSERT INTO booking (facility_id, member_id, start_time, slots)
VALUES (1, 85 , CURRENT_TIMESTAMP, 3);

ROLLBACK;


SELECT balance FROM member WHERE name = 'Noah Wilson';


