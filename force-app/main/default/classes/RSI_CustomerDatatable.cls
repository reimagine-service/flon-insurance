public class RSI_CustomerDatatable {

    @AuraEnabled(cacheable=true)
    public static String getUserAccountDetails(Id userId){
        // 
        // User userDetails=[SELECT Id,ContactId,Name,Email FROM User WHERE id=:userId];
        // 
        // String contactId=userDetails.ContactId;
        // 
        // Contact con=[select AccountId,Id from contact where id=:contactId];
        //
        // return con.AccountId;
		return '';
    }
}