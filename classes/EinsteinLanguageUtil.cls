public class EinsteinLanguageUtil {

    public String createRequestBody(String operation, String analysisText)
    {
      Einstein_Language_API__mdt einsteinLanguageApi = [Select Endpoint__c, LanguageIntentModel__c, LanguageSentimentModel__c from Einstein_Language_API__mdt where DeveloperName ='Einstein_Language'];
      String sentimentEndpoint;
      String sentimentModelId;

        if(operation == 'sentiment') {
            sentimentEndpoint = einsteinLanguageApi.Endpoint__c + 'sentiment';
            sentimentModelId = einsteinLanguageApi.LanguageSentimentModel__c ;
        }else if(operation == 'intent')
        {
            sentimentEndpoint = einsteinLanguageApi.Endpoint__c + 'intent';
            sentimentModelId = einsteinLanguageApi.LanguageIntentModel__c;
        }else
        {
            return null;
        }
        EinsteinLanguageRequest sentimentRequest = new EinsteinLanguageRequest();
        sentimentRequest.document = analysisText;
        sentimentRequest.modelId = sentimentModelId;

        String maxProbabilityString = sendRequest(sentimentEndpoint, sentimentRequest);

        return maxProbabilityString;
     }

     public String sendRequest(String sentimentEndpoint, EinsteinLanguageRequest sentimentRequest)
     {
        EinsteinLanguageTokenGenerator tokenGen = new EinsteinLanguageTokenGenerator();
        String authToken = tokenGen.getJwtToken();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod( 'POST' );
        req.setEndpoint( sentimentEndpoint );

        req.setHeader('Connection', 'keep-alive');
        req.setHeader( 'Authorization', 'Bearer ' + authToken );
        req.setHeader( 'Content-type', 'application/json' );

        String reqBodyString = Json.serializePretty(sentimentRequest);
        req.setBody( reqBodyString );

        System.debug('** Einstein Request Body ' + req.getBody());

        HTTPResponse res = http.send( req );

        System.debug('** Einstein Response Body' + res.getbody());

        Type ClassType = Type.forName('EinsteinSentimentResponse');

        EinsteinSentimentResponse sentimentResponse = (EinsteinSentimentResponse) JSON.deserialize(res.getBody(),ClassType);

        System.debug('** Einstein Response' + sentimentResponse);

        Map<Double,String> maxProbabilityMap = new Map<Double,String>();
        String probabilityLabel;
        Double maxProbability = 0;
        String finalSentiment;

        for(EinsteinSentimentResponse.Probability sentiment : sentimentResponse.probabilities)
        {
            if(sentiment.probability != null) {
                System.debug('** Analysis is - ' + sentiment.label + ':' + sentiment.probability * 100);
            }else
            {
                System.debug('** Analysis is - ' + sentiment.label + ':' + sentiment.probability);
            }
            if(sentiment.probability > maxProbability) {
                maxProbability = sentiment.probability;
                probabilityLabel = sentiment.label;
            }
        }
        finalSentiment = probabilityLabel + ':' + maxProbability;

        finalSentiment = finalSentiment.replace('neutral', 'Neutral');
        finalSentiment = finalSentiment.replace('positive', 'Positive');
        finalSentiment = finalSentiment.replace('negative', 'Negative');

        System.debug('** Final Einstein Value is - ' + finalSentiment);
        return finalSentiment;
    }
  }