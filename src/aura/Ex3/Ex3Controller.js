({

    handleClick : function(component, event, helper) {

        var action = component.get("c.simpleAction");
        var nClick=component.get("v.nClick");

        action.setParams(
            {
                "who" :  nClick-1
            }
        );

        nClick++;
        component.set("v.nClick",nClick);

        action.setCallback(this, 
            function(result){
                if(result.getState() == "SUCCESS"){
                    component.set("v.contact",result.getReturnValue());
                    let array=component.get("v.contact.Name").split(" ");
                    let temp= array[0].charAt(0)+array[1].charAt(0);
                    component.set("v.initialsContact",temp);
                }

           });
       $A.enqueueAction(action);
    }
})