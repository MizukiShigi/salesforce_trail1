trigger AccountAddressTrigger on Account (before insert, before update) {
    for (Account act:Trigger.New){
        if (act.Match_Billing_Address__c == True){
            act.ShippingPostalCode = act.BillingPostalCode;
        }
    }
}