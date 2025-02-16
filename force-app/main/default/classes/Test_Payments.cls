@isTest
public with sharing class Test_Payments {
	static testMethod void TestAssembly()
	{
			RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
			RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
			Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
			insert acchi;
			Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
			insert accpas;
			Transaction_Card__c tcc =new Transaction_Card__c( Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id);
			insert tcc;
			ApexPages.StandardController controller = new ApexPages.StandardController(tcc);
			PageReference pgRef = Page.AssemblyVF; //Create Page Reference - 'Appt_New' is the name of Page
			Test.setCurrentPage(pgRef); //Set the page for Test Method
			ApexPages.currentPage().getParameters().put('id', tcc.id);//Pass Id to page
			AssemblyController sc = new AssemblyController(controller);
			sc.Tran();
	}
	static testMethod void TestAcceptP()
	{
			RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
			RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
			Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
			insert acchi;
			Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
			insert accpas;
			Trainings__c tra=new Trainings__c(Date_Time__c=System.now());
			insert tra;
			Transaction_Card__c tcc =new Transaction_Card__c( Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Trainings__c=tra.id,Scheduled_Return_Date__c=system.today(),Date_Of_Delivery_Device__c=system.today());
			insert tcc;
			ApexPages.StandardController controller = new ApexPages.StandardController(tcc);
			PageReference pgRef = Page.AcceptP; //Create Page Reference - 'Appt_New' is the name of Page
			Test.setCurrentPage(pgRef); //Set the page for Test Method
			ApexPages.currentPage().getParameters().put('id', tcc.id);//Pass Id to page
			AcceptPController sc = new AcceptPController(controller);
			sc.Submit();
			sc.Back();
	}
	static testMethod void TestCharge()
	{
			RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
			RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
			Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
			insert acchi;
			Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
			insert accpas;
			Trainings__c tra=new Trainings__c(Date_Time__c=System.now());
			insert tra;
			Transaction_Card__c tcc =new Transaction_Card__c(Token_id__c='testspec',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Trainings__c=tra.id,Scheduled_Return_Date__c=system.today(),Date_Of_Delivery_Device__c=system.today());
			insert tcc;
			Payment_Transaction__c ptc=new Payment_Transaction__c(Transaction_Card__c=tcc.id);
			insert ptc;
			Payment__c pam=new Payment__c(Sum__c=323,Token__c='testspec',Parent_Transaction__c=tcc.id,Payment_Transaction__c=ptc.id);
			insert pam;
			PageReference pgRef = Page.ChargeOrRefund; //Create Page Reference - 'Appt_New' is the name of Page
			Test.setCurrentPage(pgRef); //Set the page for Test Method
			ApexPages.currentPage().getParameters().put('id', ptc.id);//Pass Id to page
			ChargeOrRefundController sc = new ChargeOrRefundController();
			sc.TokGo='True';
			sc.Half='True';
			sc.getitems();
			sc.getprices();
			sc.Submit();
			PageReference pgRef2 = Page.ChargeOrRefund; //Create Page Reference - 'Appt_New' is the name of Page
			Test.setCurrentPage(pgRef2); //Set the page for Test Method
			ApexPages.currentPage().getParameters().put('id', pam.id);//Pass Id to page
			ChargeOrRefundController sc1 = new ChargeOrRefundController();
			sc1.TokGo='True';
			sc1.Half='True';
			sc1.Pricepart='323';
			sc1.getitems();
			sc1.getprices();
			sc1.Submit();
			PageReference pgRef3 = Page.ChargeOrRefund; //Create Page Reference - 'Appt_New' is the name of Page
			Test.setCurrentPage(pgRef3); //Set the page for Test Method
			ApexPages.currentPage().getParameters().put('id', pam.id);//Pass Id to page
			ChargeOrRefundController sc2 = new ChargeOrRefundController();
			sc2.TokGo='True';
			sc2.Half='False';
			sc2.Pricepart='323';
			sc2.getitems();
			sc2.getprices();
			sc2.Submit();
	}
	public static testMethod void testschedule() {
		RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
		RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
		Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
		insert acchi;
		Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
		insert accpas;
		Trainings__c tra=new Trainings__c(Date_Time__c=System.now());
		insert tra;
		Transaction_Card__c tcc =new Transaction_Card__c(Manual_Transaction__c=true,Transaction_Start_Date__c=system.today(),Token_id__c='testspec',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Trainings__c=tra.id,Scheduled_Return_Date__c=system.today(),Date_Of_Delivery_Device__c=system.today());
		insert tcc;
		Payment_Transaction__c ptc=new Payment_Transaction__c(Transaction_Card__c=tcc.id);
		insert ptc;
		Payment__c pam=new Payment__c(Sum__c=323,Token__c='testspec',Parent_Transaction__c=tcc.id,Payment_Transaction__c=ptc.id);
		insert pam;
    SCFuturePay sh1 = new SCFuturePay();
    String sch = '0 0 23 * * ?';
    system.schedule('Test', sch, sh1);
	}
    public static testMethod void testqueue() {
			RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
			RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
			Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
			insert acchi;
			Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
			insert accpas;
			Trainings__c tra=new Trainings__c(Date_Time__c=System.now());
			insert tra;
			Transaction_Card__c tcc =new Transaction_Card__c(Cost_Calculated_Planned_N__c=2,Transaction_expected_num_payments__c=2,Manual_Transaction__c=true,Transaction_Start_Date__c=system.today(),Token_id__c='testspec',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Trainings__c=tra.id,Scheduled_Return_Date__c=system.today(),Date_Of_Delivery_Device__c=system.today());
			insert tcc;
			Payment_Transaction__c ptc=new Payment_Transaction__c(Transaction_Card__c=tcc.id);
			insert ptc;
    Test.startTest();
    System.enqueueJob(new QueFuturePay(tcc.id));
    Test.stopTest();
	}
	public static testMethod void testPriceCalc() {
		RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
		RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
		Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
		insert acchi;
		Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
		insert accpas;
		Trainings__c tra=new Trainings__c(Date_Time__c=System.now());
		insert tra;
		Transaction_Card__c tcc =new Transaction_Card__c(Dollar_Exchange_Rate__c=3.8,Step_Price1__c=2.8,Step_Price2__c=2.6,Step_Price3__c=2.4,Step_Price4__c=1.5,Step_Size1__c=30,Step_Size2__c=90,Step_Size3__c=180,Step_Size4__c=1000,Cost_Calculated_Planned_N__c=2,Transaction_expected_num_payments__c=2,Manual_Transaction__c=true,Transaction_Start_Date__c=system.today(),Token_id__c='testspec',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Trainings__c=tra.id,Scheduled_Return_Date__c=system.today(),Date_Of_Delivery_Device__c=system.today());
		insert tcc;
		Payment_Transaction__c ptc=new Payment_Transaction__c(Transaction_Card__c=tcc.id);
		insert ptc;
		PriceMin__c min=new PriceMin__c(Name='Default',MinDays__c=28);
		insert min;
		ApexPages.StandardController controller = new ApexPages.StandardController(tcc);
		PageReference pgRef = Page.PriceCalc; //Create Page Reference - 'Appt_New' is the name of Page
		Test.setCurrentPage(pgRef); //Set the page for Test Method
		ApexPages.currentPage().getParameters().put('id', tcc.id);//Pass Id to page
		PriceController sc = new PriceController(controller);
		Date mon = system.today();
		Datetime dat=system.now();
		sc.mon=mon.format();
		sc.dat=dat.format();
		sc.MonthChange();
		sc.Calc();
		sc.RetCheck();
		sc.pass();
		sc.Submit();
		sc.uptcc.Scheduled_Return_Date__c=mon.AddDays(31);
		sc.MonthChange();
		sc.Calc();
		sc.Submit();
		sc.uptcc.Scheduled_Return_Date__c=mon.AddDays(91);
		sc.MonthChange();
		sc.Calc();
		sc.Submit();
		sc.uptcc.Scheduled_Return_Date__c=mon.AddDays(181);
		sc.MonthChange();
		sc.Calc();
		sc.Submit();
		sc.submitTel();
}
public static testMethod void testPriceRetCalc() {
	RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
	RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
	Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
	insert acchi;
	Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
	insert accpas;
	Trainings__c tra=new Trainings__c(Date_Time__c=System.now());
	insert tra;
	Transaction_Card__c tcc =new Transaction_Card__c(Return_Date_Updated__c=System.Today().addDays(1),Dollar_Exchange_Rate__c=3.8,Step_Price1__c=2.8,Step_Price2__c=2.6,Step_Price3__c=2.4,Step_Price4__c=1.5,Step_Size1__c=30,Step_Size2__c=90,Step_Size3__c=180,Step_Size4__c=1000,Cost_Calculated_Planned_N__c=2,Transaction_expected_num_payments__c=2,Manual_Transaction__c=true,Transaction_Start_Date__c=system.today(),Token_id__c='testspec',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Trainings__c=tra.id,Date_Of_Delivery_Device__c=System.today(),Scheduled_Return_Date__c=system.today().addDays(40));
	insert tcc;
	Payment_Transaction__c ptc=new Payment_Transaction__c(Transaction_Card__c=tcc.id);
	insert ptc;
	PriceMin__c min=new PriceMin__c(Name='Default',MinDays__c=28);
	insert min;
	Payment__c pam=new Payment__c(Sum__c=323,Token__c='testspec',Parent_Transaction__c=tcc.id,Payment_Transaction__c=ptc.id);
	insert pam;
	ApexPages.StandardController controller = new ApexPages.StandardController(tcc);
	PageReference pgRef = Page.PriceRetCalc; //Create Page Reference - 'Appt_New' is the name of Page
	Test.setCurrentPage(pgRef); //Set the page for Test Method
	ApexPages.currentPage().getParameters().put('id', tcc.id);//Pass Id to page
	PriceRetController sc = new PriceRetController(controller);
	Date mon = system.today();
	sc.Calc();
	sc.RetCheck();
	sc.Submit();
	sc.uptcc.Return_Date_Updated__c=mon.AddDays(5);
	sc.Calc();
	sc.Submit();
	sc.uptcc.Return_Date_Updated__c=mon.AddDays(31);
	sc.Calc();
	sc.Submit();
	sc.uptcc.Return_Date_Updated__c=mon.AddDays(91);
	sc.Calc();
	sc.Submit();
	sc.uptcc.Return_Date_Updated__c=mon.AddDays(181);
	sc.Calc();
	sc.Submit();
}
public static testMethod void testPriceRetCalc1() {
	RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
	RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
	Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
	insert acchi;
	Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
	insert accpas;
	Trainings__c tra=new Trainings__c(Date_Time__c=System.now());
	insert tra;
	Transaction_Card__c tcc =new Transaction_Card__c(Return_Date_Updated__c=System.Today().addDays(1),Dollar_Exchange_Rate__c=3.8,Step_Price1__c=2.8,Step_Price2__c=2.6,Step_Price3__c=2.4,Step_Price4__c=1.5,Step_Size1__c=30,Step_Size2__c=90,Step_Size3__c=180,Step_Size4__c=1000,Cost_Calculated_Planned_N__c=2,Transaction_expected_num_payments__c=2,Manual_Transaction__c=true,Transaction_Start_Date__c=system.today(),Token_id__c='testspec',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Trainings__c=tra.id,Date_Of_Delivery_Device__c=System.today(),Scheduled_Return_Date__c=system.today().addDays(1));
	insert tcc;
	Payment_Transaction__c ptc=new Payment_Transaction__c(Transaction_Card__c=tcc.id);
	insert ptc;
	PriceMin__c min=new PriceMin__c(Name='Default',MinDays__c=28);
	insert min;
	Payment__c pam=new Payment__c(Sum__c=323,Token__c='testspec',Parent_Transaction__c=tcc.id,Payment_Transaction__c=ptc.id);
	insert pam;
	ApexPages.StandardController controller = new ApexPages.StandardController(tcc);
	PageReference pgRef = Page.PriceRetCalc; //Create Page Reference - 'Appt_New' is the name of Page
	Test.setCurrentPage(pgRef); //Set the page for Test Method
	ApexPages.currentPage().getParameters().put('id', tcc.id);//Pass Id to page
	PriceRetController sc = new PriceRetController(controller);
	Date mon = system.today();
	sc.Calc();
	sc.RetCheck();
	sc.Submit();
	sc.uptcc.Return_Date_Updated__c=mon.AddDays(5);
	sc.Calc();
	sc.Submit();
	sc.uptcc.Return_Date_Updated__c=mon.AddDays(31);
	sc.Calc();
	sc.Submit();
	sc.uptcc.Return_Date_Updated__c=mon.AddDays(91);
	sc.Calc();
	sc.Submit();
	sc.uptcc.Return_Date_Updated__c=mon.AddDays(181);
	sc.Calc();
	sc.Submit();
}
public static testMethod void testPriceTel() {
	RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
	RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
	Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
	insert acchi;
	Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
	insert accpas;
	Trainings__c tra=new Trainings__c(Date_Time__c=System.now());
	insert tra;
	Transaction_Card__c tcc =new Transaction_Card__c(Return_Date_Updated__c=System.Today().addDays(1),Dollar_Exchange_Rate__c=3.8,Step_Price1__c=2.8,Step_Price2__c=2.6,Step_Price3__c=2.4,Step_Price4__c=1.5,Step_Size1__c=30,Step_Size2__c=90,Step_Size3__c=180,Step_Size4__c=1000,Cost_Calculated_Planned_N__c=2,Transaction_expected_num_payments__c=2,Manual_Transaction__c=true,Transaction_Start_Date__c=system.today(),Token_id__c='testspec',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Trainings__c=tra.id,Date_Of_Delivery_Device__c=System.today(),Scheduled_Return_Date__c=system.today().addDays(1));
	insert tcc;
	Payment_Transaction__c ptc=new Payment_Transaction__c(Transaction_Card__c=tcc.id);
	insert ptc;
	PriceMin__c min=new PriceMin__c(Name='Default',MinDays__c=28);
	insert min;
	ApexPages.StandardController controller = new ApexPages.StandardController(tcc);
	PageReference pgRef = Page.PriceTel; //Create Page Reference - 'Appt_New' is the name of Page
	Test.setCurrentPage(pgRef); //Set the page for Test Method
	ApexPages.currentPage().getParameters().put('id', tcc.id);//Pass Id to page
	PriceTelController sc = new PriceTelController(controller);
}
public static testMethod void testSuccess() {
	RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
	RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
	Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
	insert acchi;
	Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
	insert accpas;
	Trainings__c tra=new Trainings__c(Date_Time__c=System.now());
	insert tra;
	Transaction_Card__c tcc =new Transaction_Card__c(Return_Date_Updated__c=System.Today().addDays(1),Dollar_Exchange_Rate__c=3.8,Step_Price1__c=2.8,Step_Price2__c=2.6,Step_Price3__c=2.4,Step_Price4__c=1.5,Step_Size1__c=30,Step_Size2__c=90,Step_Size3__c=180,Step_Size4__c=1000,Cost_Calculated_Planned_N__c=2,Transaction_expected_num_payments__c=2,Manual_Transaction__c=true,Transaction_Start_Date__c=system.today(),Token_id__c='testspec',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Trainings__c=tra.id,Date_Of_Delivery_Device__c=System.today(),Scheduled_Return_Date__c=system.today().addDays(1));
	insert tcc;
	Payment_Transaction__c ptc=new Payment_Transaction__c(Transaction_Card__c=tcc.id);
	insert ptc;
	PriceMin__c min=new PriceMin__c(Name='Default',MinDays__c=28);
	insert min;
	ApexPages.StandardController controller = new ApexPages.StandardController(tcc);
	PageReference pgRef = Page.SuccessVF; //Create Page Reference - 'Appt_New' is the name of Page
	Test.setCurrentPage(pgRef); //Set the page for Test Method
	ApexPages.currentPage().getParameters().put('SF_Transaction_Id', ptc.id);//Pass Id to page
	ApexPages.currentPage().getParameters().put('TranzilaTK', '12323456');//Pass Id to page
	ApexPages.currentPage().getParameters().put('expmonth', '12');//Pass Id to page
	ApexPages.currentPage().getParameters().put('expyear', '30');//Pass Id to page
	ApexPages.currentPage().getParameters().put('Response', '000');//Pass Id to page
	ApexPages.currentPage().getParameters().put('npay', '2');//Pass Id to page
	ApexPages.currentPage().getParameters().put('tranmode', 'test');//Pass Id to page
	ApexPages.currentPage().getParameters().put('ConfirmationCode', '123');//Pass Id to page
	ApexPages.currentPage().getParameters().put('index', '123');//Pass Id to page
	SuccessController sc = new SuccessController(controller);
	sc.up();
	ApexPages.StandardController controller1 = new ApexPages.StandardController(tcc);
	PageReference pgRef1 = Page.SuccessVF; //Create Page Reference - 'Appt_New' is the name of Page
	Test.setCurrentPage(pgRef1); //Set the page for Test Method
	ApexPages.currentPage().getParameters().put('SF_Transaction_Id', tcc.id);//Pass Id to page
	ApexPages.currentPage().getParameters().put('TranzilaTK', '12323456');//Pass Id to page
	ApexPages.currentPage().getParameters().put('expmonth', '12');//Pass Id to page
	ApexPages.currentPage().getParameters().put('expyear', '30');//Pass Id to page
	ApexPages.currentPage().getParameters().put('Response', '000');//Pass Id to page
	ApexPages.currentPage().getParameters().put('npay', '2');//Pass Id to page
	ApexPages.currentPage().getParameters().put('tranmode', 'test');//Pass Id to page
	ApexPages.currentPage().getParameters().put('ConfirmationCode', '123');//Pass Id to page
	ApexPages.currentPage().getParameters().put('index', '123');//Pass Id to page
	SuccessController sc1 = new SuccessController(controller1);
	sc1.up();
}
}