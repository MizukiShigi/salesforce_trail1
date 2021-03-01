public class NewCaseListController {
    public List<Case> getNewCases(){
        List<Case> results = Database.query(
        	'select ID, CaseNumber ' +
            'from Case ' +
            'where Status  = \'New\''
        );
        return results;
    }
}