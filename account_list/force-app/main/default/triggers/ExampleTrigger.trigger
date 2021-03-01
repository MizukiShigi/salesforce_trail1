trigger ExampleTrigger on Contact (after insert, after delete) {
    if (Trigger.isInsert){
        Integer recordCount = Trigger.New.size();
        EmailManager em = new EmailManager();
        em.sendMail('shifi1204@icloud.com', 'Trailhead Trigger Tutorial',recordCount + ' contact(s) were inserted.');
    }else if (Trigger.isDelete) {
        
    }
}