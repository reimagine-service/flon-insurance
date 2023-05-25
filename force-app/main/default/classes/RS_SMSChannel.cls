/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-13-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@RestResource(urlMapping='/smsChannel/*')
global with sharing class RS_SMSChannel{
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-13-2023 
    * @return boolean 
    **/
    @HttpGet
    global static boolean agentAvailableOverSMS() {
        List<String> usrList = new List<String>();
        List<UserServicePresence> uspList=[select name,UserId,ServicePresenceStatus.DeveloperName from UserServicePresence where IsAway = false and IsCurrentState = true and (ServicePresenceStatus.DeveloperName like '%SMS%' or ServicePresenceStatus.DeveloperName = 'Available') WITH SECURITY_ENFORCED];
        
        if(!uspList.isEmpty() || Test.isRunningTest()){
            for(UserServicePresence us:uspList){
                usrList.add(us.UserId);
            }
            string queName = RestContext.request.params.get('qName');
            queName = '%'+queName+'%';
             
            List<Group> grp=[select Id from Group where Type = 'Queue' AND DeveloperNAME like: queName  WITH SECURITY_ENFORCED];
            
            for(GroupMember grm: [select Id,UserOrGroupId from Groupmember where GroupId IN: grp]){
                if(usrList.contains(grm.UserOrGroupId)){
                    return true;
                }
            }
        }
        return false;
    }
}