public class AccountRecordSendToOrg {
    
    private static String getAuthToken(){
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String token = '';
        
        RestServicesSetting__c setting = RestServicesSetting__c.getOrgDefaults();
        
        String clientId = setting.clientId__c;
        System.debug(clientId);
        String clientSecret = setting.clientSecret__c;
        System.debug(clientSecret);
        String endPoint = Setting.Set_End_Point__c;
        System.debug(endPoint);
        req.setMethod('POST');
        req.setEndpoint(endPoint+'/services/oauth2/token');
        req.setBody('grant_type=password'+'&client_id='+clientId+'&client_secret='+clientSecret+'&username='+ Encodingutil.urlEncode(setting.UserName__c,'UTF-8')
                   +'&password='+Encodingutil.urlEncode(setting.Password__c + setting.Security_Token__c, 'UTF-8'));
        
        HTTPResponse res = http.send(req);
        System.debug('BODY'+res.getBody());
        
        Map<String,Object> bodyMap = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
        for(String s : bodyMap.keySet()){
            System.debug(s);
            if(s == 'access_token')
            	token = bodyMap.get(s).toString();
        }
        return token;
    }

    @future(callout=true)
    public static Void sendRecordToOrgB(Set<Id> accIdSet){
        
        String token = getAuthToken();
        
        if(String.isEmpty(token)){
        	System.debug('Token is empty');
        }
        RestServicesSetting__c setting = RestServicesSetting__c.getOrgDefaults();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(setting.Set_End_Point__c+'/services/apexrest/AccountsCreate');
        request.setMethod('POST');
        request.setHeader('Authorization','Bearer '+token);
        request.setHeader('Content-Type','application/json;charset=UTF-8');
        
        List<Account> accList=[SELECT Name , Description FROM Account WHERE ID IN :accIdSet];
		
        String accountList =JSON.serialize(accList);//Serialize the list of Account object.        
        request.setBody(accountList);// set body in request of account List.
        HttpResponse response = http.send(request);// requesting and will get response in response is a instance of HttpResponse
        
        if(response.getStatusCode() == 200){
            System.debug(response.getBody());            
        }
        System.debug(response.getStatusCode());
        System.debug(response.getBody());
        
    }
    @future(callout=true)
    public static void sendUpdatedRecords(Set<Id> accIdSet){
       String token = getAuthToken();
        
        if(String.isEmpty(token)){
        	System.debug('Token is empty');
        }
        
        RestServicesSetting__c setting = RestServicesSetting__c.getOrgDefaults();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(setting.Set_End_Point__c+'/services/apexrest/AccountsCreate');
        request.setMethod('PUT'); 
        request.setHeader('Authorization','Bearer '+token);
        request.setHeader('Content-Type','application/json;charset=UTF-8');
		
        List<Account> accList=[SELECT Name , Description FROM Account WHERE ID IN :accIdSet];
        String accountList =JSON.serialize(accList);       
        request.setBody(accountList);
        HttpResponse response = http.send(request);
                
        System.debug(response.getBody());                  
    }
    @future(callout=true)
    public static void sendRecordsToDelete(Set<Id> accIdSet){        
        String token = getAuthToken();
        
        if(String.isEmpty(token)){
        	System.debug('Token is empty');
        }
        
        RestServicesSetting__c setting = RestServicesSetting__c.getOrgDefaults();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint(setting.Set_End_Point__c+'/services/apexrest/AccountsCreate');
        request.setMethod('DELETE'); 
        request.setHeader('Authorization','Bearer '+token);
        request.setHeader('Content-Type','application/json;charset=UTF-8');
        
        String accountIdSet =JSON.serialize(accIdSet);       
        request.setBody(accountIdSet);
        HttpResponse response = http.send(request);
                
        System.debug(response.getBody());                    
    }
}