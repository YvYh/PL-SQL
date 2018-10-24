DROP TABLE has_price_hpr;
DROP TABLE booking_bkg;
DROp TABLE customer_cst;
DROP TABLE type_price_tpr;
DROP TABLE show_shw;
DROP TABLE type_show_tsh;

CREATE TABLE show_shw(
     shw_id NUMBER(20),
     shw_title VARCHAR2(50),
     shw_desc VARCHAR2(255),
     shw_duration NUMBER(3),
     shw_tsh_id NUMBER(20),
     shw_date DATE CONSTRAINT un_shw_date UNIQUE,
	   CONSTRAINT pk_shw PRIMARY KEY(shw_id));

CREATE TABLE customer_cst(
     cst_id NUMBER(20),
     cst_email VARCHAR2(25) CONSTRAINT nn_clt_mel NOT NULL CONSTRAINT un_clt_mel UNIQUE,
     cst_last_name VARCHAR2(25),
     cst_first_name VARCHAR2(25),
     cst_phone CHAR(10),
	   CONSTRAINT pk_cst PRIMARY KEY(cst_id));

CREATE TABLE type_show_tsh(
     tsh_id NUMBER(20),
     tsh_name VARCHAR2(25) CONSTRAINT nn_tsh_name NOT NULL,
     CONSTRAINT pk_tsh PRIMARY KEY(tsh_id));

CREATE TABLE type_price_tpr(
     tpr_id NUMBER(20),
     tpr_name VARCHAR2(25) CONSTRAINT nn_tpr_name NOT NULL,
	   CONSTRAINT pk_tpr PRIMARY KEY(tpr_id));

CREATE TABLE has_price_hpr(
     hpr_shw_id NUMBER(20),
     hpr_tpr_id NUMBER(20) ,
     hpr_seat_price NUMBER(5,2),
     CONSTRAINT pk_hpr PRIMARY KEY(hpr_shw_id,hpr_tpr_id));

CREATE TABLE booking_bkg(
     bkg_id NUMBER(20),
     bkg_date DATE CONSTRAINT nn_bkg_date NOT NULL,
     bkg_total_seat NUMBER(1),
     bkg_cst_id NUMBER(20),
     bkg_shw_id NUMBER(20),
     bkg_tpr_id NUMBER(20),
	   CONSTRAINT pk_bkg PRIMARY KEY(bkg_id));


ALTER TABLE show_shw ADD CONSTRAINT fk_shw_tsh_id FOREIGN KEY(shw_tsh_id) REFERENCES type_show_tsh(tsh_id);
ALTER TABLE has_price_hpr ADD CONSTRAINT fk_hpr_shw_id FOREIGN KEY(hpr_shw_id) REFERENCES SHOW_SHW(shw_id);
ALTER TABLE has_price_hpr ADD CONSTRAINT fk_hpr_tpr_id FOREIGN KEY(hpr_tpr_id) REFERENCES type_price_tpr(tpr_id);
ALTER TABLE booking_bkg ADD CONSTRAINT fk_bkg_cst_id FOREIGN KEY(bkg_cst_id) REFERENCES customer_cst(cst_id);
ALTER TABLE booking_bkg ADD CONSTRAINT fk_bkg_shw_id FOREIGN KEY(bkg_shw_id) REFERENCES show_shw(shw_id);
ALTER TABLE booking_bkg ADD CONSTRAINT fk_bkg_tpr_id FOREIGN KEY(bkg_tpr_id) REFERENCES type_price_tpr(tpr_id);


INSERT INTO type_show_tsh (tsh_ID, tsh_name) VALUES (1, 'Theatre');
INSERT INTO type_show_tsh (tsh_ID, tsh_name) VALUES (2, 'Danse');
INSERT INTO type_show_tsh (tsh_ID, tsh_name) VALUES (3, 'Musique');
INSERT INTO type_show_tsh (tsh_ID, tsh_name) VALUES (4, 'Magie');
INSERT INTO type_show_tsh (tsh_ID, tsh_name) VALUES (5, 'Cirque');
INSERT INTO type_show_tsh (tsh_ID, tsh_name) VALUES (6, 'Humour');
INSERT INTO type_show_tsh (tsh_ID, tsh_name) VALUES (7, 'Op�ra');


