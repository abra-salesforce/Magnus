trigger MonthInDest on Transaction_Card__c (after update) {
    for(Transaction_Card__c tcc:Trigger.new){
        Transaction_Card__c oldtcc=Trigger.OldMap.get(tcc.id);
        if((((tcc.Status__c=='טיול'&&oldtcc.Status__c!='טיול')||(tcc.Status__c=='הארכת טיול'&&oldtcc.Status__c!='הארכת טיול'))&&tcc.Date_Trip__c!=null&&(tcc.Scheduled_Return_Date__c!=null||tcc.Return_Date_Updated__c!=null))||((tcc.Status__c=='טיול'||tcc.Status__c=='הארכת טיול')&&tcc.Date_Trip__c!=null&&(tcc.Scheduled_Return_Date__c!=null||tcc.Return_Date_Updated__c!=null)&&(tcc.Scheduled_Return_Date__c!=oldtcc.Scheduled_Return_Date__c||tcc.Return_Date_Updated__c!=oldtcc.Return_Date_Updated__c))){
            Date StartDate=tcc.Date_Trip__c.addDays((tcc.Date_Trip__c.Day()-1)*-1);
            Date EndDate=tcc.Return_Date_Updated__c!=null?tcc.Return_Date_Updated__c.addDays((tcc.Return_Date_Updated__c.Day()-1)*-1):tcc.Scheduled_Return_Date__c.addDays((tcc.Scheduled_Return_Date__c.Day()-1)*-1);
            Set <Date> DatesNeeded=new Set <Date>();
            Date tempDate=StartDate;
            while(tempDate<=EndDate){
                DatesNeeded.add(tempDate);
                tempDate=tempDate.AddMonths(1);
            }
            Set <String> desids=new Set <String>();
            List <Destination__c> dests = [select id from Destination__c where TransactionCard__c=:tcc.id];
            for(Destination__c des:dests)
                desids.add(des.id);
            List <Months_in_Destination__c> monthsNeed=new List<Months_in_Destination__c>();
            List <Months_in_Destination__c> monthsNotNeed=new List<Months_in_Destination__c>();
            List <Months_in_Destination__c> monthsEx=[select id,Destination__c,Month_trip__c from Months_in_Destination__c where Destination__c in:desids];
            for(Destination__c des:dests){
                Set <Date> DatesExists=new Set <Date>();
                for(Months_in_Destination__c mon:monthsEx){
                    if(mon.Destination__c==des.id){
                        if(!DatesNeeded.Contains(mon.Month_trip__c))
                            monthsNotNeed.add(mon);
                        else
                            DatesExists.add(mon.Month_trip__c);
                    }
                }
                for(Date dat:DatesNeeded){
                    if(!DatesExists.Contains(dat))
                        monthsNeed.add(new Months_in_Destination__c(Destination__c=des.id,Month_trip__c=dat));
                }
            }
            delete monthsNotNeed;
            insert monthsNeed;
        }
    }
}
/*
1. delete all history
List <Months_in_Destination__c> monthsNeed=new List<Months_in_Destination__c>();
for(Destination__c des:[select id,TransactionCard__r.Date_Trip__c,TransactionCard__r.Scheduled_Return_Date__c,TransactionCard__r.Return_Date_Updated__c,(select id,Month_trip__c from Months_in_Destination__r) From Destination__c where TransactionCard__r.Date_Trip__c!=null AND (TransactionCard__r.Scheduled_Return_Date__c!=null OR TransactionCard__r.Return_Date_Updated__c!=null) AND (TransactionCard__r.Status__c='טיול' OR TransactionCard__r.Status__c='הארכת טיול' OR TransactionCard__r.Status__c='החזרת מכשיר' OR TransactionCard__r.Status__c='הסתיים')]){
        if(des.TransactionCard__r.Date_Trip__c!=null&&(des.TransactionCard__r.Scheduled_Return_Date__c!=null||des.TransactionCard__r.Return_Date_Updated__c!=null)){
            Date StartDate=des.TransactionCard__r.Date_Trip__c.addDays((des.TransactionCard__r.Date_Trip__c.Day()-1)*-1);
            Date EndDate=des.TransactionCard__r.Return_Date_Updated__c!=null?des.TransactionCard__r.Return_Date_Updated__c.addDays((des.TransactionCard__r.Return_Date_Updated__c.Day()-1)*-1):des.TransactionCard__r.Scheduled_Return_Date__c.addDays((des.TransactionCard__r.Scheduled_Return_Date__c.Day()-1)*-1);
            Set <Date> DatesNeeded=new Set <Date>();
            Set <Date> DatesExists=new Set <Date>();
            Date tempDate=StartDate;
            while(tempDate<=EndDate){
                DatesNeeded.add(tempDate);
                tempDate=tempDate.AddMonths(1);
            }
            for(Months_in_Destination__c mon:des.Months_in_Destination__r){
                DatesExists.add(mon.Month_trip__c);
            }
            for(Date dat:DatesNeeded){
                if(!DatesExists.Contains(dat))
                    monthsNeed.add(new Months_in_Destination__c(Destination__c=des.id,Month_trip__c=dat));
            }
        }
    }
insert monthsNeed;
*/