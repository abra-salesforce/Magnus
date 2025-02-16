@isTest(seealldata=true)
public without sharing class CustomerInvoiceandEmailTest {
    static testMethod void Testci()
    {
    	RecordType pass=[select Id from RecordType where Name =: 'כרטיס נוסע'];
    	RecordType add=[select Id from RecordType where Name =: 'כרטיס פונה'];
    	Account accadd=new account(RecordTypeId=add.id,lastname='testadd');
    	insert accadd;
    	Account accpass=new account(RecordTypeId=pass.id,lastname='testpass');
    	insert accpass;
        Transaction_card__c tcc=new Transaction_card__c(Terms_conditions_accepted__c=true,Account_Passenger__c=accpass.id,Account_Addressing__c=accadd.id);
        insert tcc;
        ApexPages.StandardController controller = new ApexPages.StandardController(tcc);
        PageReference pgRef = Page.CustomerInvoice; //Create Page Reference - 'Appt_New' is the name of Page
		Test.setCurrentPage(pgRef); //Set the page for Test Method
		ApexPages.currentPage().getParameters().put('id', tcc.id);//Pass Id to page
        CustomerInvoiceController sc = new CustomerInvoiceController(controller);
        sc.signatureData='12,13,14';
        sc.GeneratePDF();
    }
        static testMethod void Testcia()
    {
        RecordType pass=[select Id from RecordType where Name =: 'כרטיס נוסע'];
    	RecordType add=[select Id from RecordType where Name =: 'כרטיס פונה'];
    	Account accadd=new account(RecordTypeId=add.id,lastname='testadd');
    	insert accadd;
    	Account accpass=new account(RecordTypeId=pass.id,lastname='testpass');
    	insert accpass;
        Transaction_card__c tcc=new Transaction_card__c(Device_recipient__c='edan',Terms_conditions_accepted__c=true,Account_Passenger__c=accpass.id,Account_Addressing__c=accadd.id);
        insert tcc;
        Document doc = new Document();
                doc.Name='test1';
                doc.AuthorId = UserInfo.getUserId();
                doc.FolderId = UserInfo.getUserId();
                doc.ContentType = 'image/jpeg';
                doc.Type='jpg';
                doc.IsPublic=true;
                doc.Body =EncodingUtil.base64Decode('b64');
                insert doc;
        ApexPages.StandardController controller = new ApexPages.StandardController(tcc);
        PageReference pgRef = Page.CustomerInvoice2; //Create Page Reference - 'Appt_New' is the name of Page
		Test.setCurrentPage(pgRef); //Set the page for Test Method
		ApexPages.currentPage().getParameters().put('id', tcc.id);//Pass Id to page
        ApexPages.currentPage().getParameters().put('sigpic', doc.id);//Pass Id to page
        CustomerInvoiceControllerAccept sc = new CustomerInvoiceControllerAccept(controller);
        sc.signatureData='12,13,14';
        sc.GeneratePDF();
        sc.back();
    }
    static testMethod void Testem()
    {
        RecordType pass=[select Id from RecordType where Name =: 'כרטיס נוסע'];
    	RecordType add=[select Id from RecordType where Name =: 'כרטיס פונה'];
    	Account accadd=new account(RecordTypeId=add.id,lastname='testadd');
    	insert accadd;
    	Account accpass=new account(RecordTypeId=pass.id,lastname='testpass');
    	insert accpass;
        Transaction_card__c tcc=new Transaction_card__c(Terms_conditions_accepted__c=true,Account_Passenger__c=accpass.id,Account_Addressing__c=accadd.id);
        insert tcc;
        attachment at = new Attachment();
        at.body=Blob.valueOf('Unit Test Attachment Body');
        at.OwnerId = UserInfo.getUserId();
        at.ParentId = tcc.Id;
        at.Name=tcc.Name+'.pdf';
        at.ContentType = 'application/pdf';
        insert at;
        ApexPages.StandardController controller = new ApexPages.StandardController(tcc);
        PageReference pgRef = Page.InvoiceEmail; //Create Page Reference - 'Appt_New' is the name of Page
		Test.setCurrentPage(pgRef); //Set the page for Test Method
		ApexPages.currentPage().getParameters().put('id', tcc.id);//Pass Id to page
        ApexPages.currentPage().getParameters().put('atid', at.id);//Pass Id to page
        InvoiceEmailController sc = new InvoiceEmailController(controller);
        sc.tex='test@test.com';
        sc.SendEmail();
    }
}