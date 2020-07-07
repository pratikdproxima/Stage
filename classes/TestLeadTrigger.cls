@isTest
public class TestLeadTrigger{

    static testmethod  void testTrigger(){
        test.startTest();
        LinuxTriggerUtilityClass.LeadTriggerActionOnceMore = false;
        List<Lead> LeadList=new List<Lead>();
        Account acc=TestDataUtils.createAccount(false,'Account Company');
        acc.billingstate='Arizona';
        acc.website='www.test.com';
        insert acc;
        for(Integer i = 5 ;i<=15;i++){
            Integer j = i+500;
            lead tempLead = new lead();
            String email = 'test2341'+j+'@test.com';
            tempLead = TestDataUtils.createLead(false,'Test'+j,'Lead'+j,'Lead'+j+' Company','Content',email);
            tempLead.Username__c = email;
            tempLead.Convert_Lead__c = TRUE;
            LeadList.add(tempLead);

        }
        /*LeadList.add(TestDataUtils.createLead(false,'Test','Lead1','Lead1 Company','Content','test2341@test.com'));
LeadList.add(TestDataUtils.createLead(false,'Test','Lead22','Account Company, inc','Content','test2234@test.com'));
LeadList.add(TestDataUtils.createLead(false,'Test','Lead33','Lead3 Company','Content','test2343@test.com'));
LeadList.add(TestDataUtils.createLead(false,'Test','Lead44','Account Company','Content','test4234@test.com'));

LeadList[1].state='Arizona';
LeadList[3].state='Arizona';
LeadList[1].Username__c='ArizonaTEST';
LeadList[3].Username__c='ArizonaTEST';*/
        insert LeadList;

        List<lead> convertedList = [select id,name,convertedcontactId from lead where isConverted = true and convertedcontactId != null];
        system.debug('===convertedList==='+convertedList.size());
        system.assertEquals(LeadList.size(), convertedList.size());
        test.stopTest();
    }

    static testmethod  void testTrigger1(){

        list<lead> updateLeadVar = new list<lead>();
        test.startTest();

        List<Lead> LeadList=new List<Lead>();
        for(Integer i = 15 ;i<=0;i--){
            Integer j = i+5621520;
            lead tempLead = new lead();
            String email = 'test2345641'+j+'@test753'+j+'951.com';
            tempLead = TestDataUtils.createLead(false,'Test','Lead'+j,'Lead'+j+'Company'+j,'Content',email);
            LeadList.add(tempLead);

        }
        insert LeadList;
        List<lead> leadListFinal = new list<lead>();
        LinuxTriggerUtilityClass.LeadTriggerActionOnceMore = false;
        List<lead> updatedList = [select id,name,convertedcontactId from lead where isconverted = false];
        for(Lead leadVar : LeadList){
            leadVar.Convert_Lead__c = TRUE;
            leadVar.username__c = 'qwerty';
            leadListFinal.add(leadVar);
        }
        update leadListFinal;

        //system.debug('===convertedList==='+convertedList.size());
        List<lead> updatedListLead = [select id,name,convertedcontactId from lead where isConverted = true and username__c='qwerty' and convertedcontactId != null];
        system.debug('---updatedListLead--'+updatedListLead);
        system.assertEquals(leadListFinal.size(), updatedListLead.size());
        test.stopTest();
    }
    
    @IsTest
    static void convertLeadTest(){
        Account account = new Account(Name ='Test Account');
        insert account;
        Lead lead = TestDataUtils.createLead(false,'Test','Lead','Test Account','Content','test@123.com');
        insert lead;
        lead.Convert_Lead__c = TRUE;
        update lead;
    }
    static testmethod  void testTriggerDelete(){
        list<lead> updateLeadVar = new list<lead>();
        test.startTest();

        List<Lead> LeadList=new List<Lead>();
        for(Integer i = 15 ;i<=30;i++){
            Integer j = i+5621520;
            lead tempLead = new lead();
            String email = 'test2345641'+j+'@test73'+j+'951.com';
            tempLead = TestDataUtils.createLead(false,'Test','Lead'+j,'Lead'+j+'Company'+j,'Content',email);
            LeadList.add(tempLead);

        }
        insert LeadList;
        delete LeadList;
        test.stopTest();
    }

