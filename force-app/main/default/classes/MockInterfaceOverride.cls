/**
 * @description       : Apec Class for Mock Interface Override.
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-10-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class MockInterfaceOverride extends MockInterface{
    final List<SObject> objectList;  
/**
* @description 
* @author  Accenture| 03-10-2023
* @param mockRecords : list of sobject records
**/
    public MockInterfaceOverride(List<SObject> mockRecords){
        this.objectList = mockRecords;
    }
    
/**
* @description 
* @author  Accenture| 03-10-2023
* @param records : list of sobject records
* @return  objectList : list of sobject records
**/
    public override List<SObject> passThrough(List<SObject> records){
        return objectList;
    }
}