@isTest
public class MeetingTriggerHadlerTest {
   public static testmethod void TestDataSetup(){
        Project__c objProject =TestFactory.getProject();
    Collaboration__c objCollaboration = new Collaboration__c(Collaboration_Name__c = 'Test Collaboration',
                                                  Collaboration_Type__c = 'Mailing List',
                                                  Project_Name__c = objProject.Id
                                                 );
        insert objCollaboration;
        Meeting__c objMeeting = new Meeting__c(
            Name='Test Meeting 1',
            Subject__c='Test Subject',
            Meeting_Detail__c='Discussion',
            StartDate__c=Date.today(),
            EndDate__c=Date.today(),
            Type__c ='Webinar',
            StartTime__c=Time.newInstance(18, 30, 2, 00),
            EndTime__c=Time.newInstance(19, 30, 2, 00),
            Category__c='',Collaboration__c=objCollaboration.id);
        insert objMeeting;
        delete objMeeting;
   }
}