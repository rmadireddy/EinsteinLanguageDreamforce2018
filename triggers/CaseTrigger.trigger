trigger CaseTrigger on Case (after insert, before update) {

      	List<Id> caseIdsList = new List<Id>();
        for(Case caseRecord : Trigger.new) {
        if( caseRecord.description != null && (Trigger.isInsert || Trigger.newMap.get(caseRecord.id).description != Trigger.oldMap.get(caseRecord.id).description)) {
            caseIdsList.add(caseRecord.id);
        }
    }
    if(caseIdsList.size() > 0)
        EinsteinIntentAPI.getLanguageIntentAsync(caseIdsList);


}