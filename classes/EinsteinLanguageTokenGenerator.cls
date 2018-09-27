public class EinsteinLanguageTokenGenerator {
    
    public String getJwtToken()
    {
        // get stored private key file
        ContentVersion contentVersion = [SELECT  Title, VersionData FROM ContentVersion WHERE   Title = 'einstein_platform' ORDER BY Title LIMIT 1];

        // cleanup the key
        String cryptoKey  = contentVersion.VersionData.tostring();
        cryptoKey = cryptoKey.replace( '-----BEGIN RSA PRIVATE KEY-----', '' );
        cryptoKey = cryptoKey.replace( '-----END RSA PRIVATE KEY-----', '' );
        cryptoKey = cryptoKey.replace( '\n', '' );

        Einestein_language_token__c  tokenSettings = Einestein_language_token__c.getValues('JWTToken');
        // create JSON web token    
        JWT jsonWebToken = new JWT('RS256'); 
        jsonWebToken.pkcs8 = cryptoKey;
        jsonWebToken.iss = tokenSettings.Token_ISS__c;
        jsonWebToken.sub = tokenSettings.Token_SUB__c;
        jsonWebToken.aud = tokenSettings.Token_End_Point__c;
        jsonWebToken.exp = String.ValueOf(tokenSettings.Token_EXP__c);
        // get access token
        String tokenResp = JWTBearerFlow.getAccessToken(tokenSettings.Token_End_Point__c,jsonWebToken);
        system.debug('** EinesteinLanguageTokenGenerator - tokenResp' + tokenResp);
        return tokenResp;
    }

}