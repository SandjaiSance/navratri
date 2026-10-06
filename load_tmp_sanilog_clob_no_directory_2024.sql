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
  <mRID>hKdvMuuwGUioj0nBqQrylw</mRID>
  <revisionNumber>10</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-11T13:55:45Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2024-12-31T23:00Z</start>
    <end>2027-02-02T11:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2024-12-31</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>23:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2027-02-02</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>11:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W0000000000504</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>NAM Schoonebeek</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>Netherlands</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B04</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">128.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2024-12-31T23:00Z</start>
            <end>2027-02-02T11:00Z</end>
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
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('001-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202412312300-202702021100.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>FE9ch8tKK4gT7Dff20qIMQ</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-03T08:23:31Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-03T06:30Z</start>
    <end>2026-06-03T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-03</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-03</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-03T06:30Z</start>
            <end>2026-06-03T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1381</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('002-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606030630-202606031430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>8-WFqjuNF7IIr8Vj-7J_gw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-04T08:23:20Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-03T13:00Z</start>
    <end>2026-06-03T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-03</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>13:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-03</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-03T13:00Z</start>
            <end>2026-06-03T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>738</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('003-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606031300-202606031600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Cb0-I5xbanhNJNne6M20bg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-04T08:23:26Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-03T17:45Z</start>
    <end>2026-06-03T19:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-03</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>17:45:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-03</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>19:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-03T17:45Z</start>
            <end>2026-06-03T19:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>984</quantity>
              </Point>
              <Point>
                <position>31</position>
                <quantity>1074</quantity>
              </Point>
              <Point>
                <position>46</position>
                <quantity>988</quantity>
              </Point>
              <Point>
                <position>61</position>
                <quantity>1088</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('004-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606031745-202606031930.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>8y3EjZCaCpSCgt1PEL8qNA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-05T08:24:50Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-03T20:15Z</start>
    <end>2026-06-05T06:45Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-03</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>20:15:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-05</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>06:45:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-03T20:15Z</start>
            <end>2026-06-05T06:45Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1414</quantity>
              </Point>
              <Point>
                <position>16</position>
                <quantity>1408</quantity>
              </Point>
              <Point>
                <position>2056</position>
                <quantity>1361</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('005-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606032015-202606050645.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>tOIEpwZEWuUeX8S84Gr66w</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-05T08:23:36Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-03T20:15Z</start>
    <end>2026-06-05T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-03</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>20:15:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-05</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-03T20:15Z</start>
            <end>2026-06-05T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1414</quantity>
              </Point>
              <Point>
                <position>16</position>
                <quantity>1408</quantity>
              </Point>
              <Point>
                <position>2056</position>
                <quantity>1376</quantity>
              </Point>
              <Point>
                <position>2506</position>
                <quantity>1398</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('006-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606032015-202606051430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>2AVZ-we5WnwqRh_KmmoomQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-05T08:23:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-05T05:00Z</start>
    <end>2026-06-05T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-05</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-05</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000154T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele Windfarm III and IV</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.5</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-05T05:00Z</start>
            <end>2026-06-05T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>608</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('007-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606050500-202606051500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>KiJQFogaxVvBtezWDInxPA</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-06T08:23:34Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-05T11:30Z</start>
    <end>2026-06-05T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-05</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>11:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-05</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-05T11:30Z</start>
            <end>2026-06-05T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1375</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('008-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606051130-202606051430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>_vz8gBCOpt6r65e8TqAmkw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-04T18:17:34Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-06T06:30Z</start>
    <end>2026-06-06T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-06</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-06</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-06T06:30Z</start>
            <end>2026-06-06T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1404</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('009-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606060630-202606061430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>vJBwuQB2nE42j7z46iEVkQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-04T08:23:32Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-06T08:00Z</start>
    <end>2026-06-06T09:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-06</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>08:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-06</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>09:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000154T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele Windfarm III and IV</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.5</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-06T08:00Z</start>
            <end>2026-06-06T09:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>560.5</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('010-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606060800-202606060900.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>rrJ9M4zRRYIddVTcwCyrfg</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-06T20:06:57Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-07T06:30Z</start>
    <end>2026-06-07T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-07</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-07</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-07T06:30Z</start>
            <end>2026-06-07T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1414</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('011-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606070630-202606071430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>7uw41Z6f7Wn17tDxl_N_FA</mRID>
  <revisionNumber>4</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-12T08:23:36Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-08T04:00Z</start>
    <end>2026-06-11T15:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-08</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>04:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-11</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000184K</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>OWF Hollandse Kust Noord</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">760.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-08T04:00Z</start>
            <end>2026-06-11T15:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>380</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('012-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606080400-202606111530.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>s-It5F-uKMidzsZjhiqlmg</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-05T08:23:36Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-08T06:30Z</start>
    <end>2026-06-08T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-08</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-08</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-08T06:30Z</start>
            <end>2026-06-08T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1375</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('013-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606080630-202606081430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>DanPwm3TTMtfDuMIb-a85g</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-07T08:23:32Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-08T06:30Z</start>
    <end>2026-06-08T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-08</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-08</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000154T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele Windfarm III and IV</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.5</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-08T06:30Z</start>
            <end>2026-06-08T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>627</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('014-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606080630-202606081500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>2UMm3MITZ6bkwjlGjfpbDA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-09T08:23:48Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-09T05:30Z</start>
    <end>2026-06-09T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-09</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-09</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000154T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele Windfarm III and IV</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.5</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-09T05:30Z</start>
            <end>2026-06-09T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>617.5</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('015-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606090530-202606091500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>GsI_UWVVuXzaVmdUdyNdXA</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-10T08:23:46Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-09T06:30Z</start>
    <end>2026-06-09T13:15Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-09</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-09</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>13:15:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-09T06:30Z</start>
            <end>2026-06-09T13:15Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1376</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('016-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606090630-202606091315.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Evmrl2leKRarmKY6MtehpQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-10T08:23:56Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-10T05:30Z</start>
    <end>2026-06-10T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-10</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-10</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000154T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele Windfarm III and IV</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.5</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-10T05:30Z</start>
            <end>2026-06-10T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>627</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('017-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606100530-202606101430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>bHBv8gJT12NSUH8ROnkRlA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-05T08:23:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-10T06:30Z</start>
    <end>2026-06-10T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-10</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-10</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-10T06:30Z</start>
            <end>2026-06-10T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1375</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('018-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606100630-202606101430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>2oGou2foV-vlxDvYDDCkLw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-05T08:23:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-11T06:30Z</start>
    <end>2026-06-11T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-11</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-11</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-11T06:30Z</start>
            <end>2026-06-11T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1375</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('019-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606110630-202606111430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>THOF06gfCKwEMqP4EbFQFQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-11T08:23:46Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-11T07:15Z</start>
    <end>2026-06-11T15:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-11</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>07:15:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-11</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000154T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele Windfarm III and IV</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.5</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-11T07:15Z</start>
            <end>2026-06-11T15:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>608</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('020-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606110715-202606111530.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>48XjS9IpZEzLpj22pLYuSw</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-12T08:23:36Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-12T06:30Z</start>
    <end>2026-06-12T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-12</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-12</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-12T06:30Z</start>
            <end>2026-06-12T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1375</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('021-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606120630-202606121430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>UL3kRPdcjvV-bpmk265_3Q</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-11T08:23:37Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-13T06:30Z</start>
    <end>2026-06-13T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-13</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-13</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-13T06:30Z</start>
            <end>2026-06-13T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1408</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('022-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606130630-202606131430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Cjz55UkSYtP1saWuZWghKw</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-11T08:23:37Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-14T06:30Z</start>
    <end>2026-06-14T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-14</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-14</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-14T06:30Z</start>
            <end>2026-06-14T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1408</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('023-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606140630-202606141430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>KntDi1GSsnmMxDlfBgXVeQ</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-11T08:23:36Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-15T06:30Z</start>
    <end>2026-06-15T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-15</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-15</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-15T06:30Z</start>
            <end>2026-06-15T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1408</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('024-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606150630-202606151430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>2StI9U1QXiHsHdQ0neCkRw</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-16T02:24:18Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-15T07:00Z</start>
    <end>2026-06-15T15:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-15</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>07:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-15</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000154T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele Windfarm III and IV</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.5</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-15T07:00Z</start>
            <end>2026-06-15T15:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>598.5</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('025-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606150700-202606151530.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>6CdoiLX2R4WzhdzkxXIpRg</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-16T02:24:07Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-15T08:00Z</start>
    <end>2026-06-15T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-15</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>08:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-15</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-15T08:00Z</start>
            <end>2026-06-15T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1397</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('026-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606150800-202606151430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>3dB29A8CCfmOQA_XpkWD5w</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-17T08:24:30Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-16T04:00Z</start>
    <end>2026-06-16T12:15Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-16</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>04:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-16</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>12:15:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-16T04:00Z</start>
            <end>2026-06-16T12:15Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>732</quantity>
              </Point>
              <Point>
                <position>151</position>
                <quantity>671</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('027-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606160400-202606161215.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>JxuXMLlZ3X1SdDgUuZ0N8A</mRID>
  <revisionNumber>5</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-10T08:23:47Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-16T04:00Z</start>
    <end>2026-06-18T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-16</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>04:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-18</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-16T04:00Z</start>
            <end>2026-06-18T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>732</quantity>
              </Point>
              <Point>
                <position>151</position>
                <quantity>649</quantity>
              </Point>
              <Point>
                <position>631</position>
                <quantity>732</quantity>
              </Point>
              <Point>
                <position>1081</position>
                <quantity>760</quantity>
              </Point>
              <Point>
                <position>1441</position>
                <quantity>730</quantity>
              </Point>
              <Point>
                <position>2521</position>
                <quantity>760</quant')); 
    dbms_lob.append(l_clob, to_clob('ity>
              </Point>
              <Point>
                <position>2881</position>
                <quantity>725</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('028-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606160400-202606182200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>jQvb_csiLK4Ptso7lZqgtw</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-11T08:23:46Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-16T04:00Z</start>
    <end>2026-06-19T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-16</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>04:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-19</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-16T04:00Z</start>
            <end>2026-06-19T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>732</quantity>
              </Point>
              <Point>
                <position>151</position>
                <quantity>671</quantity>
              </Point>
              <Point>
                <position>631</position>
                <quantity>732</quantity>
              </Point>
              <Point>
                <position>1081</position>
                <quantity>755</quantity>
              </Point>
              <Point>
                <position>1441</position>
                <quantity>730</quantity>
              </Point>
              <Point>
                <position>2521</position>
                <quantity>760</quant')); 
    dbms_lob.append(l_clob, to_clob('ity>
              </Point>
              <Point>
                <position>2881</position>
                <quantity>725</quantity>
              </Point>
              <Point>
                <position>3961</position>
                <quantity>760</quantity>
              </Point>
              <Point>
                <position>4321</position>
                <quantity>720</quantity>
              </Point>
              <Point>
                <position>4861</position>
                <quantity>728</quantity>
              </Point>
              <Point>
                <position>5206</position>
                <quantity>732</quantity>
              </Point>
        </Available_Period>
                <Reason>
                  <code>B19</code>
                </Reason>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('029-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606160400-202606192200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>gokgKjZhCabnhVFXHK2uzQ</mRID>
  <revisionNumber>4</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-17T08:23:36Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-16T04:00Z</start>
    <end>2026-06-20T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-16</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>04:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-20</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-16T04:00Z</start>
            <end>2026-06-20T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>732</quantity>
              </Point>
              <Point>
                <position>151</position>
                <quantity>661</quantity>
              </Point>
              <Point>
                <position>631</position>
                <quantity>732</quantity>
              </Point>
              <Point>
                <position>1036</position>
                <quantity>0</quantity>
              </Point>
              <Point>
                <position>1441</position>
                <quantity>755</quantity>
              </Point>
              <Point>
                <position>2161</position>
                <quantity>760</quantit')); 
    dbms_lob.append(l_clob, to_clob('y>
              </Point>
        </Available_Period>
                <Reason>
                  <code>B19</code>
                </Reason>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('030-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606160400-202606201600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>pn3vjyXovLz1uqZYL3uMlw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-15T08:23:24Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-16T04:30Z</start>
    <end>2026-06-16T16:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-16</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>04:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-16</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000127W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Windpark Gemini</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>Netherlands</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">600.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-16T04:30Z</start>
            <end>2026-06-16T16:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>300</quantity>
              </Point>
              <Point>
                <position>631</position>
                <quantity>200</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('031-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606160430-202606161630.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Emt2WHSaG4zhCMrkq2Aw-Q</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-18T21:15:39Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-16T14:30Z</start>
    <end>2026-06-18T18:45Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-16</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>14:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-18</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>18:45:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-16T14:30Z</start>
            <end>2026-06-18T18:45Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>726</quantity>
              </Point>
              <Point>
                <position>91</position>
                <quantity>721</quantity>
              </Point>
              <Point>
                <position>481</position>
                <quantity>0</quantity>
              </Point>
              <Point>
                <position>811</position>
                <quantity>754</quantity>
              </Point>
              <Point>
                <position>961</position>
                <quantity>693</quantity>
              </Point>
              <Point>
                <position>1441</position>
                <quantity>754</quantity>
              </Point>
              <Point>
                <po')); 
    dbms_lob.append(l_clob, to_clob('sition>1531</position>
                <quantity>749</quantity>
              </Point>
              <Point>
                <position>2251</position>
                <quantity>743</quantity>
              </Point>
              <Point>
                <position>2401</position>
                <quantity>682</quantity>
              </Point>
              <Point>
                <position>2881</position>
                <quantity>733</quantity>
              </Point>
        </Available_Period>
                <Reason>
                  <code>B19</code>
                </Reason>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('032-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606161430-202606181845.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>KZOb85Q3D7AYpmA7Q3w8sg</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-18T21:14:02Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-16T14:30Z</start>
    <end>2026-06-20T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-16</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>14:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-20</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-16T14:30Z</start>
            <end>2026-06-20T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>726</quantity>
              </Point>
              <Point>
                <position>91</position>
                <quantity>721</quantity>
              </Point>
              <Point>
                <position>481</position>
                <quantity>0</quantity>
              </Point>
              <Point>
                <position>811</position>
                <quantity>754</quantity>
              </Point>
              <Point>
                <position>961</position>
                <quantity>704</quantity>
              </Point>
              <Point>
                <position>1441</position>
                <quantity>754</quantity>
')); 
    dbms_lob.append(l_clob, to_clob('              </Point>
              <Point>
                <position>1531</position>
                <quantity>760</quantity>
              </Point>
              <Point>
                <position>2251</position>
                <quantity>754</quantity>
              </Point>
              <Point>
                <position>2401</position>
                <quantity>704</quantity>
              </Point>
              <Point>
                <position>2881</position>
                <quantity>760</quantity>
              </Point>
              <Point>
                <position>3841</position>
                <quantity>704</quantity>
              </Point>
              <Point>
                <position>4321</position>
                <quantity>760</quantity>
              </Point>
              <Point>
                <position>5281</position>
                <quantity>704</quantity>
              </Point>
              <Point>
                <position>5761</position>
                <quantity>760</quantity>
              </Point>
        </Available_Period>
                <Reason>
                  <code>B19</code>
                </Reason>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('033-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606161430-202606201600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>5nrj_BVUuxFJZhdHjKWkMw</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-18T08:23:48Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-17T05:00Z</start>
    <end>2026-06-17T10:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-17</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-17</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>10:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000184K</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>OWF Hollandse Kust Noord</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">760.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-17T05:00Z</start>
            <end>2026-06-17T10:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>380</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('034-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606170500-202606171000.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>lAKqCqUtyLZWtwmt6DEEpQ</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-18T21:14:03Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-18T05:45Z</start>
    <end>2026-06-18T15:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-18</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:45:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-18</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000127W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Windpark Gemini</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>Netherlands</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">600.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-18T05:45Z</start>
            <end>2026-06-18T15:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>300</quantity>
              </Point>
              <Point>
                <position>526</position>
                <quantity>200</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('035-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606180545-202606181530.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>3LWh7kjwLbc_gMweKewkug</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-18T08:23:47Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-18T07:15Z</start>
    <end>2026-06-18T13:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-18</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>07:15:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-18</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>13:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000154T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele Windfarm III and IV</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.5</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-18T07:15Z</start>
            <end>2026-06-18T13:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>628.5</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('036-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606180715-202606181300.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>pYOlCbgX1Xj4RRmHAwhM-w</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-20T08:23:53Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-18T21:00Z</start>
    <end>2026-06-19T18:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-18</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>21:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-19</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>18:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-18T21:00Z</start>
            <end>2026-06-19T18:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>715</quantity>
              </Point>
              <Point>
                <position>421</position>
                <quantity>717</quantity>
              </Point>
              <Point>
                <position>556</position>
                <quantity>693</quantity>
              </Point>
              <Point>
                <position>571</position>
                <quantity>627</quantity>
              </Point>
              <Point>
                <position>781</position>
                <quantity>1083</quantity>
              </Point>
              <Point>
                <position>796</position>
                <quantity>627</quantity>
              </Point>
              <Point>
                ')); 
    dbms_lob.append(l_clob, to_clob('<position>1051</position>
                <quantity>904</quantity>
              </Point>
              <Point>
                <position>1141</position>
                <quantity>947</quantity>
              </Point>
        </Available_Period>
                <Reason>
                  <code>B19</code>
                </Reason>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('037-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606182100-202606191800.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>XtVkWuGFf4GqWJqgUy1AhA</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-19T08:23:38Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-18T21:00Z</start>
    <end>2026-06-20T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-18</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>21:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-20</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-18T21:00Z</start>
            <end>2026-06-20T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>715</quantity>
              </Point>
              <Point>
                <position>421</position>
                <quantity>720</quantity>
              </Point>
              <Point>
                <position>571</position>
                <quantity>649</quantity>
              </Point>
              <Point>
                <position>1021</position>
                <quantity>671</quantity>
              </Point>
              <Point>
                <position>1051</position>
                <quantity>732</quantity>
              </Point>
              <Point>
                <position>1861</position>
                <quantity>743</quant')); 
    dbms_lob.append(l_clob, to_clob('ity>
              </Point>
              <Point>
                <position>2011</position>
                <quantity>682</quantity>
              </Point>
              <Point>
                <position>2491</position>
                <quantity>760</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('038-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606182100-202606201600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>J_iFqIkQD_AXFAr863NIWQ</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-10T08:23:46Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-19T06:30Z</start>
    <end>2026-06-19T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-19</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-19</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-19T06:30Z</start>
            <end>2026-06-19T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1408</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('039-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606190630-202606191430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>dWVkZ9F3tbns7nlGqmvfcg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-19T08:23:38Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-19T07:45Z</start>
    <end>2026-06-19T14:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-19</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>07:45:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-19</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000154T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele Windfarm III and IV</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.5</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-19T07:45Z</start>
            <end>2026-06-19T14:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>617.5</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('040-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606190745-202606191400.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>UxSLh3T2zCaken2aeYofGw</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-21T08:23:37Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-20T01:00Z</start>
    <end>2026-06-21T02:45Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-20</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>01:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-21</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>02:45:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-20T01:00Z</start>
            <end>2026-06-21T02:45Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>947</quantity>
              </Point>
              <Point>
                <position>181</position>
                <quantity>903</quantity>
              </Point>
              <Point>
                <position>331</position>
                <quantity>860</quantity>
              </Point>
              <Point>
                <position>781</position>
                <quantity>859</quantity>
              </Point>
              <Point>
                <position>811</position>
                <quantity>903</quantity>
              </Point>
              <Point>
                <position>901</position>
                <quantity>1117</quantity>
              </Point>
              <Point>
                ')); 
    dbms_lob.append(l_clob, to_clob('<position>961</position>
                <quantity>1385</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('041-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606200100-202606210245.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>OfVDOOtWEddffJyoyvyIaA</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-11T08:23:36Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-20T06:30Z</start>
    <end>2026-06-20T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-20</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-20</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-20T06:30Z</start>
            <end>2026-06-20T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1408</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('042-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606200630-202606201430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>lJq2he-r4qcLU1rZHY8OqQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-20T08:24:05Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-20T07:15Z</start>
    <end>2026-06-20T13:45Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-20</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>07:15:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-20</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>13:45:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000154T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele Windfarm III and IV</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.5</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-20T07:15Z</start>
            <end>2026-06-20T13:45Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>627</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('043-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606200715-202606201345.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>TAs3Z50jJ8brWHuViut7Hg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-21T08:24:34Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-21T04:00Z</start>
    <end>2026-06-21T05:45Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-21</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>04:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-21</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>05:45:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-21T04:00Z</start>
            <end>2026-06-21T05:45Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1359</quantity>
              </Point>
              <Point>
                <position>61</position>
                <quantity>1328</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('044-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606210400-202606210545.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>HDreppvgCMxmH3ezOprvUA</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-21T08:23:38Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-21T04:00Z</start>
    <end>2026-06-21T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-21</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>04:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-21</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-21T04:00Z</start>
            <end>2026-06-21T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1419</quantity>
              </Point>
              <Point>
                <position>151</position>
                <quantity>1375</quantity>
              </Point>
              <Point>
                <position>631</position>
                <quantity>1419</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('045-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606210400-202606211600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>cWH4qZW2QVV8ptcGajQmIQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-23T08:30:11Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-21T06:00Z</start>
    <end>2026-06-22T13:45Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-21</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>13:45:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-21T06:00Z</start>
            <end>2026-06-22T13:45Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1001</quantity>
              </Point>
              <Point>
                <position>31</position>
                <quantity>951</quantity>
              </Point>
              <Point>
                <position>436</position>
                <quantity>988</quantity>
              </Point>
              <Point>
                <position>511</position>
                <quantity>1034</quantity>
              </Point>
              <Point>
                <position>541</position>
                <quantity>1056</quantity>
              </Point>
              <Point>
                <position>571</position>
                <quantity>1084</quantity>
              </Point>
              <Point>
              ')); 
    dbms_lob.append(l_clob, to_clob('  <position>601</position>
                <quantity>1145</quantity>
              </Point>
              <Point>
                <position>661</position>
                <quantity>1103</quantity>
              </Point>
              <Point>
                <position>961</position>
                <quantity>1117</quantity>
              </Point>
              <Point>
                <position>1321</position>
                <quantity>1073</quantity>
              </Point>
              <Point>
                <position>1381</position>
                <quantity>1084</quantity>
              </Point>
              <Point>
                <position>1471</position>
                <quantity>1023</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('046-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606210600-202606221345.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>SYmGPEiQSMdRdY-uXsnDiw</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-23T08:29:21Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-21T06:00Z</start>
    <end>2026-06-22T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-21</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-21T06:00Z</start>
            <end>2026-06-22T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1001</quantity>
              </Point>
              <Point>
                <position>31</position>
                <quantity>935</quantity>
              </Point>
              <Point>
                <position>481</position>
                <quantity>957</quantity>
              </Point>
              <Point>
                <position>511</position>
                <quantity>1023</quantity>
              </Point>
              <Point>
                <position>541</position>
                <quantity>1078</quantity>
              </Point>
              <Point>
                <position>571</position>
                <quantity>1100</quant')); 
    dbms_lob.append(l_clob, to_clob('ity>
              </Point>
              <Point>
                <position>601</position>
                <quantity>1172</quantity>
              </Point>
              <Point>
                <position>1321</position>
                <quantity>1100</quantity>
              </Point>
              <Point>
                <position>1381</position>
                <quantity>1084</quantity>
              </Point>
              <Point>
                <position>1471</position>
                <quantity>1023</quantity>
              </Point>
              <Point>
                <position>1951</position>
                <quantity>1056</quantity>
              </Point>
              <Point>
                <position>1981</position>
                <quantity>1364</quantity>
              </Point>
              <Point>
                <position>2011</position>
                <quantity>1408</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('047-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606210600-202606221600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Wzj2rCOJFcMXPLnmM4FAJw</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-11T08:23:38Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-21T06:30Z</start>
    <end>2026-06-21T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-21</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-21</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-21T06:30Z</start>
            <end>2026-06-21T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1408</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('048-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606210630-202606211430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>lxC4uEM88nzh9UNIp7lHqQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-21T08:23:49Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-21T07:45Z</start>
    <end>2026-06-21T14:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-21</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>07:45:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-21</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000154T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele Windfarm III and IV</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.5</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-21T07:45Z</start>
            <end>2026-06-21T14:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>579.5</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('049-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606210745-202606211400.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>W_Vj-6NNEEOuF7wqABNqMw</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-21T08:23:38Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-22T04:00Z</start>
    <end>2026-06-22T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-22</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>04:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-22T04:00Z</start>
            <end>2026-06-22T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1419</quantity>
              </Point>
              <Point>
                <position>151</position>
                <quantity>1375</quantity>
              </Point>
              <Point>
                <position>631</position>
                <quantity>1419</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('050-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606220400-202606221600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>eNVpOw0Oj3cwMzJjIGoTqg</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-11T08:23:38Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-22T06:30Z</start>
    <end>2026-06-22T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-22</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-22T06:30Z</start>
            <end>2026-06-22T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1408</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('051-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606220630-202606221430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>p3LyH7pmeEb0DpOc-YkPVg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-22T08:23:58Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-22T07:00Z</start>
    <end>2026-06-22T14:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-22</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>07:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000154T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele Windfarm III and IV</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.5</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-22T07:00Z</start>
            <end>2026-06-22T14:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>598.5</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('052-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606220700-202606221400.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>BxcXSWfQGHEHGL70upQSxA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-23T08:30:24Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-22T14:00Z</start>
    <end>2026-06-23T04:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-22</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>14:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>04:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-22T14:00Z</start>
            <end>2026-06-23T04:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1276</quantity>
              </Point>
              <Point>
                <position>31</position>
                <quantity>1309</quantity>
              </Point>
              <Point>
                <position>61</position>
                <quantity>1353</quantity>
              </Point>
              <Point>
                <position>121</position>
                <quantity>1398</quantity>
              </Point>
              <Point>
                <position>181</position>
                <quantity>1359</quantity>
              </Point>
              <Point>
                <position>481</position>
                <quantity>1398</quantity>
              </Point>
        </Available_Period>
  </Tim')); 
    dbms_lob.append(l_clob, to_clob('eSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('053-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606221400-202606230400.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>3JLtA_hhmA0fbSd-4FiO8A</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-23T08:29:22Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T04:00Z</start>
    <end>2026-06-23T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>04:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T04:00Z</start>
            <end>2026-06-23T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1419</quantity>
              </Point>
              <Point>
                <position>151</position>
                <quantity>1375</quantity>
              </Point>
              <Point>
                <position>631</position>
                <quantity>1419</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('054-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606230400-202606231600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>99IrqypLt2O7hNJfJlFc2w</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-23T08:29:28Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T06:30Z</start>
    <end>2026-06-23T14:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000154T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele Windfarm III and IV</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.5</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T06:30Z</start>
            <end>2026-06-23T14:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>627</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('055-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606230630-202606231400.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>1YBD7mdE4gu7tCYiCEaGiw</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-11T08:23:37Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T06:30Z</start>
    <end>2026-06-23T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T06:30Z</start>
            <end>2026-06-23T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1408</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('056-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606230630-202606231430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Qp9A-AxURdrz3zYXvRNVfQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-23T08:30:25Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T07:00Z</start>
    <end>2026-06-23T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>07:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T07:00Z</start>
            <end>2026-06-23T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1287</quantity>
              </Point>
              <Point>
                <position>451</position>
                <quantity>1320</quantity>
              </Point>
              <Point>
                <position>481</position>
                <quantity>1415</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('057-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606230700-202606231600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>5GqcODCjJ9xvC61hk7SW2A</mRID>
  <revisionNumber>6</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-24T20:44:23Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-24T07:00Z</start>
    <end>2026-06-24T14:45Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-24</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>07:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:45:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-24T07:00Z</start>
            <end>2026-06-24T14:45Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1304</quantity>
              </Point>
              <Point>
                <position>451</position>
                <quantity>1337</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('058-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606240700-202606241445.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>lzOlYr6b4VFz3kKMbPZBRw</mRID>
  <revisionNumber>5</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-24T20:44:22Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-25T06:00Z</start>
    <end>2026-06-25T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-25</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-25</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-25T06:00Z</start>
            <end>2026-06-25T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1414</quantity>
              </Point>
              <Point>
                <position>31</position>
                <quantity>1309</quantity>
              </Point>
              <Point>
                <position>511</position>
                <quantity>1403</quantity>
              </Point>
              <Point>
                <position>541</position>
                <quantity>1415</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('059-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606250600-202606251600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>068naRGR_tpivdyHinWyfA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-26T08:28:38Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-26T05:00Z</start>
    <end>2026-06-26T12:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-26</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-26</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>12:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-26T05:00Z</start>
            <end>2026-06-26T12:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1386</quantity>
              </Point>
              <Point>
                <position>61</position>
                <quantity>1397</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('060-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606260500-202606261200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>mfmeAU-dvzu5Kk9OR8Ay3Q</mRID>
  <revisionNumber>6</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-24T20:44:22Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-26T06:30Z</start>
    <end>2026-06-26T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-26</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-26</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-26T06:30Z</start>
            <end>2026-06-26T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1370</quantity>
              </Point>
              <Point>
                <position>31</position>
                <quantity>1337</quantity>
              </Point>
              <Point>
                <position>511</position>
                <quantity>1415</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('061-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606260630-202606261600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>iwSY2lnitMOwZ8cw-qzX3Q</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-26T08:28:36Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-26T07:00Z</start>
    <end>2026-06-26T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-26</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>07:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-26</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000154T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele Windfarm III and IV</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.5</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-26T07:00Z</start>
            <end>2026-06-26T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>589</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('062-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606260700-202606261500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>pE2OPHT6YPg7G8Vn81Jmfw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-25T08:41:20Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-26T09:00Z</start>
    <end>2026-06-26T14:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-26</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>09:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-26</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000168I</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Windpark Fryslan</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>Netherlands</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B19</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">382.7</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-26T09:00Z</start>
            <end>2026-06-26T14:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>190</quantity>
              </Point>
        </Available_Period>
                <Reason>
                  <code>A95</code>
                      <text>CBC outage</text>
                </Reason>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('063-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606260900-202606261400.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>zGinwOzopzz1FukyXM2HvQ</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-27T08:27:27Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-27T05:00Z</start>
    <end>2026-06-27T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-27</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-27</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-27T05:00Z</start>
            <end>2026-06-27T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1364</quantity>
              </Point>
              <Point>
                <position>61</position>
                <quantity>1320</quantity>
              </Point>
              <Point>
                <position>421</position>
                <quantity>1415</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('064-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606270500-202606271600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>8nSU14GvIBm6CG8OuPAY5w</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-28T08:26:54Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-27T05:00Z</start>
    <end>2026-06-27T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-27</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-27</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000127W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Windpark Gemini</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>Netherlands</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">600.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-27T05:00Z</start>
            <end>2026-06-27T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>452</quantity>
              </Point>
              <Point>
                <position>46</position>
                <quantity>480</quantity>
              </Point>
              <Point>
                <position>301</position>
                <quantity>460</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('065-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606270500-202606272200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>U2FrJndVQ4r0zgIPro31DQ</mRID>
  <revisionNumber>6</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-24T20:44:22Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-27T06:30Z</start>
    <end>2026-06-27T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-27</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-27</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-27T06:30Z</start>
            <end>2026-06-27T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1381</quantity>
              </Point>
              <Point>
                <position>31</position>
                <quantity>1348</quantity>
              </Point>
              <Point>
                <position>511</position>
                <quantity>1415</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('066-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606270630-202606271600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>NKUwUWPmHOHzfNmM0xvlwg</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T08:26:59Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-27T16:00Z</start>
    <end>2026-06-29T07:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-27</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>16:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-29</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>07:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-27T16:00Z</start>
            <end>2026-06-29T07:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1409</quantity>
              </Point>
              <Point>
                <position>871</position>
                <quantity>1299</quantity>
              </Point>
              <Point>
                <position>931</position>
                <quantity>1265</quantity>
              </Point>
              <Point>
                <position>1321</position>
                <quantity>1276</quantity>
              </Point>
              <Point>
                <position>1351</position>
                <quantity>1345</quantity>
              </Point>
              <Point>
                <position>1411</position>
                <quantity>1407</quantity>
              </Point>
              <Point>
        ')); 
    dbms_lob.append(l_clob, to_clob('        <position>2311</position>
                <quantity>1320</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('067-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606271600-202606290730.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>RRtASHQ6tA2_x_QsvNKzsw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-28T08:26:54Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-28T01:00Z</start>
    <end>2026-06-28T05:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-28</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>01:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-28</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>05:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000127W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Windpark Gemini</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>Netherlands</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">600.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-28T01:00Z</start>
            <end>2026-06-28T05:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>372</quantity>
              </Point>
              <Point>
                <position>181</position>
                <quantity>368</quantity>
              </Point>
              <Point>
                <position>211</position>
                <quantity>440</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('068-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606280100-202606280500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>YvpUffxHmcy-P5_Cg8z10Q</mRID>
  <revisionNumber>6</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-24T20:44:22Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-28T06:30Z</start>
    <end>2026-06-28T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-28</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-28</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-28T06:30Z</start>
            <end>2026-06-28T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1381</quantity>
              </Point>
              <Point>
                <position>31</position>
                <quantity>1348</quantity>
              </Point>
              <Point>
                <position>511</position>
                <quantity>1415</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('069-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606280630-202606281600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>8zeW2e6wSYNRC6Q9EXHVhQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-28T08:26:54Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-28T07:00Z</start>
    <end>2026-06-28T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-28</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>07:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-28</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000154T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele Windfarm III and IV</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.5</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-28T07:00Z</start>
            <end>2026-06-28T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>589</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('070-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606280700-202606281500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>MA40WHXeHNJKYXAtVc-36Q</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-28T19:49:37Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-29T05:00Z</start>
    <end>2026-06-29T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-29</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-29</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000168I</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Windpark Fryslan</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>Netherlands</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B19</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">382.7</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-29T05:00Z</start>
            <end>2026-06-29T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>200</quantity>
              </Point>
        </Available_Period>
                <Reason>
                  <code>A95</code>
                      <text>CBC request grid operator</text>
                </Reason>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('071-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606290500-202606291500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>9vl5Pbdl6sfD_b8D3iuNSw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-29T08:27:57Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-29T06:00Z</start>
    <end>2026-06-29T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-29</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-29</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000154T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele Windfarm III and IV</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.5</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-29T06:00Z</start>
            <end>2026-06-29T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>598.5</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('072-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606290600-202606291500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>gTsHYS3msd44sHH37D7fCQ</mRID>
  <revisionNumber>6</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-24T20:44:02Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-29T06:30Z</start>
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
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-29</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-29T06:30Z</start>
            <end>2026-06-29T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1386</quantity>
              </Point>
              <Point>
                <position>31</position>
                <quantity>1353</quantity>
              </Point>
              <Point>
                <position>481</position>
                <quantity>1375</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('073-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606290630-202606291500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>_K2CDBDDRKsMNaK-LJ-UZw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T08:27:02Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T04:15Z</start>
    <end>2026-06-30T05:15Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>04:15:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>05:15:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T04:15Z</start>
            <end>2026-06-30T05:15Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1411</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('074-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606300415-202606300515.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>K8KsEBk8MpzdGg360LuMnw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T23:04:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T06:15Z</start>
    <end>2026-06-30T07:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:15:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>07:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T06:15Z</start>
            <end>2026-06-30T07:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1403</quantity>
              </Point>
              <Point>
                <position>16</position>
                <quantity>1365</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('075-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606300615-202606300730.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>nQmZouIfaChxBuKz9h80sA</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-30T23:04:12Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T06:15Z</start>
    <end>2026-07-01T15:30Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:15:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-01</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T06:15Z</start>
            <end>2026-07-01T15:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1403</quantity>
              </Point>
              <Point>
                <position>16</position>
                <quantity>1365</quantity>
              </Point>
              <Point>
                <position>76</position>
                <quantity>1321</quantity>
              </Point>
              <Point>
                <position>496</position>
                <quantity>1354</quantity>
              </Point>
              <Point>
                <position>556</position>
                <quantity>1398</quantity>
              </Point>
              <Point>
                <position>586</position>
                <quantity>1420</quan')); 
    dbms_lob.append(l_clob, to_clob('tity>
              </Point>
              <Point>
                <position>1306</position>
                <quantity>1398</quantity>
              </Point>
              <Point>
                <position>1456</position>
                <quantity>1321</quantity>
              </Point>
              <Point>
                <position>1936</position>
                <quantity>1382</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('076-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606300615-202607011530.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>iZbVGHW0eh-yVl-uoix_lg</mRID>
  <revisionNumber>4</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-24T20:44:02Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T06:30Z</start>
    <end>2026-06-30T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T06:30Z</start>
            <end>2026-06-30T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1331</quantity>
              </Point>
              <Point>
                <position>481</position>
                <quantity>1364</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('077-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606300630-202606301500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>g4RtPqPdKkMSUk1cPpwMDg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T08:28:01Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T15:30Z</start>
    <end>2026-07-01T04:15Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>15:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-01</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>04:15:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T15:30Z</start>
            <end>2026-07-01T04:15Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1419</quantity>
              </Point>
              <Point>
                <position>751</position>
                <quantity>1398</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('078-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606301530-202607010415.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>0CpfXczpp4GOMZAWo3A2jQ</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T08:27:24Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-30T15:30Z</start>
    <end>2026-07-01T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>15:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-01</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-30T15:30Z</start>
            <end>2026-07-01T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1419</quantity>
              </Point>
              <Point>
                <position>751</position>
                <quantity>1397</quantity>
              </Point>
              <Point>
                <position>901</position>
                <quantity>1320</quantity>
              </Point>
              <Point>
                <position>1351</position>
                <quantity>1321</quantity>
              </Point>
              <Point>
                <position>1381</position>
                <quantity>1382</quantity>
              </Point>
              <Point>
                <position>1441</position>
                <quantity>1415<')); 
    dbms_lob.append(l_clob, to_clob('/quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('079-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606301530-202607011600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>fGaKxy-qyS1-kWwVZQSTQQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-24T20:44:33Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-01T04:00Z</start>
    <end>2026-07-07T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-01</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>04:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-07</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000154T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele Windfarm III and IV</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.5</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-01T04:00Z</start>
            <end>2026-07-07T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>361</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('080-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607010400-202607071600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>351mvZ4BwJe2ru5_AX3gWQ</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T19:19:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-01T06:30Z</start>
    <end>2026-07-01T09:45Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-01</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-01</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>09:45:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-01T06:30Z</start>
            <end>2026-07-01T09:45Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1330</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('081-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607010630-202607010945.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>XTX2HjTUwfVVV3urfzX2FQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-02T05:05:10Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-01T17:45Z</start>
    <end>2026-07-02T04:45Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-01</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>17:45:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-02</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>04:45:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-01T17:45Z</start>
            <end>2026-07-02T04:45Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1420</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('082-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607011745-202607020445.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>uKd_vsk4yiiFm4geSPjL_Q</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-02T05:04:48Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-01T17:45Z</start>
    <end>2026-07-02T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-01</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>17:45:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-02</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-01T17:45Z</start>
            <end>2026-07-02T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1420</quantity>
              </Point>
              <Point>
                <position>766</position>
                <quantity>1331</quantity>
              </Point>
              <Point>
                <position>1216</position>
                <quantity>1364</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('083-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607011745-202607021430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>M-4LJtZclcJRNtkCtCC8eA</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-02T08:23:30Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-02T06:30Z</start>
    <end>2026-07-02T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
      <docStatus>
        <value>A09</value>
      </docStatus>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-02</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-02</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-02T06:30Z</start>
            <end>2026-07-02T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1331</quantity>
              </Point>
              <Point>
                <position>451</position>
                <quantity>1364</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('084-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607020630-202607021430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Eg5n2D3gBfZJF23BBSKZjA</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-02T23:49:52Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-02T22:00Z</start>
    <end>2026-07-03T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-02</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>22:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-03</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-02T22:00Z</start>
            <end>2026-07-03T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1416</quantity>
              </Point>
              <Point>
                <position>421</position>
                <quantity>1377</quantity>
              </Point>
              <Point>
                <position>511</position>
                <quantity>1331</quantity>
              </Point>
              <Point>
                <position>961</position>
                <quantity>1353</quantity>
              </Point>
              <Point>
                <position>991</position>
                <quantity>1394</quantity>
              </Point>
              <Point>
                <position>1081</position>
                <quantity>1399</quantity>
              </Point>
        </Available_Period>
  </')); 
    dbms_lob.append(l_clob, to_clob('TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('085-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607022200-202607032200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>DrpcLQTjOrUFg8pXhSbL5w</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-02T23:49:52Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-04T05:00Z</start>
    <end>2026-07-04T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-04</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-04</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-04T05:00Z</start>
            <end>2026-07-04T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1394</quantity>
              </Point>
              <Point>
                <position>91</position>
                <quantity>1355</quantity>
              </Point>
              <Point>
                <position>571</position>
                <quantity>1394</quantity>
              </Point>
              <Point>
                <position>661</position>
                <quantity>1399</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('086-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607040500-202607042200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>PiWbd8_HvbfZesxzpqVaTQ</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-02T23:49:52Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-05T05:00Z</start>
    <end>2026-07-05T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-05</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-05</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-05T05:00Z</start>
            <end>2026-07-05T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1394</quantity>
              </Point>
              <Point>
                <position>91</position>
                <quantity>1364</quantity>
              </Point>
              <Point>
                <position>571</position>
                <quantity>1394</quantity>
              </Point>
              <Point>
                <position>661</position>
                <quantity>1399</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('087-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607050500-202607052200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>kygnGyyFL-ytcXhjBolmKw</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-02T23:49:53Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-06T05:00Z</start>
    <end>2026-07-06T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-06</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-06</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-06T05:00Z</start>
            <end>2026-07-06T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1394</quantity>
              </Point>
              <Point>
                <position>91</position>
                <quantity>1364</quantity>
              </Point>
              <Point>
                <position>571</position>
                <quantity>1394</quantity>
              </Point>
              <Point>
                <position>661</position>
                <quantity>1399</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('088-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607060500-202607062200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>dAZEqnJav3eliRG_6ElOpQ</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-02T23:49:53Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-07T05:00Z</start>
    <end>2026-07-07T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-07</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-07</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-07T05:00Z</start>
            <end>2026-07-07T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1394</quantity>
              </Point>
              <Point>
                <position>91</position>
                <quantity>1364</quantity>
              </Point>
              <Point>
                <position>571</position>
                <quantity>1394</quantity>
              </Point>
              <Point>
                <position>661</position>
                <quantity>1399</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('089-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607070500-202607072200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>zBKcXVihP7wvG2mkmmmoRQ</mRID>
  <revisionNumber>3</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-02T23:49:53Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-08T05:00Z</start>
    <end>2026-07-08T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-08</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-08</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-08T05:00Z</start>
            <end>2026-07-08T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1394</quantity>
              </Point>
              <Point>
                <position>91</position>
                <quantity>1364</quantity>
              </Point>
              <Point>
                <position>571</position>
                <quantity>1394</quantity>
              </Point>
              <Point>
                <position>661</position>
                <quantity>1399</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('090-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607080500-202607082200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>I0C8K8tpqoyKlBwIecKYXw</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-02T08:23:47Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-09T05:00Z</start>
    <end>2026-07-09T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-09</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-09</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-09T05:00Z</start>
            <end>2026-07-09T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1394</quantity>
              </Point>
              <Point>
                <position>91</position>
                <quantity>1364</quantity>
              </Point>
              <Point>
                <position>571</position>
                <quantity>1394</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('091-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607090500-202607091600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>S_dDABUeYrzZNm-PoGdOsw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T08:27:30Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-10T06:30Z</start>
    <end>2026-07-10T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-10</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-10</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-10T06:30Z</start>
            <end>2026-07-10T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1342</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('092-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607100630-202607101430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>UW9Okgl2hAy4ydOuV3-3lA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T08:27:30Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-11T06:30Z</start>
    <end>2026-07-11T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-11</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-11</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-11T06:30Z</start>
            <end>2026-07-11T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1342</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('093-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607110630-202607111430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>A-XKNUdjzzgDm_94VSUe8g</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T08:27:31Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-12T06:30Z</start>
    <end>2026-07-12T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-12</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-12</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-12T06:30Z</start>
            <end>2026-07-12T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1342</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('094-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607120630-202607121430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>OPnfalYSMVy9owifuI9dJg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T08:27:31Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-13T06:30Z</start>
    <end>2026-07-13T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-13</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-13</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-13T06:30Z</start>
            <end>2026-07-13T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1342</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('095-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607130630-202607131430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>9hrue1Bzp5tSXZ36vW5GEQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T08:27:31Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-14T06:30Z</start>
    <end>2026-07-14T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-14</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-14</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-14T06:30Z</start>
            <end>2026-07-14T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1342</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('096-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607140630-202607141430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>CNalhhzLqpvANPr_wzkvbQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T08:27:31Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-15T06:30Z</start>
    <end>2026-07-15T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-15</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-15</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-15T06:30Z</start>
            <end>2026-07-15T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1386</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('097-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607150630-202607151430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>5aOkgBIh-yfojl18Io_DTw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T19:19:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-16T06:30Z</start>
    <end>2026-07-16T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-16</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-16</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-16T06:30Z</start>
            <end>2026-07-16T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1397</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('098-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607160630-202607161430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>NOjZzlrXYOGbVqvhNqTERg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T19:19:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-17T06:30Z</start>
    <end>2026-07-17T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-17</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-17</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-17T06:30Z</start>
            <end>2026-07-17T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1397</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('099-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607170630-202607171430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>V7F2AYms7-81gLWeean3XQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T19:19:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-18T06:30Z</start>
    <end>2026-07-18T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-18</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-18</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-18T06:30Z</start>
            <end>2026-07-18T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1397</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('100-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607180630-202607181430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>2KNO0GkaEJtQ6Hi1axYXjg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T19:19:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-19T06:30Z</start>
    <end>2026-07-19T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-19</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-19</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-19T06:30Z</start>
            <end>2026-07-19T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1397</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('101-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607190630-202607191430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Wf7idvINkyYFJ0MxYYSz2A</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T19:19:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-20T06:30Z</start>
    <end>2026-07-20T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-20</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-20</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-20T06:30Z</start>
            <end>2026-07-20T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1397</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('102-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607200630-202607201430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>U9kxE8w380n4HfJqVhW4Pw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-02T12:47:13Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-21T05:00Z</start>
    <end>2026-07-22T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-21</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000168I</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Windpark Fryslan</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>Netherlands</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B19</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">382.7</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-21T05:00Z</start>
            <end>2026-07-22T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
                <Reason>
                  <code>A95</code>
                      <text>Windfarm Fryslan Planned Grid Outage 21-07 // 24-07 (Maintenance)</text>
                </Reason>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('103-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607210500-202607221600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>s5Cux_MPUMmogBH3SflrIw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T19:19:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-21T06:30Z</start>
    <end>2026-07-21T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-21</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-21</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-21T06:30Z</start>
            <end>2026-07-21T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1397</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('104-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607210630-202607211430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>uIYdhpCFcDde-0Wf77V5jQ</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T19:19:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-22T06:30Z</start>
    <end>2026-07-22T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-22</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-22</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-22T06:30Z</start>
            <end>2026-07-22T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1397</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('105-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607220630-202607221430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>9PgCA1pCpwufcrr7WWWyog</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-02T12:47:55Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-23T05:00Z</start>
    <end>2026-07-24T16:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>05:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>16:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000168I</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Windpark Fryslan</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>Netherlands</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B19</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">382.7</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-23T05:00Z</start>
            <end>2026-07-24T16:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>0</quantity>
              </Point>
        </Available_Period>
                <Reason>
                  <code>A95</code>
                      <text>Windfarm Fryslan Planned Grid Outage 21-07 // 24-07 (Maintenance)</text>
                </Reason>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('106-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607230500-202607241600.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>oZEaEWSxglyTYrqrnNk20A</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T19:19:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-23T06:30Z</start>
    <end>2026-07-23T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-23T06:30Z</start>
            <end>2026-07-23T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1397</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('107-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607230630-202607231430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>vz0zM5DOPT7dtyy0uACvrg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T19:19:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-24T06:30Z</start>
    <end>2026-07-24T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-24</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-24</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-24T06:30Z</start>
            <end>2026-07-24T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1397</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('108-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607240630-202607241430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>2Tg3ZWPjXvpquGYyFBC1IA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T19:19:35Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-25T06:30Z</start>
    <end>2026-07-25T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-25</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-25</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-25T06:30Z</start>
            <end>2026-07-25T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1397</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('109-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607250630-202607251430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>RSSNzrhuLsnuSoJIL7Xmnw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T19:19:36Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-26T06:30Z</start>
    <end>2026-07-26T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-26</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-26</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-26T06:30Z</start>
            <end>2026-07-26T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1397</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('110-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607260630-202607261430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>OhCqNHEsLX0h6F7zMKg29g</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T19:19:36Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-27T06:30Z</start>
    <end>2026-07-27T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-27</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-27</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-27T06:30Z</start>
            <end>2026-07-27T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1397</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('111-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607270630-202607271430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>ANHi5BUHqD1lzkZFkM6AMg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T19:19:36Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-28T06:30Z</start>
    <end>2026-07-28T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-28</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-28</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-28T06:30Z</start>
            <end>2026-07-28T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1397</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('112-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607280630-202607281430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>4QnUFWHBuPZf8HZp0p0yPA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T19:19:36Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-29T06:30Z</start>
    <end>2026-07-29T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-29</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-29</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-29T06:30Z</start>
            <end>2026-07-29T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1397</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('113-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607290630-202607291430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>qEpD9DXNegUA2pULqh_AUw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T19:19:36Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-30T06:30Z</start>
    <end>2026-07-30T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-30</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-30</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-30T06:30Z</start>
            <end>2026-07-30T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1397</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('114-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607300630-202607301430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Xqf_tDUIzdga6qPTJNl2fg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-07-01T19:19:36Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-07-31T06:30Z</start>
    <end>2026-07-31T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A53</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-07-31</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-07-31</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-07-31T06:30Z</start>
            <end>2026-07-31T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1397</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('115-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202607310630-202607311430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>uo_Ki4gWVJfvkfe_qUsIvw</mRID>
  <revisionNumber>26</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-27T21:55:27Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-05-27T22:00Z</start>
    <end>2026-06-28T01:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-05-27</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>22:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-28</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>01:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000127W</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Windpark Gemini</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>Netherlands</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">600.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-05-27T22:00Z</start>
            <end>2026-06-28T01:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>376</quantity>
              </Point>
              <Point>
                <position>43216</position>
                <quantity>272</quantity>
              </Point>
              <Point>
                <position>43261</position>
                <quantity>268</quantity>
              </Point>
              <Point>
                <position>43291</position>
                <quantity>260</quantity>
              </Point>
              <Point>
                <position>43321</position>
                <quantity>256</quantity>
              </Point>
              <Point>
                <position>43351</position>
                <quantity>252</quantity>
              </Point>
              <Point>
           ')); 
    dbms_lob.append(l_clob, to_clob('     <position>43381</position>
                <quantity>248</quantity>
              </Point>
              <Point>
                <position>43411</position>
                <quantity>240</quantity>
              </Point>
              <Point>
                <position>43441</position>
                <quantity>228</quantity>
              </Point>
              <Point>
                <position>43486</position>
                <quantity>224</quantity>
              </Point>
              <Point>
                <position>43516</position>
                <quantity>68</quantity>
              </Point>
              <Point>
                <position>43531</position>
                <quantity>52</quantity>
              </Point>
              <Point>
                <position>43561</position>
                <quantity>56</quantity>
              </Point>
              <Point>
                <position>43576</position>
                <quantity>0</quantity>
              </Point>
              <Point>
                <position>43591</position>
                <quantity>68</quantity>
              </Point>
              <Point>
                <position>43621</position>
                <quantity>220</quantity>
              </Point>
              <Point>
                <position>43921</position>
                <quantity>376</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('116-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202605272200-202606280100.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>evsiQvJxwxLBH2porPhTMw</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-03T17:52:57Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-03T16:00Z</start>
    <end>2026-06-03T17:45Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-03</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>16:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-03</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>17:45:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-03T16:00Z</start>
            <end>2026-06-03T17:45Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>789</quantity>
              </Point>
              <Point>
                <position>16</position>
                <quantity>739</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('117-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606031600-202606031745.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>-B0LRjoScUDkvu3gxueHWQ</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-05T11:28:31Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-05T06:45Z</start>
    <end>2026-06-05T11:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-05</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>06:45:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-05</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>11:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-05T06:45Z</start>
            <end>2026-06-05T11:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1309</quantity>
              </Point>
              <Point>
                <position>271</position>
                <quantity>1339</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('118-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606050645-202606051130.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>D0y1bM-rxUP7Ba4m0CDgJA</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-16T13:08:03Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-16T12:15Z</start>
    <end>2026-06-16T14:30Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-16</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>12:15:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-16</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>14:30:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-16T12:15Z</start>
            <end>2026-06-16T14:30Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>666</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B20</code>
            <text>External Factors</text>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('119-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606161215-202606161430.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>8q4plVqx-3tkIZYliilvgw</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-21T03:48:54Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-21T02:45Z</start>
    <end>2026-06-21T04:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-21</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>02:45:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-21</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>04:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-21T02:45Z</start>
            <end>2026-06-21T04:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1400</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('120-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606210245-202606210400.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>XBF5wV-q0IYBe2A0hzqZCw</mRID>
  <revisionNumber>2</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-23T21:11:00Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-23T17:00Z</start>
    <end>2026-06-23T22:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-23</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>17:00:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-23</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>22:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000171T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Hollandse Kust Zuid</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">1420.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-23T17:00Z</start>
            <end>2026-06-23T22:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>1406</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('121-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606231700-202606232200.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>Ovh3ia9BaWcbqfHZQ9ekKg</mRID>
  <revisionNumber>1</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-25T08:41:10Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-25T08:34Z</start>
    <end>2026-06-25T15:00Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-25</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>08:34:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-25</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>15:00:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000154T</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele Windfarm III and IV</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">731.5</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-25T08:34Z</start>
            <end>2026-06-25T15:00Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>627</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B19</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('122-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606250834-202606251500.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>wkAJhRhdqfWgEzQTLp9S4w</mRID>
  <revisionNumber>7</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-28T08:27:02Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-25T18:36Z</start>
    <end>2026-06-28T21:59Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-25</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>18:36:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-28</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:59:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000148O</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele 2</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">376.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-25T18:36Z</start>
            <end>2026-06-28T21:59Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>230</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('123-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606251836-202606282159.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  declare
    l_clob clob;
  begin
    dbms_lob.createtemporary(l_clob, true);
    dbms_lob.append(l_clob, to_clob('<?xml version="1.0" encoding="UTF-8"?>
<Unavailability_MarketDocument xmlns="urn:iec62325.351:tc57wg16:451-6:outagedocument:3:0">
  <mRID>2MhG2vvo3nPhG8etw2nEpA</mRID>
  <revisionNumber>6</revisionNumber>
  <type>A77</type>
  <process.processType>A26</process.processType>
  <createdDateTime>2026-06-28T08:27:00Z</createdDateTime>
  <sender_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</sender_MarketParticipant.mRID>
  <sender_MarketParticipant.marketRole.type>A32</sender_MarketParticipant.marketRole.type>
  <receiver_MarketParticipant.mRID codingScheme="A01">10X1001A1001A450</receiver_MarketParticipant.mRID>
  <receiver_MarketParticipant.marketRole.type>A33</receiver_MarketParticipant.marketRole.type>
  <unavailability_Time_Period.timeInterval>
    <start>2026-06-25T22:30Z</start>
    <end>2026-06-28T21:59Z</end>
  </unavailability_Time_Period.timeInterval>
  <TimeSeries>
    <mRID>1</mRID>
    <businessType>A54</businessType>
    <biddingZone_Domain.mRID codingScheme="A01">10YNL----------L</biddingZone_Domain.mRID>
    <start_DateAndOrTime.date>2026-06-25</start_DateAndOrTime.date>
    <start_DateAndOrTime.time>22:30:00Z</start_DateAndOrTime.time>
    <end_DateAndOrTime.date>2026-06-28</end_DateAndOrTime.date>
    <end_DateAndOrTime.time>21:59:00Z</end_DateAndOrTime.time>
    <quantity_Measure_Unit.name>MAW</quantity_Measure_Unit.name>
    <curveType>A03</curveType>
    <production_RegisteredResource.mRID codingScheme="A01">49W000000000147Q</production_RegisteredResource.mRID>
    <production_RegisteredResource.name>Borssele 1</production_RegisteredResource.name>
    <production_RegisteredResource.location.name>intra_zonal</production_RegisteredResource.location.name>
    <production_RegisteredResource.pSRType.psrType>B18</production_RegisteredResource.pSRType.psrType>
      <production_RegisteredResource.pSRType.powerSystemResources.nominalP
            unit="MAW">376.0</production_RegisteredResource.pSRType.powerSystemResources.nominalP>
        <Available_Period>
          <timeInterval>
            <start>2026-06-25T22:30Z</start>
            <end>2026-06-28T21:59Z</end>
          </timeInterval>
          <resolution>PT1M</resolution>
              <Point>
                <position>1</position>
                <quantity>216</quantity>
              </Point>
        </Available_Period>
  </TimeSeries>
      <Reason>
        <code>B18</code>
      </Reason>
</Unavailability_MarketDocument>')); 
    insert into tmp_sanilog (tekst, clobje) values ('124-UNAVAILABILITY_OF_PRODUCTION_AND_GENERATION_UNITS_202606252230-202606282159.xml', l_clob);
    dbms_lob.freetemporary(l_clob);
    v_inserted := v_inserted + 1;
  end;

  commit;
  dbms_output.put_line('Inserted rows: ' || v_inserted);
end;
/

select count(*) as rows_loaded from tmp_sanilog;
select tekst, dbms_lob.getlength(clobje) as clob_len from tmp_sanilog order by regel;
