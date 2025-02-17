public without sharing class ChargeOrRefundController {
    Public id Curid;
    Public Payment_Transaction__c ptc {get;set;}
    Public Transaction_Card__c tcc {get;set;}
    Public Payment__c pam {get;set;}
    Public Account accadd {get;set;}
    Public Boolean TokEx {get;set;}
    Public Boolean met {get;set;}
    Public String TokGo {get;set;}
    Public String Half {get;set;}
    Public String Pricepart {get;set;}
    Public String dig {get;set;}
    Public String type {get;set;}
    Public String sfid {get;set;}
    Public String products {get;set;}
    Public decimal Price {get;set;}
    Public Boolean clo {get;set;}
    Public Boolean err {get;set;}
    public ChargeOrRefundController()
    {
      products='';
        err=false;
        clo=true;
        type='';
        TokEx=false;
        met=true;
        CurId = ApexPages.currentPage().getParameters().get('id');
        list <Payment_Transaction__c> ptcl=[select id,name,CurrencyIsoCode,Type__c,Transaction_Card__c,Payment_Method__c,Status__c,Payment__c,Grand_Total__c from Payment_Transaction__c where id=:Curid];
        list <Payment__c> paml=[select id,name,CurrencyIsoCode,masof__c,Extended_Service__c,Parent_Transaction__c,Expiration_Date__c,Payment_Transaction__c,Token__c,VAT_payment__c,Result__c,Sum__c,index__c,Payment_Transaction_ID__c from Payment__c where id=:Curid];
        if(ptcl.size()>0)
        {
            ptc=ptcl[0];
            sfid=ptc.id;
            tcc=[select id,Token_Id__c,CC_Expiration_Date__c,No_of_Payments__c,Account_Addressing__c,discount__c,Return_Date_Updated__c,Cost_Calculated_Planned_N__c,Trainings__c,Date_Of_Delivery_Device__c,Scheduled_Return_Date__c,Days_Of_Planned_Service__c,Step_Size1__c,Step_Size2__c,Step_Size3__c,Step_Size4__c,Step_Price1__c,Step_Price2__c,Step_Price3__c,Step_Price4__c,Dollar_Exchange_Rate__c from Transaction_Card__c where id=:ptc.Transaction_Card__c];
            accadd=[select id,Name,PersonEmail,PersonMobilePhone from account where id=:tcc.Account_Addressing__c];
            type='חיוב';
            if(tcc.Token_id__c!=null)
            {
                TokEx=true;
                string tem=tcc.Token_id__c;
                dig=tem.substring(tem.length()-4);
            }
            if(ptc.Status__c=='סגור')
            {
                clo=false;
            }
            list <Payment_Transaction_line__c> ptls = [select id,CurrencyIsoCode,Grand_Total__c,Quantity__c,Description__c from Payment_Transaction_line__c where Payment_Transaction__c=:ptc.id];
            list <map<string,string>> ptltojson=new list <map<string,string>> ();
            for(Payment_Transaction_line__c ptl: ptls)
            {
              String quan=String.valueOf(ptl.Quantity__c);
              String price=String.valueOf((ptl.Grand_Total__c/ptl.Quantity__c).setscale(2));
              ptltojson.add(new Map<string, string>{
                                'product_name' => ptl.Description__c,
                                'product_quantity' => quan,
                                'product_price' => price
                });
            }
            products=JSON.serialize(ptltojson);
            products=EncodingUtil.urlEncode(products, 'UTF-8');
            System.debug(products);
        }
        if(paml.size()>0)
        {
            pam=paml[0];
            sfid=pam.Payment_Transaction__c;
            type='זיכוי';
            if(pam.Token__c!=null)
            {
                TokEx=true;
                string tem=pam.Token__c;
                dig=tem.substring(tem.length()-4);
            }
            if(pam.Parent_Transaction__c!=null)
            {
            tcc=[select id,Token_Id__c,CC_Expiration_Date__c,No_of_Payments__c,Account_Addressing__c,discount__c,Return_Date_Updated__c,Cost_Calculated_Planned_N__c,Trainings__c,Date_Of_Delivery_Device__c,Scheduled_Return_Date__c,Days_Of_Planned_Service__c,Step_Size1__c,Step_Size2__c,Step_Size3__c,Step_Size4__c,Step_Price1__c,Step_Price2__c,Step_Price3__c,Step_Price4__c,Dollar_Exchange_Rate__c,Manual_Transaction__c from Transaction_Card__c where id=:pam.Parent_Transaction__c];
            accadd=[select id,Name,PersonEmail,PersonMobilePhone from account where id=:tcc.Account_Addressing__c];
            }
        }
        if(type=='חיוב')
            met=false;
    }
    public List<SelectOption> getItems() {
        if(type=='חיוב')
        {
        List<SelectOption> options = new List<SelectOption>();
        if(dig!=null)
            options.add(new SelectOption('True',type+' כרטיס אשראי המסתיים ב'+dig));
        options.add(new SelectOption('False',type+' כרטיס אשראי אחר'));
        return options;
        }
        else
        {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('True',type+' כרטיס אשראי המסתיים ב'+dig));
            return options;
        }
    }
    public List<SelectOption> getPrices() {
        if(type=='זיכוי')
        {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('False','זכה את כל הסכום'));
        options.add(new SelectOption('True','זיכוי חלק מהסכום'));
        return options;
        }
        else
        {
            return null;
        }
    }
    public PageReference submit()
    {
        err=false;
            if(TokGo=='True'&&type=='חיוב'&&ptc.Status__c=='פתוח')
            {
                Http http1=new Http();
                 HttpRequest req1=new HttpRequest();
                 req1.setendpoint('https://secure5.tranzila.com/cgi-bin/tranzila71u.cgi');
                 req1.setmethod('POST');
                 String cur=ptc.CurrencyIsoCode=='USD'?'2':'1';
                 string pos='supplier=magnusintetok&sum='+ptc.Grand_Total__c.setScale(2)+'&expdate='+tcc.CC_Expiration_Date__c+'&currency='+cur+'&TranzilaPW=zJkelm&TranzilaTK='+tcc.Token_id__c+'&cred_type=1&tranmode=A&SF_Transaction_Id='+tcc.id+'&contact='+accadd.name+'&email='+accadd.PersonEmail+'&phone='+accadd.PersonMobilePhone+'&IMaam=0.18&json_purchase_data='+products;
                 req1.setbody(pos);
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
                system.debug(pos);
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
                        pay.Parent_Transaction__c=ptc.Transaction_Card__c;
                        pay.Expiration_Date__c =tcc.CC_Expiration_Date__c;
                        pay.Token__c=tcc.Token_Id__c;
                        pay.Result__c='000';
                        pay.Payment_Transaction_ID__c=con;
                        pay.Payment_Transaction__c=Curid;
                        pay.index__c=ind;
                        pay.masof__c='magnusintetok';
                        pay.VAT_payment__c=true;
                        TimeZone tz = TimeZone.getTimeZone('Asia/Jerusalem');
                        DateTime localTime = System.now().AddSeconds(tz.getOffset(System.now())/1000);
                        pay.Payment_Time__c=localTime;
                        pay.Sum__c=Ptc.Grand_Total__c;
                        insert pay;
                        ptc.Status__c='סגור';
                        update ptc;
                        String ur='/apex/SuccessVF';
                        PageReference pageRef = new PageReference(ur); //it works
                        pageref.setRedirect(true);
                        return pageRef;
                }
                else
                {
                  String ur='/apex/ERROR';
                        PageReference pageRef = new PageReference(ur); //it works
                        pageref.setRedirect(true);
                        return pageRef;
                }
            }
            if(TokGo=='True'&&type=='זיכוי'&&(half=='False'||half=='True'))
            {
                Http http1=new Http();
                 HttpRequest req1=new HttpRequest();
                 req1.setendpoint('https://secure5.tranzila.com/cgi-bin/tranzila71u.cgi');
                 req1.setmethod('POST');
                 string sup='magnusintetok';
                 string pas='gxMapl';
                 String tokpas='zJkelm';
                 if((pam.VAT_payment__c==false&&tcc.Manual_Transaction__c==false&&pam.Extended_Service__c==false&&pam.masof__c==null)||(pam.VAT_payment__c==true&&tcc.Token_Id__c!=pam.Token__c&&pam.masof__c==null)||(pam.masof__c=='magnusinte'))
                 {
                     sup='magnusinte';
                     pas='nVRS9w';
                     tokpas='B6l58e';
                 }
                 if(half=='False')
                 {
                price=pam.Sum__c;
                String cur=pam.CurrencyIsoCode=='USD'?'2':'1';
                String pos='supplier='+sup+'&sum='+pam.Sum__c.setScale(2)+'&expdate='+pam.Expiration_Date__c+'&currency='+cur+'&TranzilaPW='+tokpas+'&TranzilaTK='+pam.Token__c+'&cred_type=1&tranmode=C'+pam.index__c+'&authnr='+pam.Payment_Transaction_ID__c+'&CreditPass='+pas+'&SF_Transaction_Id='+tcc.id+'&contact='+accadd.name+'&email='+accadd.PersonEmail+'&phone='+accadd.PersonMobilePhone;
                 req1.setbody(pos);
                 HttpResponse res1;
                 String str='';
                 if(pam.Token__c!='testspec')
                 {
                 res1 = http1.send(req1);
                 str=res1.getbody();
                    }
                    else
                     str='test&Response=000&ConfirmationCode=100&index=1&';
                system.debug(str);
                system.debug(pos);
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
                    Payment__c payn=new Payment__c();
                       payn.Parent_Transaction__c=pam.Parent_Transaction__c;
                       payn.Expiration_Date__c =pam.Expiration_Date__c;
                       payn.Token__c=pam.Token__c;
                       payn.Payment_Transaction__c=pam.Payment_Transaction__c;
                       payn.Result__c='000';
                       payn.Payment_Transaction_ID__c=con;
                       payn.masof__c=sup;
                       payn.index__c=ind;
                       payn.VAT_payment__c=pam.VAT_payment__c;
                       TimeZone tz = TimeZone.getTimeZone('Asia/Jerusalem');
                       DateTime localTime = System.now().AddSeconds(tz.getOffset(System.now())/1000);
                       payn.Payment_Time__c=localTime;
                       payn.Sum__c=price*(-1);
                       insert payn;
                       String ur='/apex/SuccessVF';
                       PageReference pageRef = new PageReference(ur); //it works
                       pageref.setRedirect(true);
                       return pageRef;
                }
                else
                {
                  String ur='/apex/ERROR';
                        PageReference pageRef = new PageReference(ur); //it works
                        pageref.setRedirect(true);
                        return pageRef;
                }
            }
                if(half=='True'&&Pricepart!=null&&Pricepart!=''&&Decimal.valueOf(Pricepart)<=pam.sum__c&&Decimal.valueOf(Pricepart)>0)
                {
                    price=Decimal.valueOf(Pricepart);
                 String cur=pam.CurrencyIsoCode=='USD'?'2':'1';
                String pos='supplier='+sup+'&sum='+Pricepart+'&expdate='+pam.Expiration_Date__c+'&currency='+cur+'&TranzilaPW='+tokpas+'&TranzilaTK='+pam.Token__c+'&cred_type=1&tranmode=C'+pam.index__c+'&authnr='+pam.Payment_Transaction_ID__c+'&CreditPass='+pas+'&SF_Transaction_Id='+tcc.id+'&contact='+accadd.name+'&email='+accadd.PersonEmail+'&phone='+accadd.PersonMobilePhone;
                 req1.setbody(pos);
                 HttpResponse res1;
                 String str='';
                 if(pam.Token__c!='testspec')
                 {
                 res1 = http1.send(req1);
                 str=res1.getbody();
                    }
                    else
                     str='test&Response=000&ConfirmationCode=100&index=1&';
                system.debug(str);
                system.debug(pos);
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
                    Payment__c payn=new Payment__c();
                       payn.Parent_Transaction__c=pam.Parent_Transaction__c;
                       payn.Expiration_Date__c =pam.Expiration_Date__c;
                       payn.Token__c=pam.Token__c;
                       payn.Payment_Transaction__c=pam.Payment_Transaction__c;
                       payn.Result__c='000';
                       payn.masof__c=sup;
                       payn.Payment_Transaction_ID__c=con;
                       payn.index__c=ind;
                       payn.VAT_payment__c=pam.VAT_payment__c;
                       TimeZone tz = TimeZone.getTimeZone('Asia/Jerusalem');
                       DateTime localTime = System.now().AddSeconds(tz.getOffset(System.now())/1000);
                       payn.Payment_Time__c=localTime;
                       payn.Sum__c=price*(-1);
                       insert payn;
                       String ur='/apex/SuccessVF';
                       PageReference pageRef = new PageReference(ur); //it works
                       pageref.setRedirect(true);
                       return pageRef;
                }
                else
                {
                  String ur='/apex/ERROR';
                        PageReference pageRef = new PageReference(ur); //it works
                        pageref.setRedirect(true);
                        return pageRef;
                }
            }
            else
                err=true;
            }
        return null;
    }
}