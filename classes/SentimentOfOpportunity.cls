public class SentimentOfOpportunity {

    @InvocableMethod(label='Sentiment Of Opportunity')
    public static void getSentimentOfOpportunity(List<Id> taskIdList) {
        for(Id eachID : taskIdList)
        {
          getSentimentOfOpportunityFuture(eachID);
        }
    }
    
    @Future(callout=true)
    public static void getSentimentOfOpportunityFuture(Id taskId)
    {
         EinsteinSentimentAPI elSentimentApi = new EinsteinSentimentAPI();
         EinsteinLanguageResponse resp = new EinsteinLanguageResponse();
         Opportunity oppToUpdate = new Opportunity();    
        
         Task tskRec = [Select id,whatId,Description from Task where id=:taskId];
         resp = elSentimentApi.getLanguageSentiment(tskRec.Description);
         
         oppToUpdate.Id = tskRec.whatId;
         oppToUpdate.Einstein_Sentiment_Rating__c = resp.Probability;
         oppToUpdate.Einstein_Sentiment__c = resp.Label;
         update oppToUpdate;
    }
}