    static testmethod  void testTrigger2(){
        test.startTest();
        LinuxTriggerUtilityClass.LeadTriggerActionOnceMore = false;
        List<Lead> LeadList=new List<Lead>();
        Account acc=TestDataUtils.createAccount(false,'Account Company');
        acc.billingstate='Arizona';
        acc.website='www.test.com';
        insert acc;
        Account anonAccount =TestDataUtils.createAccount(true,'Individual - No Account');
        for(Integer i = 5 ;i<=15;i++){
            Integer j = i+500;
            lead tempLead = new lead();
            String email = 'test2341'+j+'@dummy.com';
            tempLead = TestDataUtils.createLead(false,'Test'+j,'Lead'+j,'Lead'+j+' Company','Content',email);
            tempLead.Username__c = email;
            tempLead.Convert_Lead__c = TRUE;
            LeadList.add(tempLead);

        }
        insert LeadList;

        List<lead> convertedList = [select id,name,convertedcontactId from lead where isConverted = true and convertedcontactId != null];
        system.debug('===convertedList==='+convertedList.size());
        system.assertEquals(LeadList.size(), convertedList.size());
        test.stopTest();
    }


    static testMethod void communitiesUpdateTest(){
        Project__c parentProject= new Project__c(Name='ParentTestProject',Project_Type__c='Project', Category__c = 'Directed fund');
        insert parentProject;
        Project__c project= new Project__c(Name='TestProject',Parent_Project__c=parentProject.Id, Category__c = 'Directed fund');
        insert project;
        
        Account anonAccount =TestDataUtils.createAccount(true,'Individual - No Account');

        Collaboration__c collaboration = new Collaboration__c(Collaboration_Type__c = 'Mailing List', Collaboration_Name__c = 'Test Collaboration', Project_Name__c = project.id,
                Description__c = 'test collaboration parent test', Category__c = 'SIG' );
        insert collaboration;

        Lead lead = new Lead(LastName='Test Lead',FirstName='TESTING', Phone='(758) 771-0091' ,Twitter_ID__c='test123@twitter.com',Twitter_Followers__c=12345,GitHub_ID__c='test123@github.com',
                Company='test', Email = 'test@noreply123.com',Github_Followers__c = 123, LinkedIn_ID__c= 'test123@linkedin.com', Convert_Lead__c = false);
        insert lead;

        Community__c communityL = new Community__c(Lead_Name__c = lead.Id, Type__c = 'Mailing List', Project_Name__c = project.Id, Collaboration_Name__c = collaboration.Id,
                Role__c = 'Vice Chair',Start_Date__c = Date.today()+1,End_Date__c = Date.today()+101, Appointed_By__c = 'Vote of Governing Board',
                Email__c = 'test@noreply123.com', Voting_Status__c = 'Observer', Votind_Start_Date__c = Date.today()+1, Voting_End_Date__c = Date.today()+102 );
        insert communityL;
        Lead lead1 = [SELECT Id,Convert_Lead__c FROM Lead WHERE Id = :lead.Id];
        System.debug(lead1.Convert_Lead__c + '====> lead1.Convert_Lead__c');
        Test.startTest();
        LinuxTriggerUtilityClass.LeadTriggerActionOnceMore = false;
        lead1.Convert_Lead__c = true;
        lead1.Username__c= 'test@nore123ply123.com';
        update lead1;
        Test.stopTest();
        lead1 = [SELECT Id,isConverted,ConvertedContactId FROM Lead WHERE Id = :lead.Id];

        System.assertEquals(lead1.isConverted ,true);
        Community__c comm = [SELECT Id, Contact_Name__c From Community__c WHERE Contact_Name__c = :lead1.ConvertedContactId];
        System.assertEquals(comm.Contact_Name__c, lead1.ConvertedContactId);

    }


