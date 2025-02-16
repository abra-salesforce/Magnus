public without sharing class USDCurrencyUpdate {
    @future (callout=true)
    public static void getDollar(id Curid) {
        List <Transaction_Card__c> tccs = [select id,Dollar_Exchange_Rate__c From Transaction_Card__c where id=:Curid];
        if(tccs.size()>0)
        {
            String defCur = '3.55';
            Transaction_Card__c tcc=tccs[0];
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://www.boi.org.il/currency.xml?curr=01');
            req.setMethod('GET');
            Http http = new Http();
            HTTPResponse res = new HTTPResponse();
            if(!Test.isRunningTest())	res = http.send(req);
            else res.setBody('<RATE>3.5</RATE>');
            System.debug(res.getBody());
            String data=res.getBody();
            String dollar='';
            if(data.contains('<RATE>'))
            {
                String [] spl=data.split('<RATE>');
                if(spl[1].contains('</RATE>'))
                {
                    String [] spl2=spl[1].split('</RATE>');
                    dollar=spl2[0];
                }
                else
                    dollar=defCur;
            }
            else
                dollar=defCur;
            if(dollar==defCur){
                List <CurrencyType> currens = [select ConversionRate from CurrencyType where IsActive=true and IsoCode='USD'];
                if(currens.size()>0)
                    dollar=String.valueof((1/currens[0].ConversionRate).setScale(3));
            }
            tcc.Dollar_Exchange_Rate__c=Decimal.valueof(dollar);
            update tcc;
        }
    }
}