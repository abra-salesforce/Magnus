@isTest 
private class VoicenterTestClass {
    static testMethod void validateVoicenter() {
        //VoicenterApex apex = new VoicenterApex();
        
        string x =  VoicenterApex.FindIDByPhone('0523574321');
        System.assertNotEquals(x,'');
        
        
        string x1 =  VoicenterApex.FindIDByPhone('');
        object y =  VoicenterApex.FindObjectByPhone('0523574321');
        object y11 =  VoicenterApex.FindObjectByPhone('');
        
        VoicenterApex.VoicenterCrmData crm = new VoicenterApex.VoicenterCrmData();
        crm.CustomerFieldName='WhoId';
        crm.StatusFieldValue ='Completed';
        crm.DefaultCdrOwnerID='005b0000000eXBmAAM';
        crm.DefaultCustomerFieldName='Contact';  
        
        VoicenterApex.VoicenterCrmData crm2 = new VoicenterApex.VoicenterCrmData();
        crm2.CustomerFieldName='dddddddd';
        crm2.StatusFieldValue ='Completed';
        crm2.DefaultCdrOwnerID='';
        crm2.DefaultCustomerFieldName='ddddd';
        
        VoicenterApex.VoicenterCDR cdr = new VoicenterApex.VoicenterCDR();
        cdr.CallID ='456474567677';
        cdr.CallerExtension='qGgCG45d';
        cdr.CallerNumber='0732248111';
        cdr.DateEpoch=0;
        cdr.DialStatus='Test';
        cdr.Duration=0;
        cdr.ID=0;
        cdr.RecordURL='http://test.com/769879898';
        cdr.TargetExtension='qGgCG45d';
        cdr.TargetNumber='0523574321';
        cdr.UrlID=0;
        
        object z=   VoicenterApex.LogCalls(crm, cdr);
        object z2=  VoicenterApex.GetUserID( cdr,crm.DefaultCdrOwnerID);
        object z3=  VoicenterApex.GetCustomerID( cdr,crm.DefaultCustomerFieldName);
        object z9=   VoicenterApex.LogCalls(crm, cdr);
        System.assertNotEquals(z9,null);
        VoicenterApex.VoicenterCDR cdr2 = new VoicenterApex.VoicenterCDR();
        cdr2.CallID ='0523574321';
        cdr2.CallerExtension='qGgCG45d';
        cdr2.CallerNumber='0523574321';
        cdr2.DateEpoch=0;
        cdr2.DialStatus='Test';
        cdr2.Duration=0;
        cdr2.ID=0;
        cdr2.RecordURL='http://test.com/769879898';
        cdr2.TargetExtension='qGgCG45d';
        cdr2.TargetNumber='0732248111';
        cdr2.UrlID=0;
        
        object z22=   VoicenterApex.LogCalls(crm, cdr2);   
        object z222=   VoicenterApex.LogCalls(crm2, cdr2);   

        VoicenterApex.VoicenterCDR cdr3 = new VoicenterApex.VoicenterCDR();
        cdr3.CallID ='';
        cdr3.CallerExtension='';
        cdr3.CallerNumber='';
        cdr3.DateEpoch=0;
        cdr3.DialStatus='';
        cdr3.Duration=0;
        cdr3.ID=0;
        cdr3.RecordURL='';
        cdr3.TargetExtension='';
        cdr3.TargetNumber='';
        cdr3.UrlID=0;
        object z33=   VoicenterApex.LogCalls(crm, cdr3);
        object z333=   VoicenterApex.LogCalls(crm2, cdr3);
        object z39=  VoicenterApex.GetCustomerID( cdr2,crm2.DefaultCustomerFieldName);
        object z29=  VoicenterApex.GetUserID( cdr2,crm.DefaultCdrOwnerID);
        
        object c2cTask1 = VoicenterApex.CreateTaskFromClick2Call('','003b0000011N37D');
        System.assertNotEquals(c2cTask1,null);
        object c2cTask2 = VoicenterApex.CreateTaskFromClick2Call('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx','003b0000011N37D');
        System.assertNotEquals(c2cTask2,null);
        object c2cTask3 = VoicenterApex.CreateTaskFromClick2Call('','');
        System.assertNotEquals(c2cTask3,null);
        object c2cTask4 = VoicenterApex.CreateTaskFromClick2Call('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx','');
        System.assertNotEquals(c2cTask4,null);
        object c2cTask5 = VoicenterApex.CreateTaskFromClick2Call('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx','kaka');
        System.assertNotEquals(c2cTask5,null);
        
        
    }
}