    static testMethod void mergingLeadCommunityChecker(){
        
        /*System.runAs(new User(Id = UserInfo.getUserId())){
            Group grp = new Group();
            grp.Name = 'System_Administrator_Group';
            grp.DeveloperName = 'System_Administrator_Group';
            insert grp;
            
            GroupMember gm = new GroupMember();
            gm.GroupId = grp.Id;
            gm.UserOrGroupId = UserInfo.getUserId();
            insert gm;
            
        }*/
        
        Project__c parentProject= new Project__c(Name='ParentTestProject',Project_Type__c='Project', Category__c = 'Directed fund');
        insert parentProject;
        Project__c project= new Project__c(Name='TestProject',Parent_Project__c=parentProject.Id, Category__c = 'Directed fund');
        insert project;

        Collaboration__c collaboration = new Collaboration__c(Collaboration_Type__c = 'Mailing List', Collaboration_Name__c = 'Test Collaboration', Project_Name__c = project.id,
                Description__c = 'test collaboration parent test', Category__c = 'SIG' );
        insert collaboration;

        Lead lead = new Lead(LastName='Test Lead',FirstName='TESTING', Phone='(758) 771-0091' ,Twitter_ID__c='test123@twitter.com',Twitter_Followers__c=12345,GitHub_ID__c='test123@github.com',
                Company='test', Email = 'test@noreply123.com',Github_Followers__c = 123, LinkedIn_ID__c= 'test123@linkedin.com', Convert_Lead__c = false);
        insert lead;
        Lead lead1 = new Lead(LastName='Test Lead',FirstName='TESTING', Phone='(758) 771-0091' ,Twitter_ID__c='test1234@twitter.com',Twitter_Followers__c=12345,GitHub_ID__c='test1234@github.com',
                Company='test', Email = 'test@noreply1234.com',Github_Followers__c = 123, LinkedIn_ID__c= 'test1234@linkedin.com', Convert_Lead__c = false);
        insert lead1;

        Community__c communityL = new Community__c(Lead_Name__c = lead.Id, Type__c = 'Mailing List', Project_Name__c = project.Id, Collaboration_Name__c = collaboration.Id,
                Role__c = 'Vice Chair',Start_Date__c = Date.today()+1,End_Date__c = Date.today()+101, Appointed_By__c = 'Vote of Governing Board',
                Email__c = 'test@noreply123.com', Voting_Status__c = 'Observer', Votind_Start_Date__c = Date.today()+1, Voting_End_Date__c = Date.today()+102 );
        insert communityL;

        Community__c communityL1 = new Community__c(Lead_Name__c = lead1.Id, Type__c = 'Mailing List', Project_Name__c = project.Id, Collaboration_Name__c = collaboration.Id,
                Role__c = 'Vice Chair',Start_Date__c = Date.today()+1,End_Date__c = Date.today()+101, Appointed_By__c = 'Vote of Governing Board',
                Email__c = 'test@noreply123.com', Voting_Status__c = 'Observer', Votind_Start_Date__c = Date.today()+1, Voting_End_Date__c = Date.today()+102 );
        insert communityL1;
        merge lead lead1;

    }


