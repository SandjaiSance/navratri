drop type if exists RT_PCS_API_CALL_INFORMATION;

create or replace type tt_pcs_api_call_information
   as object (api_call_id                  number(20)
             ,publication_code             varchar2(50)
             ,information_type             varchar2(100)
             ,validity_period              varchar2(20)
             ,api_call_ms                  number(12,3)
             ,rest_call_total_ms           number(12,3)
             ,last_updated                 varchar2(30)
             ,call_source                  varchar2(30)
             ,response_format              varchar2(10)
             ,response_cache_used          varchar2(10)
             ,measurement_type             varchar2(50)
             ,warning_threshold            number(10)
             ,breach_threshold_min         number(10)
             ,threshold_unit               varchar2(10)
             ,p90_api_call_ms              number(12,3)
             ,p90_rest_call_total_ms       number(12,3)
             ,breach_duration_min          number(10));
/             

create or replace type rt_pcs_api_call_information
   as table of tt_pcs_api_call_information;
/
