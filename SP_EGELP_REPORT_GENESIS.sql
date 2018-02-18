CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_EGELP_REPORT_GENESIS`(PAR_METER_ID TEXT,PAR_IN_DATE_S TEXT,PAR_IN_DATE_ST TEXT)
BEGIN
	IF PAR_METER_ID IS NULL OR PAR_METER_ID = "" THEN
		select * ,
			round(peak_demand * bill_kw,2) as total_demand ,
			round((kwhr_final - kwhr_begin ) * bill_unit,2) as total_unit ,
            round((kwhr_final - kwhr_begin ) * bill_ft,2) as total_ft
        from 
        (select  tb.hour_id , 				
				tb.meter_id ,
                meter.meter_name,
				max(kw)peak_demand ,
				min(CASE WHEN kwhr_final >0 THEN kwhr_final END) kwhr_begin ,
				max(kwhr_final)kwhr_final,
                bill_unit,
				bill_kw,
				bill_service,
				bill_ft,
				bill_vat

		from( 
			select concat(hour_id,'00')hour_id ,meter_id ,SPLIT_DECIMAL(eg_00,',',1 )  as kw ,SPLIT_DECIMAL(eg_00,',',7 )as kwhr_final  from dbrtftyrv2.eg_tr_15minute  where hour_id  between  PAR_IN_DATE_S and PAR_IN_DATE_ST    
			union all
			select concat(hour_id,'15')hour_id ,meter_id ,SPLIT_DECIMAL(eg_15,',',1  )askw , SPLIT_DECIMAL(eg_15,',',7 )as kwhr_final  from dbrtftyrv2.eg_tr_15minute  where hour_id  between  PAR_IN_DATE_S and PAR_IN_DATE_ST    
			union all
			select concat(hour_id,'30')hour_id ,meter_id ,SPLIT_DECIMAL(eg_30,',',1 ) as kw, SPLIT_DECIMAL(eg_30,',',7 )as kwhr_final  from dbrtftyrv2.eg_tr_15minute  where hour_id  between  PAR_IN_DATE_S and PAR_IN_DATE_ST    
			union all
			select concat(hour_id,'45')hour_id,meter_id ,SPLIT_DECIMAL(eg_45,',',1 ) as kw, SPLIT_DECIMAL(eg_45,',',7 )as kwhr_final  from dbrtftyrv2.eg_tr_15minute  where hour_id  between  PAR_IN_DATE_S and PAR_IN_DATE_ST  
		)tb 
        inner join dbrtftyav2.eg_ms_meter meter on tb.meter_id = meter.meter_id
        LEFT JOIN dbrtftyav2.egelp_ms_bill bill ON substr(tb.hour_id,1,6) = bill.bill_id
        group by meter_id ) as listbill;
	ELSE 
		select * ,
			round(peak_demand * bill_kw,2) as total_demand ,
			round((kwhr_final - kwhr_begin ) * bill_unit,2) as total_unit ,
            round((kwhr_final - kwhr_begin ) * bill_ft,2) as total_ft
        from (
		select  tb.hour_id , 
				tb.meter_id ,
                meter.meter_name,
				max(kw)peak_demand ,
				min(CASE WHEN kwhr_final >0 THEN kwhr_final END)kwhr_begin ,
				max(kwhr_final)kwhr_final,
                bill_unit,
				bill_kw,
				bill_service,
				bill_ft,
				bill_vat
		from( 
			select concat(hour_id,'00')hour_id ,meter_id ,SPLIT_DECIMAL(eg_00,',',1 )  as kw ,SPLIT_DECIMAL(eg_00,',',7 )as kwhr_final  from dbrtftyrv2.eg_tr_15minute  where hour_id  between  PAR_IN_DATE_S and PAR_IN_DATE_ST    
			union all
			select concat(hour_id,'15')hour_id ,meter_id ,SPLIT_DECIMAL(eg_15,',',1  )askw , SPLIT_DECIMAL(eg_15,',',7 )as kwhr_final  from dbrtftyrv2.eg_tr_15minute  where hour_id  between  PAR_IN_DATE_S and PAR_IN_DATE_ST    
			union all
			select concat(hour_id,'30')hour_id ,meter_id ,SPLIT_DECIMAL(eg_30,',',1 ) as kw, SPLIT_DECIMAL(eg_30,',',7 )as kwhr_final  from dbrtftyrv2.eg_tr_15minute  where hour_id  between  PAR_IN_DATE_S and PAR_IN_DATE_ST    
			union all
			select concat(hour_id,'45')hour_id,meter_id ,SPLIT_DECIMAL(eg_45,',',1 ) as kw, SPLIT_DECIMAL(eg_45,',',7 )as kwhr_final  from dbrtftyrv2.eg_tr_15minute  where hour_id  between  PAR_IN_DATE_S and PAR_IN_DATE_ST  
		)tb 
        inner join dbrtftyav2.eg_ms_meter meter on tb.meter_id = meter.meter_id
        LEFT JOIN dbrtftyav2.egelp_ms_bill bill ON substr(tb.hour_id,1,6) = bill.bill_id
        WHERE tb.meter_id in (PAR_METER_ID)
        group by meter_id ) as listbill;
    END IF;
	
END