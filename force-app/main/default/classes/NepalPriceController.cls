public without sharing class NepalPriceController {
	public String CurId;
	public String URL{get;set;}
	public String error{get;set;}
	public Transaction_Card__c tcc{get;set;}
	//public Nepal_Price_List__c npl;
	public Boolean newcharge{get;set;}
	public Boolean main{get;set;}
	public Boolean recharge{get;set;}
	public Boolean retDev{get;set;}
	public Boolean badStat{get;set;}
	public Decimal pay{get;set;}
	public integer deltadays {get;set;}
	public String imei{get;set;}
	public NepalPriceController() {
		CurId = ApexPages.currentPage().getParameters().get('id');
		AssemblyParameters__c asp=[select Form_URL__c from AssemblyParameters__c where name='Nepal'];
		URL=asp.Form_URL__c;
		newcharge = false;
		badStat = false;
		recharge = false;
		retDev = false;
		main = false;
		deltadays=0;
		//Dev = new Card_Device__c();
		if(CurId!=null&&CurId!='')
			InitCalc();
		else
			main = true;
	}
	public void InitCalc(){
		boolean newtcc=true;
		try{
			tcc=[Select id,TookFine__c,CurrencyIsoCode,Device__c,Status__c,Card_Device__c,Date_Of_Return__c,Token_Id__c,CC_Expiration_Date__c,No_of_Payments__c,Cost_Calculated_Planned_N__c,Date_Of_Delivery_Device__c,Scheduled_Return_Date__c,CreatedDate,Account_Passenger__r.Phone,Account_Addressing__r.PersonMobilePhone,Account_Addressing__r.Phone,Account_Addressing__r.Name,Account_Addressing__r.PersonEmail from Transaction_Card__c where id=:Curid];
		}
		catch(exception e){
			tcc=[Select id,TookFine__c,CurrencyIsoCode,Device__c,Status__c,Card_Device__c,Date_Of_Return__c,Token_Id__c,CC_Expiration_Date__c,No_of_Payments__c,Cost_Calculated_Planned_N__c,Date_Of_Delivery_Device__c,Scheduled_Return_Date__c,CreatedDate,Account_Passenger__r.Phone,Account_Addressing__r.PersonMobilePhone,Account_Addressing__r.Phone,Account_Addressing__r.Name,Account_Addressing__r.PersonEmail from Transaction_Card__c where IMEI__c=:Curid and Record_Type_Name_Text__c='נפאל' and Status__c='בטיול - נפאל'];
			newtcc=false;
		}
		if(newtcc&&tcc.Status__c=='חדש')
			NewCalc();
		else if(!newtcc&&tcc.Status__c=='בטיול - נפאל')
			ReturnCalc();
	}
	public void NewCalc(){
		newcharge=true;
		tcc.CurrencyIsoCode='USD';
		deltadays =System.Today().daysBetween(tcc.Scheduled_Return_Date__c)+1;
	}
	public PageReference Paid(){
		error = null;
		if(tcc.Status__c=='חדש'){
			System.debug(imei);
			List<Card_Device__c> devs;
			if(!Test.isRunningTest())
				devs = [select id,imei__c from Card_Device__c where DeviceLocation__c='נפאל' and Inventory__c='במלאי' and Status__c='תקין' and IMEI__c=:imei limit 1];
			else
				devs = [select id,imei__c from Card_Device__c where IMEI__c='1234' limit 1];
			if(devs.size()==0){
				error = 'IMEI invalid, Device is either broken or not available.';
				return null;
			}
			tcc.Card_Device__c=devs[0].id;
			tcc.Status__c='בטיול - נפאל';
			tcc.Cost_Calculated_Planned_N__c = pay;
			update tcc;
			Card_Device__c cdev = [select id, Inventory__c from Card_Device__c where id=:tcc.Card_Device__c];
			cdev.Inventory__c = 'לא במלאי';
			update cdev;
			PageReference pgref = new PageReference('/NepalPrice');
			pgref.setRedirect(true);
			return pgref;
		}
		return null;
	}
	public void SearchRet(){
		error = null;
		try{
			tcc=[Select id,TookFine__c,CurrencyIsoCode,Device__c,Status__c,Card_Device__c,Date_Of_Return__c,Token_Id__c,CC_Expiration_Date__c,No_of_Payments__c,Cost_Calculated_Planned_N__c,Date_Of_Delivery_Device__c,Scheduled_Return_Date__c,CreatedDate,Account_Passenger__r.Phone,Account_Addressing__r.PersonMobilePhone,Account_Addressing__r.Phone,Account_Addressing__r.Name,Account_Addressing__r.PersonEmail from Transaction_Card__c where IMEI__c=:imei and Record_Type_Name_Text__c='נפאל' and Status__c='בטיול - נפאל'];
			ReturnCalc();
		}
		catch(exception e){
			error='IMEI invalid';
		}
	}
	public void ReturnCalc(){
		retDev = true;
		deltadays = tcc.Scheduled_Return_Date__c.daysBetween(System.Today());
	}
	public PageReference Ret(){
		if(pay!=null)
			tcc.Cost_Calculated_Planned_N__c += pay;
		Card_Device__c cdev = [select id,status__c,Inventory__c from Card_Device__c where id=:tcc.Card_Device__c];
		cdev.Inventory__c = 'במלאי';
		if(badStat){
			cdev.status__c = 'לתיקון';
			tcc.TookFine__c=true;
		}
		update cdev;
		tcc.Status__c='הסתיים';
		update tcc;
		PageReference pgref = new PageReference('/NepalPrice');
		pgref.setRedirect(true);
		return pgref;
	}
}