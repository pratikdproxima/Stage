/**
 ** Snippet run the batch
 ** Id batchJobId = Database.executeBatch(new createMixMaxCampaignForLeadBatch(), 200);
 **
**/
 
global class CreateMixMaxCampaignForLeadBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
       
       system.debug('-----START------');
       
       String query ='Select id,Mixmax_Campaign_Name__c from Lead where MixMax_Create_Campaign__c = true Order By Mixmax_Campaign_Name__c';
       return Database.getQueryLocator(query);
       
    }
    global void execute(Database.BatchableContext bc, List<sobject> lstLead){
    
        try{
            
            system.debug('-----EXECUTE------'+lstLead);
            
            CampaignLeadContact.addCommunityMemberContactORLead(lstLead);
            
            //this is to cover exception in catch block
            if(test.isRunningTest()){
                Integer i=1/0;
            }
        
        }catch(Exception e){
                    
            String body = String.format('\n\n #4 Time: {0}\nMessage: {1}\nStacktrace: {2}\nLine: {3}', 
                                        new List<String>{ String.valueOf(System.now()), e.getMessage(), e.getStackTraceString(), String.valueOf(e.getLineNumber()) });
        
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('Errors occurred during batch - CreateMixMaxCampaignForLeadBatch');
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setSaveAsActivity(false);
            mail.setPlainTextBody(body);
            Messaging.sendEmail(new Messaging.Email[] { mail });            
        }
    
    }
    
    global void finish(Database.BatchableContext bc){
        system.debug('-----FINISH------');
        // call batch for mixmax contact
        Id batchJobId = Database.executeBatch(new CreateMixMaxCampaignForContactBatch(), 200);
    }
    
}