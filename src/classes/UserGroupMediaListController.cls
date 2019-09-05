public class UserGroupMediaListController {
    
    private Integer[] pageSizes;
    
    public String searchString { get; set; }
    
    public UserGroupMediaListController() {
        this.pageSizes = new Integer[]{ 20, 50, 100, 200 };
    }
    
    public SelectOption[] getPageSizes() {
        
        List<SelectOption> result = new List<SelectOption>();
        
        for (Integer pSize : this.pageSizes) {
            result.add(new SelectOption(String.valueOf(pSize), String.valueOf(pSize)));
        }

        return result;
    }
    
    public ApexPages.StandardSetController stdController {        
        get {
            if(stdController == null) {
                this.setQuery(stdController);
            }
            
            return stdController;
        }
        set;
    }
    
    // Approach based from - https://developer.salesforce.com/forums/?id=906F00000008yY9IAI
    public List<Loop_Media__c> getLoopMedia() {
        return (List<Loop_Media__c>) stdController.getRecords();
    }
    
    public void clearSearch() {
        this.searchString = null;
        this.setQuery(this.stdController);
    }
    
    public void search() {
        if (this.searchString.length() > 1) {   
            Integer currentPageSize = this.getCurrentPageSize(this.stdController);
            
            User user = this.getCurrentUser();
            List<Loop_Media__c> results = new List<Loop_Media__c>();
            
            if (user.Loop_Groups__c != null && user.Loop_Groups__c.length() > 0) { 
                String[] userGroups = user.Loop_Groups__c.split(';');
                
                for (Loop_Media__c[] lmGroup : [FIND :this.searchString RETURNING Loop_Media__c(Id, Asset_Number__c, Title__c, Groups__c, Type__c, LastModifiedDate, Name Order By Sort_Title__c)]) {
                    System.debug(lmGroup);
                    
                    for (Loop_Media__c lm : lmGroup) {
                        String mediaGroups = ';' + lm.Groups__c + ';';
                        
                        for (String userGroup : userGroups) {
                            if (mediaGroups.contains(';' + userGroup + ';')) {
                                results.add(lm);
                                break;
                            }
                        }
                    }
                }
            }
            
            this.stdController = new ApexPages.StandardSetController(results); 
            this.stdController.setPageSize(currentPageSize);
        }
        else {
        	this.setQuery(this.stdController);
        }
    }
    
    public void first() {
        this.stdController.first();
    }
    
    public void previous() {
        this.stdController.previous();
    }

    public void next() {
        this.stdController.next();
    }
    
    public void last() {
        this.stdController.last();
    }
    
    public Integer pageNumber {
        get { return this.stdController.getPageNumber(); }
    }
    
    public Integer pageSize {
        get { return this.stdController.getPageSize(); }
        set { this.stdController.setPageSize(value); }
    }
    
    public Integer resultSize {
        get { return this.stdController.getResultSize(); }
        set;
    }
    
 	public Boolean hasNext {        
		get { return this.stdController.getHasNext(); }
        set;    
    }
    
    public Boolean hasPrevious {        
		get { return this.stdController.getHasPrevious(); }
        set;    
    }
        
    private void setQuery(ApexPages.StandardSetController currentController) {
        Integer currentPageSize = this.getCurrentPageSize(currentController);
        
        User user = this.getCurrentUser();
        List<Loop_Media__c> results = new List<Loop_Media__c>();
        
        if (user.Loop_Groups__c != null && user.Loop_Groups__c.length() > 0) { 
            String[] userGroups = user.Loop_Groups__c.split(';');
                        
            for (Loop_Media__c[] lmGroup : [Select Id, Asset_Number__c, Title__c, Groups__c, Type__c, LastModifiedDate, Name From Loop_Media__c Order By Sort_Title__c]) {
                for (Loop_Media__c lm : lmGroup) {
                    String mediaGroups = ';' + lm.Groups__c + ';';
                    
                    for (String userGroup : userGroups) {
                        if (mediaGroups.contains(';' + userGroup + ';')) {
                            results.add(lm);
                            break;
                        }
                    }
                }
            }
        }
        
        this.stdController = new ApexPages.StandardSetController(results); 
        this.stdController.setPageSize(currentPageSize);
    }
    
    private User getCurrentUser() {
        return [SELECT Loop_Groups__c From User Where Id = :UserInfo.getUserId()];
    }
    
    private Integer getCurrentPageSize(ApexPages.StandardSetController currentController) {
       return currentController != null ? currentController.getPageSize() : this.pageSizes[0]; 
    }
}