INSERT INTO SHOW_SHW (shw_ID, shw_title, shw_duration, shw_date, shw_tsh_ID) VALUES (10, 'CALACAS - ZINGARO', '90', TO_DATE('28/09/2012', 'DD/MM/YYYY'),  1);
INSERT INTO SHOW_SHW (shw_ID, shw_title,  shw_DESC, shw_duration, shw_date,shw_tsh_ID) VALUES (11, 'LUNA ROSSA', 'Mise en scene B. Lotti', '75', TO_DATE('29/09/2012', 'DD/MM/YYYY'), 1);
INSERT INTO SHOW_SHW (shw_ID, shw_title,  shw_DESC, shw_duration, shw_date,shw_tsh_ID) VALUES (12, 'LES AVEUGLES', 'Mise en scene D. Marleau', '90',  TO_DATE('01/10/2012', 'DD/MM/YYYY'), 1);
INSERT INTO SHOW_SHW (shw_ID, shw_title,  shw_DESC, shw_duration,shw_date, shw_tsh_ID) VALUES (13, 'OUT OF TIME', 'Choregraphie C. Dunne', '75', TO_DATE('02/10/2012', 'DD/MM/YYYY'), 2);
INSERT INTO SHOW_SHW (shw_ID, shw_title,  shw_DESC, shw_duration,shw_date, shw_tsh_ID) VALUES (14, 'FIORDALISI', 'Choregraphie R. Giordano', '90', TO_DATE('06/10/2012', 'DD/MM/YYYY'), 2);
INSERT INTO SHOW_SHW (shw_ID, shw_title,  shw_DESC, shw_duration,shw_date,shw_tsh_ID) VALUES (15, 'LE COMTE ORY', 'Ensemble Matheus', '120',TO_DATE('23/10/2012', 'DD/MM/YYYY'),  3);
INSERT INTO SHOW_SHW (shw_ID, shw_title,  shw_duration, shw_date,shw_tsh_ID) VALUES (16, 'MARTIALSOLAL TRIO', '90', TO_DATE('24/10/2012', 'DD/MM/YYYY'),3);
INSERT INTO SHOW_SHW (shw_ID, shw_title,  shw_duration, shw_date,shw_tsh_ID) VALUES (17, 'KAZUT DE TYR', '90', TO_DATE('04/10/2012', 'DD/MM/YYYY'), 3);
INSERT INTO SHOW_SHW (shw_ID, shw_title,  shw_DESC, shw_duration,shw_date,shw_tsh_ID) VALUES (18, 'LE SOIR DES MONSTRES', 'Etienne Saglio', '75', TO_DATE('15/01/2013', 'DD/MM/YYYY'), 4);
INSERT INTO SHOW_SHW (shw_ID, shw_title,  shw_DESC, shw_duration, shw_date,shw_tsh_ID) VALUES (19, 'PFFFFF !', 'Cie Akoreacro', '75',TO_DATE('12/10/2012', 'DD/MM/YYYY'),  4);
INSERT INTO SHOW_SHW (shw_ID, shw_title, shw_duration, shw_date,shw_tsh_ID) VALUES (20, 'SOPHIA ARAM', '75', TO_DATE('17/01/2013', 'DD/MM/YYYY'), 6);


