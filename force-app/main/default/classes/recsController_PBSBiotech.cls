public class recsController_PBSBiotech {
    @AuraEnabled
    public static String getRecs(String recommender, String anchorValues, String cookie) {
        String orgDomain = 'etgb2b-dev-ed.develop.my.salesforce.com';
        String webstoreId = '0ZEHs0000009P9JOAU';
        String endpoint = 'https://'+orgDomain+'/services/data/v55.0/commerce/webstores/'+webstoreId+'/ai/recommendations?language=en-US&asGuest=true&recommender='+recommender;
        if (anchorValues.length() > 0) {
            endpoint += '&anchorValues='+anchorValues;
        }
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setHeader('Cookie', cookie);
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res.getBody();
    }
}