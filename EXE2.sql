--1.
DECLARE
--V_bkg_id booking_bkg.bkg_id%TYPE;
cursor cur_bkg is
    SELECT bkg_id
    FROM booking_bkg 
    WHERE bkg_shw_id = 10;
begin
    --open cur_bkg;
    for v_bkg_id IN cur_bkg loop
        DBMS_OUTPUT.PUT_LINE(v_bkg_id.bkg_id);
    end loop;
END;
/
--2.
create or replace procedure prc_add_tsh(p_id in TYPE_SHOW_TSH.TSH_ID%TYPE, p_name in TYPE_SHOW_TSH.TSH_NAME%TYPE) is
begin
    INSERT INTO TYPE_SHOW_TSH VALUES (p_id,p_name);
    EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        dbms_output.put_line('doublon sur la clé primaire');
END prc_add_tsh;
/
BEGIN
PRC_ADD_TSH(7, 'xx');
end;
    
--3.
CREATE TABLE error_log ( 
qui VARCHAR2(30),
quand DATE,
code_err NUMBER(6), 
msg_err VARCHAR2(255));

create or replace procedure prc_add_client(p_id in customer_cst.cst_id%TYPE, 
p_email in customer_cst.cst_email%TYPE, 
p_nom in customer_cst.cst_last_name%TYPE,
p_prenom in customer_cst.cst_first_name%TYPE,
p_phone in customer_cst.cst_phont%TYPE) is
e_no_name EXCEPTION;
begin
    INSERT INTO CUSTOMER_CST VALUES (p_id, p_email, p_nom, p_prenom, p_phont);
    if (p_nom is NULL)||(p_prenom is NULL) then
        raise e_no_name;
    
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN dbms_output.put_line("customer existed");
        when e_no_name THEN dbms_output.put_line("nom et prénom non renseignés");
        when other then 
        
--Ecrire une fonction qui : 
-- Calcule la durée moyenne des spectacles 
-- Retourne le nombre de spectacles ayant une durée strictement supérieure à cette valeur 
-- Traite comme un cas d'erreur la situation où la durée moyenne calculée vaut 0

CREATE or REPLACE FUNCTION nb_long_show RETURN NUMBER IS
v_nbr NUMBER;
v_moy DECIMAL;
e_zero_moy EXCEPTION;

BEGIN
    SELECT AVG(SHW_DURATION)
    INTO v_moy
    FROM SHOW_SHW;
    IF (v_moy=0) THEN
        RAISE e_zero_moy;
    END iF;
    
    SELECT COUNT(*)
    INTO v_nbr
    FROM SHOW_SHW
    WHERE SHW_DURATION > v_moy;
    
    RETURN v_nbr;
    
    EXCEPTION
    WHEN e_zero_moy THEN
        dbms_output.put_line('la durée moyenne:'||v_moy);

END nb_long_show;

begin
    dbms_output.put_line(nb_long_show);
end;

    