use role sysadmin;

//See how the nextval function works
select seq_author_uid.nextval;

show sequences;

select seq_author_uid.nextval, seq_author_uid.nextval; 

show sequences;

use role sysadmin;

//Drop and recreate the counter (sequence) so that it starts at 3 
// then we'll add the other author records to our author table
create or replace sequence library_card_catalog.public.seq_author_uid
start = 3 
increment = 1 
ORDER
comment = 'Use this to fill in the AUTHOR_UID every time you add a row';

//Add the remaining author records and use the nextval function instead 
//of putting in the numbers
insert into author(author_uid,first_name, middle_name, last_name) 
values
(seq_author_uid.nextval, 'Laura', 'K','Egendorf')
,(seq_author_uid.nextval, 'Jan', '','Grover')
,(seq_author_uid.nextval, 'Jennifer', '','Clapp')
,(seq_author_uid.nextval, 'Kathleen', '','Petelinsek');

-- Use sequence for UID when creating table 
create or replace table book
( book_uid number seq_author_uid.nextval()
 , title varchar(50)
 , year_published number(4,0)
);