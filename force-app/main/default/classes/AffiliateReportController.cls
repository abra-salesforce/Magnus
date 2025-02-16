//ZedXagE - ITmyWay - 24/12/17 - Partner View Magnus 
public without sharing class AffiliateReportController {
    public String Username {get;set;}
    public String Password {get;set;}
    public Integer log {get;set;}
    public Boolean terms {get;set;}
    public Boolean errorlog {get;set;}
    public Boolean errordata {get;set;}
    private String affid;
    public String affname {get;set;}
    public String logoid {get;set;}
    private map <Integer,String> months;
    public String Duration {get;set;}
    public String JSONstring {get;set;}
    public list <Charts> data {get;set;}
    public class Charts{
        public String Duration{get;set;}
        public Integer SumTransaction{get;set;}
        public Charts(String D,Integer S){
            Duration=D;
            SumTransaction=S;
        }
    }
    public AffiliateReportController(){
        logoid=null;
        Username='';
        affname='';
        Password='';
        terms=false;
        log=0;
        errorlog=false;
        errordata=false;
        Duration='A';
        JSONstring='';
        months = new Map<Integer,String>{
            1=>'ינואר',
            2=>'פבואר',
            3=>'מרץ',
            4=>'אפריל',
            5=>'מאי',
            6=>'יוני',
            7=>'יולי',
            8=>'אוגוסט',
            9=>'ספטמבר',
            10=>'אוקטובר',
            11=>'נובמבר',
            12=>'דצמבר'
            };
    }
    public void Login(){
        errorlog=false;
        list <Affiliate__c> aff=[select id,Name,Terms__c from Affiliate__c where Username__c=:Username and Password__c=:Password and Username__c!=null and Password__c!=null];
        if(aff.size()>0){
            affid=aff[0].id;
            affname=aff[0].name;
            terms=aff[0].Terms__c;
            list <attachment> atts=[select id,body from attachment where parentid=:affid];
            if(atts.size()>0)
                logoid = EncodingUtil.base64Encode(atts[0].body); // myBodyContent is normal string representation, not base64
            if(terms){
                log=2;
                RefreshChart();
            }
            else
                log=1;
        }else
            errorlog=true;
    }
    public void Terms(){
        System.debug(terms);
        if(terms){
            update new Affiliate__c(id=affid,Terms__c=terms);
            log=2;
            RefreshChart();
        }
    }
    public void RefreshChart(){
        List <Transaction_Card__c> tcs=new List <Transaction_Card__c>();
        if(Duration=='A')
            tcs=[select id,CreatedDate from Transaction_Card__c where Affiliate__c=:affid and No_of_Payments__c>0 Order By CreatedDate];
        else{
            Date dur=System.Today();
            if(Duration=='Y'){
                dur=dur.AddYears(-1);
                tcs=[select id,CreatedDate from Transaction_Card__c where Affiliate__c=:affid and CreatedDate>=:dur and No_of_Payments__c>0 Order By CreatedDate];
            }
            else if(Duration=='M'){
                dur=dur.AddMonths(-1);
                tcs=[select id,CreatedDate from Transaction_Card__c where Affiliate__c=:affid and CreatedDate>=:dur and No_of_Payments__c>0 Order By CreatedDate];
            }
            else if(Duration=='W'){
                dur=dur.AddDays(-7);
                tcs=[select id,CreatedDate from Transaction_Card__c where Affiliate__c=:affid and CreatedDate>=:dur and No_of_Payments__c>0 Order By CreatedDate];
            }
        }
        OrderCharts(tcs);
    }
    public void OrderCharts(List <Transaction_Card__c> tcs){
        errordata=false;
        integer i=0;
        data=new list<Charts>();
        for(Transaction_Card__c tc:tcs){
            if(Duration=='A'||Duration=='Y'){
                Date d=date.newinstance(tc.CreatedDate.Year(),tc.CreatedDate.Month(),1);
                if(i==0){
                    data.Add(new Charts(months.get(d.Month())+' '+d.Year(),1));
                    i++;
                }
                else if(data[i-1].Duration==months.get(d.Month())+' '+d.Year()){
                    data[i-1].SumTransaction++;
                }else{
                    data.Add(new Charts(months.get(d.Month())+' '+d.Year(),1));
                    i++;
                }
            }
            else if(Duration=='M'||Duration=='W'){
                Date d=date.newinstance(tc.CreatedDate.Year(),tc.CreatedDate.Month(),tc.CreatedDate.Day());
                if(i==0){
                    data.Add(new Charts(d.Day()+'/'+d.Month()+'/'+d.Year(),1));
                    i++;
                }
                else if(data[i-1].Duration==d.Day()+'/'+d.Month()+'/'+d.Year()){
                    data[i-1].SumTransaction++;
                }else{
                    data.Add(new Charts(d.Day()+'/'+d.Month()+'/'+d.Year(),1));
                    i++;
                }
            }
        }
        if(data.Size()>0)
            JSONstring = JSON.serialize(data);
        else
            errordata=true;
    }
}