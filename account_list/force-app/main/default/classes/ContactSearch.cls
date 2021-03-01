public class ContactSearch {
    public static list<Contact> searchForContacts(string lastname, string mpc){
        Contact[] searchForContacts = [select ID, Name, LastName,  MailingPostalCode
                                       from Contact 
                                       where LastName =: lastname
                                       and MailingPostalCode =: mpc];
        return searchForContacts;
    }
}