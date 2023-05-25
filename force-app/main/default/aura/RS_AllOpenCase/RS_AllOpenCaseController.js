({
    doInit : function(component, event, helper) {
        helper.getColumnAndAction(component);
        helper.getCaseList(component,helper);
        
    },
    handleNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.getCaseList(component, helper);
    },
     
    handlePrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.getCaseList(component, helper);
    },
     
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        switch (action.name) {
            // case 'edit':
            //     helper.editRecord(component, event);
            //     break;
            // case 'delete':
            //     helper.deleteRecord(component, event);
            //     break;
            case 'view':
                helper.viewRecord(component, event);
                break;
        }
    },
})