INSERT INTO customer_cst (Cst_ID, cst_email, Cst_last_name, Cst_first_name, Cst_phone) VALUES (1, 'rnelson@machin.fr', 'NELSON', 'Ryan', '0683242254');
INSERT INTO customer_cst (Cst_ID, cst_email, Cst_last_name, Cst_first_name, Cst_phone) VALUES (2, 'barry.robichaux@truc.fr', 'ROBICHAUX', 'Barry', '0228794613');
INSERT INTO customer_cst (Cst_ID, cst_email, Cst_last_name, Cst_first_name, Cst_phone) VALUES (3, 'cjones@machin.fr', 'JONES', 'Chandi', '0659157846');

INSERT INTO TYPE_PRICE_TPR(tpr_ID, tpr_name) VALUES (1, 'PLEIN TARIF');
INSERT INTO TYPE_PRICE_TPR(tpr_ID, tpr_name) VALUES (2, 'ABONNEMENT');
INSERT INTO TYPE_PRICE_TPR(tpr_ID, tpr_name) VALUES (3, 'ABONNEMENT PLUS');

INSERT INTO has_price_hpr(hpr_shw_id, hpr_tpr_id, hpr_seat_price) VALUES (10, 1, 55);
INSERT INTO has_price_hpr(hpr_shw_id, hpr_tpr_id, hpr_seat_price) VALUES (10, 2, 45);
INSERT INTO has_price_hpr(hpr_shw_id, hpr_tpr_id, hpr_seat_price) VALUES (10, 3, 30);
INSERT INTO has_price_hpr(hpr_shw_id, hpr_tpr_id, hpr_seat_price) VALUES (11, 1, 60);
INSERT INTO has_price_hpr(hpr_shw_id, hpr_tpr_id, hpr_seat_price) VALUES (12, 1, 62);
INSERT INTO has_price_hpr(hpr_shw_id, hpr_tpr_id, hpr_seat_price) VALUES (13, 1, 78);
INSERT INTO has_price_hpr(hpr_shw_id, hpr_tpr_id, hpr_seat_price) VALUES (14, 1, 75);
INSERT INTO has_price_hpr(hpr_shw_id, hpr_tpr_id, hpr_seat_price) VALUES (15, 1, 58);
INSERT INTO has_price_hpr(hpr_shw_id, hpr_tpr_id, hpr_seat_price) VALUES (15, 2, 46);
INSERT INTO has_price_hpr(hpr_shw_id, hpr_tpr_id, hpr_seat_price) VALUES (15, 3, 31);
INSERT INTO has_price_hpr(hpr_shw_id, hpr_tpr_id, hpr_seat_price) VALUES (16, 1, 61);

INSERT INTO BOOKING_BKG (bkg_ID, bkg_DATE, bkg_total_seat, bkg_Cst_ID, bkg_shw_ID, bkg_tpr_ID) VALUES (100, TO_DATE('29/09/2012', 'DD/MM/YYYY'), 2, 1, 10, 1);
INSERT INTO BOOKING_BKG (bkg_ID, bkg_DATE, bkg_total_seat, bkg_Cst_ID, bkg_shw_ID,bkg_tpr_ID) VALUES (101, TO_DATE('29/09/2012', 'DD/MM/YYYY'), 4, 3, 10, 2);
INSERT INTO BOOKING_BKG (bkg_ID, bkg_DATE, bkg_total_seat, bkg_Cst_ID, bkg_shw_ID, bkg_tpr_ID) VALUES (102, TO_DATE('28/08/2012', 'DD/MM/YYYY'), 1, 2, 14, 1);


COMMIT;

SET SERVEROUTPUT ON;

--1.Bloc Anonyme - Join
DECLARE 
    v_last_name CUSTOMER_CST.CST_LAST_NAME%TYPE;
    v_first_name CUSTOMER_CST.CST_FIRST_NAME%TYPE;
    V_BKG_ID BOOKING_BKG.BKG_ID%TYPE := &BKG_ID;
    
