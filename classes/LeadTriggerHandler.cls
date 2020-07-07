/*
LastModified By             ModifiedDate            Methods                                                 Against 
========================================================================================================================
Pratik D                    22-May-2020             addCommunityMemberContactORLead                         SFDC-1223
- Updated to handle insert scenario of Lead for creating MixMax Campaign and Campaign Member

Pratik D                    29-May-2020             addCommunityMemberContactORLead                         SFDC-1223
- Converting this method to batch rather than trigger

*/

public class LeadTriggerHandler{
    
    LeadTriggerHandlerAction action=new LeadTriggerHandlerAction();
    
    public void beforeInsert(list<Lead> leadList){
        checkValidionOfEmail(null,leadList);
        updateLeadSource(null,leadList);
        updateCreateMixMaxCampaignCheckbox(null, leadList);
        createLeadIfNameValueNull(leadList);
    }
    
    public void beforeUpdate(Map<Id,Lead> oldleadmap, Map<Id,Lead> newleadmap){
        checkValidionOfEmail(oldleadmap,newleadmap.values());
        updateLeadSource(oldleadmap,newleadmap.values());        
        updateCreateMixMaxCampaignCheckbox(oldleadmap,newleadmap.values());
    }
    
    public void beforeDelete(list<lead> oldleadmap){
        action.deleteAlternateEmail(oldleadmap);
    }
    
    public void afterInsert(Map<Id,Lead> newleadmap){
        insertUpdateMeth(null, newleadmap);
        //CampaignLeadContact.addCommunityMemberContactORLead(null, newleadmap);
    }
    
    
    public void afterDelete(Map<Id, Lead> oldMap) {
        action.processAllDuplicateCommunities(oldMap);
    }
    
    public void afterUpdate(Map<Id,Lead> oldleadmap, Map<Id,Lead> newleadmap){
        System.debug('====> Lead After update');
        insertUpdateMeth(oldleadmap, newleadmap);
        //checkForOptOutChange(oldleadmap, newleadmap);
        updateCommunityAndEnrollmentForConvertedLead(oldLeadMap, newleadmap);
        //CampaignLeadContact.addCommunityMemberContactORLead(oldleadmap, newleadmap);
    }
    
    public void insertUpdateMeth(Map<Id,Lead> oldleadMap, Map<Id,Lead> newLeadMap){
        List<Lead> listofleads = new List<lead>();
        set<String> emailIDString = new set<String>();
        list<lead> listofleadwithEmails = new list<lead>();
        for(Lead ld : newLeadMap.values()){
            //if convert lead is checked
            if(ld.isConverted == false && (ld.Convert_Lead__c && (oldleadmap == null || (oldleadmap != null && ld.Convert_Lead__c != oldleadmap.get(ld.Id).Convert_Lead__c)))){
                system.debug('--ld--'+ld);
                listofleads.add(ld);
            }
            if(ld.email != null && (oldleadmap == null || (oldleadmap != null && oldleadmap.get(ld.id).email != ld.email))){
                listofleadwithEmails.add(ld);
                emailIDString.add(ld.email);
            }
        }
        if(!listofleads.isEmpty()){
            action.convertLeadsNormally(listofleads);
        }
        if(!listofleadwithEmails.isEmpty()){
            action.insertAleternateEmail(listofleadwithEmails,emailIDString);
        }
    }
    
    public void checkValidionOfEmail(Map<Id,Lead> oldleadMap,List<lead> newLeadMap){
        Set<String> emailIDString = new Set<String>();
        List<Lead> leads = new List<Lead>();
        for(Lead lead : newLeadMap){
            if(String.isNotBlank(lead.email) && (oldleadmap == null || (oldleadmap != null && oldleadmap.get(lead.id).email != lead.email))){
                if(!emailIDString.contains(lead.Email)){
                    emailIDString.add(lead.email);
                    leads.add(lead);
                }
                else{
                    lead.addError('Duplicate record found');
                }
            }
        }
        if(emailIDString.size() > 0){
            action.addvalidationError(emailIDString,leads);
        }
    }
    
