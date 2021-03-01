public class AccountHandler {
    public static void insertAccount(Integer cnt){
      List<Account> addAccounts = new List<Account>();
      while(cnt <= 3){
      	  Account a = new Account();
      	  a.Name = 'Acme Inc ' + cnt;
          a.AccountNumber = 'A000' +cnt;
          addAccounts.add(a);
          cnt = cnt + 1;
      }
      insert addAccounts;
          
    }
}