BEGIN
    SELECT CST_LAST_NAME, CST_FIRST_NAME
        INTO v_last_name, v_first_name
        FROM CUSTOMER_CST RIGHT JOIN booking_bkg ON CST_ID=BKG_CST_ID
    WHERE BKG_ID = V_BKG_ID;
    DBMS_OUTPUT.PUT_LINE('NAME:'||v_first_name||' '||v_last_name);
END;


--2.Procédure -INSERT
CREATE SEQUENCE SQ_BKG_ID
    START WITH 105
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE PROCEDURE reservation(V_SHW_ID IN BOOKING_BKG.BKG_SHW_ID%TYPE) IS
    --V_SHW_ID BOOKING_BKG.BKG_SHW_ID%TYPE := &SHW_ID;
    V_SEAT BOOKING_BKG.BKG_TOTAL_SEAT%TYPE := 1;
    V_TPR_ID BOOKING_BKG.BKG_TPR_ID%TYPE := 1;
    V_DATE DATE := CURRENT_DATE;
    V_CST_ID BOOKING_BKG.BKG_CST_ID%TYPE := 2;
    V_ID BOOKING_BKG.BKG_ID%TYPE := SQ_BKG_ID.nextval;
    V_TOTAL_SEAT BOOKING_BKG.BKG_TOTAL_SEAT%TYPE;
    V_NB_SHW NUMBER;
 BEGIN
    SELECT SUM(BKG_TOTAL_SEAT), COUNT(BKG_ID)
     INTO V_TOTAL_SEAT,V_NB_SHW
    FROM BOOKING_BKG
    WHERE BKG_SHW_ID = V_SHW_ID
    GROUP BY BKG_SHW_ID;
    DBMS_OUTPUT.PUT_LINE('NB_RESERVATION:'||V_NB_SHW||'  NB_PLACE:'||V_TOTAL_SEAT);
    INSERT INTO BOOKING_BKG
    VALUES(V_ID,V_DATE,V_SEAT,V_CST_ID,V_SHW_ID,V_TPR_ID);
END;

BEGIN
    reservation(10);
END;

--3.PROCÉDURE _DELETE
CREATE OR REPLACE PROCEDURE delete_reservation(V_ID IN BOOKING_BKG.BKG_ID%TYPE) AS
    --V_NB_ROWS NUMBER(4);
BEGIN
    DELETE FROM booking_bkg
    WHERE BKG_ID=V_ID;
    IF (SQL%NOTFOUND) THEN
        DBMS_OUTPUT.PUT_LINE('NO ROW');
    ELSE
        DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || 'ROWS DELETED');
    END IF;
END;

BEGIN
    delete_reservation(103);
END;


--4.PROCÉDURE -UPDATE

-- calcule la valeur la plus grande dans la colonne bkg_total_seat
-- affiche les clients ayant réalisé des réservations avec un tel nombre de places 
--(données à afficher : numéro de réservation, date, prénom et nom du client)
DECLARE
    MAX_SEAT BOOKING_BKG.BKG_TOTAL_SEALT%TYPE;
    V_BKG_ID BOOKING_BKG.BKG_ID%TYPE;
    V_BKG_DATE BOOKING_BKG.BKG_DATE%TYPE;
    V_PRENOM CUSTOMER_CST%TYPE;
    V_NOM CUSTOMER_CST%TYPE;
BEGIN
    SELECT MAX(BKG_TOTAL_SEAT)
    INTO MAX_SEAT
    FROM booking_bkg;
    SELECT BKG_ID, BKG_DATE, CST_FIRST_NAME, CST_LAST_NAME
    INTO V_BKG_ID, V_BKG_DATE, V_PRENOM, V_NOM
    FROM booking_bkg LEFT JOIN CUSTOMER_CST ON BKG_CST_ID=customer_cst.cst_id
    WHERE BKG_TOTAL_SEAT=MAX_SEAT;
    DBMS_OUTPUT.PUT_LINE(V_BKG_ID|| V_BKG_DATE|| V_PRENOM|| V_NOM);
END;
    
