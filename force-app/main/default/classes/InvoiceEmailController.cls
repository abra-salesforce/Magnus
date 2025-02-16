public without sharing class InvoiceEmailController {
    public id Curid;
    public id Atid;
		public Transaction_card__c tcc{get;set;}
    public Attachment at{get;set;}
    public String tex{get;set;}
    public Invoice_Parameters__c inv{get;set;}
    public InvoiceEmailController(ApexPages.StandardController controller)
    {
        Curid=ApexPages.currentPage().getParameters().get('id');
        Atid=ApexPages.currentPage().getParameters().get('atid');
        Transaction_card__c acco=[select id,name from Transaction_card__c where id=:Curid];
        tcc=acco;
        at=[select id,name,body from attachment where id=:Atid];
        list <Invoice_Parameters__c> invs=[select Subject__c,Body__c,From_Address__c from Invoice_Parameters__c where Name=:'Default'];
        if(invs.size()>0)
          inv=invs[0];
    }
    public pagereference SendEmail(){
      update tcc;
        String email=tex;//co.Customer_Email__c;
        if(email!=null &&email!='')
        {
        String [] emas=email.split(';');
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(at.name);
		      efa.setBody(at.body);
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = emas;
        message.setReplyTo(inv.From_Address__c);
        message.setSenderDisplayName(inv.From_Address__c);
        message.optOutPolicy = 'FILTER';
        message.subject = inv.Subject__c;
        message.plainTextBody = inv.Body__c;
        message.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        Messaging.SingleEmailMessage[] messages =
            new List<Messaging.SingleEmailMessage> {message};
            if(tex!='test@test.com')
            {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        }
      }
        String ur='/'+tcc.id;
        PageReference pageRef = new PageReference(ur);
		pageRef.setRedirect(True);
        return pageRef;
    }
}