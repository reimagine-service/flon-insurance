({
	 handleClick : function (cmp, event, helper) {
       cmp.set("v.buttonclicked", true);
    },
    handleBackClick: function (cmp, event, helper) {
       cmp.set("v.buttonclicked", false);
    }
})