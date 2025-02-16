public without sharing class AssemblyDeskController {
    Public id Curid;
    Public Incident_Report__c inc {get;set;}
    Public AssemblyParameters__c asp {get;set;}
    public AssemblyDeskController(ApexPages.StandardController controller){
        CurId = ApexPages.currentPage().getParameters().get('id');
        inc=[select id,Type_Desk_Rescue__c,Event_Status__c,Event_Open_Date__c,Countries__c,Account_Addressing__r.Name,Telephone__c,Insured_Relationship__c,Gender__c,Age__c,IDNumber__c,Insurance_Company_picklist__c,Insurance_Policy__c,Contact_Method__c,Birth_Place__c,Passport_Number__c,Current_address__c,Additional_Passport_Number__c,Additional_Nationalities__c,Highschool__c,Work_Place__c,Profession__c,Travel_Time__c,Other_Countries_Traveled__c,Military_Service__c,Academy__c,Cellphone_Company__c,Cell_Type__c,Local_Sim__c,Height__c,Hair__c,Eyecolor__c,Clothes_Description__c,Coat__c,Shirt__c,Pants__c,Shoes__c,Backpack__c,Clothes_signals__c,Glasses__c,Beard__c,Moustache__c,Scars__c,Tattoos__c,Jewelry__c,Pouch__c,Wallet__c,Camera__c,GPS__c,Map__c,Sleeping_Bag__c,Tent__c,Water__c,Food__c,Other_Signs__c,Traveler_Email__c,Facebook_Account__c,Twitter_Account__c,Instagram_Account__c,LinkedIn_Account__c ,Favorite_Sites__c,Bank_Account__c,Bank_Name__c,Bank_Branch__c,Branch_Code__c,CreditCard_Last_Digits__c,Bank_Last_Action__c,Access_to_Bank_Account__c,Health_Condition__c,Mental_Condition__c,Health_Problems__c,Limp__c,Drug_Abuse__c,Medication__c,Medication_Description__c,Rescued_Name__r.Name,Rescued_Phone__c,Rescued_Phone_Text__c from Incident_Report__c Where id=:Curid];
        asp=[select Form_URL__c from AssemblyParameters__c where name='Desk'];
    }
    public PageReference Redirect(){
        String url=Tran();
        PageReference pageRef = new PageReference(url);
        pageref.setRedirect(true);
        return pageRef;
    }
    public String Tran(){
        string abc='aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ';
        String url=asp.Form_URL__c+'?'+
        '&tfa_6='+(inc.Type_Desk_Rescue__c!=null?inc.Type_Desk_Rescue__c:'')+
        '&tfa_1120='+(inc.Event_Status__c!=null?inc.Event_Status__c:'')+
        '&tfa_1118='+(inc.Event_Open_Date__c!=null?inc.Event_Open_Date__c.format():'')+
        '&tfa_882='+(inc.Countries__c!=null?inc.Countries__c:'')+
        '&tfa_871='+(inc.Account_Addressing__r.Name!=null?inc.Account_Addressing__r.Name:'')+
        '&tfa_872='+(inc.Telephone__c!=null?inc.Telephone__c:'')+
        '&tfa_1125='+(inc.Rescued_Phone_Text__c!=null?inc.Rescued_Phone_Text__c:'')+
        '&tfa_874='+(inc.Insured_Relationship__c!=null?inc.Insured_Relationship__c:'')+
        '&tfa_876='+(inc.Gender__c!=null?inc.Gender__c:'')+
        '&tfa_880='+(inc.Age__c!=null?inc.Age__c.format():'')+
        '&tfa_1866='+(inc.IDNumber__c!=null?inc.IDNumber__c:'')+
        '&tfa_1091='+(inc.Insurance_Company_picklist__c!=null?inc.Insurance_Company_picklist__c:'')+
        '&tfa_1103='+(inc.Insurance_Policy__c!=null?inc.Insurance_Policy__c:'')+
        '&tfa_1105='+(inc.Contact_Method__c!=null?inc.Contact_Method__c:'')+
        '&tfa_1868='+(inc.Birth_Place__c!=null?inc.Birth_Place__c:'')+
        '&tfa_1090='+(inc.Passport_Number__c!=null?inc.Passport_Number__c:'')+
        '&tfa_1864='+(inc.Current_address__c!=null?inc.Current_address__c:'')+
        '&tfa_1870='+(inc.Additional_Passport_Number__c!=null?inc.Additional_Passport_Number__c:'')+
        '&tfa_1872='+(inc.Additional_Nationalities__c!=null?inc.Additional_Nationalities__c:'')+
        '&tfa_1874='+(inc.Highschool__c!=null?inc.Highschool__c:'')+
        '&tfa_1876='+(inc.Work_Place__c!=null?inc.Work_Place__c:'')+
        '&tfa_1878='+(inc.Profession__c!=null?inc.Profession__c:'')+
        '&tfa_1880='+(inc.Travel_Time__c!=null?inc.Travel_Time__c:'')+
        '&tfa_1882='+(inc.Other_Countries_Traveled__c!=null?inc.Other_Countries_Traveled__c:'')+
        '&tfa_1884='+(inc.Military_Service__c!=null?inc.Military_Service__c:'')+
        '&tfa_1886='+(inc.Academy__c!=null?inc.Academy__c:'')+
        '&tfa_1888='+(inc.Cellphone_Company__c!=null?inc.Cellphone_Company__c:'')+
        '&tfa_1890='+(inc.Cell_Type__c!=null?inc.Cell_Type__c:'')+
        '&tfa_1892='+(inc.Local_Sim__c!=null?inc.Local_Sim__c:'')+
        '&tfa_1896='+(inc.Height__c!=null?String.Valueof(inc.Height__c):'')+
        '&tfa_1894='+(inc.Hair__c!=null?inc.Hair__c:'')+
        '&tfa_1899='+(inc.Eyecolor__c!=null?inc.Eyecolor__c:'')+
        '&tfa_1901='+(inc.Clothes_Description__c!=null?inc.Clothes_Description__c:'')+
        '&tfa_1903='+(inc.Coat__c!=null?inc.Coat__c:'')+
        '&tfa_1905='+(inc.Shirt__c!=null?inc.Shirt__c:'')+
        '&tfa_1907='+(inc.Pants__c!=null?inc.Pants__c:'')+
        '&tfa_1909='+(inc.Shoes__c!=null?inc.Shoes__c:'')+
        '&tfa_1911='+(inc.Backpack__c!=null?inc.Backpack__c:'')+
        '&tfa_1913='+(inc.Clothes_signals__c!=null?inc.Clothes_signals__c:'')+
        '&tfa_1915='+(inc.Glasses__c!=null?inc.Glasses__c:'')+
        '&tfa_1917='+(inc.Beard__c!=null?inc.Beard__c:'')+
        '&tfa_1919='+(inc.Moustache__c!=null?inc.Moustache__c:'')+
        '&tfa_1921='+(inc.Scars__c!=null?inc.Scars__c:'')+
        '&tfa_1923='+(inc.Tattoos__c!=null?inc.Tattoos__c:'')+
        '&tfa_1925='+(inc.Jewelry__c!=null?inc.Jewelry__c:'')+
        '&tfa_1927='+(inc.Pouch__c!=null?inc.Pouch__c:'')+
        '&tfa_1929='+(inc.Wallet__c!=null?inc.Wallet__c:'')+
        '&tfa_1931='+(inc.Camera__c!=null?inc.Camera__c:'')+
        '&tfa_1933='+(inc.GPS__c!=null?inc.GPS__c:'')+
        '&tfa_1935='+(inc.Map__c!=null?inc.Map__c:'')+
        '&tfa_1937='+(inc.Sleeping_Bag__c!=null?inc.Sleeping_Bag__c:'')+
        '&tfa_1939='+(inc.Tent__c!=null?inc.Tent__c:'')+
        '&tfa_1941='+(inc.Water__c!=null?inc.Water__c:'')+
        '&tfa_1943='+(inc.Food__c!=null?inc.Food__c:'')+
        '&tfa_1945='+(inc.Other_Signs__c!=null?inc.Other_Signs__c:'')+
        '&tfa_1947='+(inc.Traveler_Email__c!=null?inc.Traveler_Email__c:'')+
        '&tfa_1949='+(inc.Facebook_Account__c!=null?inc.Facebook_Account__c:'')+
        '&tfa_1951='+(inc.Twitter_Account__c!=null?inc.Twitter_Account__c:'')+
        '&tfa_1953='+(inc.Instagram_Account__c!=null?inc.Instagram_Account__c:'')+
        '&tfa_1955='+(inc.LinkedIn_Account__c !=null?inc.LinkedIn_Account__c :'')+
        '&tfa_1957='+(inc.Favorite_Sites__c!=null?inc.Favorite_Sites__c:'')+
        '&tfa_1959='+(inc.Bank_Account__c!=null?inc.Bank_Account__c:'')+
        '&tfa_1960='+(inc.Bank_Name__c!=null?inc.Bank_Name__c:'')+
        '&tfa_1962='+(inc.Bank_Branch__c!=null?inc.Bank_Branch__c:'')+
        '&tfa_1964='+(inc.Branch_Code__c!=null?inc.Branch_Code__c:'')+
        '&tfa_1966='+(inc.CreditCard_Last_Digits__c!=null?String.Valueof(inc.CreditCard_Last_Digits__c):'')+
        '&tfa_1968='+(inc.Bank_Last_Action__c!=null?inc.Bank_Last_Action__c:'')+
        '&tfa_1970='+(inc.Access_to_Bank_Account__c!=null?inc.Access_to_Bank_Account__c:'')+
        '&tfa_1972='+(inc.Health_Condition__c!=null?inc.Health_Condition__c:'')+
        '&tfa_1974='+(inc.Mental_Condition__c!=null?inc.Mental_Condition__c:'')+
        '&tfa_1981='+(inc.Health_Problems__c!=null?inc.Health_Problems__c:'')+
        '&tfa_1982='+(inc.Limp__c!=null?inc.Limp__c:'')+
        '&tfa_1984='+(inc.Drug_Abuse__c!=null?inc.Drug_Abuse__c:'')+
        '&tfa_1986='+(inc.Medication__c!=null?String.valueof(inc.Medication__c):'')+
        '&tfa_1988='+(inc.Medication_Description__c!=null?inc.Medication_Description__c:'')+
        '&tfa_875='+(inc.Rescued_Name__r.Name!=null?inc.Rescued_Name__r.Name:'')+
        '&tfa_2006='+(inc.id!=null?inc.id:'');
                return url;
    }
}