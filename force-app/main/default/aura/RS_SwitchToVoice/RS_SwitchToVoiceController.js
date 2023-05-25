({
	doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        var action = component.get("c.UpdateSwitchToVoice");
         action.setParams({
			"recordId":recordId,
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var responseValue = response.getReturnValue();
                console.log('responseValue--'+responseValue);
               var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: "Success",
                            message: "Switch to voice successfully captured.",
                            type: "success"});
                        $A.get("e.force:closeQuickAction").fire();
                        toastEvent.fire(); 
                    $A.get("e.force:refreshView").fire();
            
               
            }else if(state=== 'ERROR'){
                
            }else if(state=== 'INCOMPLETE'){
            }
            
        },'ALL');
        $A.enqueueAction(action);
             
	}
})