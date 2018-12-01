--====================================================
--Spécification du package theater_pkg
create or replace PACKAGE theater_pkg
IS
TYPE show_rec IS RECORD
 ( shw_id show_shw.shw_id%TYPE,
   shw_title show_shw.shw_title%TYPE,
   shw_type type_show_tsh.tsh_name%TYPE,
   shw_date show_shw.shw_date%TYPE
  );
  
  TYPE shw_tab
     IS TABLE OF show_rec INDEX BY BINARY_INTEGER;
     
  PROCEDURE find_shw_year
    (p_year IN INTEGER,
     p_shw_tab OUT NOCOPY shw_tab);
	 
  SUBTYPE fullname_t IS VARCHAR2(200);
  
  FUNCTION fullname (
    p_last IN customer_cst.cst_last_name%TYPE,
	p_first IN customer_cst.cst_first_name%TYPE)
	RETURN fullname_t;

  FUNCTION fullname (
    p_cst_id IN customer_cst.cst_id%TYPE)
	RETURN fullname_t;
     
END theater_pkg;
/

--====================================================
--Corps du package theater_pkg
create or replace PACKAGE BODY theater_pkg
IS

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
  
  FUNCTION fullname (
     p_cst_id IN customer_cst.cst_id%TYPE)
	RETURN fullname_t IS
  v_fullname fullname_t;
  BEGIN  
      SELECT fullname(cst_last_name, cst_first_name) INTO v_fullname FROM customer_cst WHERE cst_id = p_cst_id;
	  RETURN v_fullname;
	  EXCEPTION
	  WHEN NO_DATA_FOUND THEN
	     RETURN NULL;
  END;
  
END theater_pkg;
/
