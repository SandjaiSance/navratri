set define off
set serveroutput on

declare
  v_inserted number := 0;
begin
  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>ZnfONycZlh366Xe7TAsoEA</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-29T13:47:42Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2025-06-30T22:00Z</start>
    <end>2026-06-29T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2025-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>22:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-29</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000152X</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Delesto 2</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>Farmsum</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000153V</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Delesto 2</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">343.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2025-06-30T22:00Z</start>
            <end>2026-06-29T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('001-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202506302200-202606292200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>kHhSSDF0M7tCDelA0_WcrA</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-26T12:30:58Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-04-07T10:00Z</start>
    <end>2026-09-18T21:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-04-07</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>10:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-09-18</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000046W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Velsen</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000229</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Velsen 24</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">350.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-04-07T10:00Z</start>
            <end>2026-09-18T21:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
            <text>Other</text>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('002-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202604071000-202609182100.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>RobL-Pp2FQxLtOqxdMxhig</mRID>
  <revisionNumber>4</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-26T10:28:12Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-05-01T21:00Z</start>
    <end>2026-07-24T21:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-05-01</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>21:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000119V</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000020D</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven 30</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">470.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-05-01T21:00Z</start>
            <end>2026-07-24T21:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('003-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202605012100-202607242100.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>SL9P4sdESma-t6vGCBcPuA</mRID>
  <revisionNumber>5</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-22T13:58:58Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-05-08T21:00Z</start>
    <end>2026-06-22T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-05-08</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>21:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-05-08T21:00Z</start>
            <end>2026-06-22T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('004-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202605082100-202606221500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Sh2Yb6UddA0gt07a451NNQ</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-20T18:53:01Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-05-08T21:00Z</start>
    <end>2026-06-22T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-05-08</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>21:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-05-08T21:00Z</start>
            <end>2026-06-22T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
              <Point>
                <position>63001</position>
                <quantity>680</quantity>
              </Point>
              <Point>
                <position>63841</position>
                <quantity>224</quantity>
              </Point>
              <Point>
                <position>'));
    dbms_lob.append(l_clob, to_clob('64441</position>
                <quantity>680</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('005-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202605082100-202606221600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>KJ3NqICHU9OR3qWBVMWjjg</mRID>
  <revisionNumber>8</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-24T20:59:56Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-05-08T21:00Z</start>
    <end>2026-06-24T21:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-05-08</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>21:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-05-08T21:00Z</start>
            <end>2026-06-24T21:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
              <Point>
                <position>64441</position>
                <quantity>640</quantity>
              </Point>
              <Point>
                <position>67321</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailabili'));
    dbms_lob.append(l_clob, to_clob('ty_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('006-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202605082100-202606242130.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>wOxqGZV0qeQkbdiIAlYceA</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-03T06:03:44Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-05-15T10:00Z</start>
    <end>2026-07-07T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-05-15</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>10:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-07</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000078J</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>NLROTTETH__1</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000079H</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>NLROTTETH__1</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-05-15T10:00Z</start>
            <end>2026-07-07T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('007-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202605151000-202607072200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>K9Fm6f4GZPsSOntD_4Kb1w</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-26T11:11:47Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-05-22T15:00Z</start>
    <end>2026-07-03T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-05-22</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>15:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-03</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000048S</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>TNZ150 ELSTA</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000049Q</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Elsta 1</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">455.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-05-22T15:00Z</start>
            <end>2026-07-03T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>332</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('008-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202605221500-202607031500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>W2vVXho39Rg57mCmFqUV-A</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-27T09:59:57Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-05-31T21:00Z</start>
    <end>2026-06-27T10:15Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-05-31</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>21:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-27</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>10:15:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000000431</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Diemen</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000164</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Diemen 33</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">249.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-05-31T21:00Z</start>
            <end>2026-06-27T10:15Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('009-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202605312100-202606271015.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>am0ZBdKy6AK0rSdQXCSY-Q</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-29T07:27:51Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-05-31T22:00Z</start>
    <end>2026-07-19T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-05-31</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>22:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-19</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000094L</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>PERGEN 2</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000095J</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Pergen 2</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">125.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-05-31T22:00Z</start>
            <end>2026-07-19T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('010-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202605312200-202607192200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>ttNh5fCnxnaAkJvNITatcg</mRID>
  <revisionNumber>10</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-23T06:31:40Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-01T14:45Z</start>
    <end>2026-06-23T07:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-01</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>14:45:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>07:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000002051</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>BESS Maxima</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>Netherlands</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B20</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000207Y</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>BESS Maxima</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">35.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-01T14:45Z</start>
            <end>2026-06-23T07:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>31</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('011-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606011445-202606230730.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>bN0NF8opQeJ0KMyzSIh69g</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T07:12:40Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-01T22:00Z</start>
    <end>2026-07-01T08:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-01</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>22:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-01</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>08:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000096H</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 20</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000097F</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 20</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">131.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-01T22:00Z</start>
            <end>2026-07-01T08:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>125</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('012-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606012200-202607010800.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>LgeUMTb9KDGES38XkMXqyA</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-09T11:07:47Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-09T11:15Z</start>
    <end>2026-07-13T04:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-09</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>11:15:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-13</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>04:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000070Z</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Amer</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B01</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000002F</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Amer 9</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">631.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-09T11:15Z</start>
            <end>2026-07-13T04:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('013-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606091115-202607130400.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Tq-W-AJ5C39cOuVSqQ1SCw</mRID>
  <revisionNumber>11</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-23T18:03:31Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-12T14:30Z</start>
    <end>2026-06-23T18:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-12</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>14:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>18:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000046W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Velsen</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000021B</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>IJmond</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">144.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-12T14:30Z</start>
            <end>2026-06-23T18:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
            <text>Other</text>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('014-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606121430-202606231800.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>1IFezP6zwcNG-anW55suWg</mRID>
  <revisionNumber>5</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-22T08:58:51Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-12T15:00Z</start>
    <end>2026-07-17T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-12</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>15:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-17</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000063W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Moerdijk</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000148</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Moerdijk 2</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">418.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-12T15:00Z</start>
            <end>2026-07-17T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('015-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606121500-202607171500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>4CBUSCV3_3ZlSsA1r6rFSQ</mRID>
  <revisionNumber>6</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-17T13:50:47Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-19T04:00Z</start>
    <end>2026-07-11T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-19</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>04:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-11</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000069K</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Claus</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000059</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Claus C</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1304.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-19T04:00Z</start>
            <end>2026-07-11T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>794</quantity>
              </Point>
              <Point>
                <position>61</position>
                <quantity>359</quantity>
              </Point>
              <Point>
                <position>121</position>
                <quantity>0</quantity>
              </Point>
              <Point>
                <position>24481</position>
                <quantity>869</quantity>
              </Poi'));
    dbms_lob.append(l_clob, to_clob('nt>
        </Available_Period>
                <Reason>
                  <code>B19</code>
                </Reason>
  </TimeSeries>
      <Reason>
        <code>B18</code>
            <text>Other</text>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('016-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606190400-202607112200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>prcMXUq1UmXXKjbbTYgncQ</mRID>
  <revisionNumber>4</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-10T10:37:42Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-19T23:00Z</start>
    <end>2026-06-21T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-19</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-21</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000082S</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 6</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000083Q</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 6</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-19T23:00Z</start>
            <end>2026-06-21T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('017-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606192300-202606212200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>TUwyvnx2L5n5BLG_roKo6A</mRID>
  <revisionNumber>7</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T14:47:42Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-19T23:00Z</start>
    <end>2026-07-06T10:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-19</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-06</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>10:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000084O</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 5</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000085M</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 5</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-19T23:00Z</start>
            <end>2026-07-06T10:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('018-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606192300-202607061000.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>1kP1M5AGoWw3HxHumoqRdA</mRID>
  <revisionNumber>6</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-20T14:16:27Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-20T23:30Z</start>
    <end>2026-06-22T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-20</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-20T23:30Z</start>
            <end>2026-06-22T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>680</quantity>
              </Point>
              <Point>
                <position>1771</position>
                <quantity>224</quantity>
              </Point>
              <Point>
                <position>2371</position>
                <quantity>680</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
    '));
    dbms_lob.append(l_clob, to_clob('  <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('019-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606202330-202606221600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>mzPEPnuGNY1ei2908Trohw</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-20T18:56:56Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-20T23:30Z</start>
    <end>2026-06-22T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-20</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-20T23:30Z</start>
            <end>2026-06-22T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>680</quantity>
              </Point>
              <Point>
                <position>1771</position>
                <quantity>224</quantity>
              </Point>
              <Point>
                <position>2371</position>
                <quantity>680</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
    '));
    dbms_lob.append(l_clob, to_clob('  <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('020-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606202330-202606221600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>2pfHdyyRv35QXek-R5bOeg</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-20T20:36:54Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-21T03:00Z</start>
    <end>2026-06-21T10:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-21</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>03:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-21</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>10:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000086K</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000087I</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-21T03:00Z</start>
            <end>2026-06-21T10:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>300</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('021-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606210300-202606211000.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>mZms44qhWLtE4HmuOvsJvg</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-21T19:40:40Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-21T05:00Z</start>
    <end>2026-06-21T19:38Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-21</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-21</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>19:38:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000074R</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>FLEVO 5</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000075P</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>FLEVO 5</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">464.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-21T05:00Z</start>
            <end>2026-06-21T19:38Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('022-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606210500-202606211938.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>FkKN3SMx8pTUBWxmk5Endg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-18T14:25:57Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-22T05:00Z</start>
    <end>2026-06-22T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-22</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000088G</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 3</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000089E</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 3</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-22T05:00Z</start>
            <end>2026-06-22T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('023-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606220500-202606221500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>0GV9EHOXg5nojRn3Rrzktw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-18T14:27:34Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-22T05:00Z</start>
    <end>2026-06-22T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-22</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000086K</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000087I</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-22T05:00Z</start>
            <end>2026-06-22T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('024-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606220500-202606221500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>LwJGvo2fMNzB3EJbmDMpqA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-18T14:28:39Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-22T05:00Z</start>
    <end>2026-06-22T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-22</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000082S</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 6</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000083Q</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 6</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-22T05:00Z</start>
            <end>2026-06-22T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('025-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606220500-202606221500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>7_yb1zQBZHP04hKiwPaS3Q</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-18T14:29:39Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-22T05:00Z</start>
    <end>2026-06-22T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-22</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000080W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 7</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000081U</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 7</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-22T05:00Z</start>
            <end>2026-06-22T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('026-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606220500-202606221500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>5cqJzHK_u47mmgVcVIbqNw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-19T09:19:31Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-22T05:00Z</start>
    <end>2026-06-22T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-22</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000119V</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000019Z</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven 20</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">470.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-22T05:00Z</start>
            <end>2026-06-22T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>200</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('027-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606220500-202606221500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>lKYU2dMGTlT6GBOfYcDP3w</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-19T09:31:40Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-22T05:00Z</start>
    <end>2026-06-22T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-22</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-22T05:00Z</start>
            <end>2026-06-22T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('028-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606220500-202606221500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>43zRVc034aqwHxXczinkug</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-19T09:33:42Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-22T05:00Z</start>
    <end>2026-06-22T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-22</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000119V</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000180</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven 10</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">470.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-22T05:00Z</start>
            <end>2026-06-22T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('029-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606220500-202606221500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>EG6svgs99kEywf_x-YJ2dQ</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-21T05:52:53Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-22T05:00Z</start>
    <end>2026-06-22T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-22</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000075</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven A</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-22T05:00Z</start>
            <end>2026-06-22T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('030-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606220500-202606221500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>-mc5lsDbTa49mfYPFf247w</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-21T06:28:38Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-22T05:00Z</start>
    <end>2026-06-22T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-22</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000075</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven A</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-22T05:00Z</start>
            <end>2026-06-22T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>224</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('031-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606220500-202606221500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>h1TmX3MEtYSdfB9uqpmxdg</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-23T07:29:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-22T18:30Z</start>
    <end>2026-06-23T07:15Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-22</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>18:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>07:15:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000000342</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Den Haag</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000342</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>EDH</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">112.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-22T18:30Z</start>
            <end>2026-06-23T07:15Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('032-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606221830-202606230715.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>RmiCdZriyN80-4zoBaDb2A</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-18T14:30:33Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T05:00Z</start>
    <end>2026-06-23T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000088G</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 3</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000089E</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 3</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T05:00Z</start>
            <end>2026-06-23T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('033-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606230500-202606231500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>7PaxjSC6QxVRybl8rVzyBw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-18T14:31:40Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T05:00Z</start>
    <end>2026-06-23T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000086K</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000087I</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T05:00Z</start>
            <end>2026-06-23T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('034-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606230500-202606231500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Z2K6mbQC62JS7RUWxSIwWg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-18T14:33:55Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T05:00Z</start>
    <end>2026-06-23T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000080W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 7</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000081U</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 7</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T05:00Z</start>
            <end>2026-06-23T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('035-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606230500-202606231500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>YIFgkmLoyOpXT0BztFbNIA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-19T11:08:46Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T05:00Z</start>
    <end>2026-06-23T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000119V</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000019Z</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven 20</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">470.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T05:00Z</start>
            <end>2026-06-23T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>176</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('036-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606230500-202606231500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Zy8mEWOrP4NC3_t7j55awg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-19T11:09:34Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T05:00Z</start>
    <end>2026-06-23T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000119V</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000180</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven 10</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">470.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T05:00Z</start>
            <end>2026-06-23T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('037-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606230500-202606231500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>MJ9RXYFm7FcgONGImu0NDA</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-21T05:50:55Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T05:00Z</start>
    <end>2026-06-23T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000075</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven A</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T05:00Z</start>
            <end>2026-06-23T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('038-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606230500-202606231500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>vtYZuXNEeW-OOKhjwOuAiA</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-21T05:51:15Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T05:00Z</start>
    <end>2026-06-23T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T05:00Z</start>
            <end>2026-06-23T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>224</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('039-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606230500-202606231500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>G_yJ6pZv_Nil22yPXSYIIw</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-21T07:00:37Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T05:00Z</start>
    <end>2026-06-23T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000075</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven A</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T05:00Z</start>
            <end>2026-06-23T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>224</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('040-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606230500-202606231500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>vIAhRno_98BzTYgAmklbbg</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-22T13:58:44Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T05:00Z</start>
    <end>2026-06-23T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T05:00Z</start>
            <end>2026-06-23T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('041-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606230500-202606231500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>f148fFGJvwpWLVHVPHoqew</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-22T14:24:51Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T05:00Z</start>
    <end>2026-06-23T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000075</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven A</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T05:00Z</start>
            <end>2026-06-23T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>224</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('042-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606230500-202606231500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>rQThGfrJrMZWs6i2uQ_8aA</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-23T10:10:39Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T05:00Z</start>
    <end>2026-06-23T15:45Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:45:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000082S</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 6</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000083Q</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 6</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T05:00Z</start>
            <end>2026-06-23T15:45Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('043-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606230500-202606231545.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>c2bcWjQpfBu4oGcwpeJJ5A</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-22T14:34:39Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T05:15Z</start>
    <end>2026-06-23T18:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:15:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>18:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000074R</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>FLEVO 5</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000075P</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>FLEVO 5</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">464.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T05:15Z</start>
            <end>2026-06-23T18:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>452</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('044-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606230515-202606231800.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>1RAncEs_jOuRK5DEAn0_XQ</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-23T13:13:41Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T07:30Z</start>
    <end>2026-06-23T13:10Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>07:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>13:10:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000002051</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>BESS Maxima</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>Netherlands</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B20</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000207Y</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>BESS Maxima</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">35.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T07:30Z</start>
            <end>2026-06-23T13:10Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>27</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('045-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606230730-202606231310.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>N6KokBHaSJHSVtZAkq05FQ</mRID>
  <revisionNumber>4</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-23T15:01:40Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T14:58Z</start>
    <end>2026-06-23T17:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>14:58:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>17:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000002051</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>BESS Maxima</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>Netherlands</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B20</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000207Y</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>BESS Maxima</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">35.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T14:58Z</start>
            <end>2026-06-23T17:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>27</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('046-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606231458-202606231700.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>sf8Aa8jqujIh48SjPyoHaw</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-23T15:01:58Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T17:00Z</start>
    <end>2026-06-23T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>17:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000002051</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>BESS Maxima</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>Netherlands</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B20</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000207Y</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>BESS Maxima</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">35.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T17:00Z</start>
            <end>2026-06-23T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>31</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('047-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606231700-202606232200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>m0J5U_8hkpEAO0K5NUICfw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-18T14:34:34Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-24T05:00Z</start>
    <end>2026-06-24T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-24</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000088G</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 3</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000089E</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 3</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-24T05:00Z</start>
            <end>2026-06-24T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('048-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606240500-202606241500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>xk-jM5sOXK2vUOmN5ho3pg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-18T14:34:53Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-24T05:00Z</start>
    <end>2026-06-24T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-24</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000086K</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000087I</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-24T05:00Z</start>
            <end>2026-06-24T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('049-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606240500-202606241500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>-LPEC0l_tQ1PMVmq7oMPQA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-18T14:36:59Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-24T05:00Z</start>
    <end>2026-06-24T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-24</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000080W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 7</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000081U</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 7</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-24T05:00Z</start>
            <end>2026-06-24T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('050-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606240500-202606241500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>nk1H1owQPRijCvoAc-bnYA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-19T11:09:00Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-24T05:00Z</start>
    <end>2026-06-24T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-24</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000119V</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000019Z</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven 20</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">470.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-24T05:00Z</start>
            <end>2026-06-24T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>176</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('051-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606240500-202606241500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>9ht8XkXQT6Q_2Fy0qX4kKg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-19T11:10:41Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-24T05:00Z</start>
    <end>2026-06-24T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-24</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000119V</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000180</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven 10</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">470.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-24T05:00Z</start>
            <end>2026-06-24T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('052-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606240500-202606241500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>glLvHVYCSKlYAM4q0Jkmqg</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-21T05:51:15Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-24T05:00Z</start>
    <end>2026-06-24T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-24</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-24T05:00Z</start>
            <end>2026-06-24T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>224</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('053-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606240500-202606241500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>K1vr0d1Y2mNxnAHfCibJPg</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-21T05:51:16Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-24T05:00Z</start>
    <end>2026-06-24T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-24</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000075</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven A</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-24T05:00Z</start>
            <end>2026-06-24T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('054-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606240500-202606241500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>G_4Zo8t4b9GJnSnEuMEg8w</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-22T13:58:58Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-24T05:00Z</start>
    <end>2026-06-24T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-24</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-24T05:00Z</start>
            <end>2026-06-24T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('055-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606240500-202606241500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>HvSt8KuLvpoBmoD-IA8Hog</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-22T14:25:27Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-24T05:00Z</start>
    <end>2026-06-24T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-24</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000075</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven A</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-24T05:00Z</start>
            <end>2026-06-24T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>224</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('056-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606240500-202606241500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>qtSLMCEWLVrEqb5qWJAJ0Q</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-23T16:08:37Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-24T05:00Z</start>
    <end>2026-06-24T15:45Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-24</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:45:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000082S</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 6</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000083Q</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 6</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-24T05:00Z</start>
            <end>2026-06-24T15:45Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('057-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606240500-202606241545.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>A_vFnX6dmNZWA7G2XHZZag</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-22T14:43:36Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-24T05:15Z</start>
    <end>2026-06-24T18:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-24</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:15:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>18:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000072V</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>FLEVO 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000073T</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>FLEVO 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">443.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-24T05:15Z</start>
            <end>2026-06-24T18:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>422</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('058-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606240515-202606241800.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>eHrzs902PhfmfRJ-KHGJ5g</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-24T12:56:40Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-24T05:15Z</start>
    <end>2026-06-24T18:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-24</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:15:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>18:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000074R</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>FLEVO 5</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000075P</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>FLEVO 5</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">464.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-24T05:15Z</start>
            <end>2026-06-24T18:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>423</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('059-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606240515-202606241800.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>BusvMOWFw6mYKXZY86gATA</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-25T20:58:25Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-25T01:00Z</start>
    <end>2026-06-26T09:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-25</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>01:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-26</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>09:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000075</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven A</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-25T01:00Z</start>
            <end>2026-06-26T09:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('060-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606250100-202606260900.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>EwacQ82p-ZcQONzr4e_d7A</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-24T13:00:39Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-25T05:15Z</start>
    <end>2026-06-25T18:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-25</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:15:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-25</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>18:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000072V</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>FLEVO 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000073T</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>FLEVO 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">443.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-25T05:15Z</start>
            <end>2026-06-25T18:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>403</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('061-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606250515-202606251800.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>fpu6xY--5oB2UlH78nWAGg</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-25T14:02:19Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-25T12:00Z</start>
    <end>2026-06-25T15:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-25</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>12:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-25</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000046W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Velsen</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000021B</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>IJmond</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">144.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-25T12:00Z</start>
            <end>2026-06-25T15:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('062-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606251200-202606251530.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>NCikPZztzQWfaRrnxYtCsA</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-02T08:02:22Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-27T00:00Z</start>
    <end>2026-07-10T00:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-27</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>00:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-10</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>00:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000054X</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele 30</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B14</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000055V</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Borssele 30</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">485.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-27T00:00Z</start>
            <end>2026-07-10T00:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('063-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606270000-202607100000.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>jUeX5d7d88LfhF5NhU1NXA</mRID>
  <revisionNumber>12</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T19:16:17Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-27T04:00Z</start>
    <end>2026-06-30T20:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-27</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>04:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>20:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000046W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Velsen</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000021B</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>IJmond</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">144.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-27T04:00Z</start>
            <end>2026-06-30T20:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('064-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606270400-202606302000.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>_m5j3RxMzn3EJgY7oD4a6Q</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-26T12:00:10Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-27T05:15Z</start>
    <end>2026-06-27T06:45Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-27</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:15:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-27</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>06:45:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-27T05:15Z</start>
            <end>2026-06-27T06:45Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>630</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('065-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606270515-202606270645.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Vh6r2l1oDafJjDTuYZAeLg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-27T08:49:45Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-27T10:00Z</start>
    <end>2026-06-27T18:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-27</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>10:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-27</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>18:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000090T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Merwedekanaal 12</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000261</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Merwedekanaal 12</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">224.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-27T10:00Z</start>
            <end>2026-06-27T18:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('066-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606271000-202606271800.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>FSADHr7NzuTOBi42fdwS6Q</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-29T07:07:01Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-29T10:00Z</start>
    <end>2026-06-29T14:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-29</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>10:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-29</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-29T10:00Z</start>
            <end>2026-06-29T14:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>40</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
            <text>Other</text>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('067-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606291000-202606291400.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>utiTzwZ1-6-lyElxcxT6ZQ</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-29T07:28:10Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-29T10:00Z</start>
    <end>2026-06-29T14:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-29</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>10:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-29</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000075</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven A</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-29T10:00Z</start>
            <end>2026-06-29T14:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>40</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
            <text>Other</text>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('068-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606291000-202606291400.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>f-CEDJmwJxwpnfXdrJa2Mg</mRID>
  <revisionNumber>5</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-29T15:09:13Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-29T12:45Z</start>
    <end>2026-06-29T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-29</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>12:45:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-29</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000000431</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Diemen</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000164</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Diemen 33</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">249.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-29T12:45Z</start>
            <end>2026-06-29T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('069-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606291245-202606291500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>xYnqSLZBSm_qiydH_Nv3Mw</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-29T16:23:14Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-29T15:45Z</start>
    <end>2026-06-29T18:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-29</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>15:45:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-29</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>18:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000000431</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Diemen</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000164</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Diemen 33</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">249.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-29T15:45Z</start>
            <end>2026-06-29T18:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('070-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606291545-202606291800.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Xe1KJXdNOi99co5lmQr-yQ</mRID>
  <revisionNumber>4</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T10:19:16Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T07:15Z</start>
    <end>2026-06-30T10:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>07:15:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>10:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000000431</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Diemen</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000164</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Diemen 33</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">249.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T07:15Z</start>
            <end>2026-06-30T10:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('071-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606300715-202606301000.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>u3fEFmtLHOzvQaBKi1T97A</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-29T07:28:10Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T10:00Z</start>
    <end>2026-06-30T14:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>10:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T10:00Z</start>
            <end>2026-06-30T14:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>40</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
            <text>Other</text>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('072-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606301000-202606301400.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>EDAX_XY19dkuMKlBJjlOQg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-23T09:58:40Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T10:00Z</start>
    <end>2026-06-30T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>10:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000002051</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>BESS Maxima</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>Netherlands</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B20</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000207Y</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>BESS Maxima</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">35.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T10:00Z</start>
            <end>2026-06-30T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('073-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606301000-202606301500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>DngIZFhBvNjBRqrN7zs-cA</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T22:15:54Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T20:30Z</start>
    <end>2026-06-30T22:10Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>20:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:10:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T20:30Z</start>
            <end>2026-06-30T22:10Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>540</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('074-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606302030-202606302210.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>LvlK6fPZzVCB67lKzZzAuw</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T22:15:54Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T20:30Z</start>
    <end>2026-06-30T22:10Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>20:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:10:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000075</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven A</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T20:30Z</start>
            <end>2026-06-30T22:10Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>540</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('075-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606302030-202606302210.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>hmhY2FZx0X9gxEfMRAYuVQ</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-15T14:22:07Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T22:00Z</start>
    <end>2026-07-09T21:59Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>22:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-09</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:59:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000001128</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Rijnmond 1</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000001144</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>REC-B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">250.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T22:00Z</start>
            <end>2026-07-09T21:59Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('076-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606302200-202607092159.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>AI4_LR15T8DlpJHDRb0D9A</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-15T14:23:00Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T22:00Z</start>
    <end>2026-07-09T21:59Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>22:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-09</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:59:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000001128</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Rijnmond 1</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000001152</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>REC-X</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">250.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T22:00Z</start>
            <end>2026-07-09T21:59Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('077-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606302200-202607092159.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>VEjI8sECmjHyPYJ0Da72_w</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-15T14:23:41Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T22:00Z</start>
    <end>2026-07-09T21:59Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>22:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-09</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:59:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000001128</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Rijnmond 1</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000001136</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>REC-A</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">250.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T22:00Z</start>
            <end>2026-07-09T21:59Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('078-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606302200-202607092159.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Yxr59Pnv1ovHoaWvbB_2Tg</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T09:33:20Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-01T10:00Z</start>
    <end>2026-07-01T13:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-01</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>10:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-01</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>13:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000075</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven A</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-01T10:00Z</start>
            <end>2026-07-01T13:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>690</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('079-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607011000-202607011300.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>ucMFDafv6-fcKVSShRpbWw</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-29T07:28:10Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-01T10:00Z</start>
    <end>2026-07-01T14:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-01</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>10:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-01</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-01T10:00Z</start>
            <end>2026-07-01T14:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>40</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
            <text>Other</text>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('080-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607011000-202607011400.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>YLRy5Vpg2pWYCfolUCFvZw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T07:43:09Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-01T10:00Z</start>
    <end>2026-07-01T14:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-01</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>10:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-01</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-01T10:00Z</start>
            <end>2026-07-01T14:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>550</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
            <text>Other</text>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('081-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607011000-202607011400.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>-t4xE0XTXaZNMNj_6pqAlA</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-02T11:20:20Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-01T13:00Z</start>
    <end>2026-09-30T21:59Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-01</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>13:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-09-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:59:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000096H</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 20</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000097F</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 20</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">131.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-01T13:00Z</start>
            <end>2026-09-30T21:59Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>125</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('082-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607011300-202609302159.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>K9GittTXxl1Aaiy1ezJVUA</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-02T07:55:29Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-01T14:30Z</start>
    <end>2026-07-02T07:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-01</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>14:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-02</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>07:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000000342</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Den Haag</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000342</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>EDH</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">112.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-01T14:30Z</start>
            <end>2026-07-02T07:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('083-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607011430-202607020730.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>huuUgU_cqY7X_oqg8DzYzg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T14:12:39Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-01T21:30Z</start>
    <end>2026-07-02T04:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-01</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>21:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-02</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>04:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000080W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 7</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000081U</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 7</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-01T21:30Z</start>
            <end>2026-07-02T04:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>300</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('084-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607012130-202607020430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>_iEYzqLCPrUQvJRRRkru9Q</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T13:51:40Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-02T09:00Z</start>
    <end>2026-07-02T12:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-02</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>09:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-02</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>12:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000088G</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 3</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000089E</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 3</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-02T09:00Z</start>
            <end>2026-07-02T12:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('085-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607020900-202607021200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>4MbZHI_f4-fhg8c678W3uA</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-02T11:18:40Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-02T12:00Z</start>
    <end>2026-07-02T14:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-02</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>12:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-02</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000096H</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 20</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000097F</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 20</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">131.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-02T12:00Z</start>
            <end>2026-07-02T14:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('086-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607021200-202607021400.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>bsfLb_4NOeCt7CjVlEaDBg</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-02T11:19:18Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-02T14:00Z</start>
    <end>2026-09-30T21:59Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-02</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>14:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-09-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:59:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000096H</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 20</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000097F</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 20</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">131.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-02T14:00Z</start>
            <end>2026-09-30T21:59Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>125</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('087-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607021400-202609302159.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>9a_zK589EvmOgfOr59GI8A</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-04T05:54:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-13T05:30Z</start>
    <end>2026-07-16T14:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-13</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-16</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000000342</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Den Haag</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000342</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>EDH</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">112.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-13T05:30Z</start>
            <end>2026-07-16T14:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('088-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607130530-202607161400.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>hlRU1N7KJrmOs8XKY5rPRQ</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-10T06:09:36Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-21T06:00Z</start>
    <end>2026-09-14T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-21</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-09-14</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000000342</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Den Haag</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000342</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>EDH</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">112.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-21T06:00Z</start>
            <end>2026-09-14T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('089-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607210600-202609141600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>9uiSLe6vB8fTPSP913pC2w</mRID>
  <revisionNumber>5</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-03T15:12:04Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-08-24T23:00Z</start>
    <end>2026-10-19T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-08-24</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-10-19</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000088G</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 3</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000089E</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 3</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-08-24T23:00Z</start>
            <end>2026-10-19T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('090-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202608242300-202610192200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>wGoagj_h4rGmOxwS-rgCIQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-15T14:46:03Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-08-28T22:00Z</start>
    <end>2026-09-20T21:59Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-08-28</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>22:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-09-20</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:59:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000001128</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Rijnmond 1</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000001136</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>REC-A</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">250.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-08-28T22:00Z</start>
            <end>2026-09-20T21:59Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('091-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202608282200-202609202159.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>l9srulzQeORZ2xGQTtA7WA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-15T14:48:09Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-08-28T22:00Z</start>
    <end>2026-09-20T21:59Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-08-28</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>22:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-09-20</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:59:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000001128</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Rijnmond 1</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000001144</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>REC-B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">250.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-08-28T22:00Z</start>
            <end>2026-09-20T21:59Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('092-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202608282200-202609202159.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>qh97PRcvnrzEExLEbSOe_Q</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-15T14:50:05Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-08-28T22:00Z</start>
    <end>2026-09-20T21:59Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-08-28</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>22:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-09-20</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:59:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000001128</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Rijnmond 1</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000001152</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>REC-X</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">250.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-08-28T22:00Z</start>
            <end>2026-09-20T21:59Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('093-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202608282200-202609202159.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>6HhqnvRIxXJ0ZbQFy79nKQ</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-03T15:12:39Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-09-04T23:00Z</start>
    <end>2026-09-06T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-09-04</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-09-06</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000086K</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000087I</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-09-04T23:00Z</start>
            <end>2026-09-06T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('094-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202609042300-202609062200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>_ZoYneb3e75L0cgMdlY1Jw</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-03T15:13:14Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-09-11T23:00Z</start>
    <end>2026-09-15T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-09-11</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-09-15</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000072V</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>FLEVO 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000073T</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>FLEVO 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">443.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-09-11T23:00Z</start>
            <end>2026-09-15T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('095-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202609112300-202609152200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>8F-6XWp7euTZVSh-Qa8vCQ</mRID>
  <revisionNumber>4</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-10T10:06:56Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-09-13T20:00Z</start>
    <end>2026-09-26T04:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-09-13</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>20:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-09-26</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>04:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000070Z</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Amer</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B01</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000002F</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Amer 9</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">631.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-09-13T20:00Z</start>
            <end>2026-09-26T04:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('096-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202609132000-202609260400.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>0ZYmjosd0GbIiWTpZsVVnw</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-03T15:13:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-09-25T23:00Z</start>
    <end>2026-09-27T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-09-25</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-09-27</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000084O</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 5</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000085M</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 5</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-09-25T23:00Z</start>
            <end>2026-09-27T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('097-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202609252300-202609272200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>TBBKrvGdgdY1EW_dpU1axg</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-03T15:13:56Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-09-25T23:00Z</start>
    <end>2026-09-29T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-09-25</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-09-29</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000074R</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>FLEVO 5</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000075P</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>FLEVO 5</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">464.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-09-25T23:00Z</start>
            <end>2026-09-29T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('098-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202609252300-202609292200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>kEOXWSX4a1D2sK7r72INOQ</mRID>
  <revisionNumber>5</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-03T15:14:29Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-10-09T23:00Z</start>
    <end>2026-12-13T23:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-10-09</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-12-13</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>23:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000082S</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 6</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000083Q</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 6</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-10-09T23:00Z</start>
            <end>2026-12-13T23:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('099-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202610092300-202612132300.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>AbLAogUznM2XBfFQGxi35g</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-11T11:54:45Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-10-23T22:00Z</start>
    <end>2026-10-30T23:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-10-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>22:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-10-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>23:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000072V</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>FLEVO 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000073T</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>FLEVO 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">443.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-10-23T22:00Z</start>
            <end>2026-10-30T23:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('100-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202610232200-202610302300.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>K2owy7y8AQdZW6V_N4Idzw</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-03T15:15:14Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-10-31T00:00Z</start>
    <end>2026-11-01T23:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-10-31</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>00:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-11-01</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>23:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000080W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 7</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000081U</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 7</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-10-31T00:00Z</start>
            <end>2026-11-01T23:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('101-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202610310000-202611012300.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>ENU5nsgrPbH8n114MMduTA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-03T15:16:17Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-11-14T00:00Z</start>
    <end>2026-11-15T23:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-11-14</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>00:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-11-15</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>23:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000086K</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000087I</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-11-14T00:00Z</start>
            <end>2026-11-15T23:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('102-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202611140000-202611152300.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>xz9WCSkHlx9Od-Xj7fpoGQ</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-03T15:16:51Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-11-21T00:00Z</start>
    <end>2026-11-22T23:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-11-21</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>00:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-11-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>23:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000072V</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>FLEVO 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000073T</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>FLEVO 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">443.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-11-21T00:00Z</start>
            <end>2026-11-22T23:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('103-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202611210000-202611222300.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>5DQ2WThQ6Awtx63IVM6kuQ</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-03T15:17:41Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-12-12T00:00Z</start>
    <end>2026-12-13T23:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-12-12</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>00:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-12-13</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>23:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000074R</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>FLEVO 5</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000075P</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>FLEVO 5</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">464.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-12-12T00:00Z</start>
            <end>2026-12-13T23:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('104-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202612120000-202612132300.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>do5XG_UdqgETbWkI33KOyA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T07:11:40Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-01-16T00:00Z</start>
    <end>2027-01-17T23:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-01-16</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>00:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-01-17</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>23:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000086K</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000087I</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-01-16T00:00Z</start>
            <end>2027-01-17T23:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('105-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202701160000-202701172300.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>84aW_8vFBXXouw3Q5xw5iw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T07:15:24Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-01-23T00:00Z</start>
    <end>2027-01-24T23:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-01-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>00:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-01-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>23:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000084O</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 5</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000085M</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 5</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-01-23T00:00Z</start>
            <end>2027-01-24T23:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('106-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202701230000-202701242300.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>15YREJHe9KqPfF9wPqvemA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T07:14:20Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-01-30T00:00Z</start>
    <end>2027-01-31T23:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-01-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>00:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-01-31</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>23:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000088G</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 3</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000089E</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 3</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-01-30T00:00Z</start>
            <end>2027-01-31T23:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('107-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202701300000-202701312300.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>revZ20EtZ1t2zDGkENTldg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T07:12:44Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-02-06T00:00Z</start>
    <end>2027-02-07T23:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-02-06</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>00:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-02-07</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>23:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000082S</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 6</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000083Q</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 6</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-02-06T00:00Z</start>
            <end>2027-02-07T23:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('108-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202702060000-202702072300.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>oAE_5ifMKDXAVFMtavIWLg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-05-29T10:24:39Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-03-12T23:15Z</start>
    <end>2027-03-18T22:59Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-03-12</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:15:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-03-18</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:59:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000000512</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Sloe Centrale 10</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000415</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Unit 10</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">435.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-03-12T23:15Z</start>
            <end>2027-03-18T22:59Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('109-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202703122315-202703182259.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>0g1-o6AHRPZ01GeRaJkaUQ</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-02T14:40:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-04-02T23:00Z</start>
    <end>2027-04-18T21:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-04-02</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-04-18</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000074R</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>FLEVO 5</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000075P</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>FLEVO 5</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">464.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-04-02T23:00Z</start>
            <end>2027-04-18T21:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('110-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202704022300-202704182100.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>1Y4-FnmpU3pKcAnITi-ZFw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T07:15:39Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-04-09T23:00Z</start>
    <end>2027-04-11T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-04-09</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-04-11</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000084O</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 5</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000085M</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 5</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-04-09T23:00Z</start>
            <end>2027-04-11T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('111-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202704092300-202704112200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>TJ5zAJFDE9IN1GAbufto5A</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T07:16:23Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-04-30T23:00Z</start>
    <end>2027-05-02T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-04-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-05-02</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000080W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 7</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000081U</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 7</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-04-30T23:00Z</start>
            <end>2027-05-02T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('112-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202704302300-202705022200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>uq2I0A0QG9QKokA5ry55yg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-10T07:03:26Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-05-14T16:00Z</start>
    <end>2027-07-11T21:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-05-14</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>16:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-07-11</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000054X</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele 30</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B14</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000055V</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Borssele 30</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">485.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-05-14T16:00Z</start>
            <end>2027-07-11T21:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('113-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202705141600-202707112100.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>dtxuI3UQNJ_1R4lT6aB9FA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T07:11:01Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-05-14T23:00Z</start>
    <end>2027-05-16T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-05-14</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-05-16</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000088G</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 3</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000089E</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 3</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-05-14T23:00Z</start>
            <end>2027-05-16T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('114-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202705142300-202705162200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>MCs74ZO53kmKaC7AzkCY3g</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T07:15:59Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-05-21T23:00Z</start>
    <end>2027-05-23T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-05-21</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-05-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000082S</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 6</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000083Q</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 6</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-05-21T23:00Z</start>
            <end>2027-05-23T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('115-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202705212300-202705232200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>kbeloiCQVKjh9p9VDNUdLg</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-02T14:39:41Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-05-25T23:00Z</start>
    <end>2027-06-24T21:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-05-25</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-06-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000074R</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>FLEVO 5</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000075P</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>FLEVO 5</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">464.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-05-25T23:00Z</start>
            <end>2027-06-24T21:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('116-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202705252300-202706242100.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>B6RU6QNkkRBkdpGyp3MVtA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-02T14:40:54Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-06-04T23:00Z</start>
    <end>2027-06-20T21:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-06-04</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-06-20</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000072V</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>FLEVO 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000073T</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>FLEVO 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">443.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-06-04T23:00Z</start>
            <end>2027-06-20T21:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('117-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202706042300-202706202100.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>hpTgcN8WVm5vk7pkidG6ng</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T07:13:19Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-07-09T23:00Z</start>
    <end>2027-07-11T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-07-09</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-07-11</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000084O</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 5</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000085M</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 5</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-07-09T23:00Z</start>
            <end>2027-07-11T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('118-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202707092300-202707112200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>5DCYEJ0oogkXnFSqTSg65A</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T07:10:42Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-07-23T23:00Z</start>
    <end>2027-07-25T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-07-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-07-25</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000080W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 7</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000081U</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 7</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-07-23T23:00Z</start>
            <end>2027-07-25T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('119-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202707232300-202707252200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>xVBWqZRdi_kmyp1kxaMAnw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T07:13:39Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-08-13T23:00Z</start>
    <end>2027-08-15T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-08-13</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-08-15</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000088G</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 3</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000089E</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 3</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-08-13T23:00Z</start>
            <end>2027-08-15T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('120-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202708132300-202708152200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>5Lai_UcBKxbJJchZbZt1LQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T07:14:39Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-08-27T23:00Z</start>
    <end>2027-08-29T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-08-27</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-08-29</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000086K</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000087I</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-08-27T23:00Z</start>
            <end>2027-08-29T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('121-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202708272300-202708292200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>70zyAJ44wQUVJJi76anuCw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T07:12:59Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-09-10T23:00Z</start>
    <end>2027-09-12T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-09-10</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-09-12</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000082S</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 6</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000083Q</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 6</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-09-10T23:00Z</start>
            <end>2027-09-12T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('122-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202709102300-202709122200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>jwQGpHDHjUtgsW7Amm4cNw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T07:13:58Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-11-06T00:00Z</start>
    <end>2027-11-07T23:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-11-06</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>00:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-11-07</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>23:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000080W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 7</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000081U</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 7</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-11-06T00:00Z</start>
            <end>2027-11-07T23:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('123-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202711060000-202711072300.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>JJZH6irjrOFmgZxjToYiMw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T07:14:59Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2027-11-27T00:00Z</start>
    <end>2027-11-28T23:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2027-11-27</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>00:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-11-28</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>23:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000086K</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000087I</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2027-11-27T00:00Z</start>
            <end>2027-11-28T23:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('124-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202711270000-202711282300.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>TWX5NK5TS_XO_TH3ISGzSA</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-11T15:59:16Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2028-03-03T22:00Z</start>
    <end>2028-03-26T21:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2028-03-03</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>22:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2028-03-26</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000045Y</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hemweg</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000039T</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Hemweg 9</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">440.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2028-03-03T22:00Z</start>
            <end>2028-03-26T21:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('125-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202803032200-202803262100.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Ao28BtOYyyKhjnjJBl1bdw</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-11T15:47:16Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2028-03-31T21:00Z</start>
    <end>2028-04-23T21:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2028-03-31</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>21:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2028-04-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000000431</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Diemen</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000164</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Diemen 33</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">249.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2028-03-31T21:00Z</start>
            <end>2028-04-23T21:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('126-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202803312100-202804232100.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>8yejAiJIZh0SOkJqEt9K-g</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-16T06:46:29Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2028-04-30T22:00Z</start>
    <end>2028-06-11T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2028-04-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>22:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2028-06-11</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000102B</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Maasvlakte</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000326</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Maasvlakte 3</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1070.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2028-04-30T22:00Z</start>
            <end>2028-06-11T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('127-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202804302200-202806112200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>5aqwzEzoXJpEHZXqD4QiGA</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-25T12:42:40Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2028-05-26T23:00Z</start>
    <end>2028-06-11T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2028-05-26</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2028-06-11</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000086K</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000087I</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2028-05-26T23:00Z</start>
            <end>2028-06-11T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('128-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202805262300-202806112200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>e4V6LQxYRtGT294rAZSHuQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-11T15:59:16Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2028-06-30T21:00Z</start>
    <end>2028-07-23T21:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2028-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>21:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2028-07-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000045Y</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hemweg</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000039T</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Hemweg 9</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">440.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2028-06-30T21:00Z</start>
            <end>2028-07-23T21:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('129-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202806302100-202807232100.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>GhHsizI70DWsz7F-hCFHeg</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-25T12:42:59Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2029-02-10T00:00Z</start>
    <end>2029-04-08T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2029-02-10</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>00:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2029-04-08</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000086K</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000087I</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2029-02-10T00:00Z</start>
            <end>2029-04-08T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('130-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202902100000-202904082200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>wKWJC-1S1VuEm4EGOb3G4A</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-02T07:20:09Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2030-01-26T00:00Z</start>
    <end>2030-02-10T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2030-01-26</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>00:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2030-02-10</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000080W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 7</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000081U</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 7</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2030-01-26T00:00Z</start>
            <end>2030-02-10T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('131-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_203001260000-203002102200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>XdZvcfbipLxfvrB6yY_4Jw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-02T07:21:27Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2030-02-23T00:00Z</start>
    <end>2030-04-07T21:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2030-02-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>00:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2030-04-07</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000082S</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 6</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000083Q</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 6</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2030-02-23T00:00Z</start>
            <end>2030-04-07T21:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('132-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_203002230000-203004072100.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Ie4P37XqLzSPWhpor3iAkQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-02T07:21:30Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2030-04-19T23:00Z</start>
    <end>2030-05-19T21:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2030-04-19</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2030-05-19</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000086K</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000087I</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2030-04-19T23:00Z</start>
            <end>2030-05-19T21:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('133-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_203004192300-203005192100.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>w6Tm5SUvtJapgenl-GCarg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-02T07:22:26Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2030-05-31T23:00Z</start>
    <end>2030-06-16T21:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2030-05-31</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2030-06-16</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000084O</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 5</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000085M</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 5</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2030-05-31T23:00Z</start>
            <end>2030-06-16T21:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('134-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_203005312300-203006162100.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>g0VOEdKokOT4IqD6he2bGA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-02T07:21:51Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2030-08-30T23:00Z</start>
    <end>2030-10-13T21:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2030-08-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2030-10-13</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000088G</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 3</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000089E</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 3</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2030-08-30T23:00Z</start>
            <end>2030-10-13T21:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('135-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_203008302300-203010132100.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>igVLEHooqOYV5InKl_IAJw</mRID>
  <revisionNumber>8</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-18T15:49:53Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-05-26T16:30Z</start>
    <end>2026-06-30T21:59Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-05-26</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>16:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:59:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000001128</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Rijnmond 1</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000001144</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>REC-B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">250.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-05-26T16:30Z</start>
            <end>2026-06-30T21:59Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('136-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202605261630-202606302159.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>hrr8XAl2_k3ffZDgWqsbBQ</mRID>
  <revisionNumber>4</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-18T15:50:04Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-12T22:10Z</start>
    <end>2026-06-30T21:59Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-12</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>22:10:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:59:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000001128</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Rijnmond 1</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000001152</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>REC-X</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">250.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-12T22:10Z</start>
            <end>2026-06-30T21:59Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
              <Point>
                <position>166</position>
                <quantity>125</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('137-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606122210-202606302159.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>oNgLg1ovEKeD8hSMUq4nWA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-20T23:09:32Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-20T23:00Z</start>
    <end>2026-06-20T23:05Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-20</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-20</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>23:05:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000074R</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>FLEVO 5</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000075P</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>FLEVO 5</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">464.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-20T23:00Z</start>
            <end>2026-06-20T23:05Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>280</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('138-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606202300-202606202305.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>eIUELRttBfpbYdXpVjOi2A</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-21T03:46:40Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-21T03:45Z</start>
    <end>2026-06-21T04:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-21</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>03:45:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-21</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>04:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000074R</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>FLEVO 5</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000075P</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>FLEVO 5</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">464.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-21T03:45Z</start>
            <end>2026-06-21T04:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>280</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('139-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606210345-202606210430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>PT6uPXdoyn5BbcyzkItPcQ</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-22T15:34:39Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-22T15:25Z</start>
    <end>2026-06-22T15:32Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-22</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>15:25:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:32:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000088G</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 3</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000089E</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 3</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-22T15:25Z</start>
            <end>2026-06-22T15:32Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('140-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606221525-202606221532.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>3IjRnc01Tr9asIAH26k47g</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-23T15:00:40Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T13:10Z</start>
    <end>2026-06-23T14:58Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>13:10:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:58:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000002051</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>BESS Maxima</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>Netherlands</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B20</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000207Y</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>BESS Maxima</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">35.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T13:10Z</start>
            <end>2026-06-23T14:58Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('141-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606231310-202606231458.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>RaqF1FkxOn4yWud1o9ptcw</mRID>
  <revisionNumber>5</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T06:58:45Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T16:15Z</start>
    <end>2026-07-01T06:45Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>16:15:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-01</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>06:45:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000000342</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Den Haag</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000342</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>EDH</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">112.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T16:15Z</start>
            <end>2026-07-01T06:45Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('142-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606231615-202607010645.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>vSWtom-xpyxu50TITll1ig</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-24T12:28:06Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-24T09:45Z</start>
    <end>2026-06-24T12:15Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-24</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>09:45:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>12:15:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000000431</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Diemen</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000172</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Diemen 34</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">435.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-24T09:45Z</start>
            <end>2026-06-24T12:15Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('143-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606240945-202606241215.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>h8-IKd8__f-SS0-0rtXClA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-24T23:35:14Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-24T23:27Z</start>
    <end>2026-06-25T00:27Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-24</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:27:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-25</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>00:27:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-24T23:27Z</start>
            <end>2026-06-25T00:27Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>640</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('144-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606242327-202606250027.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>0nGR8OxrD5LUlPSpOodFiA</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-25T06:48:04Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-25T04:46Z</start>
    <end>2026-06-25T08:41Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-25</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>04:46:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-25</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>08:41:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-25T04:46Z</start>
            <end>2026-06-25T08:41Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>590</quantity>
              </Point>
              <Point>
                <position>116</position>
                <quantity>560</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('145-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606250446-202606250841.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>R9yjD_CsVWfUTqOUO6Hmbg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-25T14:50:39Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-25T14:44Z</start>
    <end>2026-06-25T15:44Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-25</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>14:44:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-25</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:44:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-25T14:44Z</start>
            <end>2026-06-25T15:44Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>600</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('146-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606251444-202606251544.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>O6uz-sv7OxeW5Nrc5gik2w</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-25T15:30:19Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-25T15:24Z</start>
    <end>2026-06-25T16:15Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-25</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>15:24:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-25</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:15:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000080W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 7</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000081U</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 7</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-25T15:24Z</start>
            <end>2026-06-25T16:15Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('147-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606251524-202606251615.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Q0srrATV3KR0LIxAsnFkFA</mRID>
  <revisionNumber>4</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-27T01:48:53Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-26T22:53Z</start>
    <end>2026-06-27T02:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-26</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>22:53:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-27</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>02:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000075</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven A</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-26T22:53Z</start>
            <end>2026-06-27T02:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>630</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('148-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606262253-202606270200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>pFxl9kEEMeig0jcbOAC_jw</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-27T15:25:21Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-27T14:05Z</start>
    <end>2026-06-27T15:15Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-27</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>14:05:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-27</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:15:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000066Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven </production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B05</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000083</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven B</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">790.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-27T14:05Z</start>
            <end>2026-06-27T15:15Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>300</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('149-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606271405-202606271515.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>SMAPAXiYkzutSBGbtXYUew</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-27T15:39:39Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-27T15:36Z</start>
    <end>2026-06-27T16:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-27</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>15:36:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-27</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000002051</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>BESS Maxima</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>Netherlands</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B20</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000207Y</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>BESS Maxima</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">35.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-27T15:36Z</start>
            <end>2026-06-27T16:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>31</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('150-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606271536-202606271630.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>r3ns_c9z2ldYbEZv1nw-Qw</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-29T16:01:10Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-29T14:45Z</start>
    <end>2026-06-29T15:55Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-29</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>14:45:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-29</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:55:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000119V</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eemshaven</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000019Z</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eemshaven 20</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">470.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-29T14:45Z</start>
            <end>2026-06-29T15:55Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>292</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('151-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606291445-202606291555.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>NJMY2Kl8xK8SL-zr4cBxYQ</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T04:51:17Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T03:45Z</start>
    <end>2026-06-30T05:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>03:45:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>05:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000046W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Velsen</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000237</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Velsen 25</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">375.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T03:45Z</start>
            <end>2026-06-30T05:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>270</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('152-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606300345-202606300500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>xewamfCCxBJKXNNkqm9Tkg</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T06:29:41Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T03:45Z</start>
    <end>2026-06-30T07:15Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>03:45:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>07:15:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000000431</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Diemen</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W0000000000164</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Diemen 33</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">249.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T03:45Z</start>
            <end>2026-06-30T07:15Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>100</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('153-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606300345-202606300715.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>iYDqugLcyNTftmwit8fiAQ</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T08:08:19Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T07:48Z</start>
    <end>2026-06-30T08:04Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>07:48:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>08:04:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000088G</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 3</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000089E</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 3</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T07:48Z</start>
            <end>2026-06-30T08:04Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>140</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('154-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606300748-202606300804.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>pV2t2Jgb0M8uwr8bVpmRTw</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T08:07:41Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T07:49Z</start>
    <end>2026-06-30T08:04Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>07:49:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>08:04:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000086K</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 4</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000087I</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 4</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T07:49Z</start>
            <end>2026-06-30T08:04Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>140</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('155-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606300749-202606300804.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>UZYULz_f-MqhCUBvYOztJg</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T08:06:40Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T07:50Z</start>
    <end>2026-06-30T08:04Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>07:50:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>08:04:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000080W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 7</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000081U</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 7</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T07:50Z</start>
            <end>2026-06-30T08:04Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>140</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('156-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606300750-202606300804.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>-0jpjUodvkI71ZbJtE-1Yw</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T08:08:00Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T07:50Z</start>
    <end>2026-06-30T08:04Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>07:50:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>08:04:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000082S</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Eems 6</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>NL</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000083Q</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>Eems 6</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">360.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T07:50Z</start>
            <end>2026-06-30T08:04Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>140</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('157-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606300750-202606300804.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>LY97vh08u_zzGhseaFecVA</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A80</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T13:33:44Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T12:45Z</start>
    <end>2026-06-30T13:45Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>12:45:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>13:45:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000001047</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>RoCa</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
    <production_RegisteredResource.pSRType.powerSystemResources.mRID codingScheme="A01">49W000000000037X</production_RegisteredResource.pSRType.powerSystemResources.mRID>
    <production_RegisteredResource.pSRType.powerSystemResources.name>RoCa 3</production_RegisteredResource.pSRType.powerSystemResources.name>
    <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">220.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T12:45Z</start>
            <end>2026-06-30T13:45Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>108</quantity>
              </Point>
              <Point>
                <position>16</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>'));
    insert into tmp_sanilog (tekst, clobje) values ('158-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606301245-202606301345.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  commit;
  dbms_output.put_line('Inserted rows: ' || v_inserted);
end;
/

select count(*) as rows_loaded from tmp_sanilog;
select tekst, dbms_lob.getlength(clobje) as clob_len from tmp_sanilog order by regel;
