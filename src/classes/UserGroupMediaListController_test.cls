@isTest
public class UserGroupMediaListController_test {
    public static testmethod void testQuery() {
        UserGroupMediaListController_test.createTestMedia();
        
        Test.startTest();
        UserGroupMediaListController_test.testQuery_future();
        Test.stopTest();
    }
    
    @future
    private static void testQuery_future() {
        User testUser = UserGroupMediaListController_test.createTestUser();
        
        Loop_Media__c[] all = [Select Id From Loop_Media__c]; 
        System.assert(all.size() == 26);
        
        System.runAs(testUser) {
            UserGroupMediaListController sub = new UserGroupMediaListController();
            
            System.assert(sub.resultSize == 24);
            System.assert(sub.hasNext == true);
            System.assert(sub.hasPrevious == false);
            System.assert(sub.getPageSizes()[0].getValue() == '20');
            System.assert(sub.getPageSizes()[1].getValue() == '50');
            System.assert(sub.getPageSizes()[2].getValue() == '100');
            System.assert(sub.getPageSizes()[3].getValue() == '200');
            
            System.assert(sub.getLoopMedia().size() == 20);
            System.assert(sub.pageSize == 20);
            System.assert(sub.pageNumber == 1);
            
            sub.next();
            System.assert(sub.pageNumber == 2);
            
            sub.first();
            System.assert(sub.pageNumber == 1);
            
            sub.pageSize = 10;
            
            sub.last();
            System.assert(sub.pageNumber == 3);
            
            sub.previous();
            System.assert(sub.pageNumber == 2);
        }
    }
    
    public static testmethod void testSearch() {
        UserGroupMediaListController_test.createTestMedia();
        
        Test.startTest();
        UserGroupMediaListController_test.testSearch_future();
        Test.stopTest();
    }
    
    @future
    private static void testSearch_future() {
        User testUser = UserGroupMediaListController_test.createTestUser();
        
        Loop_Media__c[] all = [Select Id, Title__c From Loop_Media__c]; 
        System.assert(all.size() == 26);
        
        List<Id> fixedSearchResults = new List<Id>();
        
        for (Loop_Media__c lm : all) {
            if (lm.Title__c.contains('Twenty')) {
             	fixedSearchResults.add(lm.Id);   
            }
        }
        
        Test.setFixedSearchResults(fixedSearchResults);

        System.runAs(testUser) {
            UserGroupMediaListController sub = new UserGroupMediaListController();

            sub.searchString = 'Twenty';
            sub.search();
            
            System.assert(sub.resultSize == 6);
            
            sub.clearSearch();
            System.assert(sub.resultSize == 24);

			sub.searchString = '1';
			sub.search();

            // Search string not long enough. Should result in all records
            System.assert(sub.resultSize == 24);
        }
    }
    
    private static User createTestUser() {
    	// Setup test data
        // This code runs as the system user
        Profile profile = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
        User testUser = new User(
            Alias = 'standt', 
            Email='standarduser@meetmaestro.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = profile.Id, 
            TimeZoneSidKey='America/New_York', 
            UserName='standarduser@meetmaestro.com'
       	);
        
        insert testUser;
        
        PermissionSet permSet = [SELECT Id FROM PermissionSet Where Name = 'Loop_Connector_View_Media'];
		insert new PermissionSetAssignment(AssigneeId = testUser.id, PermissionSetId = permSet.Id);

        // Gets around MIXED_DML_OPERATION  issue
        System.runAs(new User(Id = Userinfo.getUserId())) {
            Loop_User_Group__c groups = new Loop_User_Group__c(
                Groups__c='1;2;3',
                User__c = testUser.id
            );
            insert groups;
        }
        
        return testUser;
    }
    
