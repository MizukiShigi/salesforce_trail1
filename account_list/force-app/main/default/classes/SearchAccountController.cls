public class SearchAccountController {
    
    // 対象のフィールドクラス
    static List<String> TARGET_FIELDS = new List<String>{
        'Id',
        'Name',
        'OwnerId',
        'AccountNumber',
        'Tradestyle',
        'Rating',
        'AnnualRevenue',
        'NumberOfEmployees',
        'YearStarted',
        'LastModifiedDate'
    };
    static List<String> TARGET_FIELDS_CONTACT = new List<String>{
        'Id',
        'Name'
    };
    static List<String> TARGET_FIELDS_OPP = new List<String>{
        'Id',
        'Name',
        'StageName',
        'Type'
    };

    public List<Account> results {get;set;} // 検索結果(読み書き可能)
    public SearchCondition condition {get;set;}    // 検索条件取得用(読み書き可能)
    public String sortField {get;set;}      // 見出しソート用リンクを押された際のフィールド名

    // 初期化処理
    public void init(){
        this.results = new List<Account>(); 
        this.condition = new SearchCondition();
        this.sortField = null;
        search();
    }

    // クリアボタン処理
    public PageReference clear(){
        init();
        return null;
    }

    // 検索ボタン処理
    public PageReference search(){
        // 検索条件からSOQLを作成
        // condition.SearchCondition();
        String soqlQuery = this.condition.getSoqlQuery();
        System.debug('[soql]' + soqlQuery);

        try{
            this.results = database.query(soqlQuery);
        }catch(DmlException e){                          // DmlExceptionを使う?他の例外を使うのか?
            ApexPages.addMessages(e);
        }catch(Exception e){
            ApexPages.addMessages(e);
        }
        return null;
    }

    // ソートリンク処理
    public PageReference sort(){
        // ソートを行う対象フィールドが不明な場合は何もしない
        if(this.sortField == null){
            return null;
        }

        // ソートを行う対象が現在ソートしているフィールドと同じ場合はソート順を逆転
        if(this.sortField == this.condition.sortkey){
            this.condition.setOrderReverse();
        }
        // ソートを行う対象が、現在ソートしているフィールドと違う場合は新しい項目でソートするようにする
        else {
            this.condition.sortkey = this.sortField;
        }

        // 検索実行
        search();
        return null;
    }
    
    public String getSortKey(){
        return this.condition.sortkey;
    }
    public String getSortOrder(){
        return this.condition.sortOrderToString();
    }

    // 検索を管理するクラス
    public Class SearchCondition{
		
        private Time JST_AM0 = Time.newInstance(9, 0, 0, 0); 
        
        // 検索条件の入力フィールド用
        public Account obj_acc {get;set;}
        public Opportunity obj_opp {get;set;}

        public String sortkey {get;set;}
        public String order {get;set;}
        public String searchName {get; set;}
        public Date startDate {get; set;}
        public Date endDate {get; set;}
        

        // コンストラクタ
        public SearchCondition(){
            this.obj_acc = new Account();
            this.obj_opp = new Opportunity();
            this.searchName = null;
            this.startDate = null;
            this.endDate = null;
            // デフォルトは最終更新日時の降順とする
            this.sortkey = 'LastModifiedDate';
            this.order = 'DESC';
        }

        // SOQLを作成
        public String getSoqlQuery(){
            List<String> param = new String[]{getFieldList(), getContactFieldList(), getOppFieldList(), getChildWhere(), getParentWhere(), getOrder()};
            return String.format('SELECT {0}, (SELECT {1} FROM Contacts), (SELECT {2} FROM Opportunities {3}) FROM Account {4} {5} LIMIT 500', param);
        }
        
        // 取引先SELECT対象フィールド
        private String getFieldList(){
            return String.join(TARGET_FIELDS, ',');
        }
        
        // 取引先責任者SELECT対象フィールド
        private String getContactFieldList(){
            return String.join(TARGET_FIELDS_CONTACT, ',');
        }

        // 商談SELECT対象フィールド
        private String getOppFieldList(){
            return String.join(TARGET_FIELDS_OPP, ',');
        }

        // Where句作成
        private String getParentWhere(){
            List<String> param_parent = new String[]{ };
            // 取引先名検索like
            if(this.searchName != null && this.searchName != ''){
                param_parent.add('Name LIKE ' + '\'%' + this.searchName + '%\'');
            }
            // 商談種別検索
            if(this.obj_opp.Type != null){
                param_parent.add('Id in (SELECT AccountId FROM Opportunity WHERE Type = ' + '\'' + this.obj_opp.Type + '\'' + ')');
            }
            // 最終更新日時
            if(this.startDate != null){
                DateTime dt =  getStartOfDay(this.startDate);
                String sDatetime = dt.format('yyyy-MM-dd\'T\'HH:mm:ss.000\'Z\'');
                param_parent.add('LastModifiedDate >= ' + sDatetime);
            }
            if(this.endDate != null){
                DateTime dt =  getStartOfDay(this.endDate);
                String eDatetime = dt.format('yyyy-MM-dd\'T\'HH:mm:ss.000\'Z\'');
                param_parent.add('LastModifiedDate <= ' + eDatetime);
            }
            if(param_parent.isEmpty()){
                return ' ';
            }
            return 'WHERE ' + String.join(param_parent, 'AND ');
        }
        
        private String getChildWhere(){
            List<String> param_child = new String[]{ };
            // 商談種別検索
            if(this.obj_opp.Type != null){
                param_child.add('Type = ' + '\'' + this.obj_opp.Type + '\'');
            }
            if(param_child.isEmpty()){
                return ' ';
            }
            return 'WHERE ' + String.join(param_child, 'AND ');
            }
		
        private DateTime getStartOfDay(Date d){
            // GMT+9を考慮して、GMTで日本の0時を作成する（＝GMTでは1日前の15時）
            JST_AM0 = Time.newInstance(15, 0, 0, 0);
            return Datetime.newInstance(d.addDays(-1), JST_AM0);
        }
        
        // ORDERBY句作成
        private String getOrder(){
            List<String> order_param = new String[]{this.sortkey, this.order};
            return String.format('ORDER BY {0} {1}', order_param);
        }

        // ソート順を見出しに表示する記号に変換する
        public String sortOrderToString(){
            if(this.order == 'DESC'){
                return '▼';
            }
            return '▲';
        }
        // ソート順を逆にする
        public void setOrderReverse(){
            if(this.order == 'DESC'){
                this.order = 'ASC';
            }
            else{
                this.order = 'DESC';
            }
        }
    }
}