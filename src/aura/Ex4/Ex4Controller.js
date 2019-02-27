({

    doInit : function(component) {
        var initAction= component.get("c.getPicklistStatus");
        var opts = [
            { class: "optionClass", label: "2ption1", value: "opt1", selected: "true" },
            { class: "optionClass", label: "Option2", value: "opt2" },
            { class: "optionClass", label: "Option3", value: "opt3" }];
        initAction.setCallback(this,
                        function(result){
                            if( result.getState() === "SUCCESS" ){
                                var values=result.getReturnValue();
                                for (let index = 0; index <values.length; index++)
                                   opts[index] = { class: "optionClass", label: values[index], value: values[index]};
                            component.find("typeSelector").set("v.options", opts);
                            }

                        }
        ); 
        $A.enqueueAction(initAction);
    },

    handleClick : function(component, event, helper) {

        var dateFrom = component.get("v.dateFrom");
        var dateTo = component.get("v.dateTo");
        var serviceType = component.get("v.serviceType");
        var accountName = component.get("v.accountName");
        var action = component.get("c.getBookings");

        action.setParams(
            {
                "serviceType" :  serviceType,
                "dateFrom" : dateFrom,
                "dateTo" : dateTo,
                "accountName" : accountName
            }
        );

        action.setCallback(this,
                function(result){
                   if( result.getState() === "SUCCESS" )
                    component.set("v.bookings",result.getReturnValue());
                   else
                        component.set("v.bookings",null);
                }            
            );
       $A.enqueueAction(action);
    },


    handleCancel : function(component, event, helper) {
        var name = event.getSource().get("v.value");
        var action2 = component.get("c.updateNewStatus");

        action2.setParams(
            {
                "bookingName" : name
            }
        );

        action2.setCallback(this,
                function(result){
                   if( result.getState() === "SUCCESS" && result.getReturnValue() === true)
                        component.get("v.bookings").forEach(element => {
                            if(element.Name == name){
                                element.Status__c = 'Canceled'; 
                                component.set("v.bookings",component.get("v.bookings"));
                            }                          
                        });
                }
            
            );

       $A.enqueueAction(action2);
    },

    handleGenerate : function(component, event, helper) {
        var name = event.getSource().get("v.value");
        var action3 = component.get("c.generateInvoice");
        console.log("genera1");

        action3.setParams(
            {
                "bookingName" : name
            }
        );

        console.log("genera2");

        action3.setCallback(this,
                function(result){
                    if( result.getState() === "SUCCESS" && result.getReturnValue() === true)
                        console.log("Fattura creata");

                        component.get("v.bookings").forEach(element => {
                            if(element.Name == name){
                                element.Status__c = 'Canceled'; 
                                component.set("v.bookings",component.get("v.bookings"));
                            }                          
                        });
                }
            
            );

       $A.enqueueAction(action3);
    }
})