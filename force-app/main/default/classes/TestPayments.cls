@isTest(seealldata=true)
public without sharing class TestPayments {
    static testMethod void TestAssembly()
    {
            Test.setMock(HttpCalloutMock.class, new MockUSDUpdate());
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
            sc.CheckFirst();
            sc.Redirect();
    }
    static testMethod void TestAcceptP()
    {
        Test.setMock(HttpCalloutMock.class, new MockUSDUpdate());
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
        Test.setMock(HttpCalloutMock.class, new MockUSDUpdate());
            RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
            RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
            Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
            insert acchi;
            Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
            insert accpas;
            Trainings__c tra=new Trainings__c(Date_Time__c=System.now());
            insert tra;
            Transaction_Card__c tcc =new Transaction_Card__c(Device__c='SE+ - מטיילים בארץ',Token_id__c='testspec',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Trainings__c=tra.id,Scheduled_Return_Date__c=system.today(),Date_Of_Delivery_Device__c=system.today());
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
        Test.setMock(HttpCalloutMock.class, new MockUSDUpdate());
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
            Test.setMock(HttpCalloutMock.class, new MockUSDUpdate());
            RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
            RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
            Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
            insert acchi;
            Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
            insert accpas;
            Trainings__c tra=new Trainings__c(Date_Time__c=System.now());
            insert tra;
            Transaction_Card__c tcc =new Transaction_Card__c(Cost_Calculated_Planned_N__c=2,CreditAmount__c=2,Transaction_expected_num_payments__c=2,Manual_Transaction__c=true,Transaction_Start_Date__c=system.today(),Token_id__c='testspec',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Trainings__c=tra.id,Scheduled_Return_Date__c=system.today(),Date_Of_Delivery_Device__c=system.today());
            insert tcc;
            Payment_Transaction__c ptc=new Payment_Transaction__c(Transaction_Card__c=tcc.id);
            insert ptc;
    Test.startTest();
    System.enqueueJob(new QueFuturePay(tcc.id));
    Test.stopTest();
    }
    public static testMethod void testAffiliate() {
        Test.setMock(HttpCalloutMock.class, new MockUSDUpdate());
        Affiliate__c aff=new Affiliate__c(Username__c='test',password__c='test',name='test');
        insert aff;
        RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
        RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
        Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
        insert acchi;
        Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
        insert accpas;
        Trainings__c tra=new Trainings__c(Date_Time__c=System.now());
        insert tra;
        Transaction_Card__c tcc =new Transaction_Card__c(Affiliate__c=aff.id,Token_id__c='testspec',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Trainings__c=tra.id,Scheduled_Return_Date__c=system.today(),Date_Of_Delivery_Device__c=system.today());
        insert tcc;
        Payment__c pam=new Payment__c(Sum__c=323,Token__c='testspec',Parent_Transaction__c=tcc.id);
        insert pam;
        PageReference pgRef = Page.AffiliateReport; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        AffiliateReportController sc = new AffiliateReportController();
        sc.Username=aff.Username__c;
        sc.Password=aff.Password__c;
        sc.Login();
        sc.Terms=true;
        sc.Terms();
        sc.Duration='M';
        sc.RefreshChart();
    }
    public static testMethod void testnewPriceCalc() {
        Test.setMock(HttpCalloutMock.class, new MockUSDUpdate());
        RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
        RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
        Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id,phone='12343');
        insert acchi;
        Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id,phone='12343');
        insert accpas;
        Training_Month__c trm=new Training_Month__c(name='test',Date__c=System.today());
        insert trm;
        Trainings__c tra=new Trainings__c(Date_Time__c=System.now(),Training_Month__c=trm.id);
        insert tra;
        Transaction_Card__c tcc =new Transaction_Card__c(Dollar_Exchange_Rate__c=3.8,Step_Price1__c=2.8,Step_Price2__c=2.6,Step_Price3__c=2.4,Step_Price4__c=1.5,Step_Size1__c=30,Step_Size2__c=90,Step_Size3__c=180,Step_Size4__c=1000,Cost_Calculated_Planned_N__c=2,CreditAmount__c=2,Transaction_expected_num_payments__c=2,Manual_Transaction__c=true,Transaction_Start_Date__c=system.today(),Token_id__c='testspec',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Scheduled_Return_Date__c=system.today(),Date_Of_Delivery_Device__c=System.today(),Date_Trip__c=System.today().addDays(-50),Trainings__c=tra.id);
        insert tcc;
        Payment_Transaction__c ptc=new Payment_Transaction__c(Transaction_Card__c=tcc.id);
        insert ptc;
        Affiliate__c aff=[select id from Affiliate__c limit 1];
        ApexPages.StandardController controller = new ApexPages.StandardController(tcc);
        PageReference pgRef = Page.PriceCalc; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        ApexPages.currentPage().getParameters().put('id', tcc.id);//Pass Id to page
        ApexPages.currentPage().getParameters().put('aff', aff.id);//Pass Id to page
        ApexPages.currentPage().getParameters().put('device', 'A');//Pass Id to page

        PriceController sc = new PriceController(controller);   
    }
    public static testMethod void testPriceCalc() {
        Test.setMock(HttpCalloutMock.class, new MockUSDUpdate());
        RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
        RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
        Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id,phone='12343');
        insert acchi;
        Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id,phone='12343');
        insert accpas;
        Training_Month__c trm=new Training_Month__c(name='test',Date__c=System.today());
        insert trm;
        Trainings__c tra=new Trainings__c(Date_Time__c=System.now(),Training_Month__c=trm.id);
        insert tra;
        Transaction_Card__c tcc =new Transaction_Card__c(Device__c='A',/*Program__c='Magnus Basic',*/Priority__c=1,Dollar_Exchange_Rate__c=3.8,Step_Price1__c=2.8,Step_Price2__c=2.6,Step_Price3__c=2.4,Step_Price4__c=1.5,Step_Size1__c=30,Step_Size2__c=90,Step_Size3__c=180,Step_Size4__c=1000,Cost_Calculated_Planned_N__c=2,CreditAmount__c=2,Transaction_expected_num_payments__c=2,Manual_Transaction__c=true,Transaction_Start_Date__c=system.today(),Token_id__c='testspec',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Scheduled_Return_Date__c=system.today(),Date_Of_Delivery_Device__c=System.today(),Date_Trip__c=System.today().addDays(-50),Trainings__c=tra.id);
        insert tcc;
        Payment_Transaction__c ptc=new Payment_Transaction__c(Transaction_Card__c=tcc.id);
        insert ptc;
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
        sc.selectedProduct='A';
        sc.selectedPlan='A;Magnus Basic;1';
        sc.getPlans();
        sc.changePlan();        
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
        sc.trans(1);
        sc.trans(0);
        tcc.Trainings__c=null;
        
        Account acchi1=new Account(lastname='testspec',Recordtypeid=hi.id,phone='12343');
        insert acchi1;
        Account accpas1=new Account(lastname='testspec',Recordtypeid=pas.id,phone='12343');
        insert accpas1;
        Transaction_Card__c tcc1 =new Transaction_Card__c(Priority__c=1,Dollar_Exchange_Rate__c=3.8,Step_Price1__c=2.8,Step_Price2__c=2.6,Step_Price3__c=2.4,Step_Price4__c=1.5,Step_Size1__c=30,Step_Size2__c=90,Step_Size3__c=180,Step_Size4__c=1000,Cost_Calculated_Planned_N__c=2,CreditAmount__c=2,Transaction_expected_num_payments__c=2,Manual_Transaction__c=true,Transaction_Start_Date__c=system.today(),Token_id__c='testspec',Account_Addressing__c=acchi1.id,Account_Passenger__c=accpas1.id,Date_Of_Delivery_Device__c=system.today());
        insert tcc1;
        Payment_Transaction__c ptc1=new Payment_Transaction__c(Transaction_Card__c=tcc1.id);
        insert ptc1;
        controller = new ApexPages.StandardController(tcc1);
        pgRef = Page.PriceCalc; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        ApexPages.currentPage().getParameters().put('id', tcc1.id);//Pass Id to page
        sc = new PriceController(controller);
        sc.mon=mon.format();
        sc.dat=dat.format();
        sc.RetCheck();

        Payment__c pam=new Payment__c(Sum__c=323,Token__c='testspec',Parent_Transaction__c=tcc.id);
        insert pam;
        controller = new ApexPages.StandardController(tcc);
        pgRef = Page.PriceCalc; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        ApexPages.currentPage().getParameters().put('id', tcc.id);//Pass Id to page
        sc = new PriceController(controller);
        sc.mon=mon.format();
        sc.dat=dat.format();
        sc.RetCheck();
        
    }
    public static testMethod void testPriceCalc2() {
        Test.setMock(HttpCalloutMock.class, new MockUSDUpdate());
        RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
        RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
        Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
        insert acchi;
        Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
        insert accpas;
        Training_Month__c trm=new Training_Month__c(name='test',Date__c=System.today());
        insert trm;
        Trainings__c tra=new Trainings__c(Date_Time__c=System.now(),Training_Month__c=trm.id);
        insert tra;
        Transaction_Card__c tcc =new Transaction_Card__c(Device__c='A',Program__c='Magnus Basic',Priority__c=1,Trainings__c=tra.id,Dollar_Exchange_Rate__c=3.8,Step_Price1__c=2.8,Step_Price2__c=2.6,Step_Price3__c=2.4,Step_Price4__c=1.5,Step_Size1__c=30,Step_Size2__c=90,Step_Size3__c=180,Step_Size4__c=1000,Cost_Calculated_Planned_N__c=2,CreditAmount__c=2,Transaction_expected_num_payments__c=2,Manual_Transaction__c=true,Transaction_Start_Date__c=system.today(),Token_id__c='testspec',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Scheduled_Return_Date__c=system.today(),Date_Of_Delivery_Device__c=system.today());
        insert tcc;
        Payment_Transaction__c ptc=new Payment_Transaction__c(Transaction_Card__c=tcc.id);
        insert ptc;
        ApexPages.StandardController controller = new ApexPages.StandardController(tcc);
        PageReference pgRef = Page.PriceCalc; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        ApexPages.currentPage().getParameters().put('id', tcc.id);//Pass Id to page
        ApexPages.currentPage().getParameters().put('admin', '1');//Pass Id to page
        PriceController sc = new PriceController(controller);
        Date mon = system.today();
        Datetime dat=system.now();
        sc.mon=mon.format();
        sc.dat=dat.format();
        sc.MonthChange();
        sc.Calc();
        sc.RetCheck();
        sc.pass();
        sc.selectedProduct='A';
            sc.selectedPlan='A;Magnus Basic;1';
            sc.getPlans();
                    sc.changePlan();        

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
        sc.trans(1);
        sc.trans(0);
        sc.test();
        
    }
    public static testMethod void testPriceRetCalc() {
        Test.setMock(HttpCalloutMock.class, new MockUSDUpdate());
        RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
        RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
        Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
        insert acchi;
        Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
        insert accpas;
        Trainings__c tra=new Trainings__c(Date_Time__c=System.now());
        insert tra;
        Transaction_Card__c tcc =new Transaction_Card__c(Device__c='A',Program__c='Magnus Basic',Priority__c=1,Return_Date_Updated__c=System.Today().addDays(1),Dollar_Exchange_Rate__c=3.8,Step_Price1__c=2.8,Step_Price2__c=2.6,Step_Price3__c=2.4,Step_Price4__c=1.5,Step_Size1__c=30,Step_Size2__c=90,Step_Size3__c=180,Step_Size4__c=1000,Cost_Calculated_Planned_N__c=2,CreditAmount__c=2,Transaction_expected_num_payments__c=2,Manual_Transaction__c=true,Transaction_Start_Date__c=system.today(),Token_id__c='testspec',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Trainings__c=tra.id,Date_Of_Delivery_Device__c=System.today(),Date_Trip__c=System.today().addDays(-50),Scheduled_Return_Date__c=system.today().addDays(40));
        insert tcc;
        Payment_Transaction__c ptc=new Payment_Transaction__c(Transaction_Card__c=tcc.id);
        insert ptc;
        Payment__c pam=new Payment__c(Sum__c=323,Token__c='testspec',Parent_Transaction__c=tcc.id,Payment_Transaction__c=ptc.id);
        insert pam;
        ApexPages.StandardController controller = new ApexPages.StandardController(tcc);
        PageReference pgRef = Page.PriceRetCalc; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        ApexPages.currentPage().getParameters().put('id', tcc.id);//Pass Id to page
        PriceRetController sc = new PriceRetController(controller);
        Date mon = system.today();
        sc.initialize();
        sc.changePlan();        
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
        Test.setMock(HttpCalloutMock.class, new MockUSDUpdate());
        RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
        RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
        Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
        insert acchi;
        Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
        insert accpas;
        Trainings__c tra=new Trainings__c(Date_Time__c=System.now());
        insert tra;
        Transaction_Card__c tcc =new Transaction_Card__c(Device__c='A',Program__c='Magnus Basic',Priority__c=1,Return_Date_Updated__c=System.Today().addDays(1),Dollar_Exchange_Rate__c=3.8,Step_Price1__c=2.8,Step_Price2__c=2.6,Step_Price3__c=2.4,Step_Price4__c=1.5,Step_Size1__c=30,Step_Size2__c=90,Step_Size3__c=180,Step_Size4__c=1000,Cost_Calculated_Planned_N__c=2,CreditAmount__c=2,Transaction_expected_num_payments__c=2,Manual_Transaction__c=true,Transaction_Start_Date__c=system.today(),Token_id__c='testspec',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Trainings__c=tra.id,Date_Of_Delivery_Device__c=System.today(),Date_Trip__c=System.today().addDays(-50),Scheduled_Return_Date__c=system.today().addDays(1));
        insert tcc;
        Payment_Transaction__c ptc=new Payment_Transaction__c(Transaction_Card__c=tcc.id);
        insert ptc;
        Payment__c pam=new Payment__c(Sum__c=323,Token__c='testspec',Parent_Transaction__c=tcc.id,Payment_Transaction__c=ptc.id);
        insert pam;
        ApexPages.StandardController controller = new ApexPages.StandardController(tcc);
        PageReference pgRef = Page.PriceRetCalc; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        ApexPages.currentPage().getParameters().put('id', tcc.id);//Pass Id to page
        PriceRetController sc = new PriceRetController(controller);
        Date mon = system.today();
        sc.initialize();
        sc.changePlan();        
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
        sc.test();
    }
    public static testMethod void testPriceTel() {
        Test.setMock(HttpCalloutMock.class, new MockUSDUpdate());
        RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
        RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
        Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
        insert acchi;
        Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
        insert accpas;
        Trainings__c tra=new Trainings__c(Date_Time__c=System.now());
        insert tra;
        Transaction_Card__c tcc =new Transaction_Card__c(Return_Date_Updated__c=System.Today().addDays(1),Dollar_Exchange_Rate__c=3.8,Step_Price1__c=2.8,Step_Price2__c=2.6,Step_Price3__c=2.4,Step_Price4__c=1.5,Step_Size1__c=30,Step_Size2__c=90,Step_Size3__c=180,Step_Size4__c=1000,Cost_Calculated_Planned_N__c=2,CreditAmount__c=2,Transaction_expected_num_payments__c=2,Manual_Transaction__c=true,Transaction_Start_Date__c=system.today(),Token_id__c='testspec',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Trainings__c=tra.id,Date_Of_Delivery_Device__c=System.today(),Date_Trip__c=System.today().addDays(-50),Scheduled_Return_Date__c=system.today().addDays(1));
        insert tcc;
        Payment_Transaction__c ptc=new Payment_Transaction__c(Transaction_Card__c=tcc.id);
        insert ptc;
        ApexPages.StandardController controller = new ApexPages.StandardController(tcc);
        PageReference pgRef = Page.PriceTel; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        ApexPages.currentPage().getParameters().put('id', tcc.id);//Pass Id to page
        PriceTelController sc = new PriceTelController(controller);
        sc.checkmanual();
    }
    public static testMethod void testSuccess() {
        Test.setMock(HttpCalloutMock.class, new MockUSDUpdate());
        RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
        RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
        Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
        insert acchi;
        Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
        insert accpas;
        Trainings__c tra=new Trainings__c(Date_Time__c=System.now());
        insert tra;
        Transaction_Card__c tcc =new Transaction_Card__c(Return_Date_Updated__c=System.Today().addDays(1),Dollar_Exchange_Rate__c=3.8,Step_Price1__c=2.8,Step_Price2__c=2.6,Step_Price3__c=2.4,Step_Price4__c=1.5,Step_Size1__c=30,Step_Size2__c=90,Step_Size3__c=180,Step_Size4__c=1000,Cost_Calculated_Planned_N__c=2,CreditAmount__c=2,Transaction_expected_num_payments__c=2,Manual_Transaction__c=true,Transaction_Start_Date__c=system.today(),Token_id__c='testspec',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Trainings__c=tra.id,Date_Of_Delivery_Device__c=System.today(),Date_Trip__c=System.today().addDays(-50),Scheduled_Return_Date__c=system.today().addDays(1));
        insert tcc;
        Payment_Transaction__c ptc=new Payment_Transaction__c(Transaction_Card__c=tcc.id);
        insert ptc;
        ApexPages.StandardController controller = new ApexPages.StandardController(tcc);
        PageReference pgRef = Page.SuccessVF; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        ApexPages.currentPage().getParameters().put('SF_Transaction_Id', ptc.id+','+system.today().format()+','+'lsdjfkgh'+','+'true'+','+'03:00:00.000z'+','+'');//Pass Id to page
        ApexPages.currentPage().getParameters().put('TranzilaTK', '12323456');//Pass Id to page
        ApexPages.currentPage().getParameters().put('expmonth', '12');//Pass Id to page
        ApexPages.currentPage().getParameters().put('expyear', '30');//Pass Id to page
        ApexPages.currentPage().getParameters().put('Response', '000');//Pass Id to page
        ApexPages.currentPage().getParameters().put('npay', '2');//Pass Id to page
        ApexPages.currentPage().getParameters().put('tranmode', 'test');//Pass Id to page
        ApexPages.currentPage().getParameters().put('ConfirmationCode', '123');//Pass Id to page
        ApexPages.currentPage().getParameters().put('index', '123');//Pass Id to page
        ApexPages.currentPage().getParameters().put('sum', '23.8');//Pass Id to page
        SuccessController sc = new SuccessController(controller);
        sc.ptls[0].pt.Quantity__c=1;
        sc.upprice();
        sc.up();

        sc.additems();

        ApexPages.StandardController controller1 = new ApexPages.StandardController(tcc);
        PageReference pgRef1 = Page.SuccessVF; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef1); //Set the page for Test Method
        ApexPages.currentPage().getParameters().put('SF_Transaction_Id', tcc.id+','+system.today().format()+','+'lsdjfkgh'+','+'true'+','+'03:00:00.000z'+','+'');//Pass Id to page
        ApexPages.currentPage().getParameters().put('TranzilaTK', '12323456');//Pass Id to page
        ApexPages.currentPage().getParameters().put('expmonth', '12');//Pass Id to page
        ApexPages.currentPage().getParameters().put('expyear', '30');//Pass Id to page
        ApexPages.currentPage().getParameters().put('Response', '000');//Pass Id to page
        ApexPages.currentPage().getParameters().put('npay', '2');//Pass Id to page
        ApexPages.currentPage().getParameters().put('tranmode', 'test');//Pass Id to page
        ApexPages.currentPage().getParameters().put('ConfirmationCode', '123');//Pass Id to page
        ApexPages.currentPage().getParameters().put('index', '123');//Pass Id to page
        ApexPages.currentPage().getParameters().put('sum', '23.8');//Pass Id to page
        SuccessController sc1 = new SuccessController(controller1);
        sc1.up();

        ApexPages.StandardController controller2 = new ApexPages.StandardController(tcc);
        PageReference pgRef2 = Page.SuccessVF; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef2); //Set the page for Test Method
        ApexPages.currentPage().getParameters().put('SF_Transaction_Id', tcc.id+','+system.today().format()+','+'lsdjfkgh'+','+'true'+','+'03:00:00.000z'+','+'');//Pass Id to page
        ApexPages.currentPage().getParameters().put('TranzilaTK', '12323456');//Pass Id to page
        ApexPages.currentPage().getParameters().put('expmonth', '12');//Pass Id to page
        ApexPages.currentPage().getParameters().put('expyear', '30');//Pass Id to page
        ApexPages.currentPage().getParameters().put('Response', '000');//Pass Id to page
        ApexPages.currentPage().getParameters().put('npay', '2');//Pass Id to page
        ApexPages.currentPage().getParameters().put('tranmode', 'test');//Pass Id to page
        ApexPages.currentPage().getParameters().put('ConfirmationCode', '123');//Pass Id to page
        ApexPages.currentPage().getParameters().put('index', '123');//Pass Id to page
        ApexPages.currentPage().getParameters().put('sum', '23.8');//Pass Id to page
        SuccessController sc2 = new SuccessController(controller2);
        sc2.up();
    }
    public static testMethod void testNepal(){
        Test.setMock(HttpCalloutMock.class, new MockUSDUpdate());
        RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
        RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
        Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
        insert acchi;
        Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
        insert accpas;
        Trainings__c tra=new Trainings__c(Date_Time__c=System.now());
        insert tra;
        RecordType rec=[select id from RecordType where name='נפאל'];
        Transaction_Card__c tcc =new Transaction_Card__c(Status__c='חדש',RecordTypeId=rec.id,Return_Date_Updated__c=System.Today().addDays(1),Dollar_Exchange_Rate__c=3.8,Step_Price1__c=2.8,Step_Price2__c=2.6,Step_Price3__c=2.4,Step_Price4__c=1.5,Step_Size1__c=30,Step_Size2__c=90,Step_Size3__c=180,Step_Size4__c=1000,Cost_Calculated_Planned_N__c=2,CreditAmount__c=2,Transaction_expected_num_payments__c=2,Manual_Transaction__c=true,Transaction_Start_Date__c=system.today(),Device__c='SE+',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Trainings__c=tra.id,Date_Of_Delivery_Device__c=System.today().addDays(-50),Date_Trip__c=System.today().addDays(-50),Scheduled_Return_Date__c=system.today().addDays(-40));
        insert tcc;
        Card_Device__c cdev = new Card_Device__c(model__c='SE+',DeviceLocation__c='נפאל',status__c='תקין',Inventory__c='במלאי',IMEI__c='1234');
        insert cdev;
        PageReference pgRef = Page.NepalPrice;
        Test.setCurrentPage(pgRef);
        ApexPages.currentPage().getParameters().put('id', tcc.id);
        NepalPriceController np = new NepalPriceController();
        //np.Tranzilla();
        np.imei = cdev.IMEI__c;
        np.pay = 20;
        np.Paid();
        tcc.Token_id__c='testspec';
        tcc.Status__c='בטיול - נפאל';
        update tcc;
        np.InitCalc();
        np.searchRet();
        np.Ret();
        NepalFinesScheduler sc = new NepalFinesScheduler();
        sc.execute(null);
        ID jobID = System.enqueueJob(new NepalFinesQueue(null));
        PageReference pgRef1 = Page.NepalPrice;
        Test.setCurrentPage(pgRef1);
        ApexPages.currentPage().getParameters().put('id', cdev.IMEI__c);
        ApexPages.currentPage().getParameters().put('status', 'bad');
    }
    static testMethod void TestAssemblyDesk(){
        Test.setMock(HttpCalloutMock.class, new MockUSDUpdate());
        RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
        Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
        insert acchi;
        Incident_Report__c inc =new Incident_Report__c( Account_Addressing__c=acchi.id,Type_Desk_Rescue__c='Rescue',Event_Status__c='Open');
        insert inc;
        ApexPages.StandardController controller = new ApexPages.StandardController(inc);
        PageReference pgRef = Page.AssemblyDesk; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        ApexPages.currentPage().getParameters().put('id', inc.id);//Pass Id to page
        AssemblyDeskController sc = new AssemblyDeskController(controller);
        sc.Redirect();
    }
    static testMethod void TestNatBag(){
        Test.setMock(HttpCalloutMock.class, new MockUSDUpdate());
        RecordType pas=[select id from RecordType where name = 'כרטיס נוסע'];
        RecordType hi=[select id from RecordType where name = 'כרטיס פונה'];
        Account acchi=new Account(lastname='testspec',Recordtypeid=hi.id);
        insert acchi;
        Account accpas=new Account(lastname='testspec',Recordtypeid=pas.id);
        insert accpas;
        Trainings__c tra=new Trainings__c(Date_Time__c=System.now());
        insert tra;
        Transaction_Card__c tcc =new Transaction_Card__c(Pickup_in_Natbag__c=true,Return_in_Natbag__c=true,Return_Date_Updated__c=System.Today().addDays(1),Dollar_Exchange_Rate__c=3.8,Step_Price1__c=2.8,Step_Price2__c=2.6,Step_Price3__c=2.4,Step_Price4__c=1.5,Step_Size1__c=30,Step_Size2__c=90,Step_Size3__c=180,Step_Size4__c=1000,Cost_Calculated_Planned_N__c=2,CreditAmount__c=2,Transaction_expected_num_payments__c=2,Manual_Transaction__c=true,Transaction_Start_Date__c=system.today(),Device__c='A',Account_Addressing__c=acchi.id,Account_Passenger__c=accpas.id,Trainings__c=tra.id,Date_Of_Delivery_Device__c=System.today().addDays(-50),Date_Trip__c=System.today().addDays(-50),Scheduled_Return_Date__c=system.today().addDays(-40));
        insert tcc;
        Card_Device__c cdev = new Card_Device__c(model__c='A',DeviceLocation__c='מגנוס',status__c='תקין',Inventory__c='במלאי',IMEI__c='1234');
        insert cdev;

        //natbag
        tcc.Card_Device__c=cdev.id;
        update tcc;
        tcc.Status__c='ממתין לאיסוף בנתב\"ג';
        update tcc;
        String imei = [select IMEI__c from Transaction_Card__c where id=:tcc.id].IMEI__c;
        NatBagController ng = new NatBagController();
        ng.IMEI=imei;
        ng.Departures();
        ng.IMEI=imei;
        ng.VAULT='1234';
        ng.Vaults();
        ng.IMEI=imei;
        ng.Arrivals();
    }
}