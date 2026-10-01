create or replace package argus_actions
is
   function get_versionnumber
     return varchar2;

   procedure fill_frequent_pbn_expectations;
   
   procedure check_pbn_expectations (p_check_name        in  varchar2 default 'ALL');
   
   procedure check_pbn_expectations_after_ack (p_tmn_id  in  pcs_tmn_transmissions.id%type);

   function determine_fill_from_runtime(p_check_name     in ags_pbn_definitions.check_name%type)
      return date;
      
   function determine_fill_until_runtime(p_date_from_utc in  date
                                        ,p_check_name    in ags_pbn_definitions.check_name%type)
      return date;
            
   procedure determine_statusses (p_delivered_utc        in  date
                                 ,p_approved_utc         in  date
                                 ,p_rejected_utc         in  date
                                 ,p_deadline_utc         in  date
                                 ,p_timely               out varchar2  
                                 ,p_complete             out varchar2);
                                 
   function is_argus_publication (p_publication_name     in  sup_publications.name%type)
      return boolean;

   procedure fill_expectations   (p_publication          in sup_publications.name%type);
   
   procedure check_expectations  (p_publication          in sup_publications.name%type);

   procedure check_expectation_after_ack (p_publication  in sup_publications.name%type  
                                         ,p_mrid         in pcs_tmn_transmissions.mrid%type);

end argus_actions;
/
