/* trigger */
drop trigger t_before_bericht on Bericht;
drop trigger t_before_einsatz on Einsatz;
drop function check_bericht();
drop function check_einsatz();

/* function/procedure */
drop function p_erhoehe_dienstgrad(jahre INTEGER);
drop function f_bonus(person INTEGER);
