public without sharing class NatBagController {
	public String IMEI{get;set;}
	public String VAULT{get;set;}
	public String message{get;set;}
	public boolean err{get;set;}
	public List<Transaction_Card__c> tccs{get;set;}
	public NatBagController() {
	}
	/*public void Departures(){
		message=null;
		err=true;
		tccs=[Select id,Status__c,Account_Passenger__r.Name from Transaction_Card__c where Status__c='ממתין לאיסוף בנתב\"ג' and IMEI__c!=null and IMEI__c=:IMEI and Pickup_in_Natbag__c=true];
		if(tccs.size()>0){
			tccs[0].Status__c = 'טיול';
			update tccs[0];
			err=false;
			IMEI=null;
			message='עודכן בהצלחה! '+tccs[0].Account_Passenger__r.Name+' לקח מכשיר מנתב\"ג.';
		}
		else message='לא נמצא לקוח הממתין למכשיר זה, אנא וודא תקינות IMEI או צור קשר עם המשרדים';
	}*/
	public void Departures(){
		message=null;
		err=true;
		tccs=[Select id,Status__c,Account_Passenger__r.Name from Transaction_Card__c where Status__c='מכשיר מוכן' and IMEI__c!=null and IMEI__c=:IMEI and Pickup_in_Natbag__c=true];
		if(tccs.size()>0){
			tccs[0].Status__c = 'ממתין לאיסוף בנתב\"ג';
			update tccs[0];
			err=false;
			IMEI=null;
			VAULT=null;
			message='עודכן בהצלחה! מכשיר מוכן בנתב\" ג ל'+tccs[0].Account_Passenger__r.Name;
		}
		else message='לא נמצא לקוח הממתין למכשיר זה, אנא וודא תקינות IMEI או צור קשר עם המשרדים';
	}
	public void Vaults(){
		message=null;
		err=true;
		tccs=[Select id,Status__c,SafeBox_Num__c,Account_Passenger__r.Name from Transaction_Card__c where (Status__c='מכשיר מוכן' or Status__c='ממתין לאיסוף בנתב\"ג') and IMEI__c!=null and IMEI__c=:IMEI and Pickup_in_Natbag__c=true];
		if(tccs.size()>0&&VAULT!=null&&VAULT!=''){
			tccs[0].Status__c = 'ממתין לאיסוף בנתב\"ג';
			tccs[0].SafeBox_Num__c = VAULT;
			update tccs[0];
			err=false;
			IMEI=null;
			VAULT=null;
			message='עודכן בהצלחה! מכשיר הועבר לכספת מספר - '+tccs[0].SafeBox_Num__c+' בנתב\" ג ל'+tccs[0].Account_Passenger__r.Name;
		}
		else message='לא נמצא לקוח הממתין למכשיר זה, אנא וודא תקינות IMEI והכסנת ערך בשדה כספת או צור קשר עם המשרדים';
	}
	public void Arrivals(){
		message=null;
		err=true;
		tccs=[Select id,Status__c,The_Actual_Return_Date__c,Account_Passenger__r.Name from Transaction_Card__c where (Status__c='טיול' or Status__c='הארכת טיול' or Status__c='החזרת מכשיר' or Status__c = 'ממתין לאיסוף בנתב\"ג') and IMEI__c!=null and IMEI__c=:IMEI and Return_in_Natbag__c=true];
		if(tccs.size()>0){
			tccs[0].Status__c = 'החזרה מנתב\"ג';
			tccs[0].The_Actual_Return_Date__c=System.Today();
			update tccs[0];
			err=false;
			IMEI=null;
			VAULT=null;
			message='עודכן בהצלחה! '+tccs[0].Account_Passenger__r.Name+' החזיר מכשיר לנתב\"ג.';
		}
		else message='לא נמצא לקוח בטיול עם מכשיר זה, אנא וודא תקינות IMEI או צור קשר עם המשרדים';
	}
}