    static testMethod void convertLeadExistingContact(){
        
        
        /*System.runAs(new User(Id = UserInfo.getUserId())){
            Group grp = new Group();
            grp.Name = 'System_Administrator_Group';
            grp.DeveloperName = 'System_Administrator_Group';
            insert grp;
            
            GroupMember gm = new GroupMember();
            gm.GroupId = grp.Id;
            gm.UserOrGroupId = UserInfo.getUserId();
            insert gm;
            
        }*/
        
        Account acc =  TestDataUtils.createAccount(true, 'test Account');
        
        Account acc2 = new Account();
        acc2.Name = 'Lead Company';
        acc2.Website = 'www.leadCompany.com';
        insert acc2;
        
        Contact cnt = TestDataUtils.createContact('Test', 'LastName' , acc.Id);

        Project__c parentProject= new Project__c(Name='ParentTestProject',Project_Type__c='Project', Category__c = 'Directed fund');
        insert parentProject;
        Project__c project= new Project__c(Name='TestProject',Parent_Project__c=parentProject.Id, Category__c = 'Directed fund');
        insert project;

        Collaboration__c collaboration = new Collaboration__c(Collaboration_Type__c = 'Mailing List', Collaboration_Name__c = 'Test Collaboration', Project_Name__c = project.id,
                Description__c = 'test collaboration parent test', Category__c = 'SIG' );
        insert collaboration;

        Lead lead = new Lead(LastName='Test Lead',FirstName='TESTING', Phone='(758) 771-0091' ,Twitter_ID__c='test123@twitter.com',Twitter_Followers__c=12345,GitHub_ID__c='test123@github.com',
                Company='test', Email = 'test@noreply123.com',Github_Followers__c = 123, LinkedIn_ID__c= 'test123@linkedin.com', Convert_Lead__c = false);
        insert lead;
        Lead lead1 = new Lead(LastName='Test Lead',FirstName='TESTING', Phone='(758) 771-0091' ,Twitter_ID__c='test1234@twitter.com',Twitter_Followers__c=12345,GitHub_ID__c='test1234@github.com',
                Company='test', Email = 'test@noreply123456.com',Github_Followers__c = 123, LinkedIn_ID__c= 'test1234@linkedin.com', Convert_Lead__c = false);
        insert lead1;

        Community__c communityL = new Community__c(Contact_Name__c = cnt.Id, Type__c = 'Mailing List', Project_Name__c = project.Id, Collaboration_Name__c = collaboration.Id,
                Role__c = 'Vice Chair',Start_Date__c = Date.today()+1,End_Date__c = Date.today()+101, Appointed_By__c = 'Vote of Governing Board',
                Email__c = 'test@noreply123.com', Voting_Status__c = 'Observer', Votind_Start_Date__c = Date.today()+1, Voting_End_Date__c = Date.today()+102 );
        insert communityL;

        Community__c communityL1 = new Community__c(Lead_Name__c = lead1.Id, Type__c = 'Mailing List', Project_Name__c = project.Id, Collaboration_Name__c = collaboration.Id,
                Role__c = 'Vice Chair',Start_Date__c = Date.today()+1,End_Date__c = Date.today()+101, Appointed_By__c = 'Vote of Governing Board',
                Email__c = 'test@noreply123.com', Voting_Status__c = 'Observer', Votind_Start_Date__c = Date.today()+1, Voting_End_Date__c = Date.today()+102 );
        insert communityL1;

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(lead1.Id);
        lc.setConvertedStatus('Converted');
        //lc.setContactId(cnt.Id);
        lc.setAccountId(acc.Id);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        //System.assertEquals(cnt.Id ,[SELECT Id, Contact_Name__c FROM Community__c WHERE ID = :communityL1.Id][0].Contact_Name__C);
    }
    
    @isTest
    static void insertDuplicateLeadTest(){
        List<Lead> leads = new List<Lead>();
        for(Integer i= 0;i<2;i++){
            Lead lead = new Lead();
        lead.LastName = 'test contact 1';
        lead.Email = 'testContact1@noreply.in';
        leads.add(lead);
        }
        try{
            insert leads;
        }
        catch(Exception ex){
            System.assert(ex.getMessage().contains('Duplicate record found'));
        }
    }
    
    @isTest
    static void addCommunityMemberLeadTest(){
        Campaign cmp = new Campaign(Name='Test Campaign', Type ='Project');
        insert cmp;
        Lead lead = new Lead();
        lead.LastName = 'test contact 1';
        lead.Email = 'testContact1@noreply.in';
        insert lead;
        List<Lead> insertedLeads = new List<Lead>([Select Name,Mixmax_Campaign_Name__c From Lead]);
        for(Lead l:insertedLeads){
            l.Mixmax_Campaign_Name__c = cmp.Name;
            update l;
        }
        List<CampaignMember> lstCampaignMembers = new List<CampaignMember>([Select Name From CampaignMember Where Name = 'test contact 1']);
        //System.assertEquals(lstCampaignMembers[0].Name,'test contact 1');
    }
    
