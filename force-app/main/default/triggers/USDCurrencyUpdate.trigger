trigger USDCurrencyUpdate on Transaction_Card__c (after insert) {
for(Transaction_Card__c tcc: Trigger.new){
       USDCurrencyUpdate.getDollar(tcc.id);
}
}