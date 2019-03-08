trigger TriggerContactEx9 on Contact (before insert) {
    TriggerHandlerContactEx9.insertNewContact(trigger.newMap);
}