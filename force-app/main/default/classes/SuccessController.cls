public without sharing class SuccessController {
    Public String ur;
    Public String aid;
    Public String tok;
    Public String exp;
    Public String res;
    Public String npa;
    Public String mod;
    Public String notes;
    Public String retdate;
    Public Boolean pickNat;
    Public String pickuptimeNat;
    Public Boolean retNat;
    Public String conf;
    Public String ind;
    Public String sum;
    Public String cur;
    public String vatRate { get; set; }
    public String imeidevice {get;set;}
    Public Decimal Price {get;set;}
    Public Boolean FirstPayment {get;set;}
    Public Boolean Nepal {get;set;}
    Public List < ProdLine > ptls {get;set;}
    
    public Time StringToTime (String t) {
        if(t!=null) {
            try {
                String [] spl1 = t.split('\\.');
                String [] spl2 = spl1[0].split(':');
                Time tm = Time.newInstance(Integer.valueof(spl2[0]),Integer.valueof(spl2[1]),Integer.valueof(spl2[2]),0);
                return tm;
            }
            catch(exception e) {
                return null;
            }
        }
        return null;
    }
    public class ProdLine {
        public Product__c prod {get;set;}
        public Payment_Transaction_line__c pt {get;set;}
        public ProdLine(Product__c pro, Payment_Transaction_line__c lin) {
            prod = pro;
            pt = lin;
        }
    }
    Public Transaction_Card__c tcc {get;set;}
    Public Payment_Transaction__c ptc {get;set;}
    public SuccessController(ApexPages.StandardController controller) {
        price = 0;
        imeidevice = '';
        FirstPayment = false;
        Nepal = false;
        ptls = new List < ProdLine > ();
        //prodnames=new map<string,string>();
        ur = ApexPages.currentPage().getUrl();
        aid = ApexPages.currentPage().getParameters().get('SF_Transaction_Id');
        tok = ApexPages.currentPage().getParameters().get('TranzilaTK');
        exp = ApexPages.currentPage().getParameters().get('expmonth') + ApexPages.currentPage().getParameters().get('expyear');
        res = ApexPages.currentPage().getParameters().get('Response');
        npa = ApexPages.currentPage().getParameters().get('npay');
        mod = ApexPages.currentPage().getParameters().get('tranmode');
        conf = ApexPages.currentPage().getParameters().get('ConfirmationCode');
        ind = ApexPages.currentPage().getParameters().get('index');
        sum = ApexPages.currentPage().getParameters().get('sum');
        cur = ApexPages.currentPage().getParameters().get('currency');
        if(cur=='2')
            cur='USD';
        else
            cur='ILS';
        
        if (aid != null && aid.contains(',')) {
            String[] spl = aid.split(',');
            aid = spl[0];
            if (spl.size() > 1)
                retdate = spl[1];
            if (spl.size() > 2)
                notes = spl[2];
            else
                notes = '';
            if (spl.size() > 3)
                pickNat = spl[3]=='true'?true:(spl[3]=='false'?false:null);
            else
                pickNat = null;
            if (spl.size() > 4)
                pickuptimeNat = spl[4]!=''?spl[4]:null;
            else
                pickuptimeNat = null;
            if (spl.size() > 5)
                retNat = spl[5]=='true'?true:(spl[5]=='false'?false:null);
            else
                retNat = null;
        }
        if(aid!=null&&aid!=''){
            list < Transaction_Card__c > checkDev = [Select id, Device__c from Transaction_Card__c where id =: aid AND Device__c!=null limit 1];
            if(checkDev.size()>0)
                for (Product__c prod: [select id, Name, Price__c, Description__c, WebName__c, WebDescription__c From Product__c where WebAvailable__c = true AND Device_Compatible__c INCLUDES (:checkDev[0].Device__c)])
                    ptls.add(new ProdLine(prod, new Payment_Transaction_line__c(Product__c = prod.id, Quantity__c = 0, Price__c = prod.Price__c, Description__c = prod.Description__c)));
            else
                for (Product__c prod: [select id, Name, Price__c, Description__c, WebName__c, WebDescription__c From Product__c where WebAvailable__c = true])
                    ptls.add(new ProdLine(prod, new Payment_Transaction_line__c(Product__c = prod.id, Quantity__c = 0, Price__c = prod.Price__c, Description__c = prod.Description__c)));
        }
        else
            for (Product__c prod: [select id, Name, Price__c, Description__c, WebName__c, WebDescription__c From Product__c where WebAvailable__c = true])
                ptls.add(new ProdLine(prod, new Payment_Transaction_line__c(Product__c = prod.id, Quantity__c = 0, Price__c = prod.Price__c, Description__c = prod.Description__c)));
    }
    public PageReference additems() {
        price = checkPrice();
        list < map < string, string >> ptltojson = new list < map < string, string >> ();
        integer i = 0;
        for (ProdLine pl: ptls) {
            if (pl.pt.Quantity__c != null && pl.pt.Quantity__c > 0) {
                i++;
                String quan = String.valueOf(pl.pt.Quantity__c);
                String price = String.valueOf(pl.pt.Price__c / pl.pt.Quantity__c);
                ptltojson.add(new Map < string, string > {
                    'product_name' => pl.pt.Description__c,
                    'product_quantity' => quan,
                    'product_price' => price
                });
            }
        }
        String products = JSON.serialize(ptltojson);
        products = EncodingUtil.urlEncode(products, 'UTF-8');
        if (i > 0 && price != null && price > 0) {
            Account accadd = [select id, Name, PersonEmail, PersonMobilePhone from account where id =: tcc.Account_Addressing__c];
            Http http1 = new Http();
            HttpRequest req1 = new HttpRequest();
            req1.setendpoint('https://secure5.tranzila.com/cgi-bin/tranzila71u.cgi');
            req1.setmethod('POST');
            vatRate = String.valueOf(Decimal.valueOf(System.Label.Vat) / 100);
            string pos = 'supplier=magnusintetok&sum=' + price + '&expdate=' + exp + '&currency='+(cur=='USD'?'2':'1')+'&TranzilaPW=zJkelm&TranzilaTK=' + tok + '&cred_type=1&tranmode=A&SF_Transaction_Id=' + tcc.id + '&contact=' + accadd.name + '&email=' + accadd.PersonEmail + '&phone=' + accadd.PersonMobilePhone + '&IMaam='+vatRate+'&json_purchase_data=' + products;
            req1.setbody(pos);
            HttpResponse res1;
            String str = '';
            if (tcc.Token_Id__c != 'testspec') {
                res1 = http1.send(req1);
                str = res1.getbody();
            } else
                str = 'test&Response=000&ConfirmationCode=100&index=1&';
            Payment_Transaction__c pamt = new Payment_Transaction__c(Transaction_Card__c = tcc.id, Type__c = 'חיוב', Payment_Method__c = 'אשראי');
            insert pamt;
            List < Payment_Transaction_line__c > ptlsForInsert = new List < Payment_Transaction_line__c > ();
            for (ProdLine pl: ptls)
                if (pl.pt.Quantity__c != null && pl.pt.Quantity__c > 0) {
                    pl.pt.Payment_Transaction__c = pamt.id;
                    ptlsForInsert.add(pl.pt);
                }
            insert ptlsForInsert;
            system.debug(str);
            system.debug(pos);
            if (str.contains('Response=000')) {
                string con = '';
                string ind = '';
                String[] spl1 = str.split('ConfirmationCode=');
                String[] spl2 = str.split('index=');
                if (spl1[1].contains('&')) {
                    String[] spl3 = spl1[1].split('&');
                    con = spl3[0];
                } else
                    con = spl1[1];
                if (spl2[1].contains('&')) {
                    String[] spl4 = spl2[1].split('&');
                    ind = spl4[0];
                } else
                    ind = spl2[1];
                Payment__c pay = new Payment__c();
                pay.Parent_Transaction__c = tcc.id;
                pay.Expiration_Date__c = exp;
                pay.Token__c = tok;
                pay.Result__c = '000';
                pay.Payment_Transaction_ID__c = con;
                pay.Payment_Transaction__c = pamt.id;
                pay.index__c = ind;
                pay.masof__c = 'magnusintetok';
                pay.VAT_payment__c = true;
                pay.CurrencyIsoCode=cur;
                TimeZone tz = TimeZone.getTimeZone('Asia/Jerusalem');
                DateTime localTime = System.now().AddSeconds(tz.getOffset(System.now()) / 1000);
                pay.Payment_Time__c = localTime;
                pay.Sum__c = price;
                insert pay;
                pamt.Status__c = 'סגור';
                update pamt;
                String ur = '/SuccessVF';
                PageReference pageRef = new PageReference(ur); //it works
                pageref.setRedirect(true);
                return pageRef;
            } else {
                String ur = '/ERROR';
                PageReference pageRef = new PageReference(ur); //it works
                pageref.setRedirect(true);
                return pageRef;
            }
        }
        return null;
    }
    public void upPrice() {
        price = 0;
        for (ProdLine pl: ptls)
            if (pl.pt.Quantity__c != null && pl.pt.Quantity__c > 0)
                price += pl.pt.Quantity__c * pl.pt.Price__c;
    }
    public decimal checkPrice() {
        decimal checkprice = 0;
        for (ProdLine pl: ptls)
            if (pl.pt.Quantity__c != null && pl.pt.Quantity__c > 0)
                checkprice += pl.pt.Quantity__c * pl.pt.Price__c;
        return checkprice.setScale(2);
    }
    public PageReference up() {
        if (res == '000' && aid != null && tok != null && exp != null) {
            list < Transaction_Card__c > tcl = [Select id, Pickup_in_Natbag__c, Pickup_Time__c, Return_in_Natbag__c, IMEI__c, Card_Device__c, Record_Type_Name_Text__c, CreditAmount__c, Return_Date_Updated__c, Transaction_expected_num_payments__c, Account_Addressing__c, Token_Id__c, Manual_Transaction__c, CC_Expiration_Date__c, No_of_Payments__c, Cost_Calculated_Planned_N__c from Transaction_Card__c where id =: aid];
            if (tcl.size() > 0) {
                tcc = tcl[0];
                decimal np = npa!=null?(npa!=''?integer.valueof(npa):0):0;
                np = np + 1;
                if (tcc.No_of_Payments__c == 0 && mod != 'VK') {
                    tcc.Transaction_expected_num_payments__c = np;
                    tcc.Token_Id__c = tok;
                    tcc.CC_Expiration_Date__c = exp;
                    Payment__c pay = new Payment__c();
                    pay.Parent_Transaction__c = tcc.id;
                    pay.Expiration_Date__c = exp;
                    pay.Token__c = tcc.Token_Id__c;
                    pay.Result__c = res;
                    pay.Payment_Transaction_ID__c = conf;
                    pay.masof__c = 'magnusinte';
                    pay.index__c = ind;
                    TimeZone tz = TimeZone.getTimeZone('Asia/Jerusalem');
                    DateTime localTime = System.now().AddSeconds(tz.getOffset(System.now()) / 1000);
                    pay.Payment_Time__c = localTime;
                    pay.Sum__c = decimal.valueof(sum);
                    pay.CurrencyIsoCode=cur;
                    if(tcc.Record_Type_Name_Text__c != 'נפאל')
                        FirstPayment = true;
                    else{
                        Nepal = true;
                        tcc.Status__c='בטיול - נפאל';
                        imeidevice = tcc.IMEI__c;
                        Card_Device__c cdev = [select id, Inventory__c from Card_Device__c where id=:tcc.Card_Device__c];
                        cdev.Inventory__c = 'לא במלאי';
                        update cdev;
                    }
                    insert pay;
                }
                if (tcc.No_of_Payments__c > 0 && mod != 'VK') {
                    Payment__c pay = new Payment__c();
                    pay.Parent_Transaction__c = tcc.id;
                    pay.Expiration_Date__c = exp;
                    pay.Token__c = tok;
                    pay.Result__c = res;
                    pay.Payment_Transaction_ID__c = conf;
                    pay.masof__c = 'magnusinte';
                    pay.Extended_Service__c = true;
                    pay.index__c = ind;
                    TimeZone tz = TimeZone.getTimeZone('Asia/Jerusalem');
                    DateTime localTime = System.now().AddSeconds(tz.getOffset(System.now()) / 1000);
                    pay.Payment_Time__c = localTime;
                    pay.Sum__c = decimal.valueof(sum);
                    pay.Notes__c = notes;
                    pay.CurrencyIsoCode=cur;
                    insert pay;
                    tcc.Cost_Calculated_Planned_N__c += decimal.valueof(sum);
                    tcc.CreditAmount__c = tcc.Cost_Calculated_Planned_N__c;
                    if(pickNat!=null)
                        tcc.Pickup_in_Natbag__c = pickNat;
                    if(pickuptimeNat!=null)
                        tcc.Pickup_Time__c = StringToTime(pickuptimeNat);
                    if(retNat!=null)
                        tcc.Return_in_Natbag__c = retNat;
                    if (retDate != null && retDate != '')
                        tcc.Return_Date_Updated__c = Date.parse(retDate);
                }
                update tcc;
            }
            list < Payment_Transaction__c > ptl = [select id, name, Type__c, Transaction_Card__c, Payment_Method__c, Status__c, Payment__c, Grand_Total__c from Payment_Transaction__c where id =: aid];
            if (ptl.size() > 0) {
                ptc = ptl[0];
                tcc = [Select id, Token_Id__c, CC_Expiration_Date__c, No_of_Payments__c, Account_Addressing__c, discount__c, Return_Date_Updated__c, Cost_Calculated_Planned_N__c, Trainings__c, Date_Of_Delivery_Device__c, Scheduled_Return_Date__c, Days_Of_Planned_Service__c, Step_Size1__c, Step_Size2__c, Step_Size3__c, Step_Size4__c, Step_Price1__c, Step_Price2__c, Step_Price3__c, Step_Price4__c, Dollar_Exchange_Rate__c from Transaction_Card__c where id =: ptc.Transaction_Card__c];
                decimal np = npa!=null?(npa!=''?integer.valueof(npa):0):0;
                np = np + 1;
                if (mod != 'VK') {
                    ptc.Status__c = 'סגור';
                    update ptc;
                    Payment__c pay = new Payment__c();
                    pay.Parent_Transaction__c = tcc.id;
                    pay.Payment_Transaction__c = ptc.id;
                    pay.Expiration_Date__c = exp;
                    pay.Token__c = tok;
                    pay.Result__c = res;
                    pay.Payment_Transaction_ID__c = conf;
                    pay.VAT_payment__c = true;
                    pay.index__c = ind;
                    TimeZone tz = TimeZone.getTimeZone('Asia/Jerusalem');
                    DateTime localTime = System.now().AddSeconds(tz.getOffset(System.now()) / 1000);
                    pay.Payment_Time__c = localTime;
                    pay.Sum__c = decimal.valueof(sum);
                    pay.masof__c = 'magnusinte';
                    pay.CurrencyIsoCode=cur;
                    insert pay;
                }
            }
        }
        return null;
    }
}