create or replace package pcs_rcn_actions is
  function get_versionnumber return varchar2;

  function initiate_new_reception (p_xml          in xmltype
                                  ,p_delivery     in varchar2
                                  ,p_enqueue_time in timestamp
                                  ,p_start_time   in timestamp
                                  ,p_message_supplied_utc  in timestamp default null
                                  )
     return pcs_rcn_receptions.id%type;
     
  function initiate_new_reception (p_json                   in clob
                                  ,p_delivery               in varchar2
                                  ,p_enqueue_time           in timestamp
                                  ,p_start_time             in timestamp
                                  ,p_message_supplied_utc  in timestamp default null
                                  )
     return pcs_rcn_receptions.id%type;

  function initiate_new_pct_reception (p_xml          in xmltype
                                      ,p_delivery     in varchar2
                                      ,p_enqueue_time in timestamp
                                      ,p_start_time   in timestamp)
     return pcs_rcn_receptions.id%type;

  procedure set_bvalidity (p_rcn_id             in pcs_rcn_receptions.id%type
                          ,p_bvalidity_utc_from in pcs_rcn_receptions.bvalidity_utc_from%type default null
                          ,p_bvalidity_utc_to   in pcs_rcn_receptions.bvalidity_utc_to%type   default null
                          );

  procedure get_delivery(p_rcn_id   in pcs_rcn_receptions.id%type
                        ,p_dly_row out sup_deliveries%rowtype
                        );
  procedure add_info_to_reception (p_rcn_row        in out pcs_rcn_receptions%rowtype);
                        
  function simulate_rcn_doc_version (p_document_mrid   in varchar2)
    return number;

end pcs_rcn_actions;
/
