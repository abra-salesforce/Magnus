public without sharing class AcceptPController {
  Public id Curid;
  Public String Tel;
  Public Account accadd {get;set;}
  Public Transaction_Card__c tcc {get;set;}
  Public Trainings__c tr {get;set;}
  Public String Del {get;set;}
  Public String Ret {get;set;}
  Public String payway {get;set;}
  Public Boolean agr {get;set;}
  Public Boolean err {get;set;}
  public boolean rikushet {get; set;}
  public AcceptPController(ApexPages.StandardController controller)
    {
      agr=false;
      err=false;
      CurId = ApexPages.currentPage().getParameters().get('id');
      Tel = ApexPages.currentPage().getParameters().get('tel');
      tcc=[Select id,Device__c,Program__c,Submit2__c,Manual_Transaction__c,Token_Id__c,CC_Expiration_Date__c,No_of_Payments__c,CityForDelivery__c,DeliveryCost__c,AddressForDelivery__c,Account_Addressing__c,Delivery__c,lithium__c,TotalValueBat__c,Rec_Bat_Amount__c,discount__c,BatAmount__c,Cost_Calculated_Planned_N__c,Maximum_Allowed_Num_Payments__c,Trainings__c,Date_Of_Delivery_Device__c,Scheduled_Return_Date__c,Days_Of_Planned_Service__c,Step_Size1__c,Step_Size2__c,Step_Size3__c,Step_Size4__c,Step_Price1__c,Step_Price2__c,Step_Price3__c,Step_Price4__c,Dollar_Exchange_Rate__c,Affiliate__c from Transaction_Card__c where id=:Curid];
      rikushet = priceController.getRikushet(String.valueof(tcc.Affiliate__c));
      accadd=[select id,Name,PersonEmail,PersonMobilePhone from account where id=:tcc.Account_Addressing__c];
      tr=[select id,name,Date_Time__c from Trainings__c where id=:tcc.Trainings__c];
      Del=tr.Date_Time__c.format();
      Ret=tcc.Scheduled_Return_Date__c.format();
      if(tcc.Manual_Transaction__c==true)
        payway='טלפוני';
      else
        payway='אשראי';
    }
    public PageReference submit()
      {
          err=false;
          if(agr!=true)
            err=true;
          else
          {
            tcc.Submit2__c=true;
            update tcc;
            if(tel=='1')
            {
              String ur='/TelVF';
              PageReference pageRef = new PageReference(ur); //it works
              pageref.setRedirect(true);
              return pageRef;
            }
          }
          return null;
      }
      public PageReference back()
        {
            tcc.Program__c=null;
            update tcc;
            String ur='/pricecalc?id='+Curid+'&device='+tcc.Device__c+'&aff='+tcc.Affiliate__c;
            PageReference pageRef = new PageReference(ur); //it works
            pageref.setRedirect(true);
            return pageRef;
        }
}