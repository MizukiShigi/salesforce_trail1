public class ContactAndLeadSearch {
    public static List<List<sObject>> searchContactsAndLeads(string searchword){
        List<List<sObject>> contactleadlist = [find :searchword in all fields returning Contact(Name),Lead(Name)];
        return contactleadlist;
    }
}