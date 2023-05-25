({
    doInitialization: function(component, event, helper) {
        console.log('type');
        var nt=component.get("v.navigateType");
        component.set("v.pageNumber",1);
        
        helper.getCaseHistory(component,nt);
        var action = component.get("c.getmydomain");
        action.setCallback( this, function(response) {
            var state = response.getState();
            if (state==="SUCCESS") {
                component.set("v.domainurl",response.getReturnValue());
                console.log(response.getReturnValue());
                console.log("Domainurl",component.get("v.domainurl"));
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    handleLink : function (component, event, helper) {
        
        var selectedItem = event.currentTarget;
        var recordId = selectedItem.dataset.record;
        //var recordId = event.getSource().getElement().getAttribute('data-taskid');
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId" : recordId
        });
        navEvt.fire();
    },
    goToNext: function(component, event, helper) {
        var pgNumber=component.get("v.pageNumber");
        pgNumber=pgNumber+1;
        component.set("v.pageNumber",pgNumber);
        component.set("v.navigateType",'next');
        var ntType=component.get("v.navigateType");
        helper.getCaseHistory(component,ntType);
    },
    goToPrevious: function(component, event, helper) {
        var pgNumber=component.get("v.pageNumber");
        pgNumber=pgNumber-1;
        component.set("v.pageNumber",pgNumber);
        component.set("v.navigateType",'previous');
        var ntType=component.get("v.navigateType");
        helper.getCaseHistory(component,ntType);
    },
    
    
})