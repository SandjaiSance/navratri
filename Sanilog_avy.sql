-- Create table
create table TMP_SANILOG
(
  regel      NUMBER(10) not null,
  session_id NUMBER not null,
  tijd       DATE default sysdate not null,
  tekst      VARCHAR2(2000),
  xmlletje   XMLTYPE,
  clobje     CLOB default empty_clob(),
  cre_user   VARCHAR2(30) default user not null
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );


create or replace trigger tmp_sanilog_ins_trg
before insert on tmp_sanilog
  for each row
begin
    if :new.regel is null then
       select nvl(max(regel), 0) + 1
         into :new.regel
         from tmp_sanilog;
    end if;

    :new.session_id          := nvl(:new.session_id          ,666);

end tmp_sanilog_ins_trg;
/