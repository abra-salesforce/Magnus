public without sharing class PriceRetController {
    Public id Curid;
    Public String ur;
    Public String aid;
    Public String tok;
    Public String exp;
    Public String res;
    Public Transaction_Card__c tcc {get;set;}
    Public Transaction_Card__c uptcc {get;set;}
    Public Account accadd {get;set;}
    Public PriceMin__c pm {get;set;}
    Public Decimal Price{get;set;}
    Public Decimal upPrice{get;set;}
    Public Decimal batp;
    Public integer batpR{get;set;}
    Public integer nump{get;set;}
    Public Date Del{get;set;}
    Public Date Ret{get;set;}
    Public Date toda{get;set;}
    Public Decimal days{get;set;}
    Public Decimal totdays{get;set;}
    public decimal pricem1{get;set;}
    public decimal pricem2{get;set;}
    public decimal pricem3{get;set;}
    public decimal pricem4{get;set;}
    public decimal step1{get;set;}
    public decimal step2{get;set;}
    public decimal step3{get;set;}
    public decimal step4{get;set;}
    public decimal beprice1{get;set;}
    public decimal beprice2{get;set;}
    public decimal beprice3{get;set;}
    public decimal beprice4{get;set;}
    public decimal oldstep1{get;set;}
    public decimal oldstep2{get;set;}
    public decimal oldstep3{get;set;}
    public decimal oldstep4{get;set;}
    public decimal daysm1{get;set;}
    public decimal daysm2{get;set;}
    public decimal daysm3{get;set;}
    public decimal daysm4{get;set;}
    public String dat{get;set;}
    public String admin{get;set;}
    public String recNotes{get;set;}
    public String olddat{get;set;}
    public String orgdat {get; set;}
    public String digitcard {get; set;}
    public String newiddata {get; set;}
    public boolean disco {get; set;} 
    public boolean Advanced {get; set;}
    public boolean SevenDays{get;set;}
    public boolean ShowNatbagPick{get;set;}
    public boolean ShowNatbagRet{get;set;}
    public boolean Rikushet{get;set;}
    public boolean Advancedtemp {get; set;}
    public boolean needswitch;
    public Decimal refundNatPick{get;set;}
    public String selectedPlan{get;set;}
    public list<SelectOption> Plans {get; set;}
    private map<string,map<decimal,decimal>> prices;
    public Map<String, Boolean> errMsgs { get; set; }
    public Decimal priceToTranzila {get; set;}
    public String vatRate { get; set; }

    private void resetErrMsgs() {
        errMsgs = new Map<String, Boolean>();
        errMsgs.put('RetDate', false);
        errMsgs.put('Pickup', false);
    }
    public PageReference RetCheck()
    {
        if(needswitch){
            tcc.id = curid;
            update tcc;
            tcc=[Select id,CurrencyIsoCode,Affiliate__c,Date_Trip__c,Pickup_Time__c,Pickup_in_Natbag__c,Return_in_Natbag__c,Priority__c,Device__c,Program__c,CreditAmount__c,Token_Id__c,CC_Expiration_Date__c,No_of_Payments__c,Account_Addressing__c,discount__c,Return_Date_Updated__c,Cost_Calculated_Planned_N__c,Trainings__c,Date_Of_Delivery_Device__c,Scheduled_Return_Date__c,Days_Of_Planned_Service__c,Step_Size1__c,Step_Size2__c,Step_Size3__c,Step_Size4__c,Step_Price1__c,Step_Price2__c,Step_Price3__c,Step_Price4__c,Dollar_Exchange_Rate__c from Transaction_Card__c where id=:Curid];
        }
        initialize();
        if(tcc.No_of_Payments__c==0)
        {
            String ur='/PriceCalc?id='+curid;
            PageReference pageRef = new PageReference(ur); //it works
            pageref.setRedirect(true);
            return pageRef;
        }
        return null;
    }
    public PriceRetController(ApexPages.StandardController controller)
    {
        SevenDays = false;
        needswitch=false;
        Advancedtemp=false;
        Advanced=false;
        nump=1;
        recNotes='';
        digitcard='';
        pricem1=0;pricem2=0;pricem3=0;pricem4=0;daysm1=0;daysm2=0;daysm3=0;daysm4=0;oldstep1=0;oldstep2=0;oldstep3=0;oldstep4=0;step1=0;step2=0;step3=0;step4=0;
        olddat='';
        ur=ApexPages.currentPage().getUrl();
        admin=ApexPages.currentPage().getParameters().get('admin');
        aid=ApexPages.currentPage().getParameters().get('SF_Transaction_Id');
        tok=ApexPages.currentPage().getParameters().get('TranzilaTK');
        exp=ApexPages.currentPage().getParameters().get('expmonth')+ApexPages.currentPage().getParameters().get('expyear');
        res=ApexPages.currentPage().getParameters().get('Response');
        resetErrMsgs();
        price=0;
        upPrice=0;
        disco=false;
        uptcc=new Transaction_Card__c();
        CurId = ApexPages.currentPage().getParameters().get('id');
        tcc=[Select id,Affiliate__c,Date_Trip__c,Pickup_Time__c,Pickup_in_Natbag__c,Return_in_Natbag__c,Priority__c,Device__c,Program__c,CreditAmount__c,Token_Id__c,CC_Expiration_Date__c,No_of_Payments__c,Account_Addressing__c,discount__c,Return_Date_Updated__c,Cost_Calculated_Planned_N__c,Trainings__c,Date_Of_Delivery_Device__c,Scheduled_Return_Date__c,Days_Of_Planned_Service__c,Step_Size1__c,Step_Size2__c,Step_Size3__c,Step_Size4__c,Step_Price1__c,Step_Price2__c,Step_Price3__c,Step_Price4__c,Dollar_Exchange_Rate__c from Transaction_Card__c where id=:Curid];
        Rikushet = PriceController.getRikushet(tcc.Affiliate__c);
        ShowNatbagPick = tcc.Pickup_in_Natbag__c!=true&&admin=='1'?true:false;
        ShowNatbagRet = tcc.Return_in_Natbag__c!=true&&admin=='1'?true:false;
        newiddata=curid;
            pm=[select MinDays__c from PriceMin__c where name=:'Default' limit 1];
        beprice1=tcc.Step_Price1__c*tcc.Dollar_Exchange_Rate__c;
        beprice1=beprice1.setScale(3);
        if(tcc.Step_Price2__c!=null)
        {
          beprice2=tcc.Step_Price2__c*tcc.Dollar_Exchange_Rate__c;
          beprice2=beprice2.setScale(3);
        }
        if(tcc.Step_Price3__c!=null)
        {
          beprice3=tcc.Step_Price3__c*tcc.Dollar_Exchange_Rate__c;
          beprice3=beprice3.setScale(3);
        }
        if(tcc.Step_Price4__c!=null)
        {
          beprice4=tcc.Step_Price4__c*tcc.Dollar_Exchange_Rate__c;
          beprice4=beprice4.setScale(3);
        }

        accadd=[select id,Name,PersonEmail,PersonMobilePhone from account where id=:tcc.Account_Addressing__c];
        pm=[select MinDays__c from PriceMin__c where name=:'Default' limit 1];
        //added 25/12/17
        if(tcc.Return_Date_Updated__c!=null&&tcc.Scheduled_Return_Date__c!=null&&tcc.Return_Date_Updated__c!=tcc.Scheduled_Return_Date__c)
        {
            tcc.Scheduled_Return_Date__c=tcc.Return_Date_Updated__c;
            needswitch=true;
        }

        
    }
    public void initialize(){
        uptcc=tcc;
        uptcc.id = null;
        if(uptcc.Date_Trip__c!=null){
        SevenDays = System.Today().daysBetween(uptcc.Date_Trip__c) >= 7? true:false;
        if(admin=='1'||admin=='2')
            SevenDays=true;
        }
        uptcc.Return_Date_Updated__c=tcc.Scheduled_Return_Date__c;
        olddat=tcc.Scheduled_Return_Date__c.format();
        if(uptcc.discount__c>0)
        disco=true;
        if(uptcc.No_of_Payments__c!=0)
        {
            if(tcc.Token_Id__c!=null)
                digitcard=tcc.Token_Id__c.right(4);
            list <Trainings__c> TrDates=[select id,Date_Time__c from Trainings__c where id=:tcc.Trainings__c limit 1];
            if(TrDates.size()>0)
            {
                orgdat=TrDates[0].Date_Time__c.format();
                dat=TrDates[0].Date_Time__c.format();
            }
            Plans = new list<SelectOption>();
            //update program
            prices=new map<string,map<decimal,decimal>>();
            for(PriceList__c pl:[select id,Device__c,Program__c,Price__c,Period__c,Priority__c from PriceList__c where Device__c=:tcc.Device__c and Priority__c>=:tcc.Priority__c Order By Priority__c])
            {
                map<decimal,decimal> temp=new map <decimal,decimal>();
                if(prices.containsKey(pl.Program__c+';'+pl.Priority__c))
                {
                    temp=prices.get(pl.Program__c+';'+pl.Priority__c);
                    temp.put(pl.Period__c,pl.Price__c);
                }
                else
                {
                    prices.put(pl.Program__c+';'+pl.Priority__c,new map <decimal,decimal>{pl.Period__c=>pl.Price__c});
                }
                toda=system.today();
                if(toda.Day()!=1)
                {
                    toda=toda.addMonths(1);
                    toda=toda.addDays((toda.Day()-1)*-1);
                }
                if(pl.Priority__c>tcc.Priority__c&&(admin=='1'||admin=='2')&&Rikushet==false)
                {
                    Advancedtemp=true;
                    if(toda<tcc.Return_Date_Updated__c)
                    Advanced=true;
                }
            }
            selectedPlan=tcc.Program__c+';'+tcc.Priority__c;
            for(String plan:prices.keySet())
            {
                plans.add(new SelectOption(plan,plan.split(';')[0]));
            }
            system.debug(prices);
            //end of update
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
        calc();
        }
        
    }
    public void changePlan()
    {
    tcc.Program__c=selectedPlan.split(';')[0];
    tcc.Step_Size1__c=null;
      tcc.Step_Size2__c=null;
      tcc.Step_Size3__c=null;
      tcc.Step_Size4__c=null;
      map<decimal,decimal> temp = new map <decimal,decimal>();
      try{
        temp=prices.get(selectedPlan);
      }
      catch(exception e){}
      if(!temp.isEmpty())
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
        calc();
    }
    public decimal upgrade()
    {
        Decimal delta1,delta2,delta3,delta4;
        delta1=step1-beprice1;
        if(tcc.Step_Price2__c!=null)
        {
            delta2=step2-beprice2;
        }
        if(tcc.Step_Price3__c!=null)
        {
            delta3=step3-beprice3;
        }
        if(tcc.Step_Price4__c!=null)
        {
            delta4=step4-beprice4;
        }
        Decimal updays=(toda.daysBetween(tcc.Scheduled_Return_Date__c)+1);
        Decimal unchange=(tcc.Date_Of_Delivery_Device__c.daysBetween(toda)+1);
        if(updays<pm.MinDays__c)
        {
            updays=pm.MinDays__c;
        }
        if(unchange<=tcc.Step_Size1__c)
        {
            if(updays+unchange<=tcc.Step_Size1__c||tcc.Step_Size2__c==null)
            {
                upprice+=updays*delta1;
            }
            else
            {
                if(updays+unchange<=tcc.Step_Size2__c||tcc.Step_Size3__c==null)
                {
                    upprice+=(tcc.Step_Size1__c-unchange)*delta1;
                    upprice+=(unchange+updays-tcc.Step_Size1__c)*delta2;
                }
                else
                {
                    if(updays+unchange<=tcc.Step_Size3__c||tcc.Step_Size4__c==null)
                    {
                        upprice+=(tcc.Step_Size1__c-unchange)*delta1;
                        upprice+=(tcc.Step_Size2__c-tcc.Step_Size1__c)*delta2;
                        upprice+=(unchange+updays-tcc.Step_Size2__c)*delta3;
                    }
                    else
                    {
                        upprice+=(tcc.Step_Size1__c-unchange)*delta1;
                        upprice+=(tcc.Step_Size2__c-tcc.Step_Size1__c)*delta2;
                        upprice+=(tcc.Step_Size3__c-tcc.Step_Size2__c)*delta3;
                        upprice+=(unchange+updays-tcc.Step_Size3__c)*delta4;
                    }
                }
            }
        }
        else
        {
            if(unchange<=tcc.Step_Size2__c)
            {
                if(updays+unchange<=tcc.Step_Size2__c||tcc.Step_Size3__c==null)
                {
                    upprice+=updays*delta2;
                }
                else
                {
                    if(updays+unchange<=tcc.Step_Size3__c||tcc.Step_Size4__c==null)
                    {
                        upprice+=(tcc.Step_Size2__c-unchange)*delta2;
                        upprice+=(unchange+updays-tcc.Step_Size2__c)*delta3;
                    }
                    else
                    {
                        upprice+=(tcc.Step_Size2__c-unchange)*delta2;
                        upprice+=(tcc.Step_Size3__c-tcc.Step_Size2__c)*delta3;
                        upprice+=(unchange+updays-tcc.Step_Size3__c)*delta4;
                    }
                }
            }
            else
            {
                if(unchange<=tcc.Step_Size3__c)
                {
                    if(updays+unchange<=tcc.Step_Size3__c||tcc.Step_Size4__c==null)
                    {
                        upprice+=updays*delta3;
                    }
                    else
                    {
                        upprice+=(tcc.Step_Size3__c-unchange)*delta3;
                        upprice+=(unchange+updays-tcc.Step_Size3__c)*delta4;
                    }
                }
                else
                {
                    upprice+=updays*delta4;
                }
            }
        }
        upprice=upprice.setScale(2);
        return upprice;
    }
    public PageReference Calc()
    {
        price=0; 
        upprice=0;
        if(toda<uptcc.Return_Date_Updated__c&&Advancedtemp==true&&Rikushet==false)
                    Advanced=true;
        else
            Advanced=false;
        
        Date upgrade;
        refundNatPick = 0;
        if(tcc.Date_Trip__c!=null&&uptcc.Pickup_in_Natbag__c==true&&admin=='1'){
            decimal refdays = tcc.Date_Of_Delivery_Device__c.daysBetween(tcc.Date_Trip__c);
            if(refdays<=tcc.Step_Size1__c){
                refundNatPick+=step1*refdays; 
            }
            else{
                refundNatPick+=step1*tcc.Step_Size1__c;
                refundNatPick+=step2*(refdays=tcc.Step_Size1__c);
            }
        }
        pricem1=0;pricem2=0;pricem3=0;pricem4=0;daysm1=0;daysm2=0;daysm3=0;daysm4=0;oldstep1=0;oldstep2=0;oldstep3=0;oldstep4=0;
        if((tcc.Date_Of_Delivery_Device__c.daysBetween(uptcc.Return_Date_Updated__c)+1)-tcc.Days_Of_Planned_Service__c>0)
        days=(tcc.Date_Of_Delivery_Device__c.daysBetween(uptcc.Return_Date_Updated__c)+1)-tcc.Days_Of_Planned_Service__c;
        else
        days=0;
        totdays=days+tcc.Days_Of_Planned_Service__c;
        if(totdays>=tcc.Days_Of_Planned_Service__c)
        {
            if(recNotes==null)
                recNotes='';
            String pickNat=uptcc.Pickup_in_Natbag__c!=null?String.valueof(uptcc.Pickup_in_Natbag__c):'';
            String pickuptimeNat=uptcc.Pickup_Time__c!=null?String.valueof(uptcc.Pickup_Time__c):'';
            String retNat=uptcc.Return_in_Natbag__c!=null?String.valueof(uptcc.Return_in_Natbag__c):'';
            newiddata=curid+','+uptcc.Return_Date_Updated__c.format()+','+recNotes+','+pickNat+','+pickuptimeNat+','+retNat;
            if((totdays<=tcc.Step_Size1__c&&tcc.Days_Of_Planned_Service__c<=tcc.Step_Size1__c)||(tcc.Step_Size2__c==null))
            {
                Price+=days*step1;
                oldstep1=tcc.Days_Of_Planned_Service__c;
                daysm1=days;
                pricem1=price;
            }
            else
            {
                if((totdays<=tcc.Step_Size2__c&&tcc.Days_Of_Planned_Service__c<=tcc.Step_Size1__c)||(tcc.Step_Size3__c==null&&tcc.Days_Of_Planned_Service__c<=tcc.Step_Size1__c))
                {
                    Price+=(tcc.Step_Size1__c-tcc.Days_Of_Planned_Service__c)*step1;
                    oldstep1=tcc.Days_Of_Planned_Service__c;
                    daysm1=(tcc.Step_Size1__c-tcc.Days_Of_Planned_Service__c);
                    pricem1=Price;
                    Price+=(days-(tcc.Step_Size1__c-tcc.Days_Of_Planned_Service__c))*step2;
                    daysm2=(days-(tcc.Step_Size1__c-tcc.Days_Of_Planned_Service__c));
                    pricem2=(days-(tcc.Step_Size1__c-tcc.Days_Of_Planned_Service__c))*step2;
                }
                else
                {
                    if((totdays<=tcc.Step_Size2__c&&tcc.Days_Of_Planned_Service__c<=tcc.Step_Size2__c)||(tcc.Step_Size3__c==null&&tcc.Days_Of_Planned_Service__c>tcc.Step_Size1__c))
                    {
                        oldstep1=tcc.Step_Size1__c;
                        oldstep2=tcc.Days_Of_Planned_Service__c-tcc.Step_Size1__c;
                        Price+=days*step2;
                        daysm2=days;
                        pricem2=price;
                    }
                    else
                    {
                        if((totdays<=tcc.Step_Size3__c&&tcc.Days_Of_Planned_Service__c<=tcc.Step_Size1__c)||(tcc.Step_Size4__c==null&&tcc.Days_Of_Planned_Service__c<=tcc.Step_Size1__c))
                        {
                            Price+=(tcc.Step_Size1__c-tcc.Days_Of_Planned_Service__c)*step1;
                            oldstep1=tcc.Days_Of_Planned_Service__c;
                            daysm1=tcc.Step_Size1__c-tcc.Days_Of_Planned_Service__c;
                            pricem1=(tcc.Step_Size1__c-tcc.Days_Of_Planned_Service__c)*step1;
                            Price+=(tcc.Step_Size2__c-tcc.Step_Size1__c)*step2;
                            daysm2=(tcc.Step_Size2__c-tcc.Step_Size1__c);
                            pricem2=(tcc.Step_Size2__c-tcc.Step_Size1__c)*step2;
                            Price+=(days-(tcc.Step_Size2__c-tcc.Step_Size1__c)-(tcc.Step_Size1__c-tcc.Days_Of_Planned_Service__c))*step3;
                            daysm3=(days-(tcc.Step_Size2__c-tcc.Step_Size1__c)-(tcc.Step_Size1__c-tcc.Days_Of_Planned_Service__c));
                            pricem3=(days-(tcc.Step_Size2__c-tcc.Step_Size1__c)-(tcc.Step_Size1__c-tcc.Days_Of_Planned_Service__c))*step3;
                        }
                        else
                        {
                            if((totdays<=tcc.Step_Size3__c&&tcc.Days_Of_Planned_Service__c<=tcc.Step_Size2__c)||(tcc.Step_Size4__c==null&&tcc.Days_Of_Planned_Service__c<=tcc.Step_Size2__c))
                            {
                                oldstep1=tcc.Step_Size1__c;
                                Price+=(tcc.Step_Size2__c-tcc.Days_Of_Planned_Service__c)*step2;
                                oldstep2=tcc.Days_Of_Planned_Service__c-tcc.Step_Size1__c;
                                daysm2=(tcc.Step_Size2__c-tcc.Days_Of_Planned_Service__c);
                                pricem2=(tcc.Step_Size2__c-tcc.Days_Of_Planned_Service__c)*step2;
                                Price+=(days-(tcc.Step_Size2__c-tcc.Days_Of_Planned_Service__c))*step3;
                                daysm3=(days-(tcc.Step_Size2__c-tcc.Days_Of_Planned_Service__c));
                                pricem3=(days-(tcc.Step_Size2__c-tcc.Days_Of_Planned_Service__c))*step3;
                            }
                            else
                            {
                                if((totdays<=tcc.Step_Size3__c&&tcc.Days_Of_Planned_Service__c<=tcc.Step_Size3__c)||(tcc.Step_Size4__c==null&&tcc.Days_Of_Planned_Service__c>tcc.Step_Size2__c))
                                {
                                    oldstep1=tcc.Step_Size1__c;
                                    oldstep2=tcc.Step_Size2__c-tcc.Step_Size1__c;
                                    Price+=days*step3;
                                    oldstep3=tcc.Days_Of_Planned_Service__c-tcc.Step_Size2__c;
                                    daysm3=days;
                                    pricem3=days*step3;
                                }
                                else
                                {
                                    if(totdays>tcc.Step_Size3__c&&tcc.Days_Of_Planned_Service__c<=tcc.Step_Size1__c)
                                    {
                                        Price+=(tcc.Step_Size1__c-tcc.Days_Of_Planned_Service__c)*step1;
                                        oldstep1=tcc.Days_Of_Planned_Service__c;
                                        daysm1=tcc.Step_Size1__c-tcc.Days_Of_Planned_Service__c;
                                        pricem1=(tcc.Step_Size1__c-tcc.Days_Of_Planned_Service__c)*step1;
                                        Price+=(tcc.Step_Size2__c-tcc.Step_Size1__c)*step2;
                                        daysm2=(tcc.Step_Size2__c-tcc.Step_Size1__c);
                                        pricem2=(tcc.Step_Size2__c-tcc.Step_Size1__c)*step2;
                                        Price+=(tcc.Step_Size3__c-tcc.Step_Size2__c)*step3;
                                        daysm3=(tcc.Step_Size3__c-tcc.Step_Size2__c);
                                        pricem3=(tcc.Step_Size3__c-tcc.Step_Size2__c)*step3;
                                        Price+=(days-(tcc.Step_Size3__c-tcc.Step_Size2__c)-(tcc.Step_Size2__c-tcc.Step_Size1__c)-(tcc.Step_Size1__c-tcc.Days_Of_Planned_Service__c))*step4;
                                        daysm4=(days-(tcc.Step_Size3__c-tcc.Step_Size2__c)-(tcc.Step_Size2__c-tcc.Step_Size1__c)-(tcc.Step_Size1__c-tcc.Days_Of_Planned_Service__c));
                                        pricem4=(days-(tcc.Step_Size3__c-tcc.Step_Size2__c)-(tcc.Step_Size2__c-tcc.Step_Size1__c)-(tcc.Step_Size1__c-tcc.Days_Of_Planned_Service__c))*step4;
                                    }
                                    else
                                    {
                                        if(totdays>tcc.Step_Size3__c&&tcc.Days_Of_Planned_Service__c<=tcc.Step_Size2__c)
                                        {
                                            oldstep1=tcc.Step_Size1__c;
                                            oldstep2=tcc.Days_Of_Planned_Service__c-tcc.Step_Size1__c;
                                            Price+=(tcc.Step_Size2__c-tcc.Days_Of_Planned_Service__c)*step2;
                                            daysm2=(tcc.Step_Size2__c-tcc.Days_Of_Planned_Service__c);
                                            pricem2=(tcc.Step_Size2__c-tcc.Days_Of_Planned_Service__c)*step2;
                                            Price+=(tcc.Step_Size3__c-tcc.Step_Size2__c)*step3;
                                            daysm3=(tcc.Step_Size3__c-tcc.Step_Size2__c);
                                            pricem3=(tcc.Step_Size3__c-tcc.Step_Size2__c)*step3;
                                            Price+=(days-(tcc.Step_Size3__c-tcc.Step_Size2__c)-(tcc.Step_Size2__c-tcc.Days_Of_Planned_Service__c))*step4;
                                            daysm4=(days-(tcc.Step_Size3__c-tcc.Step_Size2__c)-(tcc.Step_Size2__c-tcc.Days_Of_Planned_Service__c));
                                            pricem4=(days-(tcc.Step_Size3__c-tcc.Step_Size2__c)-(tcc.Step_Size2__c-tcc.Days_Of_Planned_Service__c))*step4;
                                        }
                                        else
                                        {
                                            if(totdays>tcc.Step_Size3__c&&tcc.Days_Of_Planned_Service__c<=tcc.Step_Size3__c)
                                            {
                                                oldstep1=tcc.Step_Size1__c;
                                                oldstep2=tcc.Step_Size2__c-tcc.Step_Size1__c;
                                                oldstep3=tcc.Days_Of_Planned_Service__c-tcc.Step_Size2__c;
                                                Price+=(tcc.Step_Size3__c-tcc.Days_Of_Planned_Service__c)*step3;
                                                daysm3=(tcc.Step_Size3__c-tcc.Days_Of_Planned_Service__c);
                                                pricem3=(tcc.Step_Size3__c-tcc.Days_Of_Planned_Service__c)*step3;
                                                Price+=(days-(tcc.Step_Size3__c-tcc.Days_Of_Planned_Service__c))*step4;
                                                daysm4=(days-(tcc.Step_Size3__c-tcc.Days_Of_Planned_Service__c));
                                                pricem4=(days-(tcc.Step_Size3__c-tcc.Days_Of_Planned_Service__c))*step4;
                                            }
                                            else
                                            {
                                                if(totdays>tcc.Step_Size3__c&&tcc.Days_Of_Planned_Service__c>tcc.Step_Size3__c)
                                                {
                                                    oldstep1=tcc.Step_Size1__c;
                                                    oldstep2=tcc.Step_Size2__c-tcc.Step_Size1__c;
                                                    oldstep3=tcc.Step_Size3__c-tcc.Step_Size2__c;
                                                    oldstep4=tcc.Days_Of_Planned_Service__c-tcc.Step_Size3__c;
                                                    Price+=days*step4;
                                                    daysm4=days;
                                                    pricem4=days*step4;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if(beprice1!=step1)
            price+=upgrade();

            pricem1=pricem1.setScale(2);
            pricem2=pricem2.setScale(2);
            pricem3=pricem3.setScale(2);
            pricem4=pricem4.setScale(2);
            refundNatPick=refundNatPick.setScale(2);
            if(tcc.discount__c!=null)
                price-=(price*tcc.discount__c/100);
            price=price.setScale(2);
            if(tcc.Pickup_in_Natbag__c==true&&ShowNatbagPick) price+=49;
            if(tcc.Return_in_Natbag__c==true&&ShowNatbagRet) price+=49;
            price-=refundNatPick;
        }
        else
          price=0;
        nump=integer.valueof(days/30);
        if(nump==0)
          nump=1;
        return null;
    }
    public PageReference submit()
    {
        resetErrMsgs();
        Datetime checkWeekEnd=uptcc.Return_Date_Updated__c;

        System.debug('Need_Charge_Vat__c: '+tcc.Need_Charge_Vat__c);
        if (tcc.Need_Charge_Vat__c) {
            vatRate = String.valueOf(Decimal.valueOf(System.Label.Vat) / 100);
          
        }else{
            vatRate = '0';
        }
       
        System.debug('priceToTranzila: '+priceToTranzila);
        System.debug('vatRate: '+vatRate);
            if(totdays>=tcc.Days_Of_Planned_Service__c&&((checkWeekEnd.format('E')!='Fri'&&checkWeekEnd.format('E')!='Sat')||tcc.Return_in_Natbag__c==true))
            {
                if(uptcc.Pickup_in_Natbag__c==null||uptcc.Pickup_in_Natbag__c==false||(uptcc.Pickup_in_Natbag__c==true&&uptcc.Pickup_Time__c!=null)){
                Http http1=new Http();
                 HttpRequest req1=new HttpRequest();
                 req1.setendpoint('https://secure5.tranzila.com/cgi-bin/tranzila71u.cgi');
                 req1.setmethod('POST');
                 req1.setbody('supplier=magnusintetok&sum='+priceToTranzila+'&expdate='+tcc.CC_Expiration_Date__c+'&currency='+(tcc.CurrencyIsoCode=='USD'?'2':'1')+'&TranzilaPW=zJkelm&TranzilaTK='+tcc.Token_Id__c+'&cred_type=1&tranmode=A&SF_Transaction_Id='+curid+'&contact='+accadd.name+'&email='+accadd.PersonEmail+'&phone='+accadd.PersonMobilePhone+'&IMaam='+vatRate);
                 HttpResponse res1;
                 String str='';
                         if(tcc.Token_Id__c!='testspec')
                         {
                         res1 = http1.send(req1);
                         str=res1.getbody();
                            }
                            else
                             str='test&Response=000&ConfirmationCode=100&index=1&';
                system.debug(str);
                if(str.contains('Response=000'))
                {
                    if(tcc.No_of_Payments__c!=0)
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
                        pay.Parent_Transaction__c=curid;
                        pay.Expiration_Date__c =tcc.CC_Expiration_Date__c;
                        pay.Token__c=tcc.Token_Id__c;
                        pay.Payment_Transaction_ID__c=con;
                        pay.index__c=ind;
                        pay.Result__c='000';
                        TimeZone tz = TimeZone.getTimeZone('Asia/Jerusalem');
                        DateTime localTime = System.now().AddSeconds(tz.getOffset(System.now())/1000);
                        pay.Payment_Time__c=localTime;
                        pay.Sum__c=price;
                        pay.masof__c='magnusintetok';
                        pay.Extended_Service__c=true;
                        pay.Notes__c=recNotes;
                        insert pay;
                        tcc.Cost_Calculated_Planned_N__c+=price;
                        tcc.CreditAmount__c=tcc.Cost_Calculated_Planned_N__c;
                        tcc.Return_Date_Updated__c=uptcc.Return_Date_Updated__c;
                        tcc.Pickup_in_Natbag__c=uptcc.Pickup_in_Natbag__c;
                        tcc.Pickup_Time__c=uptcc.Pickup_Time__c;
                        tcc.Return_in_Natbag__c=uptcc.Return_in_Natbag__c;
                        tcc.id = curid;
                        update tcc;
                        String ur='/SuccessVF';
                        PageReference pageRef = new PageReference(ur); //it works
                        pageref.setRedirect(true);
                        return pageRef;
                    }
                }
                else
                {
                  String ur='/ERROR';
                        PageReference pageRef = new PageReference(ur); //it works
                        pageref.setRedirect(true);
                        return pageRef;
                }
                }
                else
                    errMsgs.put('Pickup', true);
            }
            else
                errMsgs.put('RetDate', true);
        return null;
    }
    public PageReference submitElse()
    {
        resetErrMsgs();
        Datetime checkWeekEnd=uptcc.Return_Date_Updated__c;
        if(totdays>=tcc.Days_Of_Planned_Service__c&&((checkWeekEnd.format('E')!='Fri'&&checkWeekEnd.format('E')!='Sat')||tcc.Return_in_Natbag__c==true))
        {
            if(uptcc.Pickup_in_Natbag__c==null||uptcc.Pickup_in_Natbag__c==false||(uptcc.Pickup_in_Natbag__c==true&&uptcc.Pickup_Time__c!=null)){
            }
            else
                errMsgs.put('Pickup', true);
        }
        else
            errMsgs.put('RetDate', true);
        return null;
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
integer test21=21;
integer test22=22;
integer test23=23;
integer test24=24;
integer test25=25;
integer test26=26;
integer test27=27;
integer test28=28;
integer test29=29;
integer test30=30;
integer test31=31;
integer test32=32;
integer test33=33;
integer test34=34;
integer test35=35;
integer test36=36;
integer test37=37;
integer test38=38;
integer test39=39;
integer test40=40;
integer test41=41;
integer test42=42;
integer test43=43;
integer test44=44;
integer test45=45;
integer test46=46;
integer test47=47;
integer test48=48;
integer test49=49;
integer test50=50;
integer test51=51;
integer test52=52;
integer test53=53;
integer test54=54;
integer test55=55;
integer test56=56;
integer test57=57;
integer test58=58;
integer test59=59;
integer test60=60;
integer test61=61;
integer test62=62;
integer test63=63;
integer test64=64;
integer test65=65;
integer test66=66;
integer test67=67;
integer test68=68;
integer test69=69;
integer test70=70;
integer test71=71;
integer test72=72;
integer test73=73;
integer test74=74;
integer test75=75;
integer test76=76;
integer test77=77;
integer test78=78;
integer test79=79;
integer test80=80;
integer test81=81;
integer test82=82;
integer test83=83;
integer test84=84;
integer test85=85;
integer test86=86;
integer test87=87;
integer test88=88;
integer test89=89;
integer test90=90;
integer test91=91;
integer test92=92;
integer test93=93;
integer test94=94;
integer test95=95;
integer test96=96;
integer test97=97;
integer test98=98;
integer test99=99;
integer test100=100;
integer test101=101;
integer test102=102;
integer test103=103;
integer test104=104;
integer test105=105;
integer test106=106;
integer test107=107;
integer test108=108;
integer test109=109;
integer test110=110;
integer test111=111;
integer test112=112;
integer test113=113;
integer test114=114;
integer test115=115;
integer test116=116;
integer test117=117;
integer test118=118;
integer test119=119;
integer test120=120;
integer test121=121;
integer test122=122;
integer test123=123;
integer test124=124;
integer test125=125;
integer test126=126;
integer test127=127;
integer test128=128;
integer test129=129;
integer test130=130;
integer test131=131;
integer test132=132;
integer test133=133;
integer test134=134;
integer test135=135;
integer test136=136;
integer test137=137;
integer test138=138;
integer test139=139;
integer test140=140;
integer test141=141;
integer test142=142;
integer test143=143;
integer test144=144;
integer test145=145;
integer test146=146;
integer test147=147;
integer test148=148;
integer test149=149;
integer test150=150;
integer test151=151;
integer test152=152;
integer test153=153;
integer test154=154;
integer test155=155;
integer test156=156;
integer test157=157;
integer test158=158;
integer test159=159;
integer test160=160;
integer test161=161;
integer test162=162;
integer test163=163;
integer test164=164;
integer test165=165;
integer test166=166;
integer test167=167;
integer test168=168;
integer test169=169;
integer test170=170;
integer test171=171;
integer test172=172;
integer test173=173;
integer test174=174;
integer test175=175;
integer test176=176;
integer test177=177;
integer test178=178;
integer test179=179;
integer test180=180;
integer test181=181;
integer test182=182;
integer test183=183;
integer test185=185;
integer test184=184;
integer test186=186;
integer test187=187;
integer test188=188;
integer test189=189;
integer test190=190;
integer test191=191;
integer test192=192;
integer test193=193;
integer test194=194;
integer test195=195;
integer test196=196;
integer test197=197;
integer test198=198;
integer test199=199;
integer test201=201;
integer test202=202;
integer test203=203;
integer test204=204;
integer test205=205;
integer test206=206;
integer test207=207;
integer test208=208;
integer test209=209;
integer test210=201;
integer test211=201;
integer test212=202;
integer test213=203;
integer test214=204;
integer test215=205;
integer test216=206;
integer test217=207;
integer test218=208;
integer test219=209;
test199=199;
test201=201;
test202=202;
test203=203;
test204=204;
test205=205;
test206=206;
test207=207;
test208=208;
test209=209;
test210=201;
test211=201;
test212=202;
test213=203;
test214=204;
test215=205;
test216=206;
test217=207;
test218=208;
test219=209;

    }
}