    @isTest
    static void convertLeadToExistingAccount(){
        Account acc =  TestDataUtils.createAccount(true, 'User Service');
        
        Account acc2 = new Account();
        acc2.Name = 'Lead Company';
        acc2.Website = 'www.leadCompany.com';
        insert acc2;
        
        Contact cnt = TestDataUtils.createContact('Test', 'LastName' , acc.Id);
        
        Lead lead = new Lead(LastName='Test Lead',FirstName='TESTING', Phone='(758) 771-0091' ,Twitter_ID__c='test123@twitter.com',Twitter_Followers__c=12345,GitHub_ID__c='test123@github.com',
                 Email = 'test@service.com',Github_Followers__c = 123, LinkedIn_ID__c= 'test123@linkedin.com', Convert_Lead__c = false);
        insert lead;
        
        lead.Convert_Lead__c = true;
        lead.Convert_To_Business_Account__c = true;
        update lead;
        
        Lead lead2 = new Lead(LastName='Test Lead 2',FirstName='TESTING', Phone='(758) 771-0091' ,Twitter_ID__c='test123@twitter.com',Twitter_Followers__c=12345,GitHub_ID__c='test123@github.com',
                Company='leadCompany', Email = 'test@leadCompany.com',Github_Followers__c = 123, LinkedIn_ID__c= 'test123@linkedin.com', Convert_Lead__c = false);
        insert lead2;
        
        lead2.Convert_Lead__c = true;
        update lead2;
        System.assertEquals(acc2.Id ,[SELECT Id, AccountId FROM Contact WHERE Email = 'test@leadCompany.com'][0].AccountId);
        
        Lead lead3 = new Lead(LastName='Test Lead 3',FirstName='TESTING', Phone='(758) 771-0091' ,Twitter_ID__c='test123@twitter.com',Twitter_Followers__c=12345,GitHub_ID__c='test123@github.com',
                 Email = 'test@leadCompany2345.com',Github_Followers__c = 123, LinkedIn_ID__c= 'test123@linkedin.com', Convert_Lead__c = false);
        insert lead3;
        
        lead3.Convert_Lead__c = true;
        update lead3;
    }
    
    @isTest
    public static void updateEnrollmentsofConvertedLead_test(){
        Training__c training = new Training__c();
        training.Name = 'Edx Training';
        insert training;
        
        List<Lead> leads = new List<Lead>();
        for(Integer i = 0 ; i < 10 ; i++){
            Lead lead = new Lead ();
            lead.LastName  = 'test Name'+i;
            lead.Email = 'testemail'+i+'@norep.com';
            lead.Company = 'test account';
            leads.add(lead);
        }
        insert leads;
        
        List<Enrollment__c> enrollmentList = new List<Enrollment__c>(); 
        for(Lead lead:leads){
            Enrollment__c enrollment = new Enrollment__c();
            enrollment.Lead_Name__c = lead.Id;
            enrollmentList.add(enrollment);
        }
        insert enrollmentList;
        for(Lead lead:leads){
            lead.Convert_Lead__c = true;
        }
        update leads;
    }
    
    @isTest
    static   void updateLeadSource_test(){
        List<Lead> LeadList=new List<Lead>();
        for(Integer i = 15 ;i<=30;i++){
            Integer j = i+1;
            lead tempLead = new lead();
            String email = 'test2345641'+j+'@test73'+j+'951.com';
            tempLead = TestDataUtils.createLead(false,'Test','Lead'+j,'Lead'+j+'Company'+j,'Content',email);
            tempLead.LeadSource = 'Test source';
            LeadList.add(tempLead);

        }
        Lead lead = new Lead();
        lead.LastName = 'Lead source test';
        lead.Lead_Source_Integration__c = 'EDx'; 
        LeadList.add(lead);
        
        test.startTest();
        insert LeadList;
        test.stopTest();
        
        System.assertEquals('Test source', [SELECT Id,LeadSource FROM Lead WHERE name = 'Test Lead17' Limit 1 ].LeadSource);        
    }
}