    public void updateCommunityAndEnrollmentForConvertedLead(Map<Id, Lead> oldMap,Map<Id, Lead> newMap ){
        List<Lead> leads = [select Id,isConverted from lead where Id IN : newMap.keySet()];
        Set<Id> convertedLeadIds = new Set<Id>();
        if(!leads.isEmpty()){
            for(Lead lead : leads){
                if(lead.isConverted && !oldMap.get(lead.Id).isConverted){
                    convertedLeadIds.add(lead.Id);
                }
            }
            if(!convertedLeadIds.isEmpty()){
                LeadTriggerHandlerAction.updateCommunitiesofConvertedLead(convertedLeadIds);
                LeadTriggerHandlerAction.updateEnrollmentsofConvertedLead(convertedLeadIds);
                LeadTriggerHandlerAction.updateWorkHistory(convertedLeadIds);
            } 
        }
    }
    
    /*public static void checkForOptOutChange(Map<Id, Lead> oldMap, Map<Id, Lead> newMap){
Map<Id, Boolean> idVsSubscribe = new Map<Id, Boolean>();

for(Lead l : newMap.values()){
if (l.HasOptedOutOfEmail != oldMap.get(l.Id).HasOptedOutOfEmail) {
idVsSubscribe.put(l.Id, !l.HasOptedOutOfEmail);
}
}

if (!idVsSubscribe.isEmpty()) {
CampaignMemberStatus.updateCampaignMemberSubscriptionStatus('Lead', idVsSubscribe);
}
}*/
    
     private static void updateLeadSource(Map<Id, Lead> oldMap, List<Lead> leadList){
        List<String> leadSourcePickListValues = Utility.getPickListValuesIntoList('Lead','LeadSource');
        Map<String,List<String>> dependentPicklistValuesMap = Utility.getDependentPicklistValues(leadList[0],'LeadSource','Lead_Source_Detail_p__c');
        for(Lead lead:leadList){
            if(lead.Convert_Lead__c && (oldMap == null || lead.Convert_Lead__c != oldMap.get(lead.Id).Convert_Lead__c)){
                System.debug('lead.LeadSource =>' + lead.LeadSource);
                System.debug('lead.LeadSource =>' + lead.Lead_Source_Detail_p__c);
                System.debug('Picklist values =>' + dependentPicklistValuesMap);
                if((lead.LeadSource != null && !leadSourcePickListValues.contains(lead.LeadSource)) ||((lead.LeadSource == null && lead.Lead_Source_Detail_p__c != null))){
                    lead.Lead_Source_Detail__c = lead.LeadSource +' , ' +lead.Lead_Source_Detail_p__c;
                    lead.LeadSource = 'other';
                    lead.Lead_Source_Detail_p__c = 'other';
                }else if(lead.LeadSource != null && lead.Lead_Source_Detail_p__c != null){
                    if(!dependentPicklistValuesMap.containsKey(lead.LeadSource) || !dependentPicklistValuesMap.get(lead.LeadSource).contains(lead.Lead_Source_Detail_p__c)){
                        lead.Lead_Source_Detail__c = lead.LeadSource +'  ,' +lead.Lead_Source_Detail_p__c;
                        lead.LeadSource = 'other';
                        lead.Lead_Source_Detail_p__c = 'other';
                    }
                }
            }
            
        }
    }
    
    //Check if Mixmax_Campaign_Name__c changed or added if new Lead 
    //And set Create_MixMax_Campaign__c checkbox to true
    private static void updateCreateMixMaxCampaignCheckbox(Map<Id, Lead> oldMap, List<Lead> leadList){
        
        for(Lead lead:leadList){
            if( (oldMap == null && lead.Mixmax_Campaign_Name__c != NULL) 
                || 
                (oldMap != null && lead.Mixmax_Campaign_Name__c != oldMap.get(lead.Id).Mixmax_Campaign_Name__c)
            ){
                lead.MixMax_Create_Campaign__c = true;
            }
        }
    }
    
    private static void createLeadIfNameValueNull(List<Lead> lstList){
        For(Lead objLead : lstList){
            if(objLead.FirstName == NUll){
                objLead.FirstName ='[[Unknown]]';
            }
            if(objLead.LastName == NUll){
                objLead.LastName = '[[Unknown]]';
            }
        }
    }
    
}