public without sharing class NepalFinesScheduler implements Schedulable {
  public void execute(SchedulableContext sc){
		/*List <Transaction_Card__c> tcs=[Select id,TookFine__c,CurrencyIsoCode,Device__c,Card_Device__c,Date_Of_Return__c,Token_Id__c,CC_Expiration_Date__c,No_of_Payments__c,Cost_Calculated_Planned_N__c,Date_Of_Delivery_Device__c,Scheduled_Return_Date__c,CreatedDate,Account_Passenger__r.Phone,Account_Addressing__r.PersonMobilePhone,Account_Addressing__r.Phone,Account_Addressing__r.Name,Account_Addressing__r.PersonEmail from Transaction_Card__c where TookFine__c=false And Status__c='בטיול - נפאל' And Record_Type_Name_Text__c='נפאל' and Scheduled_Return_Date__c<:System.Today().AddDays(-30)];
		if(tcs.Size()>0)
			ID jobID = System.enqueueJob(new NepalFinesQueue(tcs));*/
	}
}