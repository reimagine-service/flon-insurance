({
	getColumnAndAction : function(component) {
        var actions = [
            // {label: 'Edit', name: 'edit'},
            // {label: 'Delete', name: 'delete'},
            {label: 'View', name: 'view'}
        ];
        component.set('v.columns', [
            // {label: 'CaseNumber', fieldName: 'CaseNumber', type: 'text'},	
            {label: 'Case', fieldName: 'linkName', type: 'url', 
            typeAttributes: {label: { fieldName: 'CaseNumber' }, target: '_blank'}},
            {label: 'Status', fieldName: 'Status', type: 'text'},
            {label: 'Case Type', fieldName: 'Type', type: 'text'},
            // {label: 'CreatedDate', fieldName: 'CreatedDate', type: 'text'},
            {label: 'Created Date', fieldName: 'CreatedDate', type: 'date', typeAttributes: {  
                day: 'numeric',  
                month: 'numeric',  
                year: 'numeric',    
                hour12: true}},
           // {label: 'Customer Name', fieldName: 'AccountName', type: 'text'}
            // {type: 'action', typeAttributes: { rowActions: actions } } 
        ]);
    },
	getCaseList: function(component, pageNumber, pageSize) {
        
		var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
		var recordId = component.get('v.recordId');
        var channel = component.get('v.Channel');
        var action = component.get("c.allcases");
        action.setParams({
			"recordId":recordId,
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "channel":channel
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log('state',state);
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
           
                if(resultData.length > 0){
                   component.set("v.initialData", true);
				console.log('resultData',resultData);
                if(resultData.length < component.get("v.pageSize")){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }
                component.set("v.dataSize", resultData.length);
                for (var i = 0; i < resultData.length; i++) {
                    var row = resultData[i];
                    if (row.Account) row.AccountName = row.Account.Name;
                    row.linkName = '/'+row.Id;
                    console.log(row.linkName);
                }
                console.log('AccountName',row.AccountName);
                component.set('v.AccountName',row.AccountName);
                
                // component.set("v.data", rows);
                component.set("v.data", resultData);
                }else if(!component.get("v.initialData") && resultData.length <= 0){                    
                        component.set('v.UserMessage',true);
                }
            }
        });
        $A.enqueueAction(action);
    },
     
    viewRecord : function(component, event) {
        var row = event.getParam('row');
        var recordId = row.Id;
        var navEvt = $A.get("event.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
})