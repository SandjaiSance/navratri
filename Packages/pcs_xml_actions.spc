create or replace package pcs_xml_actions
is
  type rt_message_metadata        is record
      (id                                     varchar2(1000)
      ,creation_time                          varchar2(1000)
      ,message_type                           varchar2(1000)
      ,subtype                                varchar2(1000)
      ,version                                varchar2(1000)
      ,reference                              varchar2(1000)
      ,priority                               varchar2(1000)
      ,significance                           varchar2(1000)
      ,test_indication                        varchar2(1000)
      ,diversiontype                          varchar2(1000)
      ,b2b_sender                             varchar2(1000)
      ,b2b_sender_role                        varchar2(1000)
      ,b2b_recipient                          varchar2(1000)
      ,b2b_recipient_role                     varchar2(1000)
      ,b2b_mimetype                           varchar2(1000)
      ,b2b_run_id                             varchar2(1000)
      ,b2b_send_time                          varchar2(1000)
      ,b2b_receiving_time                     varchar2(1000)
      ,b2b_reference_id                       varchar2(1000)
      ,b2b_mailer                             varchar2(1000)
      ,b2b_subject                            varchar2(1000)
      ,b2b_filename                           varchar2(1000));

  type tr_nodes is record
      (message_line                           pls_integer
      ,node_level                             number(5)
      ,node_xpath                             varchar2(1000)
      ,node_name                              varchar2(1000)
      ,node_value                             varchar2(2000)
      ,namespace                              varchar2(2000));

  type tr_node_attributes is record
      (message_line                           number(10)
      ,attribute_sequence                     number(2)
      ,attribute_name                         varchar2(1000)
      ,attribute_value                        varchar2(2000));

  type tt_nodes           is table of tr_nodes           index by simple_integer;
  type tt_node_attributes is table of tr_node_attributes index by simple_integer;

  type rt_message_payload_info        is record
      (mrid                                   varchar2(100)
      ,revision_number                        varchar2(100)
      ,bvaldity_utc_from                      varchar2(100)
      ,bvaldity_utc_to                        varchar2(100)
      ,document_type                          varchar2(100)
	  ,sender_marketparticipant_mrid          varchar2(100));

  function get_versionnumber
      return varchar2;

  procedure get_message_metadata         (p_xml              in  xmltype
                                         ,p_message_metadata out rt_message_metadata);

  procedure determine_namespace          (p_xml              in     xmltype
                                         ,p_namespace           out varchar2
                                         ,p_namespace_prefix    out varchar2 );

  function get_message_type              (p_xml              in     xmltype
                                         ,p_namespace        in     varchar2  default null
                                         ,p_namespace_prefix in     varchar2  default null)
      return varchar2;

  function get_message_subtype           (p_xml              in     xmltype
                                         ,p_namespace        in     varchar2  default null
                                         ,p_namespace_prefix in     varchar2  default null)
      return varchar2;

  procedure get_message_name             (p_xml              in     xmltype
                                         ,p_msg_name            out varchar2);

  procedure get_message_nodes_flat       (p_xml              in     xmltype
                                         ,p_nodes               out tt_nodes
                                         ,p_node_attributes     out tt_node_attributes);
                                         
  procedure get_message_payload_info     (p_xml                   in  xmltype
                                         ,p_message_payload_info  out rt_message_payload_info
                                         );

  procedure message_nodes_to_gtt         (p_xml              in     xmltype);
  
  function get_document_type (p_xml   in xmltype)
    return varchar2;

  function get_hash(p_xml in xmltype)
    return raw;
  

end pcs_xml_actions;
/
