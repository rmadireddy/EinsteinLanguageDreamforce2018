public class EinsteinIntentAPI {

    @future(callout=true)
    public static void getLanguageIntentAsync(List<id> caseIdsList) {

            List<Case> caseList = [select id, Einstein_Intent_Rating__c, Einstein_Intent__c, Case_Notes__c, description from case where id in:caseIdsList];
            for (case caseRecord : caseList) {
                new EinsteinIntentAPI().getLanguageIntent(caseRecord);
            }
    }

    public  void getLanguageIntent(Case caseRecord) {
        EinsteinLanguageUtil elUtil = new EinsteinLanguageUtil();
        String analysisText = caseRecord.description;
        String maxProbabilityString = elUtil.createRequestBody('intent', analysisText);
        List<String> probabilitySplitList = maxProbabilityString.split(':');
        String maxProbabilityLabel;
        Double maxProbability=0;

        if(probabilitySplitList.size() > 0) {
            maxProbabilityLabel = probabilitySplitList[0];
            if(probabilitySplitList.size() > 1 && probabilitySplitList[1] != null)
                maxProbability = Double.valueOf(probabilitySplitList[1]);
        }
        caseRecord.Einstein_Intent_Rating__c = maxProbability * 100;
        caseRecord.Einstein_Intent__c = maxProbabilityLabel;

        Database.DMLOptions dmo = new Database.DMLOptions();

        dmo.assignmentRuleHeader.useDefaultRule = true;
        caseRecord.setOptions(dmo);


        update caseRecord;
    }
}