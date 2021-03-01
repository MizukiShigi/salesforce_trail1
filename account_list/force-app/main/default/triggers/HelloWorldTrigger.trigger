trigger HelloWorldTrigger on Account (before insert, after insert, after delete) {
    if(Trigger.isInsert){
        if (Trigger.isBefore){
            
        }else if (Trigger.isAfter){
            
        }
    }else if (trigger.isDelete){
        
    }
}