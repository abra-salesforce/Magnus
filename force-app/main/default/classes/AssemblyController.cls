public without sharing class AssemblyController {
    Public id Curid;
    Public Transaction_Card__c tcc {get;set;}
    Public Account accadd {get;set;}
    Public Account accpas {get;set;}
    Public AssemblyParameters__c asp {get;set;}
    public String Device {get;set;}
    public String seplus;
    public String type;
    public List <PriceList__c> A {get;set;}
    public List <PriceList__c> SEP {get;set;}
    public AssemblyController(ApexPages.StandardController controller){
        Device='';
        seplus = Label.SEplus;
        CurId = ApexPages.currentPage().getParameters().get('id');
        A=[select Price__c,Available__c from PriceList__c Where Device__c='A' And Program__c='Magnus Basic' Order by Priority__c];
        SEP=[select Price__c,Available__c from PriceList__c Where Device__c='SE+' And Program__c='Magnus Basic' Order by Priority__c];
        tcc=[Select id,Date_Of_Delivery_Device__c,Scheduled_Return_Date__c,Record_Type_Name_Text__c,Passport_Number__c,Track_s__c,Insurance_Company__c,Date_Trip__c,Date_Of_Return__c,Account_Passenger__c,Account_Addressing__c,Device__c from Transaction_Card__c where id=:Curid];
        if(tcc.Device__c!=null)
            Device=tcc.Device__c;
        System.debug(tcc.Record_Type_Name_Text__c);
        if(tcc.Record_Type_Name_Text__c==null||tcc.Record_Type_Name_Text__c=='לוויני')
            type='Default';
        else if(tcc.Record_Type_Name_Text__c=='נפאל')
            type='Nepal';
        System.debug(type);
        accadd=[select id,Firstname,Lastname,Phone,PersonEmail,Account_Mail__c,Get_To_magnus__c,Contaction_Status__c from account where id=:tcc.Account_Addressing__c];
        accpas=[select id,Firstname,Lastname,PersonEmail,Male_Female__c,PersonBirthdate,First_Name_English__c,Last_Name_English__c,Phone,Passenger_Mail__c,PersonHomePhone,BillingCity,BillingStreet,BillingCountry,BillingPostalCode,Passenger_Id__c,Addressee_First_Name1__c,Addressee_Last_Name1__c,Addressee_Email1__c,Addressee_phone1__c,Addressee_ProximityNew1__c,Addressee_First_Name2__c,Addressee_Last_Name2__c,Addressee_Email2__c,Addressee_phone2__c,Addressee_ProximityNew2__c from account where id=:tcc.Account_Passenger__c];
        asp=[select Form_URL__c from AssemblyParameters__c where name=:type];
    }
    public PageReference CheckFirst(){
        if(Device!=''||seplus!='TRUE'){
            String url=Tran();
            PageReference pageRef = new PageReference(url);
            pageref.setRedirect(true);
            return pageRef;
        }
        else
            return null;
    }
    public PageReference Redirect(){
        String url=Tran();
        PageReference pageRef = new PageReference(url);
        pageref.setRedirect(true);
        return pageRef;
    }
    public String Tran(){
        string abc='aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ';
        string DateDep='';
        string DateBack='';
        string DateBirth='';
        if(type=='Default'){
            if(tcc.Date_Trip__c!=null)
                DateDep=tcc.Date_Trip__c.format();
            if(tcc.Date_Of_Return__c!=null)
                DateBack=tcc.Date_Of_Return__c.format();
        }
        if(type=='Nepal'){
            if(tcc.Date_Of_Delivery_Device__c!=null)
                DateDep=tcc.Date_Of_Delivery_Device__c.format();
            if(tcc.Scheduled_Return_Date__c!=null)
                DateBack=tcc.Scheduled_Return_Date__c.format();
        }
        if(accpas.PersonBirthdate!=null)
            DateBirth=accpas.PersonBirthdate.format();
        String url=asp.Form_URL__c+'?'+
            'tfa_2899='+tcc.id+
            '&tfa_2889='+(tcc.Insurance_Company__c!=null?tcc.Insurance_Company__c:'')+
            '&tfa_3605='+DateDep+
            '&tfa_3606='+DateBack+
            '&tfa_2897='+accadd.id+
            '&tfa_1876='+(accadd.FirstName!=null?accadd.FirstName:'')+
            '&tfa_1='+(accadd.LastName!=null?accadd.LastName:'')+
            '&tfa_1873='+(accadd.PersonEmail!=null?accadd.PersonEmail:'')+
            '&tfa_1880='+(accadd.Phone!=null?accadd.Phone:'')+
            '&tfa_2874='+(accadd.Get_To_magnus__c!=null?accadd.Get_To_magnus__c:'')+
            '&tfa_2882='+(accadd.Contaction_Status__c!=null?accadd.Contaction_Status__c:'')+
            '&tfa_2898='+accpas.id+
            '&tfa_1926='+((accpas.FirstName!=null&&(accpas.FirstName.containsany(abc)))?accpas.FirstName:'')+
            '&tfa_1928='+((accpas.LastName!=null&&(accpas.LastName.containsany(abc)))?accpas.LastName:'')+
            '&tfa_1917='+(accpas.Male_Female__c!=null?accpas.Male_Female__c:'')+
            '&tfa_1921='+DateBirth+
            '&tfa_1884='+((accpas.FirstName!=null&&(!accpas.FirstName.containsany(abc)))?accpas.FirstName:accpas.First_Name_English__c)+
            '&tfa_1885='+((accpas.LastName!=null&&(!accpas.LastName.containsany(abc)))?accpas.LastName:accpas.Last_Name_English__c)+
            '&tfa_1930='+(accpas.Phone!=null?accpas.Phone:'')+
            '&tfa_1931='+(accpas.PersonEmail!=null?accpas.PersonEmail:'')+
            '&tfa_1933='+(accpas.PersonHomePhone!=null?accpas.PersonHomePhone:'')+
            '&tfa_2197='+(accpas.BillingCity!=null?accpas.BillingCity:'')+
            '&tfa_2195='+(accpas.BillingStreet!=null?accpas.BillingStreet:'')+
            '&tfa_2198='+(accpas.BillingCountry!=null?accpas.BillingCountry:'')+
            '&tfa_2509='+(accpas.BillingPostalCode!=null?accpas.BillingPostalCode:'')+
            '&tfa_2902='+(accpas.Addressee_First_Name1__c!=null?accpas.Addressee_First_Name1__c:'')+
            '&tfa_2904='+(accpas.Addressee_Last_Name1__c!=null?accpas.Addressee_Last_Name1__c:'')+
            '&tfa_2907='+(accpas.Addressee_Email1__c!=null?accpas.Addressee_Email1__c:'')+
            '&tfa_2906='+(accpas.Addressee_phone1__c!=null?accpas.Addressee_phone1__c:'')+
            '&tfa_3608='+(accpas.Addressee_ProximityNew1__c!=null?accpas.Addressee_ProximityNew1__c:'')+
            '&tfa_2920='+(accpas.Addressee_First_Name2__c!=null?accpas.Addressee_First_Name2__c:'')+
            '&tfa_2921='+(accpas.Addressee_Last_Name2__c!=null?accpas.Addressee_Last_Name2__c:'')+
            '&tfa_2924='+(accpas.Addressee_Email2__c!=null?accpas.Addressee_Email2__c:'')+
            '&tfa_3629='+DateBack+
            '&tfa_2923='+(accpas.Addressee_phone2__c!=null?accpas.Addressee_phone2__c:'')+
            '&tfa_3631='+(accadd.PersonEmail!=null?accadd.PersonEmail:'')+
            '&tfa_3615='+(accpas.Addressee_ProximityNew2__c!=null?accpas.Addressee_ProximityNew2__c:'')+
            '&tfa_3645='+Device+
            (type=='Default'?('&tfa_2513='+(accpas.Passenger_Id__c!=null?accpas.Passenger_Id__c:'')):('&tfa_2513='+(tcc.Passport_Number__c!=null?tcc.Passport_Number__c:'')+'&tfa_2516='+(tcc.Track_s__c!=null?tcc.Track_s__c:'')));
        return url;
    }
}