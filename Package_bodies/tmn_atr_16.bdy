create or replace package body tmn_atr_16
is
/*********************************************************************************************************************
   Purpose    : ATR_16 UMM Operational Messages

   Change History
   Date        Author            Version   Description
   ----------  ----------------  --------  ------------------------------------------------------------------------------
   30-08-2023  Xander Pikaar     01.00.00  TRAN-6358 - Creatie
   13-03-2026  Sandjai Ramasray  01.01.00  TRAN-7367 Argus: DQF maken voor ATR_16
                                                     - specifieke fill_expectation gemaakt
  **********************************************************************************************************************/
  cn_package               constant  varchar2(100) := 'tmn_atr_16';
  cn_versionnumber         constant  varchar2(100) := '01.01.00';
  cn_message_id            constant  varchar2(20)  := 'MESSAGE_ID';
  cn_publication           constant  varchar2(100) := 'ATR_16';

  function get_versionnumber
    return varchar2
  is
  begin
    return cn_versionnumber;
  end get_versionnumber;

  procedure start_publication ( p_message_id               in varchar2
                              , p_runtime_utc              in timestamp default systimestamp at time zone 'UTC'
                              , p_start_time_utc           in timestamp with time zone default systimestamp at time zone 'UTC'
                              )
  /***********************************************************************************************************************************
   Doel        : Publiceren van atr_16 - Settled Imbalance Volumes
  ************************************************************************************************************************************/
  is
    cn_module                constant varchar2(100) := cn_package || '.start_publication';

    v_mrid                   varchar2(100);
    v_priority               number(1);
    v_delay_allowed          boolean                := FALSE;

    r_pbn                    sup_publications%rowtype;
    r_tmn                    pcs_tmn_transmissions%rowtype;
    r_tpr                    pcs_tmn_parameters%rowtype;
    
    e_unknown_publication    exception;

    pragma autonomous_transaction;

  begin
    -- Altijd een nieuw proces aanmaken, bij deze publicatie hebben we geen p_catch_up_transmission, want we kunnen deze niet bijdraaien 
    -- omdat hij niet over een bepaalde bvalidity gaat
    pcs_pcs_actions.start_process(p_initiating_procedure => cn_module
                                 ,p_description          => cn_publication
                                 ,p_legal_owner          => sup_constants.cn_legal_owner_ttn
                                 );

    -- write 'Start' into log-trace
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'Start'
                              ||chr(10)||' p_message_id  : ' || p_message_id
                              ||chr(10)||' p_runtime_utc : ' || to_char(p_runtime_utc ,sup_constants.cn_utc_date_format)
                             );

    tmn_utilities.get_mrid(p_publication  => cn_publication
                          ,p_message_id   => p_message_id
                          ,p_tmn_mrid     => v_mrid
                          );

    r_pbn.legal_owner                := sup_ojtppy_actions.get_domain_value(p_ojt_code => cn_publication
                                                                           ,p_ppy_code => 'LEGAL_OWNER');
    r_pbn.name                       := cn_publication;
    sup_pbn_dml.get_row_bk(p_pbn_row => r_pbn);

    r_tmn                            := null;
    r_tmn.pbn_id                     := r_pbn.id;
    r_tmn.mrid                       := v_mrid;
    -- bvalidity is verplicht in pcs_tmn_transmissions. Bij dit bericht klopt het niet, want die heeft niet echt een bvalidity, anders dan dat de melding
    -- op de website beschikbaar gesteld wordt op moment van versturen (ongeveer, zit natuurlijk iets verwerklingstijd in). 
    r_tmn.bvalidity_utc_from         := systimestamp at time zone 'UTC';
    r_tmn.bvalidity_utc_to           := to_timestamp('31-12-9999 23:59:59','dd-mm-yyyy hh24:mi:ss');
    pcs_tmn_actions.initiate_new_transmission(p_tmn_row => r_tmn);

    -- Registreren gebruikte parameters van deze transmissie
    r_tpr.tmn_id                     := r_tmn.id;
    r_tpr.code                       := cn_message_id;
    r_tpr.value                      := p_message_id;
    pcs_tpr_dml.ins_row (p_pcs_tpr_row => r_tpr);

    -- Indien een delay periode is gedefinieerd, dan is een vertraagde start dus toegestaan
    v_delay_allowed := (sup_ojtppy_actions.get_domain_value(p_ojt_code                => cn_publication
                                                           ,p_ppy_code                => 'START_TRANSMISSION_DELAY'
                                                           ,p_tvalidity_utc_timestamp => p_runtime_utc
                                                           ,p_bvalidity_utc_timestamp => p_runtime_utc
                                                           )
                        is not null);

    -- schedule job
    pcs_jsr_actions.schedule_job(p_pbn_name                                           => cn_publication
                                ,p_mrid                                               => v_mrid
                                ,p_priority                                           => v_priority
                                ,p_bvalidity_utc_from                                 => null
                                ,p_bvalidity_utc_to                                   => null
                                ,p_delay_allowed                                      => v_delay_allowed
                                ,p_runtime_utc                                        => p_runtime_utc
                                ,p_start_time_utc                                     => p_start_time_utc
                                ,p_tmn_id                                             => r_tmn.id
                                );
    
    -- Transmissie wordt gedaan, dan moeten we ook een AGS_PBN_EXPECTATIONS record aanmaken
    fill_expectations( p_mrid        => v_mrid
                     , p_runtime_utc => p_runtime_utc
                     );
    
    -- write 'End' into log-trace
    pcs_log_actions.log_trace(p_module => cn_module
                             ,p_text   => 'End'
                              ||chr(10)||' p_message_id  : '||p_message_id
                              ||chr(10)||' p_runtime_utc : '||to_char(p_runtime_utc ,sup_constants.cn_utc_date_format)
                             );

    pcs_pcs_actions.end_process;

  exception
    when e_unknown_publication then
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Onbekend publicatie type voor atr_16: '
                              ||chr(10)||' p_message_id  : ' || p_message_id
                              ||chr(10)||' p_runtime_utc : ' || to_char(p_runtime_utc ,sup_constants.cn_utc_date_format)
                             );
      -- Beeindig het proces
      pcs_pcs_actions.end_process;

    when others then
      commit;

      -- Log xml-bericht, als die gevuld is
      pcs_log_actions.log_error(p_module => cn_module
                               ,p_text   => 'Parameters'
                              ||chr(10)||' p_message_id  : ' || p_message_id
                              ||chr(10)||' p_runtime_utc : ' || to_char(p_runtime_utc ,sup_constants.cn_utc_date_format)
                             );
      -- Beeindig het proces
      pcs_pcs_actions.end_process;

  end start_publication;

  procedure fill_expectations ( p_mrid                     in varchar2
                              , p_runtime_utc              in date
                              )
  /***********************************************************************************************************************************
   Doel        : Zet de ags_pbn_expectations records klaar voor de Argus controle.
                 ATR_16 is een data-publicatie en zal worden gestart vanuit start_publication en niet vanuit een scheduled job.
  ************************************************************************************************************************************/
  is
    cn_module                constant varchar2(100) := cn_package || '.fill_expectations';

    v_runtime_utc                     date;
    v_deadline_utc                    date;
    v_ags_definition_found            boolean          := false;

    r_ags_epn                         ags_pbn_expectations%rowtype;

    e_no_ags_definition               exception;

    cursor c_ags_dfn (b_publication  in varchar2)
        is select ags_dfn.check_name
                 ,ags_dfn.deadline_after_runtime
             from ags_pbn_definitions ags_dfn
             join sup_publications pbn on pbn.id = ags_dfn.pbn_id
            where pbn.name = b_publication;

  begin

    pcs_log_actions.log_info(p_module => cn_module
                            ,p_text   => 'Create Argus expectations for publication ' || cn_publication);

    sup_utilities.keep_session_nls;
    sup_utilities.set_session_dutch;

    for r_ags_dfn in c_ags_dfn (b_publication => cn_publication) loop

        v_ags_definition_found := true;

        v_runtime_utc                := p_runtime_utc;
        v_deadline_utc               := v_runtime_utc + to_dsinterval(r_ags_dfn.deadline_after_runtime);

        r_ags_epn                     := null;
        r_ags_epn.check_name          := cn_publication;
        r_ags_epn.mrid                := p_mrid;
        r_ags_epn.runtime_utc         := v_runtime_utc;
        r_ags_epn.deadline_utc        := v_deadline_utc;
        r_ags_epn.retry_counter       := 0;
        ags_epn_dml.dml_row(p_row => r_ags_epn);

    end loop;

    if not v_ags_definition_found then
       raise e_no_ags_definition;
    end if;

    pcs_log_actions.log_info(p_module => cn_module
                            ,p_text   => 'Ags_pbn_definitions record added for publication ' || cn_publication);

  exception
    when e_no_ags_definition then
         pcs_log_actions.log_error(p_module => cn_module
                                  ,p_text   => 'No ags_pbn_definitions record found for publication ' || cn_publication
                                  );

    when others then
         pcs_log_actions.log_error(p_module => cn_module);
  end fill_expectations;

  procedure check_expectations
  is
  /***********************************************************************************************************************************
   Doel : Controleer de tijdigheid en compleetheid van de transmissies met Argus. Default verwijzing naar Argus_actions.check_expectations.
  ************************************************************************************************************************************/
  begin
    argus_actions.check_expectations (p_publication =>  cn_publication);
  end check_expectations;

  procedure check_expectation_after_ack(p_mrid            in pcs_tmn_transmissions.mrid%type)
  is
  /***********************************************************************************************************************************
   Doel : Controleer de tijdigheid en compleetheid van de transmissies met Argus. Default verwijzing naar Argus_actions.check_expectation_after_ack.
  ************************************************************************************************************************************/
  begin
    argus_actions.check_expectation_after_ack (p_publication => cn_publication
                                              ,p_mrid        => p_mrid);

  end check_expectation_after_ack;
end tmn_atr_16;
/
