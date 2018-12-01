--YU Hong   TP4
/
SET SERVEROUT ON;
/
--1.Trigger
ALTER TABLE booking_bkg ADD bkg_total_amount NUMBER(6,2);

CREATE OR REPLACE TRIGGER ck_total_amount
BEFORE INSERT OR UPDATE OF bkg_id,bkg_total_seat,bkg_tpr_id,bkg_shw_id ON BOOKING_BKG FOR EACH ROW
DECLARE
    seat_price HAS_PRICE_HPR.HPR_SEAT_PRICE%TYPE;
BEGIN
    SELECT HPR_SEAT_PRICE 
    INTO seat_price 
    FROM HAS_PRICE_HPR
    WHERE HPR_SHW_ID=:NEW.BKG_SHW_ID AND HPR_TPR_ID=:NEW.BKG_TPR_ID;
    
    :NEW.BKG_TOTAL_AMOUNT := :NEW.BKG_TOTAL_SEAT*seat_price;
    
    EXCEPTION
        WHEN  no_data_found THEN
            RAISE_APPLICATION_ERROR(-20203, 'un SELECT INTO ne retourne aucune ligne');
END;
    
/
INSERT INTO booking_bkg(bkg_id, BKG_DATE, bkg_total_seat, bkg_cst_id, bkg_shw_id,
bkg_tpr_id) VALUES (103, SYSDATE,5, 1, 10, 1);
/

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--2.Packages
--====================================================
--Spécification du package theater_pkg
create or replace PACKAGE theater_pkg
IS
-- déclarer un nouveux enregistrement
TYPE show_rec IS RECORD
 ( shw_id show_shw.shw_id%TYPE,
   shw_title show_shw.shw_title%TYPE,
   shw_type type_show_tsh.tsh_name%TYPE,
   shw_date show_shw.shw_date%TYPE
  );
-- déclarer un nouveux type de liste ou index est numérique
  TYPE shw_tab
     IS TABLE OF show_rec INDEX BY BINARY_INTEGER;
-- déclarer une procédure qui permet de trouver l'année de show
  PROCEDURE find_shw_year
    (p_year IN INTEGER,
     p_shw_tab OUT NOCOPY shw_tab);
-- déclarer une variable de chaîne de caractère	 
  SUBTYPE fullname_t IS VARCHAR2(200);
  
-- déclarer une function retournant un nom entière à partir de nom et prénom
  FUNCTION fullname (
    p_last IN customer_cst.cst_last_name%TYPE,
	p_first IN customer_cst.cst_first_name%TYPE)
	RETURN fullname_t;
-- déclarer une function retournant un nom entière à partir d'id de client
  FUNCTION fullname (
    p_cst_id IN customer_cst.cst_id%TYPE)
	RETURN fullname_t;
    
  TYPE bkg_rec IS RECORD
 ( cst_id BOOKING_BKG.BKG_CST_ID%TYPE,
   shw_title show_shw.shw_title%TYPE,
   total_seat booking_bkg.bkg_total_seat%TYPE,
   montal booking_bkg.bkg_total_amount%TYPE,
   fname fullname_t
  );
-- déclarer un nouveux type de liste ou index est numérique
  TYPE bkg_tab
     IS TABLE OF bkg_rec INDEX BY BINARY_INTEGER;
-- déclarer une procédure la liste des réservations d'un client     
  PROCEDURE list_booking (p_cst_id IN customer_cst.cst_id%TYPE,
    p_bkg_tab OUT NOCOPY bkg_tab
    );
    
-- déclarer une variable numérique	 
  SUBTYPE prix_moy_t IS NUMERIC;
  
-- déclarer une function retournant le prix moyen d’un spectacle
  FUNCTION prix_moy (
    p_shw_id IN HAS_PRICE_HPR.HPR_SHW_ID%TYPE)
	RETURN prix_moy_t;
     
END theater_pkg;

--====================================================
--Corps du package theater_pkg
create or replace PACKAGE BODY theater_pkg
IS
--à partir d'une année en sortie la liste des spectacle de cette année
    PROCEDURE find_shw_year
        (p_year IN INTEGER,
         p_shw_tab OUT NOCOPY shw_tab) IS
    CURSOR shw_cur IS SELECT shw_id, shw_title, tsh_name, shw_date
       FROM show_shw JOIN type_show_tsh
       ON shw_tsh_id = tsh_id
       WHERE EXTRACT (YEAR FROM shw_date) = p_year;
    BEGIN
      FOR v_shw_rec IN shw_cur LOOP
         p_shw_tab(v_shw_rec.shw_id) := v_shw_rec;
      END LOOP;
    END find_shw_year;

  FUNCTION fullname (
    p_last IN customer_cst.cst_last_name%TYPE,
	p_first IN customer_cst.cst_first_name%TYPE)
	RETURN fullname_t IS
  BEGIN
     RETURN p_last || ' - ' || p_first;
  END;

