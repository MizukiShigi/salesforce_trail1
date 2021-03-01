trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
	List<Task> task = new List<Task>();
    
    for(Opportunity o : [select Id, StageName from Opportunity Where Id  in :Trigger.New ]){        
        if (o.StageName == 'Closed Won'){
            task.add(new Task(
                    Subject  = 'Follow Up Test Task',
                    WhatId = o.Id));  
        }
    }
    if (task.size() > 0){
        insert task;
    }
}