trigger sampletrigger1 on Account (after update) {
	List<Opportunity> relatedOpps = [SELECT Id,Name,Probability FROM Opportunity
        WHERE AccountId IN :Trigger.New];
          
    List<Opportunity> oppsToUpdate = new List<Opportunity>();
    // Iterate over the related opportunities
    for(Opportunity opp : relatedOpps) {      
        // Update the description when probability is greater 
        // than 50% but less than 100% 
        if ((opp.Probability >= 50) && (opp.Probability < 100)) {
            opp.Description = 'New description for opportunity.';
            system.debug(opp);
            oppsToUpdate.add(opp);
        }
    }
    system.debug(oppsToUpdate);
    // Perform DML on a collection
    update oppsToUpdate;
}