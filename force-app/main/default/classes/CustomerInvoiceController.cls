public without sharing class CustomerInvoiceController {
    public String signatureData {set; get;}
    public String signaturepic {set; get;}
    public String dear {set; get;}
    public id Curid{get;set;}
    public Transaction_card__c tcc{get;set;}
		public Boolean sigin{get;set;}
        public Boolean acce{get;set;}
    public CustomerInvoiceController(ApexPages.StandardController controller)
    {
        dear='';
        acce=false;
			sigin=false;
            Curid=ApexPages.currentPage().getParameters().get('id');
        tcc=[select id,Signature__c,Card_Device__r.model__c,Terms_conditions_accepted__c,name,Device_recipient__c,Account_Passenger__r.Name from Transaction_card__c where id=:Curid];
        Pattern p = Pattern.compile('[a-zA-Z]+');
        Pattern ps = Pattern.compile('[a-zA-Z]+ [a-zA-Z]+');
        Boolean c = p.matcher(tcc.Account_Passenger__r.Name).matches();
        Boolean d = ps.matcher(tcc.Account_Passenger__r.Name).matches();
        if(!d&&!c)
            {
                dear='לכבוד : '+tcc.Account_Passenger__r.Name;
            }
                else
                {
                dear=tcc.Account_Passenger__r.Name+' : לכבוד';
            }
    }
    public pagereference GeneratePDF(){
        acce=false;
      sigin=false;
        List <string> b64 =new list <string>();
        String ur='/apex/CustomerInvoice1?id='+tcc.id;
        if(tcc.Terms_conditions_accepted__c==true)
        {
        if (signatureData != null && signatureData != '')
        {
            tcc.Signature__c = '<img style="width: 100%;height:150px;" src="' + signatureData + '"/>';
            update tcc;
            b64=signatureData.split(',');
            if(b64.size()>1)
            {
                Document doc = new Document();
                doc.Name=tcc.name;
                doc.AuthorId = UserInfo.getUserId();
                doc.FolderId = UserInfo.getUserId();
                doc.ContentType = 'image/jpeg';
                doc.Type='jpg';
                doc.IsPublic=true;
                doc.Body =EncodingUtil.base64Decode(b64[1]);
                insert doc;
                ur='/apex/CustomerInvoice1?id='+tcc.id+'&sigpic='+doc.id;
            }
            PageReference newPage = new PageReference(ur);
            newPage.setRedirect(true);
            return newPage;
        }
        else
        {
          sigin=true;
          return null;
        }
        }
        else
        {
            acce=true;
        return null;
        }
    }
}