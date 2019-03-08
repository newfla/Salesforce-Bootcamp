public with sharing class TriggerHandlerContactEx9 {
    public Static void insertNewContact(Map<Id,Contact> maps){
        Map<Id,Account> mapAccount = new Map<Id,Account>();
        Set<Id> listIdsAccount= new Set<Id>();

        for (Contact contact: maps.values())
           listIdsAccount.add(contact.AccountId);

        try {
           mapAccount = new Map<Id,Account>( [SELECT Id, (SELECT id FROM ContactS)
                            FROM Account
                            WHERE ID in : listIdsAccount ]);
        } catch (Exception e) {
          return; 
        }

        listIdsAccount = new Set<Id>();

        for(Contact contact: maps.values()){
            if(mapAccount.get(contact.AccountId).Contacts.size()>4)
                contact.addError('errore troppi contatti su questo account');
            }
        }
}