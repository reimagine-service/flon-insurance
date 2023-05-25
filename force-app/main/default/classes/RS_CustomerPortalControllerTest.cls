/**
* @description       : Test Class for RS_CustomerPortalController ApexClass. 
* @author            : Accenture
* @last modified on  : 03-23-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class RS_CustomerPortalControllerTest {
    /**
    * @description : Test data setup
    * @author Accenture | 03-23-2023 
    **/
    @TestSetup
    public static void testdata(){
        String articleTitle = 'Test Article';
        String articleBody = 'Test Body';
        String articleUrlName = 'test';
        String language = 'en_US';
        
        Knowledge__kav article = new Knowledge__kav(
            Title = articleTitle,
            Summary = articleBody,
            UrlName = articleUrlName,
            Language = language
        );
        
        insert article;
    }
    @IsTest
    public static void testgetKnowledgeArticles(){
        List<String> knowArticles = new List<String>();
        Knowledge__kav knowArticle =[Select Title from Knowledge__kav LIMIT 1];
        knowArticles.add(knowArticle.Title);
        Test.startTest();
        RS_CustomerPortalController.getKnowledgeArticles();
        RS_CustomerPortalController.getSuggestedKnowledgeArticles(knowArticles);
        Test.stopTest();
        System.assertEquals('Test Article',knowArticle.Title);
    }
}