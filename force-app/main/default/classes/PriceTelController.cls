public without sharing class PriceTelController {
    Public id Curid;
    Public Transaction_Card__c tcc {get;set;}
    Public Account accadd {get;set;}
    Public PriceMin__c pm {get;set;}
    Public Decimal batp;
    Public integer batpR {get;set;}
    Public Decimal days{get;set;}
    public PriceTelController(ApexPages.StandardController controller)
    {
        batp=0;
        CurId = ApexPages.currentPage().getParameters().get('id');
        tcc=[Select id,CreditAmount__c,CVV__c,Payee_id__c,Manual_Transaction__c,Token_Id__c,CC_Expiration_Date__c,No_of_Payments__c,CityForDelivery__c,DeliveryCost__c,AddressForDelivery__c,Account_Addressing__c,Delivery__c,lithium__c,TotalValueBat__c,Rec_Bat_Amount__c,discount__c,BatAmount__c,Registration_Fees__c,Cost_Calculated_Planned_N__c,Trainings__c,Date_Of_Delivery_Device__c,Scheduled_Return_Date__c,Days_Of_Planned_Service__c,Step_Size1__c,Step_Size2__c,Step_Size3__c,Step_Size4__c,Step_Price1__c,Step_Price2__c,Step_Price3__c,Step_Price4__c,Dollar_Exchange_Rate__c from Transaction_Card__c where id=:Curid];
        accadd=[select id,Name,PersonEmail,PersonMobilePhone from account where id=:tcc.Account_Addressing__c];
        pm=[select MinDays__c from PriceMin__c where name=:'Default' limit 1];
		if(tcc.Date_Of_Delivery_Device__c.daysBetween(tcc.Scheduled_Return_Date__c)+1>pm.MinDays__c)
                days=tcc.Date_Of_Delivery_Device__c.daysBetween(tcc.Scheduled_Return_Date__c)+1;
            else
                days=pm.MinDays__c;
        batp=days/30;
            batpR=integer.valueof(batp.round(System.RoundingMode.UP));
    }
    public void checkmanual()
    {
        if(tcc.Manual_Transaction__c!=true)
        {
            tcc.Manual_Transaction__c=true;
            update tcc;
        }
    }
}