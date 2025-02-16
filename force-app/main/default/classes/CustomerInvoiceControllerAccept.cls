public without sharing class CustomerInvoiceControllerAccept {
	public String signatureData {set; get;}
		public String signaturepic {set; get;}
        public String signatureid {set; get;}
        public String dear {set; get;}
        public String dear2 {set; get;}
		public id Curid{get;set;}
		public Transaction_card__c tcc{get;set;}
        public Transaction_card__c uptcc{get;set;}
        public Document doc{get;set;}
    public CustomerInvoiceControllerAccept(ApexPages.StandardController controller)
    {
        dear='';
        signatureid=ApexPages.currentPage().getParameters().get('sigpic');
        signaturepic='';
        if(signatureid!=null)
        {
            doc=[select id,body from document where id=:signatureid];
            signaturepic='/servlet/servlet.FileDownload?file='+signatureid;
        }
        Curid=ApexPages.currentPage().getParameters().get('id');
        tcc=[select id,Signature__c,name,Card_Device__r.model__c,Terms_conditions_accepted__c,Device_recipient__c,Account_Passenger__r.Name from Transaction_card__c where id=:Curid];
        uptcc=tcc;
        Pattern p = Pattern.compile('[a-zA-Z]+');
        Pattern ps = Pattern.compile('[a-zA-Z]+ [a-zA-Z]+');
        Boolean a = p.matcher(uptcc.Device_recipient__c).matches();
        Boolean b = ps.matcher(uptcc.Device_recipient__c).matches();
        Boolean c = p.matcher(tcc.Account_Passenger__r.Name).matches();
        Boolean d = ps.matcher(tcc.Account_Passenger__r.Name).matches();
        if(!b&&!a)
            uptcc.Device_recipient__c=Reverse(uptcc.Device_recipient__c);
        if(!d&&!c)
        {
            dear='לכבוד : '+tcc.Account_Passenger__r.Name;
            dear2=Reverse(tcc.Account_Passenger__r.Name)+' : דובכל';
        }
            else
            {
            dear=tcc.Account_Passenger__r.Name+' : לכבוד';
            dear2=tcc.Account_Passenger__r.Name+' : דובכל';
        }
    }
		private String Reverse(String str) {
		String reversed = '';
		Integer len = str.length();

		for(Integer i = len - 1; i >= 0; i--) {
			reversed += str.substring(i, i + 1);
		}

		return reversed;
	}
    public pagereference GeneratePDF(){
        pagereference Pg = Page.CustomerInvoice2;
        if(signatureid!=null)
            Pg.getParameters().put('sigpic', doc.id);
        attachment at = new Attachment();
        try
        {
        	Blob pdf1 = pg.getcontentASPDF();
            at.Body=pdf1;
        }
        catch(exception e)
        {
            at.body=Blob.valueOf('Unit Test Attachment Body');
        }
        at.OwnerId = UserInfo.getUserId();
        at.ParentId = tcc.Id;
        at.Name=tcc.Name+'.pdf';
        at.ContentType = 'application/pdf';
        insert at;
        if(signatureid!=null)
            delete doc;
        String ur='/apex/InvoiceEmail?id='+tcc.id+'&Atid='+at.id;
        PageReference pageRef = new PageReference(ur);
        pageRef.setRedirect(True);
        return pageRef;
    }
    public pagereference Back(){
        if(signatureid!=null)
        {
            try{
                delete doc;
            }
            catch (exception e){}
        }
        String ur='/apex/CustomerInvoice?id='+tcc.id;
        PageReference newPage = new PageReference(ur);
        newPage.setRedirect(true);
        return newPage;
    }
}