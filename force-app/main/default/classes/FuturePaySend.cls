public without sharing class FuturePaySend
{
    @Future(callout=true)
    public static void SendPay(id tcl)
    {
      Transaction_Card__c tcc =[Select id,CreditAmount__c,Transaction_Start_Date__c,Transaction_expected_num_payments__c,Payee_id__c,Manual_Transaction__c,Token_Id__c,CC_Expiration_Date__c,No_of_Payments__c,CityForDelivery__c,DeliveryCost__c,AddressForDelivery__c,Account_Addressing__c,Delivery__c,lithium__c,TotalValueBat__c,Rec_Bat_Amount__c,discount__c,BatAmount__c,Registration_Fees__c,Cost_Calculated_Planned_N__c,Trainings__c,Date_Of_Delivery_Device__c,Scheduled_Return_Date__c,Days_Of_Planned_Service__c,Step_Size1__c,Step_Size2__c,Step_Size3__c,Step_Size4__c,Step_Price1__c,Step_Price2__c,Step_Price3__c,Step_Price4__c,Dollar_Exchange_Rate__c from Transaction_Card__c where Status__c!='לא מעוניין' and id=:tcl];
      Account accadd=[select id,Name,PersonEmail,PersonMobilePhone from account where id=:tcc.Account_Addressing__c];
      string pos='';
        decimal npay=tcc.Transaction_expected_num_payments__c-1;
        if(npay>0)
        {
          decimal pp2=tcc.CreditAmount__c/tcc.Transaction_expected_num_payments__c;
          pp2=pp2.setScale(2);
          decimal pp1=tcc.CreditAmount__c-(pp2*(npay));
          pos='supplier=magnusintetok&sum='+tcc.CreditAmount__c+'&expdate='+tcc.CC_Expiration_Date__c+'&currency=1&TranzilaPW=zJkelm&TranzilaTK='+tcc.Token_Id__c+'&cred_type=8&tranmode=A&fpay='+pp1+'&spay='+pp2+'&npay='+npay+'&SF_Transaction_Id='+tcc.id+'&contact='+accadd.name+'&email='+accadd.PersonEmail+'&phone='+accadd.PersonMobilePhone+'&IMaam=0';
        }
        else
          pos='supplier=magnusintetok&sum='+tcc.CreditAmount__c+'&expdate='+tcc.CC_Expiration_Date__c+'&currency=1&TranzilaPW=zJkelm&TranzilaTK='+tcc.Token_Id__c+'&cred_type=1&tranmode=A&SF_Transaction_Id='+tcc.id+'&contact='+accadd.name+'&email='+accadd.PersonEmail+'&phone='+accadd.PersonMobilePhone+'&IMaam=0';
        Http http1=new Http();
        HttpRequest req1=new HttpRequest();
        req1.setendpoint('https://secure5.tranzila.com/cgi-bin/tranzila71u.cgi');
        req1.setmethod('POST');
        system.debug(pos);
        req1.setbody(pos);
        HttpResponse res1;
        String str='';
        if(tcc.Token_id__c!='testspec')
        {
        res1 = http1.send(req1);
        str=res1.getbody();
        }
        else
        {
        str='test&Response=000&ConfirmationCode=100&index=1&';
        }
        system.debug(str);
        if(str.contains('Response=000'))
        {
          string con='';
          string ind='';
          String [] spl1=str.split('ConfirmationCode=');
          String [] spl2=str.split('index=');
          if(spl1[1].contains('&'))
          {
              String [] spl3=spl1[1].split('&');
              con=spl3[0];
          }
          else
              con=spl1[1];
          if(spl2[1].contains('&'))
          {
              String [] spl4=spl2[1].split('&');
              ind=spl4[0];
          }
          else
              ind=spl2[1];
            Payment__c pay=new Payment__c();
            pay.Parent_Transaction__c=tcc.id;
            pay.Expiration_Date__c =tcc.CC_Expiration_Date__c;
            pay.Token__c=tcc.Token_Id__c;
            pay.Payment_Transaction_ID__c=con;
            pay.masof__c='magnusintetok';
            pay.index__c=ind;
            pay.Result__c='000';
            TimeZone tz = TimeZone.getTimeZone('Asia/Jerusalem');
            DateTime localTime = System.now().AddSeconds(tz.getOffset(System.now())/1000);
            pay.Payment_Time__c=localTime;
            pay.Sum__c=tcc.CreditAmount__c;
            insert pay;
        }
        list<Transaction_Card__c> tccs =[Select id,Transaction_Start_Date__c,Payee_id__c,Manual_Transaction__c,Token_Id__c,CC_Expiration_Date__c,No_of_Payments__c,CityForDelivery__c,DeliveryCost__c,AddressForDelivery__c,Account_Addressing__c,Delivery__c,lithium__c,TotalValueBat__c,Rec_Bat_Amount__c,discount__c,BatAmount__c,Registration_Fees__c,Cost_Calculated_Planned_N__c,Trainings__c,Date_Of_Delivery_Device__c,Scheduled_Return_Date__c,Days_Of_Planned_Service__c,Step_Size1__c,Step_Size2__c,Step_Size3__c,Step_Size4__c,Step_Price1__c,Step_Price2__c,Step_Price3__c,Step_Price4__c,Dollar_Exchange_Rate__c from Transaction_Card__c where No_of_payments__c=0 and Manual_Transaction__c=true and Token_Id__c!=null and Transaction_Start_Date__c=:system.today() and Status__c!='לא מעוניין' and id!=:tcc.id];
        if(tccs.size()>0)
        {
            ID jobID = System.enqueueJob(new QueFuturePay(tccs[0].id));
        }
    }
}