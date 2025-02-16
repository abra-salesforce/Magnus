@isTest
public without sharing class MockUSDUpdate implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setBody('<CURRENCIES><LAST_UPDATE>2017-08-09</LAST_UPDATE><CURRENCY><NAME>Dollar</NAME><UNIT>1</UNIT><CURRENCYCODE>USD</CURRENCYCODE><COUNTRY>USA</COUNTRY><RATE>3.601</RATE><CHANGE>-0.111</CHANGE></CURRENCY></CURRENCIES>');
        return res;
    }

}