({
    getdomainurl:function(component,event,helper){
        var action = component.get("c.getmydomain");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state==="SUCCESS") {
                component.set("v.domainurl",response.getReturnValue());
                console.log("domain",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getCaseHistory:function(component,type){
        console.log('type1111111111111111111111111111111',type);
        if(type=='initialLoad'){
            var action = component.get("c.getCallbackInteraction");
            
            action.setParams({"accountId": component.get("v.recordId")});
            
            action.setCallback( this, function(response) {
                var state = response.getState();
                var resultData=response.getReturnValue();
                var recordLength=response.getReturnValue().length;
                component.set("v.totalRecords",recordLength);
                console.log('hi');
                var paginateData=[];
                if (state==="SUCCESS") {
                    //component.set("v.message",response.getReturnValue());
                    component.set("v.listInteraction",response.getReturnValue());
                    var futureInteractions = component.get("v.listInteraction");
                    console.log(futureInteractions.size);
                    var counter = component.get("v.counter");
                    var finalCount = 0;  
                    for(var i = 0; i<futureInteractions.size;i++){
                        
                        
                        component.set("v.counter",[i]);
                    }
                    
                    
                    console.log(component.get("v.counter"));
                    console.log(component.get("v.listInteraction"));
                    component.set("v.listInteraction",resultData);
                    //alert('contactList'+component.get("v.contactList"));
                    for(var i=0;i<3;i++)
                    {
                        if(recordLength > i)
                        {
                            paginateData.push(resultData[i]);
                            
                        }                   
                    }
                    component.set("v.CaseListPaginateWise",paginateData);
                    console.log("CaseListPaginateWise",JSON.stringify(component.get("v.CaseListPaginateWise")));
                    console.log("paginateData",paginateData.length);
                    if(paginateData.length==0){
                        component.set("v.bool",false);
                        console.log("Boolean",component.get("v.bool"));
                    }
                    component.set("v.lastPageNumber",Math.ceil(recordLength/3));
                    console.log(response.getReturnValue());
                }
            });
            
            $A.enqueueAction(action);
        }
        if(type=='next')
        {
            var pgNumber=component.get("v.pageNumber");
            console.log("pgNumber",pgNumber);
            var limit=3*pgNumber;
            var start=limit-3;
            
            var paginateData=[];
            var caseList=[];
            caseList=component.get("v.listInteraction");
            var recordLength=component.get("v.totalRecords");
            var counter=component.get("v.counter");
            for(var i=start;i<limit;i++)
            {
                if(recordLength > i)
                {
                    paginateData.push(caseList[i]);
                    
                }                   
            }
            component.set("v.CaseListPaginateWise",paginateData);
        }
        if(type=='previous')
        {
            var pgNumber=component.get("v.pageNumber");
            var limit=3*pgNumber;
            var start=limit-3;
            var paginateData=[];
            var contactList=[];
            contactList=component.get("v.listInteraction");
            var recordLength=component.get("v.totalRecords");
            for(var i=start;i<limit;i++)
            {
                if(recordLength > i)
                {
                    paginateData.push(contactList[i]);
                    
                }                   
            }
            component.set("v.CaseListPaginateWise",paginateData);
        }
    },
    
})