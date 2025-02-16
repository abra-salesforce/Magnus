global without sharing class SCFuturePay Implements Schedulable {
global void execute(SchedulableContext sc)
	{
		Integer test=1;
		list<Transaction_Card__c> tccs =[Select id,Transaction_Start_Date__c,Payee_id__c,Manual_Transaction__c,Token_Id__c,CC_Expiration_Date__c,No_of_Payments__c,CityForDelivery__c,DeliveryCost__c,AddressForDelivery__c,Account_Addressing__c,Delivery__c,lithium__c,TotalValueBat__c,Rec_Bat_Amount__c,discount__c,BatAmount__c,Registration_Fees__c,Cost_Calculated_Planned_N__c,Trainings__c,Date_Of_Delivery_Device__c,Scheduled_Return_Date__c,Days_Of_Planned_Service__c,Step_Size1__c,Step_Size2__c,Step_Size3__c,Step_Size4__c,Step_Price1__c,Step_Price2__c,Step_Price3__c,Step_Price4__c,Dollar_Exchange_Rate__c from Transaction_Card__c where No_of_payments__c=0 and Manual_Transaction__c=true and Token_Id__c!=null and Transaction_Start_Date__c=:system.today() and Status__c!='לא מעוניין'];
        if(tccs.size()>0)
        {
           ID jobID = System.enqueueJob(new QueFuturePay(tccs[0].id));
        }
    }
}