@isTest(seealldata=true)
public with sharing class MonthinDest_Test {
	static testMethod void Test()
	{
		Transaction_Card__c tcc = [select id,Return_Date_Updated__c from Transaction_Card__c where Status__c='טיול' and Date_Trip__c!=null and Return_Date_Updated__c!=null limit 1];
		tcc.Return_Date_Updated__c=tcc.Return_Date_Updated__c.addMonths(1);
		update tcc;
	}
}