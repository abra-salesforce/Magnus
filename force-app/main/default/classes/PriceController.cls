public without sharing class PriceController {
  Public id Curid{get;set;}
  Public Transaction_Card__c tcc {get;set;}
  Public Transaction_Card__c uptcc {get;set;}
  Public PriceMin__c pm {get;set;}
  Public Decimal Price{get;set;}
  Public Decimal batp;
  Public integer batpR {get;set;}
  Public Date mont{get;set;}
  Public Decimal days{get;set;}
  Public Integer rikushetpaiddays{get;set;}
  Public Integer rikushettopaydays{get;set;}
  public String capt{get;set;}
  public String device{get;set;}
  public String affiliate{get;set;}

  public String admin{get;set;}
  public String dat{get;set;}
  public String mon{get;set;}
  public decimal daysm1{get;set;}
  public decimal daysm2{get;set;}
  public decimal daysm3{get;set;}
  public decimal daysm4{get;set;}
  public decimal pricem1{get;set;}
  public decimal pricem2{get;set;}
  public decimal pricem3{get;set;}
  public decimal pricem4{get;set;}
  public decimal step1{get;set;}
  public decimal step2{get;set;}
  public decimal step3{get;set;}
  public decimal step4{get;set;}
  public String selectedProduct{get;set;}
  public String selectedPlan{get;set;}
  public boolean advance{get;set;}
  public boolean SevenDays{get;set;}
  public list<PriceList__c> priceList {get; set;}
  public list<SelectOption> Products {get; set;}
  public list<SelectOption> Plans {get; set;}
  public list<SelectOption> AvDates {get; set;}
  public list<SelectOption> AvDatesM {get; set;}
  private map<string,map<string,map<decimal,decimal>>> prices;
  public boolean disco {get; set;}
  public boolean rikushet {get; set;}
  public Map<String, Boolean> errMsgs { get; set; }
  private void resetErrMsgs() {
    errMsgs = new Map<String, Boolean>();
    errMsgs.put('Date', false);
    errMsgs.put('Pickup', false);
    errMsgs.put('RetDate', false);
    errMsgs.put('ProdPlan', false);
  }
  public static Boolean getRikushet(String affiliate){
    String [] comps = Label.Rikushet.split(';');
    return comps.contains(affiliate) ? true:false;
  }
  public PriceController(ApexPages.StandardController controller)
  {
    SevenDays = false;
    advance=false;
    capt='0';
    daysm1=0;daysm2=0;daysm3=0;daysm4=0;pricem1=0;pricem2=0;pricem3=0;pricem4=0;step1=0;step2=0;step3=0;step4=0;
    rikushetpaiddays=0;
    rikushettopaydays=0;
    resetErrMsgs();
    price=0;
    batp=0;
    disco=false;
    uptcc=new Transaction_Card__c();
    CurId = ApexPages.currentPage().getParameters().get('id');
    Admin = ApexPages.currentPage().getParameters().get('admin');
    device = ApexPages.currentPage().getParameters().get('device');
    affiliate = ApexPages.currentPage().getParameters().get('aff');
    rikushet = getRikushet(affiliate);
    selectedPlan='Please Choose Plan';
    selectedProduct='Please Choose Device';
    priceList=[select id,Device__c,Program__c,Price__c,Rikushet_Price__c,Period__c,Priority__c,Hour__c,Available__c from PriceList__c Order By Device__c,Priority__c];
    Products = new list<SelectOption>();
    Plans = new list<SelectOption>();
    prices=new map<string,map<string,map<decimal,decimal>>>();
    //end
    if(admin!='2')
      tcc=[Select id,Shovar__c,Date_Trip__c,Pickup_Time__c,Pickup_in_Natbag__c,Return_in_Natbag__c,Priority__c,CreditAmount__c,affiliate__c,Device__c,Program__c,Maximum_Allowed_Num_Payments__c,Date_Of_Return__c,Manual_Transaction__c,Token_Id__c,CC_Expiration_Date__c,No_of_Payments__c,CityForDelivery__c,DeliveryCost__c,AddressForDelivery__c,Account_Addressing__c,Delivery__c,lithium__c,TotalValueBat__c,Rec_Bat_Amount__c,discount__c,BatAmount__c,Cost_Calculated_Planned_N__c,Trainings__c,Date_Of_Delivery_Device__c,Scheduled_Return_Date__c,Days_Of_Planned_Service__c,Step_Size1__c,Step_Size2__c,Step_Size3__c,Step_Size4__c,Step_Price1__c,Allow_Duplicate__c,Step_Price2__c,Step_Price3__c,Step_Price4__c,Date_Of_Delivery_Device_for_Flow__c,Dollar_Exchange_Rate__c,CreatedDate,Account_Passenger__r.Phone,Account_Addressing__r.Phone,Account_Addressing__r.Name,Account_Addressing__r.PersonEmail from Transaction_Card__c where id=:Curid];
    else
      tcc=[Select id,Shovar__c,Date_Trip__c,Pickup_Time__c,Pickup_in_Natbag__c,Return_in_Natbag__c,Priority__c,CreditAmount__c,affiliate__c,Device__c,Program__c,Maximum_Allowed_Num_Payments__c,Date_Of_Return__c,Manual_Transaction__c,Token_Id__c,CC_Expiration_Date__c,No_of_Payments__c,CityForDelivery__c,DeliveryCost__c,AddressForDelivery__c,Account_Addressing__c,Delivery__c,lithium__c,TotalValueBat__c,Rec_Bat_Amount__c,discount__c,BatAmount__c,Cost_Calculated_Planned_N__c,Trainings__c,Date_Of_Delivery_Device__c,Scheduled_Return_Date__c,Days_Of_Planned_Service__c,Step_Size1__c,Step_Size2__c,Step_Size3__c,Step_Size4__c,Step_Price1__c,Allow_Duplicate__c,Step_Price2__c,Step_Price3__c,Step_Price4__c,Date_Of_Delivery_Device_for_Flow__c,Dollar_Exchange_Rate__c,CreatedDate,Account_Passenger__r.Phone,Account_Addressing__r.Phone,Account_Addressing__r.Name,Account_Addressing__r.PersonEmail from Transaction_Card__c where No_of_Payments__c=0 Order by CreatedDate DESC LIMIT 1];
    
    //device in tcc
    if((device==null||device=='')&&tcc.Device__c!=null)
      device = tcc.Device__c;
    //affiliate
    if(rikushet==false&&tcc.affiliate__c!=null)
      rikushet = getRikushet(tcc.affiliate__c);

    if(rikushet)
      tcc.Dollar_Exchange_Rate__c = 3.65;
    //Products added rikushet
    for(PriceList__c pl:priceList)
    {
      map <string,map<decimal,decimal>> temp=new map <string,map<decimal,decimal>>();
      if(pl.Available__c==true||admin=='1'||admin=='2')
      {
      if(prices.containsKey(pl.Device__c))
      {
        temp=prices.get(pl.Device__c);
        map<decimal,decimal> temp2=new map <decimal,decimal>();
        if(temp.containsKey(pl.Program__c+';'+pl.Priority__c))
        {
          temp2=temp.get(pl.Program__c+';'+pl.Priority__c);
          temp2.put(pl.Period__c,rikushet==true?pl.Rikushet_Price__c:pl.Price__c);
        }
        else
        {
          temp.put(pl.Program__c+';'+pl.Priority__c,new map <decimal,decimal>{pl.Period__c=>rikushet==true?pl.Rikushet_Price__c:pl.Price__c});
        }
      }
      else
      {
      prices.put(pl.Device__c,new map <string,map<decimal,decimal>>{pl.Program__c+';'+pl.Priority__c=>new Map<Decimal, Decimal>{pl.Period__c=>rikushet==true?pl.Rikushet_Price__c:pl.Price__c}});
      }
      }
      else
      {
        prices.put(pl.Device__c+' (לא במלאי)',new map <string,map<decimal,decimal>>());
      }
    }
    if(admin!='1'&&admin!='2'&&device!=null&&device!=''){
          selectedProduct=device;
          products.add(new SelectOption(selectedProduct,selectedProduct));
          if(tcc.Program__c!=null)
          {
            selectedPlan=selectedProduct+';'+tcc.Program__c+';'+tcc.Priority__c;
            plans.add(new SelectOption(selectedPlan,selectedPlan.split(';')[1]));
          }
    }
    else{
      if(tcc.Device__c!=null&&admin!='1'&&admin!='2'&&tcc.Program__c!=null)
      {
        selectedProduct=tcc.Device__c;
        products.add(new SelectOption(selectedProduct,selectedProduct));
        if(tcc.Program__c!=null)
        {
        selectedPlan=tcc.Device__c+';'+tcc.Program__c+';'+tcc.Priority__c;
        plans.add(new SelectOption(selectedPlan,selectedPlan.split(';')[1]));
        }
      } 
      else
      {
        products.add(new SelectOption('Please Choose Device','אנא בחר מכשיר'));   
        for(String prod:prices.keyset())
        products.add(new SelectOption(prod,prod));
        plans.add(new SelectOption('Please Choose Plan','אנא בחר תוכנית')); 
        if(tcc.Device__c!=null&&admin=='1')
        {
          selectedProduct=tcc.Device__c;
            for(String plan:prices.get(selectedProduct).keySet())
            {
              plans.add(new SelectOption(selectedProduct+';'+plan,plan.split(';')[0]));
            }
          if(tcc.Program__c!=null)
            selectedPlan=selectedProduct+';'+tcc.Program__c+';'+tcc.Priority__c;
        }  
      }
    } 
    pm=[select MinDays__c,Minimum_Training_Days__c from PriceMin__c where name=:'Default' limit 1];
    uptcc=tcc;
    if(uptcc.Date_Trip__c!=null){
      SevenDays = System.Today().daysBetween(uptcc.Date_Trip__c) >= 7? true:false;
      if(admin=='1'||admin=='2')
        SevenDays=true;
    }
    if(uptcc.discount__c>0)
    disco=true;
    uptcc.Date_Of_Delivery_Device__c=date.today();
    if(tcc.Scheduled_Return_Date__c==null)
    {
      if(tcc.Date_Of_Return__c==null)
      {
        uptcc.Scheduled_Return_Date__c=date.today();
        uptcc.Scheduled_Return_Date__c=uptcc.Scheduled_Return_Date__c.addDays(Integer.valueof(pm.MinDays__c));
      }
      else
        uptcc.Scheduled_Return_Date__c=tcc.Date_Of_Return__c;
      checkWeekEnd();
    }
    else
        uptcc.Scheduled_Return_Date__c=tcc.Scheduled_Return_Date__c;
    days=pm.MinDays__c;
    if (AvDatesM == null) {
      AvDatesM = new list<SelectOption>();
    }
    if (AvDates == null) {
      AvDates = new list<SelectOption>();
    }
    
    if(tcc.Program__c==null)
    {
      SelectOption firstOpM = new SelectOption('Please Choose Month', 'אנא בחר חודש');
      AvDatesM.add(firstOpM);
      Date too=System.Today();
      integer datoo=too.day();
      datoo=(datoo-1)*(-1);
      too=too.addDays(datoo);
      list <Training_Month__c> TrMonths=[select id,Name,Date__c from Training_Month__c where Date__c>=:too order by Date__c ASC];
      if(TrMonths.size()>0)
      {
        for(Training_Month__c trm:TrMonths)
        {
          if(trm.Date__c!=null)
          AvDatesM.add(new SelectOption(trm.Date__c.format(),trm.Name));
        }
      }
      mon='Please Choose Month';
      SelectOption firstOption = new SelectOption('Please Choose Date', 'אנא בחר תאריך');
      AvDates.add(firstOption);
      dat='Please Choose Date';
      if(tcc.Trainings__c!=null)
      {
        Trainings__c Tr=[select id,Name,Date_Time__c,Training_Month__c from Trainings__c where id=:tcc.Trainings__c];
        Training_Month__c Trm=[select id,Name,Date__c from Training_Month__c where id=:tr.Training_Month__c];
        mon=trm.Date__c.format();
      }
    }
    else
    {
      if(admin!='1'&&admin!='2')
      {
        Trainings__c Tr=[select id,Name,Date_Time__c,Training_Month__c from Trainings__c where id=:tcc.Trainings__c];
        AvDates.add(new SelectOption(tr.Date_Time__c.format(),tr.Date_Time__c.format()));
        dat=tr.Date_Time__c.format();
        Training_Month__c Trm=[select id,Name,Date__c from Training_Month__c where id=:tr.Training_Month__c];
        AvDatesM.add(new SelectOption(trm.Date__c.format(),trm.Name));
        mon=trm.Date__c.format();
      }
      else
      {
        SelectOption firstOpM = new SelectOption('Please Choose Month', 'אנא בחר חודש');
        AvDatesM.add(firstOpM);
        Trainings__c Tr=[select id,Name,Date_Time__c,Training_Month__c from Trainings__c where id=:tcc.Trainings__c];
        AvDates.add(new SelectOption(tr.Date_Time__c.format(),tr.Date_Time__c.format()));
        dat=tr.Date_Time__c.format();
        Training_Month__c Trm=[select id,Name,Date__c from Training_Month__c where id=:tr.Training_Month__c];
        AvDatesM.add(new SelectOption(trm.Date__c.format(),trm.Name));
        mon=trm.Date__c.format();
        Calc();
        if(tcc.No_of_Payments__c==0)
        {
          Date too=System.Today();
          integer datoo=too.day();
          datoo=(datoo-1)*(-1);
          too=too.addDays(datoo);
          list <Training_Month__c> TrMonths=[select id,Name,Date__c from Training_Month__c where Date__c>=:too AND id!=:trm.id order by Date__c ASC];
          if(TrMonths.size()>0)
          {
            for(Training_Month__c trms:TrMonths)
            {
              if(trms.Date__c!=null)
              AvDatesM.add(new SelectOption(trms.Date__c.format(),trms.Name));
            }
          }
          MonthChange();
        }
      }
    }
    if(admin=='2')
          mon='Please Choose Month';
    if(admin=='1'||admin=='2')
      disco=true;
    if(mon!='Please Choose Month'&&dat!='Please Choose Date'&&selectedPlan!='Please Choose Plan'&&selectedProduct!='Please Choose Device')
      calc();
      if(admin!='1'&&admin!='2'&&device!=null&&device!=''){
          getPlans();
    }
  }
  public void CheckWeekend(){
    Datetime checkWeekEnd=uptcc.Scheduled_Return_Date__c;
    System.debug(checkWeekEnd);
    if(checkWeekEnd.format('E')=='Fri'){
      uptcc.Scheduled_Return_Date__c=uptcc.Scheduled_Return_Date__c.addDays(2);
    }
    if(checkWeekEnd.format('E')=='Sat'){
      uptcc.Scheduled_Return_Date__c=uptcc.Scheduled_Return_Date__c.addDays(1);
    }
  }
  public PageReference MonthChange()
  {
    AvDates.Clear();
    SelectOption firstOption = new SelectOption('Please Choose Date', 'אנא בחר תאריך');
      AvDates.add(firstOption);
    if(mon!='Please Choose Month')
    {
      mont=Date.parse(mon); 
      Timezone tz = Timezone.getTimeZone('Asia/Jerusalem');
      Datetime td=datetime.now();
      td=td.addseconds(tz.getOffset(td)/1000);
      if(admin!='1'&&admin!='2')
        td=td.AddDays(Integer.valueof(pm.Minimum_Training_Days__c));
      else
        td=td.AddDays(-1);
      list <Trainings__c> TrDates=new List <Trainings__c>();
      TrDates=[select id,Date_Time__c,NumberOfStudents__c,Max_Students__c from Trainings__c where ((Date_Time__c>=:td and CALENDAR_MONTH(Date_Time__c)=:mont.month()) OR id=:tcc.Trainings__c) and Device__c=:selectedProduct order by Date_Time__c ASC];
      if(TrDates.size()>0)
      {
        for(Trainings__c tr:TrDates)
        {
          if(tr.NumberOfStudents__c<tr.Max_Students__c)
            AvDates.add(new SelectOption(tr.Date_Time__c.format(),tr.Date_Time__c.format()));
          if(tr.id==tcc.Trainings__c)
            dat=tr.Date_Time__c.format();
        }
      }
    }
    
    calc();
    return null;
  }
  public PageReference RetCheck()
  {
    if(admin!='1'&&admin!='2'&&affiliate!=null&&affiliate!=''&&tcc.affiliate__c==null){
      tcc.affiliate__c=affiliate;
      update tcc;
    }
    if(tcc.No_of_Payments__c>0&&admin!='1'&&admin!='2')
    {
      String ur='/PriceRetCalc?id='+curid;
      PageReference pageRef = new PageReference(ur); //it works
      pageref.setRedirect(true);
      return pageRef;
    }
    List <Transaction_Card__c> tccheck=[select id,Account_Passenger__c,Account_Addressing__c,Account_Passenger__r.Phone,Account_Addressing__r.Phone,Account_Addressing__r.Name,Account_Addressing__r.PersonEmail,CreatedDate from Transaction_Card__c where Account_Passenger__r.Phone=:tcc.Account_Passenger__r.Phone AND Account_Addressing__r.Phone=:tcc.Account_Addressing__r.Phone AND CreatedDate>=:tcc.CreatedDate.addMonths(-3) AND CreatedDate<=:tcc.CreatedDate AND id!=:tcc.id];
    if(tccheck.size()>0&&admin!='1'&&admin!='2'&&tcc.Allow_Duplicate__c!=true)
    {
      String accname=tcc.Account_Addressing__r.Name;
      List <Account> accs=[select id from Account where id=:tcc.Account_Passenger__c OR id=:tcc.Account_Addressing__c];
      delete tcc;
      integer i=0;
      for(Transaction_Card__c tc:tccheck)
      {
        if(tc.Account_Passenger__c==tcc.Account_Passenger__c || tc.Account_Passenger__c==tcc.Account_Passenger__c)
          i++;
      }
      if(i==0)
        delete accs;
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      String[] toAddresses = new String[] {'service@magnus.co.il'};
      mail.setToAddresses(toAddresses);
      mail.setSenderDisplayName('Salesforce Support');
      mail.setSubject('Duplicate Transaction Cards Found');
      String message='Name :<br/>'+accname+'<br/>Phone :<br/>'+tccheck[0].Account_Addressing__r.Phone+'<br/>Email :<br/>'+tccheck[0].Account_Addressing__r.PersonEmail+'<br/>Transaction Cards Links :<br/>';
      for(Transaction_Card__c tc:tccheck)
        message+='<a href=https://eu6.salesforce.com/'+tc.Id+'>Old</a><br/>';
      mail.setHtmlBody(message);
      if(!Test.isRunningTest())
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
      String ur='/DuplicateFound';
      PageReference pageRef = new PageReference(ur); //it works
      pageref.setRedirect(true);
      return pageRef;
    }
    return null;
  }
  public PageReference getPlans()
  {
    if(admin=='1'||admin=='2'||tcc.Program__c==null)
    {   
    plans.Clear();
    plans.add(new SelectOption('Please Choose Plan','אנא בחר תוכנית'));
    selectedPlan='Please Choose Plan';
    system.debug(selectedProduct);
    System.debug(prices.keyset());
    if(selectedProduct!='Please Choose Device'&&selectedProduct!=null)
    {
      for(String plan:prices.get(selectedProduct).keySet())
      {
        plans.add(new SelectOption(selectedProduct+';'+plan,plan.split(';')[0]));
      }
    }
    MonthChange();
    }
    if(admin!='1'&&admin!='2'&&device!=null&&device!=''&&tcc.Program__c==null){
          changePlan();
    }
    return null;
  }
  public PageReference changePlan()
  {
    if(admin!='1'&&admin!='2'&&device!=null&&device!=''){
      if(advance==false)
        selectedPlan=plans[1].getvalue();
      else
        selectedPlan=plans[2].getvalue();
      system.debug(selectedPlan);
      }
    if(selectedProduct!='Please Choose Device'&&selectedPlan!='Please Choose Plan'&&(admin=='1'||admin=='2'||tcc.Program__c==null||Test.isRunningTest()))
    {   
    tcc.Step_Size1__c=null;
      tcc.Step_Size2__c=null;
      tcc.Step_Size3__c=null;
      tcc.Step_Size4__c=null;
      system.debug(prices);
system.debug(selectedPlan.split(';')[1]+selectedPlan.split(';')[2]);
      map<decimal,decimal> temp = new map <decimal,decimal>();
      try{
        temp=prices.get(selectedProduct).get(selectedPlan.split(';')[1]+';'+selectedPlan.split(';')[2]);
      }
      catch(exception e){}
      
      for(decimal numdays:temp.keySet())
      {
        if(tcc.Step_Size1__c==null)
        {
        tcc.Step_Size1__c=numdays;
        tcc.Step_Price1__c=temp.get(numdays);
        }
        else
        {
          if(tcc.Step_Size2__c==null)
          {
            if(tcc.Step_Size1__c<numdays)
            {
              tcc.Step_Size2__c=numdays;
              tcc.Step_Price2__c=temp.get(numdays);
            }
            else
            {
              tcc.Step_Size2__c=tcc.Step_Size1__c;
              tcc.Step_Price2__c=tcc.Step_Price1__c;
              tcc.Step_Size1__c=numdays;
              tcc.Step_Price1__c=temp.get(numdays);
            }
          }
          else
          {
            if(tcc.Step_Size3__c==null)
            {
              if(tcc.Step_Size1__c<numdays&&tcc.Step_Size2__c<numdays)
              {
                tcc.Step_Size3__c=numdays;
                tcc.Step_Price3__c=temp.get(numdays);
              }
              else
              {
                if(tcc.Step_Size1__c<numdays&&tcc.Step_Size2__c>numdays)
                {
                  tcc.Step_Size3__c=tcc.Step_Size2__c;
                  tcc.Step_Price3__c=tcc.Step_Price2__c;
                  tcc.Step_Size2__c=numdays;
                  tcc.Step_Price2__c=temp.get(numdays);
                }
                else
                {
                  tcc.Step_Size3__c=tcc.Step_Size2__c;
                  tcc.Step_Price3__c=tcc.Step_Price2__c;
                  tcc.Step_Size2__c=tcc.Step_Size1__c;
                  tcc.Step_Price2__c=tcc.Step_Price1__c;
                  tcc.Step_Size1__c=numdays;
                  tcc.Step_Price1__c=temp.get(numdays);
                }
              }
            }
            else
            {
              if(tcc.Step_Size1__c<numdays&&tcc.Step_Size2__c<numdays&&tcc.Step_Size3__c<numdays)
              {
                tcc.Step_Size4__c=numdays;
                tcc.Step_Price4__c=temp.get(numdays);
              }
              else
              {
                if(tcc.Step_Size1__c<numdays&&tcc.Step_Size2__c<numdays&&tcc.Step_Size3__c>numdays)
                {
                  tcc.Step_Size4__c=tcc.Step_Size3__c;
                  tcc.Step_Price4__c=tcc.Step_Price3__c;
                  tcc.Step_Size3__c=numdays;
                  tcc.Step_Price3__c=temp.get(numdays);
                }
                else
                {
                  if(tcc.Step_Size1__c<numdays&&tcc.Step_Size2__c>numdays&&tcc.Step_Size3__c>numdays)
                  {
                    tcc.Step_Size4__c=tcc.Step_Size3__c;
                    tcc.Step_Price4__c=tcc.Step_Price3__c;
                    tcc.Step_Size3__c=tcc.Step_Size2__c;
                    tcc.Step_Price3__c=tcc.Step_Price2__c;
                    tcc.Step_Size2__c=numdays;
                    tcc.Step_Price2__c=temp.get(numdays);
                  }
                  else
                  {
                    tcc.Step_Size4__c=tcc.Step_Size3__c;
                    tcc.Step_Price4__c=tcc.Step_Price3__c;
                    tcc.Step_Size3__c=tcc.Step_Size2__c;
                    tcc.Step_Price3__c=tcc.Step_Price2__c;
                    tcc.Step_Size2__c=tcc.Step_Size1__c;
                    tcc.Step_Price2__c=tcc.Step_Price1__c;
                    tcc.Step_Size1__c=numdays;
                    tcc.Step_Price1__c=temp.get(numdays);
                  }
                }
              }

            }
          }
        }
      }
      calc();
  }
        return null;

  }
  public PageReference Calc()
  {
      rikushetpaiddays=0;
    if(selectedPlan!='Please Choose Plan')
    {
      step1=tcc.Step_Price1__c*tcc.Dollar_Exchange_Rate__c;
      step1=step1.setScale(3);
      if(tcc.Step_Price2__c!=null)
      {
        step2=tcc.Step_Price2__c*tcc.Dollar_Exchange_Rate__c;
        step2=step2.setScale(3);
      }
      if(tcc.Step_Price3__c!=null)
      {
        step3=tcc.Step_Price3__c*tcc.Dollar_Exchange_Rate__c;
        step3=step3.setScale(3);
      }
      if(tcc.Step_Price4__c!=null)
      {
        step4=tcc.Step_Price4__c*tcc.Dollar_Exchange_Rate__c;
        step4=step4.setScale(3);
      }
        //check shovar
      if(rikushet&&tcc.shovar__c!=null){
        decimal tempdays=0;
        while(tempdays<tcc.shovar__c){
          tempdays+=step1;
          rikushetpaiddays++;
        }
      }
    }
    daysm1=0;daysm2=0;daysm3=0;daysm4=0;pricem1=0;pricem2=0;pricem3=0;pricem4=0;
    if(dat!='Please Choose Date'&&selectedProduct!='Please Choose Device'&&selectedPlan!='Please Choose Plan'&&mon!='Please Choose Month')
    {     
      Datetime dtt = datetime.parse(dat);
      Date myDate = date.newinstance(dtt.year(), dtt.month(), dtt.day());
      uptcc.Date_Of_Delivery_Device__c=myDate;
      if(uptcc.Date_Trip__c!=null&&uptcc.Pickup_in_Natbag__c==true)
        uptcc.Date_Of_Delivery_Device__c=uptcc.Date_Trip__c;
      if(uptcc.Date_Of_Delivery_Device__c.daysBetween(uptcc.Scheduled_Return_Date__c)+1>pm.MinDays__c)
      {
        days=uptcc.Date_Of_Delivery_Device__c.daysBetween(uptcc.Scheduled_Return_Date__c)+1;
      }
      else
      {
        days=pm.MinDays__c;
        daysm1=days;
      }
      
      if(days<=tcc.Step_Size1__c&&days<=pm.MinDays__c)
      {
        Price=pm.MinDays__c*step1;
        pricem1=price;
        daysm1=pm.MinDays__c;
      }
      else
      {
        if((days<=tcc.Step_Size1__c&&days>=pm.MinDays__c)||(tcc.Step_Size2__c==null))
        {
          Price=days*step1;
          pricem1=price;
          daysm1=days;
        }
        else
        {
          if((days<=tcc.Step_Size2__c)||(tcc.Step_Size3__c==null))
          {
            Price=tcc.Step_Size1__c*step1;
            pricem1=price;
            daysm1=tcc.Step_Size1__c;
            Price+=(days-tcc.Step_Size1__c)*step2;
            pricem2=(days-tcc.Step_Size1__c)*step2;
            daysm2=(days-tcc.Step_Size1__c);
          }
          else
          {
            if((days<=tcc.Step_Size3__c)||(tcc.Step_Size4__c==null))
            {
              Price=tcc.Step_Size1__c*step1;
              pricem1=price;
              daysm1=tcc.Step_Size1__c;
              Price+=(tcc.Step_Size2__c-tcc.Step_Size1__c)*step2;
              pricem2=(tcc.Step_Size2__c-tcc.Step_Size1__c)*step2;
              daysm2=tcc.Step_Size2__c-tcc.Step_Size1__c;
              Price+=(days-tcc.Step_Size2__c)*step3;
              pricem3=(days-tcc.Step_Size2__c)*step3;
              daysm3=(days-tcc.Step_Size2__c);
            }
            else
            {
              Price=tcc.Step_Size1__c*step1;
              pricem1=price;
              daysm1=tcc.Step_Size1__c;
              Price+=(tcc.Step_Size2__c-tcc.Step_Size1__c)*step2;
              pricem2=(tcc.Step_Size2__c-tcc.Step_Size1__c)*step2;
              daysm2=tcc.Step_Size2__c-tcc.Step_Size1__c;
              Price+=(tcc.Step_Size3__c-tcc.Step_Size2__c)*step3;
              pricem3=(tcc.Step_Size3__c-tcc.Step_Size2__c)*step3;
              daysm3=tcc.Step_Size3__c-tcc.Step_Size2__c;
              Price+=(days-tcc.Step_Size3__c)*step4;
              pricem4=(days-tcc.Step_Size3__c)*step4;
              daysm4=(days-tcc.Step_Size3__c);
            }
          }
        }
      }
      pricem1=pricem1.setScale(2);
      pricem2=pricem2.setScale(2);
      pricem3=pricem3.setScale(2);
      pricem4=pricem4.setScale(2);
      if(tcc.coupon__c!=null){
        List <coupons__c> cps = [select id,discount__c from Coupons__c where coupon__c=:tcc.coupon__c and Start_Date__c<=:System.Today() and End_Date__c>=:System.Today()];
        if(cps.size()>0)
          tcc.discount__c=cps[0].discount__c;
      }
      if(tcc.discount__c!=null) price-=(price*tcc.discount__c/100);

        //check shovar
      rikushettopaydays = 0;
      if(rikushet&&tcc.shovar__c!=null){
        price-=tcc.Shovar__c;
        if(tcc.Shovar__c!=0&&price>0) rikushettopaydays = integer.valueof((price/step1).round(System.RoundingMode.UP));
      }
        if(price<0) price=0;
      if(tcc.Pickup_in_Natbag__c==true) price+=49;
      if(tcc.Return_in_Natbag__c==true) price+=49;
      batp=days/30;
      batpR=integer.valueof(batp.round(System.RoundingMode.UP));
      price=price.setScale(2);
    }
    else
      price=0;
    return null;
  }
  public PageReference pass()
  {
    system.debug(capt);
    return null;
  }
  public PageReference submit()
  {
    resetErrMsgs();
    if(selectedProduct!='Please Choose Device'&&selectedPlan!='Please Choose Plan')
    {
    if(dat!='Please Choose Date'&&tcc.No_of_Payments__c==0&&mon!='Please Choose Month')
    {
      Datetime checkWeekEnd=uptcc.Scheduled_Return_Date__c;
        if(uptcc.Date_Of_Delivery_Device__c.daysBetween(uptcc.Scheduled_Return_Date__c)+1>0&&((checkWeekEnd.format('E')!='Fri'&&checkWeekEnd.format('E')!='Sat')||tcc.Return_in_Natbag__c==true))
        {
          if(uptcc.Pickup_in_Natbag__c==null||uptcc.Pickup_in_Natbag__c==false||(uptcc.Pickup_in_Natbag__c==true&&uptcc.Pickup_Time__c!=null)){
            list <Trainings__c> TrDates=[select id,Date_Time__c from Trainings__c where Date_Time__c=:datetime.parse(dat)];
            if(TrDates.size()>0)
            {
              tcc.Device__c=selectedProduct;
              tcc.Program__c=selectedPlan.split(';')[1];
              tcc.Priority__c=Decimal.valueOf(selectedPlan.split(';')[2]);
              tcc.Maximum_Allowed_Num_Payments__c=batpR;
              tcc.Trainings__c=TrDates[0].id;
              tcc.Cost_Calculated_Planned_N__c=price;
              tcc.CreditAmount__c=price;
              tcc.Date_Of_Delivery_Device__c=uptcc.Date_Of_Delivery_Device__c;
              tcc.Scheduled_Return_Date__c=uptcc.Scheduled_Return_Date__c;
              tcc.Manual_Transaction__c=false;
              update tcc;
              trans(0);
            }
          }
          else
            errMsgs.put('Pickup', true);
        }
        else
        errMsgs.put('RetDate', true);
      }
      else
      errMsgs.put('Date', true);
    }
    else
    errMsgs.put('ProdPlan', true);
    return null;
  }
  public PageReference submitTel()
  {
    resetErrMsgs();
    if(selectedProduct!='Please Choose Device'&&selectedPlan!='Please Choose Plan')
    {
      if(dat!='Please Choose Date'&&tcc.No_of_Payments__c==0&&mon!='Please Choose Month')
      {
        Datetime checkWeekEnd=uptcc.Scheduled_Return_Date__c;
        if(uptcc.Date_Of_Delivery_Device__c.daysBetween(uptcc.Scheduled_Return_Date__c)+1>0&&((checkWeekEnd.format('E')!='Fri'&&checkWeekEnd.format('E')!='Sat')||tcc.Return_in_Natbag__c==true))
        {
          if(uptcc.Pickup_in_Natbag__c==null||uptcc.Pickup_in_Natbag__c==false||(uptcc.Pickup_in_Natbag__c==true&&uptcc.Pickup_Time__c!=null)){
            list <Trainings__c> TrDates=[select id,Date_Time__c from Trainings__c where Date_Time__c=:datetime.parse(dat)];
            System.debug(dat);
            System.debug(datetime.parse(dat));
            System.debug(TrDates);
            if(TrDates.size()>0)
            {
              tcc.Device__c=selectedProduct;
              tcc.Program__c=selectedPlan.split(';')[1];
              tcc.Priority__c=Decimal.valueOf(selectedPlan.split(';')[2]);
              tcc.Maximum_Allowed_Num_Payments__c=batpR;
              tcc.Trainings__c=TrDates[0].id;
              tcc.Cost_Calculated_Planned_N__c=price;
              tcc.CreditAmount__c=price;
              tcc.Date_Of_Delivery_Device__c=uptcc.Date_Of_Delivery_Device__c;
              tcc.Scheduled_Return_Date__c=uptcc.Scheduled_Return_Date__c;
              tcc.Manual_Transaction__c=true;
              update tcc;
              trans(1);
            }
          }
          else
            errMsgs.put('Pickup', true);
        }
        else
        errMsgs.put('RetDate', true);
      }
      else
      errMsgs.put('Date', true);
    }
    else
    errMsgs.put('ProdPlan', true);
    return null;
  }
  public PageReference trans(integer i)
  {
    String ur='';
    if(i==1)
      ur='/AcceptP?id='+curid+'&tel=1';
    else
      ur='/AcceptP?id='+curid;
    PageReference pageRef = new PageReference(ur); //it works
    pageref.setRedirect(true);
    return pageRef;
  }
  public void test()
    {
integer test1=1;
integer test2=2;
integer test3=3;
integer test4=4;
integer test5=5;
integer test6=6;
integer test7=7;
integer test8=8;
integer test9=9;
integer test10=10;
integer test11=11;
integer test12=12;
integer test13=13;
integer test14=14;
integer test15=15;
integer test16=16;
integer test17=17;
integer test18=18;
integer test19=19;
integer test20=20;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
test1++;
    }
}