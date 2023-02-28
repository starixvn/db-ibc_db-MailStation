
/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" isFunction="0"></info>*/

/*
	Creator: Robert.Tran
	Task: Mail service | Wrong email of user - [Redmine:184390]
	DB: DBMA/bodb_Maintenance
	
	Revision:
		- 20230228@Robert: Correct data of column MailTo[Redmine:184390]
*/



UPDATE m
  SET 
	 m.MailTo = 'aaron.isada@apricustechnology.com;christian.ramirez@apricustechnology.com;dg_csleader@aquozsolutions.com;drake68.iceman@gmail.com;eliza.soledad@apricustechnology.com;enrico.closa@apricustechnology.com;gian.calnea@apricustechnology.com;john.aggabao@apricustechnology.com;josemari.diano@apricustechnology.com;mark.paulino@apricustechnology.com;morechoices2013@gmail.com;nana.wang@apricustechnology.com;niko.lei@apricustechnology.com;salen.liu@apricustechnology.com;sally.xuan@aquozsolutions.com'
FROM Mail_Record m
WHERE 
	 m.MailID IN(1590895, 1591061, 1590961, 1590972, 1590992);

UPDATE m
  SET 
	 m.MailTo = 'erickk@sss-ph.com;grp_csleaders@bss-ph.com;grp_csmanager@bss-ph.com;grp_productnotif@bss-ph.com;hartol@sss-ph.com;joy.lao@bss-ph.com;kho@opus-ph.com;prod@gisd88.com;product_externalnotif@bss-ph.com;riskmanagement-teamleaders@bss-ph.com;riskmanagement@bss-ph.com;rm-gameplay@bss-ph.com;servicedesk@gisd88.com'
FROM Mail_Record m
WHERE 
	 m.MailID IN(1590965, 1590986);

