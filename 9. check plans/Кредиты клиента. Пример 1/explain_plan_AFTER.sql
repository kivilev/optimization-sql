Plan hash value: 1860088990
 
----------------------------------------------------------------------------------------------------------------
| Id  | Operation                            | Name                    | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                     |                         |     1 |   950 |     1   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                        |                         |     1 |   950 |     1   (0)| 00:00:01 |
|   2 |   TABLE ACCESS BY INDEX ROWID        | CLIENT                  |     1 |   826 |     1   (0)| 00:00:01 |
|*  3 |    INDEX UNIQUE SCAN                 | CLIENT_PK               |     1 |       |     1   (0)| 00:00:01 |
|   4 |   TABLE ACCESS BY INDEX ROWID BATCHED| CLIENT_CREDIT           |     1 |   124 |     0   (0)| 00:00:01 |
|*  5 |    INDEX RANGE SCAN                  | CLIENT_CREDIT_CLIENT_I  |     1 |       |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------------------------
 
Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------
 
   1 - SEL$58A6D7F6
   2 - SEL$58A6D7F6 / C@SEL$1
   3 - SEL$58A6D7F6 / C@SEL$1
   4 - SEL$58A6D7F6 / CC@SEL$1
   5 - SEL$58A6D7F6 / CC@SEL$1
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("C"."ID"=1000)
   5 - access("CC"."CLIENT_ID"=1000)
 
Column Projection Information (identified by operation id):
-----------------------------------------------------------
 
   1 - (#keys=0) "C"."ID"[NUMBER,22], "C"."FNAME"[VARCHAR2,800], "C"."LNAME"[VARCHAR2,800], 
       "C"."BDAY"[DATE,7], "CC"."CLIENT_CREDIT_ID"[VARCHAR2,200], "CC"."CLIENT_ID"[NUMBER,22], 
       "CC"."CREATE_DTIME"[DATE,7]
   2 - "C"."ID"[NUMBER,22], "C"."FNAME"[VARCHAR2,800], "C"."LNAME"[VARCHAR2,800], "C"."BDAY"[DATE,7]
   3 - "C".ROWID[ROWID,10], "C"."ID"[NUMBER,22]
   4 - "CC"."CLIENT_CREDIT_ID"[VARCHAR2,200], "CC"."CLIENT_ID"[NUMBER,22], "CC"."CREATE_DTIME"[DATE,7]
   5 - "CC".ROWID[ROWID,10], "CC"."CLIENT_ID"[NUMBER,22]
 
Note
-----
   - dynamic statistics used: dynamic sampling (level=2)
