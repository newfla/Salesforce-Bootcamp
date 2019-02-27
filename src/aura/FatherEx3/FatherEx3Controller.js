({
    handleMessage : function(component, event, helper) {
       
         var message = event.getParam("Message");
       
        component.set("v.messageFromChild",message);
       
    }
})