-- Le nom de famille du client devra s’afficher avec une majuscule initiale
  FUNCTION fullname (
     p_cst_id IN customer_cst.cst_id%TYPE)
	RETURN fullname_t IS
  v_fullname fullname_t;
  BEGIN  
      SELECT fullname(CONCAT(upper(SUBSTR(cst_last_name, 1,1)),lower(SUBSTR(cst_last_name,2,LENGTH(cst_last_name)-1))),cst_first_name) 
      INTO v_fullname 
      FROM customer_cst 
      WHERE cst_id = p_cst_id;
	  RETURN v_fullname;
	  EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	     RETURN NULL;
  END;

--à partir d’un identifiant de client de fournir en sortie la liste des réservations de ce client
  PROCEDURE list_booking (p_cst_id IN customer_cst.cst_id%TYPE,
    p_bkg_tab OUT NOCOPY bkg_tab
    ) IS
    CURSOR bkg_cur IS SELECT bkg_cst_id, shw_title, bkg_total_seat, bkg_total_amount, fullname(bkg_cst_id)
        FROM BOOKING_BKG JOIN SHOW_SHW
        ON bkg_shw_id = shw_id
        WHERE bkg_cst_id = p_cst_id;
    BEGIN
        FOR v_bkg_cur IN bkg_cur LOOP
            p_bkg_tab(p_cst_id) := v_bkg_cur;
        END LOOP;
    END list_booking;
    
--retourner le prix moyen d’un spectacle à partir de l’identifiant du spectacle
    FUNCTION prix_moy (
        p_shw_id IN HAS_PRICE_HPR.HPR_SHW_ID%TYPE)
        RETURN prix_moy_t IS
        v_prix_moy prix_moy_t;
      BEGIN
         SELECT AVG(HPR_SEAT_PRICE)
         INTO v_prix_moy
         FROM HAS_PRICE_HPR
         WHERE HPR_SHW_ID = p_shw_id
         GROUP BY HPR_SHW_ID;
         RETURN v_prix_moy;
      END;
    
END theater_pkg;
/
--====================================================
-- test fullname function and find_shw_year PROCEDURE
declare
    fullname VARCHAR2(200);
    p_show_tab THEATER_PKG.shw_tab;
    l_row BINARY_INTEGER;
begin
    fullname := THEATER_PKG.FULLNAME(1);
    DBMS_OUTPUT.PUT_LINE(fullname);
    THEATER_PKG.find_shw_year (2013, p_show_tab);
    l_row := p_show_tab.FIRST;
    WHILE (l_row IS NOT NULL) LOOP
        DBMS_OUTPUT.PUT_LINE(p_show_tab(l_row).shw_date);
        l_row := p_show_tab.NEXT(l_row); 
    END LOOP;
end;
/
-- test list_booking PROCEDURE
declare
    fullname VARCHAR2(200);
    p_bkg_tab THEATER_PKG.bkg_tab;
    l_row BINARY_INTEGER;
begin
    THEATER_PKG.LIST_BOOKING (1,p_bkg_tab);
    l_row := p_bkg_tab.FIRST;
    WHILE (l_row IS NOT NULL) LOOP
        DBMS_OUTPUT.PUT_LINE(p_bkg_tab(l_row).fname);
        DBMS_OUTPUT.PUT_LINE(p_bkg_tab(l_row).shw_title);
        l_row := p_bkg_tab.NEXT(l_row); 
    END LOOP;
end;
/
--test prix_moy function
BEGIN
    DBMS_OUTPUT.PUT_LINE(THEATER_PKG.PRIX_MOY(10));
END;
/

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--4.
SELECT index_name, table_name FROM user_indexes;
--sur les colonnes qui sont les clé primaires/étrangés de ce table

SELECT BKG_DATE 
FROM BOOKING_BKG
ORDER BY BKG_ID;
-- BOOKING_BKG BY INDEX ROWID
-- PK_BKG FULL SCAN

SELECT CST_LAST_NAME, CST_FIRST_NAME,BKG_SHW_ID,BKG_DATE
FROM BOOKING_BKG JOIN CUSTOMER_CST
ON BKG_CST_ID=CST_ID
ORDER BY BKG_DATE;

CREATE INDEX UN_BKG_DATE ON BOOKING_BKG(BKG_DATE);