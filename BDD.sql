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
INSERT INTO type_show_tsh (tsh_ID, tsh_name) VALUES (7, 'Op?ra');


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