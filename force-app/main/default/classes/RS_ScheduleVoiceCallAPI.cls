/**
 * @description       : 
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@RestResource(urlMapping='/ScheduleVoiceCallAPI/*')
global with sharing class RS_ScheduleVoiceCallAPI {
    @HttpPost
    global static Boolean CreateVC(String AccId,String ClBckTime,String PhoneNumber,String ClBckDate,String QName,String QARN,String issuetype,String existingCaseNumber){
        try{
            RS_VoiceCall_OwnerId__mdt getOwnerDetails=[Select OwnerId__c from RS_VoiceCall_OwnerId__mdt WITH SECURITY_ENFORCED];
            VoiceCall vc = new VoiceCall();
            String callcenterID=[Select id from CallCenter where InternalName ='ACLightningAdapter']?.Id;
            Account getcustomerdetails=[Select AccountNumber,PersonBirthdate,Id from Account where Id=:AccId WITH SECURITY_ENFORCED];
            String replaceDateString=ClBckDate.replaceAll('/', '-');
            Date dateString=Date.valueOf(replaceDateString);
            //Date dateString=Date.valueOf(ClBckDate);
            vc.CallCenterId =callcenterID;
            vc.VendorType ='ContactCenter';
            vc.CallType='Inbound';
            vc.ToPhoneNumber =[SELECT MessagingPlatformKey from MessagingChannel where MessageType='Voice' and MasterLabel='Reimagine Service Phone support'].MessagingPlatformKey;
            vc.FromPhoneNumber= PhoneNumber;
            vc.CallStartDateTime = datetime.now();
            vc.CallEndDateTime = datetime.now();
            vc.Related_Account__c = AccId;
            vc.RS_Callback_Status__c='RequestedViaCaip';
            vc.RS_CustomerAccountNumber__c=getcustomerdetails.AccountNumber;
            vc.RS_DateOfBirth__c=getcustomerdetails.PersonBirthdate;
            vc.RS_Customer_Identified__c=true;
            vc.RS_CustomerVerified__c=true;
            vc.IVRIntent__c=issuetype;
            vc.OwnerId=getOwnerDetails.OwnerId__c;
            Time t;
            String regex = '(\\d{1,2}):(\\d{1,2}) ([PA]M)';
            Pattern p = Pattern.compile( regex );
            Matcher m = p.matcher(ClBckTime);
            if ( m.matches() ){
                Integer hours1 = Integer.valueOf( m.group(1) )
                    , minutes1 = Integer.valueOf( m.group(2) )
                    , pmShift = m.group(3) == 'PM' ? 12 : 0
                        ;
                t = Time.newInstance( hours1 + pmShift , minutes1 , 0 , 0 );
                
            }
            //Time startTime = Time.newInstance(hours, minutes, 0, 0);
            Decimal timeZone=[SELECT Time_Zone__c from RS_VoiceCall_OwnerId__mdt  where DeveloperName ='Integration_User']?.Time_Zone__c;
            Integer myintval = Integer.valueOf(timeZone);
            DateTime prefferedDateTime=DateTime.newInstance(dateString, t);
            
            vc.RS_Preferred_Callback_Time__c=prefferedDateTime;
             if(issuetype=='Others'){
                vc.IVRType__c='ExistingCase';
                
                vc.IVRInput__c=((existingCaseNumber=='')?'' :existingCaseNumber);
            }
            else{
                vc.IVRType__c='NewCase';
            }
            if(Schema.getGlobalDescribe().get('VoiceCall').getDescribe().isCreateable()){
            insert vc;
            }
            
            if(vc!=null && vc.id!=null){
                String voicecallId = vc.id;
                return createDynamoDB((voicecallId.substring(0,voicecallId.length()-3)),ClBckTime, PhoneNumber, ClBckDate, QName, QARN);
            }else{
                return false;
            }
        }catch(exception e)
        {
            system.debug('ERROR MESSAGE>>>>>' + e.getMessage());
            return false;
        }
    }
    /**
    * @description : Method to put item in dynamo DB
    * @author Accenture | 03-24-2023 
    * @param voiceCallId 
    * @param clBckTime 
    * @param phoneNumber 
    * @param clBckDate 
    * @param qName 
    * @param qARN 
    * @return boolean 
    **/
    public static boolean createDynamoDB(String voiceCallId, String clBckTime, String phoneNumber, String clBckDate, String qName, String qARN){
            RS_sf_aws_sync.schduleCallback(voiceCallId, clBckTime, phoneNumber, clBckDate, qName, qARN);
            return true;
        }
    }