({
	doInit : function(component, event, helper) {
		//$A.get('e.force:refreshView').fire();
        //$A.get('e.force:closeQuickAction').fire();
		//window.location.href="/lightning/r/VoiceCall/"+component.get("v.recordId")+"/edit";

		/*var editRecordEvent = $A.get("e.force:editRecord");
		editRecordEvent.setParams({
			"recordId" : component.get("v.recordId")
		});
		editRecordEvent.fire();
		*/
		//var closeActionPanel = $A.get("e.force:closeQuickAction");
        //closeActionPanel.fire();

		/*window.setTimeout(
			$A.getCallback(function() {
				var editRecordEvent = $A.get("e.force:editRecord");
				editRecordEvent.setParams({
				"recordId" : component.get("v.recordId")
				});
				editRecordEvent.fire();
			}),100
		);*/

		window.setTimeout(
			$A.getCallback(function() {
				$A.get("e.force:closeQuickAction").fire();
	
			}),1000
		);
		//window.location.href="/"+component.get("v.recordId");

		/*setTimeout(function(){
			$A.get("e.force:closeQuickAction").fire(); 
		}, 1000);*/
	},

	handleClick : function(component, event, helper) {
		var editRecordEvent = $A.get("e.force:editRecord");
		editRecordEvent.setParams({
			"recordId" : component.get("v.recordId")
		});
		editRecordEvent.fire();
		//var refreshPanel = $A.get("e.force:refreshView");
		//refreshPanel.fire();
		var closeActionPanel = $A.get("e.force:closeQuickAction");
		closeActionPanel.fire();
	}
})