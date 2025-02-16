public without sharing class NepalFinesQueue implements Queueable, Database.AllowsCallouts {
	public List <Transaction_Card__c> tcs;
	public NepalFinesQueue(List <Transaction_Card__c> ts) {
		tcs=ts;
	}
	public void execute(QueueableContext context) {
		/*if(tcs.size()>0){
			Transaction_Card__c tcc=tcs[0];
			Nepal_Price_List__c	npl=[select Fine__c from Nepal_Price_List__c Where Device__c=:tcc.Device__c];
			Decimal Price=npl.Fine__c.setScale(2);
			Http http=new Http();
			HttpRequest req=new HttpRequest();
			req.setendpoint('https://secure5.tranzila.com/cgi-bin/tranzila71u.cgi');
			req.setmethod('POST');
			string pos='supplier=magnusintetok&sum='+Price+'&expdate='+tcc.CC_Expiration_Date__c+'&currency=2&TranzilaPW=zJkelm&TranzilaTK='+tcc.Token_id__c+'&cred_type=1&tranmode=A&SF_Transaction_Id='+tcc.id+'&contact='+tcc.Account_Addressing__r.name+'&email='+tcc.Account_Addressing__r.PersonEmail+'&phone='+tcc.Account_Addressing__r.PersonMobilePhone;
			req.setbody(pos);
			HttpResponse res;
			String str='';
			if(tcc.Token_Id__c!='testspec'){
				res = http.send(req);
				str=res.getbody();
			}
			else
				str='test&Response=000&ConfirmationCode=100&index=1&';
			if(str.contains('Response=000')){
				string con='';
				string ind='';
				String [] spl1=str.split('ConfirmationCode=');
				String [] spl2=str.split('index=');
				if(spl1[1].contains('&')){
					String [] spl3=spl1[1].split('&');
					con=spl3[0];
				}
				else
					con=spl1[1];
				if(spl2[1].contains('&')){
					String [] spl4=spl2[1].split('&');
					ind=spl4[0];
				}
				else
					ind=spl2[1];
				Payment__c pay=new Payment__c();
				pay.Parent_Transaction__c=tcc.id;
				pay.Expiration_Date__c =tcc.CC_Expiration_Date__c;
				pay.Token__c=tcc.Token_Id__c;
				pay.Result__c='000';
				pay.Payment_Transaction_ID__c=con;
				pay.index__c=ind;
				pay.masof__c='magnusintetok';
				TimeZone tz = TimeZone.getTimeZone('Asia/Jerusalem');
				DateTime localTime = System.now().AddSeconds(tz.getOffset(System.now())/1000);
				pay.Payment_Time__c=localTime;
				pay.Sum__c=Price;
				insert pay;
				tcc.TookFine__c=true;
				tcc.Cost_Calculated_Planned_N__c+=Price;
				update tcc;
			}
			tcs.remove(0);
			if(!Test.isRunningTest())
				ID jobID = System.enqueueJob(new NepalFinesQueue(tcs));
		}*/
	}
}