public with sharing class EinsteinLanguageRequest {

    public String modelId;
    public String document;

    public static EinsteinLanguageRequest parse(String json) {
        return (EinsteinLanguageRequest) System.JSON.deserialize(json, EinsteinLanguageRequest.class);
    }

}