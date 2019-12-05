public class LoopMediaWidgetController extends LoopMediaBaseController {
    
    public String widgetSubtitle { get; set; }
    public String browseLoopLocation { get; set; }
    
    public LoopMediaWidgetController() {
        this.pageSizes = new Integer[]{ 5 };
        this.externalContentOnly = false;
        
        Loop_Settings__mdt[] loopSettings = [Select Loop_Widget_Subtitle__c, Sharable_Content_Only_Widget_Default__c, View_All_Media_Location__c From Loop_Settings__mdt Limit 1];
        
        if (loopSettings != null && loopSettings.size() > 0) {
            this.externalContentOnly = loopSettings[0].Sharable_Content_Only_Widget_Default__c;
            this.widgetSubtitle = loopSettings[0].Loop_Widget_Subtitle__c;
            this.browseLoopLocation = loopSettings[0].View_All_Media_Location__c;
        }
    }
    
    public Boolean showCta {
        get { return this.hasSearchValue == false; }
        set;
    }
}