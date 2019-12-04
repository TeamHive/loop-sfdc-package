public class UserGroupMediaListController extends LoopMediaBaseController {
    public UserGroupMediaListController() {
        this.pageSizes = new Integer[]{ 20, 50, 100, 200 };
        this.externalContentOnly = false;
        
         Loop_Settings__mdt[] loopSettings = [Select Sharable_Content_Only_List_Default__c From Loop_Settings__mdt Limit 1];
        
        if (loopSettings != null && loopSettings.size() > 0) {
            this.externalContentOnly = loopSettings[0].Sharable_Content_Only_List_Default__c;
        }
    }
}