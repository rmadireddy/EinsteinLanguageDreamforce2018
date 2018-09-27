public class EinsteinSentimentAPI {
    
    public EinsteinLanguageResponse getLanguageSentiment(String analysisText) {
            
            EinsteinLanguageUtil elUtil = new EinsteinLanguageUtil();
            // create request body
            String maxProbabilityString = elUtil.createRequestBody('sentiment', analysisText); 
            List<String> probabilitySplitList = maxProbabilityString.split(':');
            String maxProbabilityLabel;
            Double maxProbability=0;
     
             if(probabilitySplitList.size() > 0) {
                 maxProbabilityLabel = probabilitySplitList[0];
                 if(probabilitySplitList.size() > 1 && probabilitySplitList[1] != null)
                    maxProbability = Double.valueOf(probabilitySplitList[1]);
             }
             // create response object
             EinsteinLanguageResponse resp = new EinsteinLanguageResponse();
             resp.Probability = maxProbability;
             resp.Label = maxProbabilityLabel;
        
        return resp;   
    }  

}