SET SERVEROUT ON;
--1.Procédure–SQLdynamique
create or replace procedure delete_row (p_table IN varchar2, p_condition IN varchar2)
IS
    v_table number(20);
    e_table EXCEPTION;
BEGIN
              
    execute immediate 'DELETE FROM '||p_table|| ' WHERE '||p_condition;
    
    IF SQL%ROWCOUNT>0 THEN
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQL%ROWCOUNT) ||' rows deleted');
    ELSE
        RAISE e_table;
    END IF;
    EXCEPTION WHEN e_table THEN DBMS_OUTPUT.PUT_LINE(p_table ||' or '||p_condition||' doesn"t existe');
END;
/
BEGIN
delete_row('show_shw','SHW_ID=17');
END;

--2.
CREATE TABLE log_bkg_lgb (
   lgb_date DATE,
   lgb_user VARCHAR2(30),
   lgb_event VARCHAR2(30),
   lgb_bkg_id NUMBER(20)
);

CREATE OR REPLACE TRIGGER ck_chg_booking
AFTER INSERT OR UPDATE OR DELETE ON BOOKING_BKG FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO LOG_BKG_LGB(lgb_date,lgb_user,lgb_event,lgb_bkg_id)
        VALUEs(SYSDATE,USER,'Inserte',:NEW.BKG_ID);
    ELSIF DELETING THEN
        INSERT INTO LOG_BKG_LGB(lgb_date,lgb_user,lgb_event,lgb_bkg_id)
        VALUEs(SYSDATE,USER,'Delete',:OLD.BKG_ID);
    ELSE
        INSERT INTO LOG_BKG_LGB(lgb_date,lgb_user,lgb_event,lgb_bkg_id)
        VALUEs(SYSDATE,USER,'Update',:OLD.BKG_ID);
    END IF;
END;

INSERT INTO BOOKING_BKG(BKG_ID, BKG_DATE, BKG_TOTAL_SEAT, BKG_CST_ID, BKG_SHW_ID,BKG_TPR_ID)
VALUES(103,SYSDATE,3,1,15,2);

UPDATE BOOKING_BKG
SET BKG_TPR_ID=1
WHERE BKG_ID=103;

DELETE FROM BOOKING_BKG
WHERE BKG_ID=103;

--3.
ALTER TABLE booking_bkg ADD bkg_total_amount NUMBER(6,2);

CREATE OR REPLACE TRIGGER ck_total_amount
AFTER INSERT OR UPDATE ON BOOKING_BKG FOR EACH ROW
BEGIN
    UPDATE 
    (SELECT * FROM BOOKING_BKG
    LEFT JOIN HAS_PRICE_HPR
    ON HPR_SHW_ID=BKG_SHW_ID AND HPR_TPR_ID=BKG_TPR_ID) up
    SET up.BKG_TOTAL_AMOUNT=up.BKG_TOTAL_SEAT*up.HPR_SEAT_PRICE
    WHERE up.BKG_ID=:OLD.BKG_ID;
END;
    
DECLARE
e_wrong EXCEPTION;
e_fk EXCEPTION;
PRAGMA EXCEPTION_INIT( e_wrong, -20201); PRAGMA EXCEPTION_INIT( e_fk, -02291);
BEGIN
INSERT INTO booking_bkg(bkg_id, bkg_total_seat, bkg_cst_id, bkg_shw_id,
bkg_tpr_id)
    VALUES (103, 5, 100, 10, 1);
  UPDATE booking_bkg
SET bkg_total_seat = bkg_total_seat + 1, bkg_tpr_id = 2
   WHERE BKG_ID = 103;
  COMMIT;
  EXCEPTION
  WHEN e_wrong THEN
    DBMS_OUTPUT.PUT_LINE('wrong booking update or insert'); 
  WHEN e_fk THEN
    DBMS_OUTPUT.PUT_LINE('FK problem Check ids'); 
END;
/
