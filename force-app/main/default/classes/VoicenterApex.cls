global with sharing class VoicenterApex {

    public String objectPhone { get; set; }
    public static String UserPhone  { get; set; }
    public static Account account { get; set; }
    public static User calluser { get; set; }
    public static  ID ObjectID  { get; set; }
  
    global class FindObjectResponse {
        public String ID { get; set; }
        public String Name { get; set; }
        public String OrganizationName { get; set; }
        public String ObjectType { get; set; }
        public String Phone {get;set;}
        public object Raw {get;set;}
    } 
    global class VoicenterCdrInsertResult {
        public object InsertResult { get; set; }
        public VoicenterCDR CDR { get; set; }
        public String Error { get; set; }
        public String WorkerID { get; set; }
        public String CustomerID { get; set; }
        public String ExistingTaskOID  { get; set; }
    }
    
    global class VoicenterCrmData {
        public string CustomerFieldName { get; set; }
        public string StatusFieldValue { get; set; }
        public string DefaultCdrOwnerID { get; set; }
        public string DefaultCustomerFieldName { get; set; }
    }
    
    global class VoicenterCDR {
        public string CallID  { get; set; }
        public string CallerExtension { get; set; }
        public string CallerNumber { get; set; }
        public Long DateEpoch { get; set; }
        public string DialStatus { get; set; }
        public integer Duration { get; set; }
        public integer ID { get; set; }
        public string RecordURL { get; set; }
        public string TargetExtension { get; set; }
        public string TargetNumber { get; set; }
        public integer UrlID { get; set; }
    }
    public VoicenterApex() { 
        //System.debug(' VoicenterApex constructor Start');
    } 
    @RemoteAction
    global static FindObjectResponse FindObjectByPhone(String phoneNumber) {       
        List<List<sObject>> results = [FIND :phoneNumber
                                       IN Phone FIELDS
                                       RETURNING 
                                       Contact(Id, Phone, Name, Department),
                                       Account(Id, Phone, Name), 
                                       Lead(Id, Phone, Company, Name)];
        
        FindObjectResponse resp = new FindObjectResponse();
        resp.Raw = results;
        resp.Phone = phoneNumber;
        
        if(results[0].size() > 0) {
            Contact cny = (Contact)results[0][0];
            resp.ID = cny.Id;
            resp.Name = cny.Name;
            resp.OrganizationName = cny.Department;
            resp.ObjectType = 'Contact';
        }
        else if(results[1].size() > 0) {
            Account accnt = (Account)results[1][0];
            resp.ID = accnt.Id;
            resp.Name = accnt.Name;
            resp.OrganizationName = accnt.Name;
            resp.ObjectType = 'Account';          
        }
        else if(results[2].size() > 0) {
            Lead lny = (Lead)results[2][0];
            resp.ID = lny.Id;
            resp.Name = lny.Name;
            resp.OrganizationName = lny.Company;
            resp.ObjectType = 'Lead';
        }
        
        /*
        sObject[] records = ((List<sObject>)results[0]);
        if (!records.isEmpty()) {
            for (Integer i = 0; i < records.size(); i++) {
                sObject record = records[i];   
                if (record.getSObjectType() == Contact.getSObjectType()) {
                    // contacts.add((Contact) record);
                    //return ((String)((Contact) record).Id);
                    Contact cny = (Contact) record;
                    resp.ID = cny.Id;
                    resp.Name = cny.Name;
                    resp.OrganizationName = cny.Department;
                    resp.ObjectType = 'Contact';
                }
                else if (record.getSObjectType() == Lead.getSObjectType()){
                    //leads.add((Lead) record);
                    //return ((String)((Lead) record).Id);
                    Lead lny = (Lead) record;
                    resp.ID = lny.Id;
                    resp.Name = lny.Name;
                    resp.OrganizationName = lny.Company;
                    resp.ObjectType = 'Lead';
                } 
                else if (record.getSObjectType() == Account.getSObjectType()){
                    Account accnt = (Account)record;
                    resp.ID = accnt.Id;
                    resp.Name = accnt.Name;
                    resp.OrganizationName = accnt.Name;
                    resp.ObjectType = 'Account';
                }
            }
        }*/
        
        return resp;
    }
    
    @RemoteAction
    global static ID FindIDByPhone(String phoneNumber) {
        List<List<sObject>> results = [FIND :phoneNumber
                                       IN Phone FIELDS
                                       RETURNING Contact(Id, Phone, FirstName, LastName),
                                       Lead(Id, Phone, FirstName, LastName), Account(Id, Phone, Name)];
        sObject[] records = ((List<sObject>)results[0]);
        
        
        if (!records.isEmpty()) {
            for (Integer i = 0; i < records.size(); i++) {
                sObject record = records[i];   
                
                
                if (record.getSObjectType() == Contact.sObjectType) {
                    // contacts.add((Contact) record);
                    
                    return ((String)((Contact) record).Id);
                }
                else if (record.getSObjectType() == Lead.sObjectType){
                    //leads.add((Lead) record);
                    return ((String)((Lead) record).Id);
                }
                
                
                
            }
            
        }   
        return null;
    }
    
    global static String GetUserID(VoicenterCDR cdr, string crmDefaultUser){
        String userID = '';
        try{
            String varPhone1 = cdr.CallerNumber;
            String varPhone2 = cdr.CallerExtension;
            String varPhone3 = cdr.TargetNumber;
            String varPhone4 = cdr.TargetExtension;
            String query = 'SELECT Id FROM User WHERE ';
            String whereStr = '';
            if(varPhone1 != ''){
                whereStr += 'OR  Phone = :varPhone1 ';
            }
            if(varPhone2 != ''){
                whereStr += 'OR  Phone = :varPhone2 ';
            }
            if(varPhone3 != ''){
                whereStr += 'OR  Phone = :varPhone3 ';
            }
            if(varPhone4 != ''){
                whereStr += 'OR  Phone = :varPhone4 ';
            }
            if(whereStr.startsWith('OR')){
                whereStr = whereStr.mid(3, whereStr.length());
            }
            List<User> sobjList = Database.query('SELECT Id FROM User WHERE ' + whereStr);
            
            for(integer i = 0; i < sobjList.size(); i++) {
                userID = sobjList.get(0).Id;
            }
            if(userID == ''){
                userID = crmDefaultUser;
            }
            if(userID == ''){
                userID = UserInfo.getUserId();
            }
        }
        catch (Exception e) {
            
        }
        
        return userID;
    }
    
    global static string GetCustomerID(VoicenterCDR cdr, String defaultEntityName){
        String userID = '';
        String varPhone1 = cdr.CallerNumber;
        String varPhone2 = cdr.CallerExtension;
        String varPhone3 = cdr.TargetNumber;
        String varPhone4 = cdr.TargetExtension;

        String whereStr = '';
        if(varPhone1 != ''){
            whereStr += 'OR  Phone = :varPhone1 ';
        }
        if(varPhone2 != ''){
            whereStr += 'OR  Phone = :varPhone2 ';
        }
        if(varPhone3 != ''){
            whereStr += 'OR  Phone = :varPhone3 ';
        }
        if(varPhone4 != ''){
            whereStr += 'OR  Phone = :varPhone4 ';
        }
        
        if(whereStr.startsWith('OR')){
            whereStr = whereStr.mid(3, whereStr.length());
        }
        List<sObject> sobjList ;
   try{   
        String query = 'SELECT Id FROM ' + defaultEntityName + ' WHERE ';
        
        sobjList = Database.query(query + whereStr);     
        for(integer i = 0; i < sobjList.size(); i++) {
            userID = sobjList.get(0).Id;
        }
   }  catch (Exception e) {
           
       return null ;
          //  System.debug('Query Issue: ' + e);  //return e.getMessage();
        } 
        if(userID == ''){
            sobjList = Database.query('SELECT Id FROM Contact WHERE ' + whereStr);     
            for(integer i = 0; i < sobjList.size(); i++) {
                userID = sobjList.get(0).Id;
            }
        }

        if(userID == ''){
            sobjList = Database.query('SELECT Id FROM Lead WHERE ' + whereStr);     
            for(integer i = 0; i < sobjList.size(); i++) {
                userID = sobjList.get(0).Id;
            }
        }
        
        return userID;
    }
    
    @RemoteAction
   global static object CreateTaskFromClick2Call(String ivrUniqueID, String customerID){
       // Check if task with given Ivr unique id already exists:
       VoicenterCdrInsertResult res = new VoicenterCdrInsertResult();
       res.Error = 'OK';
       res.WorkerID = '';
       res.CustomerID = '';
       res.ExistingTaskOID = '';
       
       ivrUniqueID = ivrUniqueID.trim();
       
       if(ivrUniqueID == '')
       {
           res.Error = 'Empty ivr id';
           return res;
       }
       
       /*List<List<sObject>> results = [FIND :ivrUniqueID
                                      IN ALL FIELDS
                                      RETURNING 
                                      Task(Id)];
       
       if(results[0].size() > 0) {
           res.Error = 'Already exists';
           Task task = (Task)results[0][0];
           res.ExistingTaskOID = task.Id;
           return res;
       }*/
       
      
       
       try{
           Task t = new Task(
               OwnerId = UserInfo.getUserId(),
               Subject = 'Call',
               Status = 'Open',
               Priority = 'Normal',
               ivruniqueid__c = ivrUniqueID
           );
           
           if(customerID.startsWith('001')){
               t.WhatId = customerID;
           }
           else {
               t.WhoId = customerID;
           }
               
          
           upsert t;
           res.InsertResult = t;
       }
       catch(DmlException e) {
           res.InsertResult = e.getMessage();
           res.Error = 'Dml Error';
           String em =  e.getMessage();
        //   System.debug('The following exception has occurred: ' + em );    
           //return em;
       }
       
       catch (Exception e) {
           res.InsertResult = e.getMessage();
           res.Error = 'Error';
         //  System.debug('Query Issue: ' + e);  //return e.getMessage();
       }
       return res;
   }
    
    @RemoteAction
    global static object LogCalls(VoicenterCrmData crmData, VoicenterCDR cdr) {
        VoicenterCdrInsertResult res = new VoicenterCdrInsertResult();
        res.CDR = cdr;
        res.Error = '';
        res.WorkerID = '';
        res.CustomerID = '';

        Task[] newTask = new Task[0];

        try{
            String userID = GetUserID(cdr, crmData.DefaultCdrOwnerID);            
            if(userID == ''){
                // Countinue or abort ?   
            }
            res.WorkerID = userID;
            /// Search for customer ID: (Customer / lead / etc... )
            String customerID = GetCustomerID(cdr, crmData.DefaultCustomerFieldName);
            res.CustomerID = customerID;
             Task theTask = new Task(
                Description = '',
                OwnerId = userID,
                //WhoId = customerID,
                ActivityDate = DateTime.newInstance(cdr.DateEpoch * 1000).date(),
                Priority = 'Normal',
                CallDisposition = cdr.DialStatus,
                CallDurationInSeconds = cdr.Duration,
                Status = 'Completed',
                callrecordurl__c = cdr.RecordURL,
                ivruniqueid__c = cdr.CallID,
                Subject  = 'Voicenter CDR'
            );
            
            if(customerID != ''){
                theTask.WhoId = customerID;
            }
            
            newTask.add(theTask);
            insert newTask;
            res.InsertResult = newTask;            
            //return res;
            
        }
        catch(DmlException e) {
            res.InsertResult = e.getMessage();
            res.Error = 'Dml Error';
            String em =  e.getMessage();
         //   System.debug('The following exception has occurred: ' + em );    
            //return em;
        }
        
        catch (Exception e) {
            res.InsertResult = e.getMessage();
            res.Error = 'Error';
          //  System.debug('Query Issue: ' + e);  //return e.getMessage();
        }
        
        return res;
    }   
}