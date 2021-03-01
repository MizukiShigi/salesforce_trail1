public class EmailManager {
    public void sendMail(string address, string subject, string body){
        Messaging.SingleEmailMessage mail = new messaging.SingleEmailMessage();
        string[] toAddresses = new String[] {address};
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlaintextbody(body);
        Messaging.SendEmailResult[] results = messaging.sendEmail(
            new messaging.SingleEmailMessage[] {mail});
       inspectResults(results); 
    }
    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        
        // sendEmail returns an array of result objects.
        // Iterate through the list to inspect results. 
        // In this class, the methods send only one email, 
        // so we should have only one result.
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());                 
            }
        }
        
        return sendResult;
    }
}