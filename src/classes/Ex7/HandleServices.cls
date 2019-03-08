@RestResource(urlMapping='/api/handleservices/*')
global without sharing class HandleServices {
    
    private static final String[] intTypes = new String[]{'Parking', 'Retail','Fast Track'};
    
    global class ServiceWrapper{
        public String type {get;set;}
        public String extId {get;set;}
		public Double price {get;set;}            
    }
    
    @HttpPut
    global static void upsertServices(List<ServiceWrapper> extServices){
        
        System.debug('rest call'+extServices);
    RestResponse response = RestContext.response;
        List<Service__c> services = new List<Service__c>();
        for(ServiceWrapper wrapper: extServices){
            services.add(new Service__c(
           	external_Id__c  = wrapper.extId,
            Price__c = wrapper.price,
            Type__c = mapServiceType(wrapper.type)));
        }
        try{
            Database.upsert(services, Service__c.fields.external_Id__c);
        } catch(Exception e){
            
        }
    }
    
    private static String mapServiceType(String extType){
        switch on extType{
            when 'PP','FP'{
            	return intTypes[0];
            }
        
            when 'RT', 'DS'{
            	return intTypes[1];
            }
            when 'FT'{
                return intTypes[2];
            }
            when else{
                return 'Type not found';
            }
        }
        
    }

}