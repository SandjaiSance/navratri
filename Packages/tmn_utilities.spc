create or replace package tmn_utilities
is
  function get_versionnumber
    return varchar2;

  procedure get_xml (p_publication                       in varchar2
                    ,p_tmn_xml_result                   out xmltype
                    );

  procedure get_json (p_publication                      in varchar2
                     ,p_tmn_json_result                 out clob
                     );

  procedure get_mrid(p_publication                       in varchar2
                    ,p_pbn_date_utc                      in date
                    ,p_tmn_mrid                         out varchar2
                    );

  procedure get_mrid(p_publication                       in varchar2
                    ,p_pbn_date_utc                      in date
                    ,p_tmn_mrid                         out varchar2
                    ,p_tmn_next_version                 out number
                    ,p_get_version                       in boolean default true
                    );

  procedure get_mrid(p_publication                      in varchar2
                    ,p_udc_sender_mrid                  in varchar2
                    ,p_udc_mrid                         in varchar2
                    ,p_tmn_mrid                        out varchar2
                    );

  procedure get_mrid(p_publication                      in varchar2
                    ,p_udc_sender_mrid                  in varchar2
                    ,p_udc_mrid                         in varchar2
                    ,p_tmn_mrid                        out varchar2
                    ,p_tmn_next_version                out number
                    );
  procedure get_mrid(p_publication                      in varchar2
                    ,p_contract_id                      in varchar2
                    ,p_tmn_mrid                        out varchar2
                    ,p_tmn_next_version                out number
                    );

  procedure get_mrid(p_publication                      in varchar2
                    ,p_auction_id                       in varchar2
                    ,p_tmn_mrid                        out varchar2
                    ,p_tmn_next_version                out number
                    );

  procedure get_mrid(p_publication                      in varchar2
                    ,p_transaction_id                   in varchar2
                    ,p_tmn_mrid                        out varchar2
                    ,p_tmn_next_version                out number
                    );

  procedure get_mrid(p_publication                      in varchar2
                    ,p_border_ara_code                  in varchar2
                    ,p_pbn_date_loc                     in varchar2
                    ,p_tmn_mrid                        out varchar2
                    ,p_tmn_next_version                out number
                    );

  procedure get_mrid(p_mrid_prefix                      in varchar2
                    ,p_mrid_suffix_format               in varchar2
                    ,p_pbn_date                         in date
                    ,p_mrid_suffix                      in varchar2 default null
                    ,p_tmn_mrid                        out nocopy varchar2
                    );

  procedure get_mrid(p_publication                      in varchar2
                    ,p_message_id                       in varchar2
                    ,p_tmn_mrid                        out nocopy varchar2
                    );
                      
  procedure get_mrid(p_publication                      in varchar2
                    ,p_reconciliation_date              in timestamp
                    ,p_tmn_mrid                        out nocopy varchar2
                    );

  procedure get_period_to_publish(p_publication         in sup_publications.name%type
                                 ,p_pbn_date_utc        in date
                                 ,p_pbn_date_utc_from  out date
                                 ,p_pbn_date_utc_to    out date
                                 );

  function execute_expression   (p_time                 in date
                                ,p_expr                 in varchar2
                                ) return timestamp with time zone;


  procedure get_period_to_publish_new(p_publication        in sup_publications.name%type
                                     ,p_pbn_date_utc       in date
                                     ,p_pbn_date_utc_from out date
                                     ,p_pbn_date_utc_to   out date
                                     );

end tmn_utilities;
/
