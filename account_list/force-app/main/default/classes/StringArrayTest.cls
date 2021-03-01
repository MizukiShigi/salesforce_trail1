public class StringArrayTest {
    public static list<string>  generateStringArray(integer n){
        list<string> tests = new list<string>();
        for(integer I=0;i<n;i++){
            tests.add('Test '+i);
            system.debug(tests[i]);
        }
     	return tests;
    }
}