    private static void createTestMedia() {
        List<Loop_Media__c> testData = new List<Loop_Media__c>();
        
        testData.add(new Loop_Media__c(Title__c = 'One', Groups__c = '1;2', Asset_Number__c = 'Media-1', Loop_id__c = '1'));
        testData.add(new Loop_Media__c(Title__c = 'Two', Groups__c = '1;2;5', Asset_Number__c = 'Media-2', Loop_id__c = '2'));
        testData.add(new Loop_Media__c(Title__c = 'Three', Groups__c = '3;4;5', Asset_Number__c = 'Media-3', Loop_id__c = '3'));
        testData.add(new Loop_Media__c(Title__c = 'Four', Groups__c = '1;5', Asset_Number__c = 'Media-4', Loop_id__c = '4'));
        testData.add(new Loop_Media__c(Title__c = 'Five', Groups__c = '1;2', Asset_Number__c = 'Media-5', Loop_id__c = '5'));
        testData.add(new Loop_Media__c(Title__c = 'Six', Groups__c = '4;5', Asset_Number__c = 'Media-6', Loop_id__c = '6'));
        testData.add(new Loop_Media__c(Title__c = 'Seven', Groups__c = '1;2;', Asset_Number__c = 'Media-7', Loop_id__c = '7'));
        testData.add(new Loop_Media__c(Title__c = 'Eight', Groups__c = '3;4', Asset_Number__c = 'Media-8', Loop_id__c = '8'));
        testData.add(new Loop_Media__c(Title__c = 'Nine', Groups__c = '1;4;5', Asset_Number__c = 'Media-9', Loop_id__c = '9'));
        testData.add(new Loop_Media__c(Title__c = 'Ten', Groups__c = '1;2', Asset_Number__c = 'Media-10', Loop_id__c = '10'));
        testData.add(new Loop_Media__c(Title__c = 'Eleven', Groups__c = '1;2', Asset_Number__c = 'Media-11', Loop_id__c = '11'));
        testData.add(new Loop_Media__c(Title__c = 'Twelve', Groups__c = '3;4;5', Asset_Number__c = 'Media-12', Loop_id__c = '12'));
        testData.add(new Loop_Media__c(Title__c = 'Thirteen', Groups__c = '1;5', Asset_Number__c = 'Media-13', Loop_id__c = '13'));
        testData.add(new Loop_Media__c(Title__c = 'Fourteen', Groups__c = '1;3', Asset_Number__c = 'Media-14', Loop_id__c = '14'));
        testData.add(new Loop_Media__c(Title__c = 'Fifteen', Groups__c = '2;5', Asset_Number__c = 'Media-15', Loop_id__c = '15'));
        testData.add(new Loop_Media__c(Title__c = 'Sixteen', Groups__c = '1;2;3;4;5', Asset_Number__c = 'Media-16', Loop_id__c = '16'));
        testData.add(new Loop_Media__c(Title__c = 'Seventeen', Groups__c = '1;2;3;4;5', Asset_Number__c = 'Media-17', Loop_id__c = '17'));
        testData.add(new Loop_Media__c(Title__c = 'Eighteen', Groups__c = '1;5', Asset_Number__c = 'Media-18', Loop_id__c = '18'));
        testData.add(new Loop_Media__c(Title__c = 'Nineteen', Groups__c = '1;2;3', Asset_Number__c = 'Media-19', Loop_id__c = '19'));
        testData.add(new Loop_Media__c(Title__c = 'Twenty', Groups__c = '3;4;5', Asset_Number__c = 'Media-20', Loop_id__c = '20'));
        testData.add(new Loop_Media__c(Title__c = 'Twenty One', Groups__c = '5', Asset_Number__c = 'Media-21', Loop_id__c = '21'));
        testData.add(new Loop_Media__c(Title__c = 'Twenty Two', Groups__c = '1;2;5', Asset_Number__c = 'Media-22', Loop_id__c = '22'));
        testData.add(new Loop_Media__c(Title__c = 'Twenty Three', Groups__c = '1;2;5', Asset_Number__c = 'Media-23', Loop_id__c = '23'));
        testData.add(new Loop_Media__c(Title__c = 'Twenty Four', Groups__c = '1;2;5', Asset_Number__c = 'Media-24', Loop_id__c = '24'));
        testData.add(new Loop_Media__c(Title__c = 'Twenty Five', Groups__c = '1;2;5', Asset_Number__c = 'Media-25', Loop_id__c = '25'));
        testData.add(new Loop_Media__c(Title__c = 'Twenty Six', Groups__c = '1;2;5', Asset_Number__c = 'Media-26', Loop_id__c = '26'));
        
        insert testData;
    }
}