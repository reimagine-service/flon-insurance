/**
* @description       : An apex class that exposes the mock interface
* @author            : Accenture
* @group             : 
* @last modified on  : 03-09-2023
* @last modified by  : Accenture
**/
public class ObjectManager {
    static MockInterface mockInstance = new MockInterface();
/**
* @description 
* @author  Accenture| 03-09-2023 
* @param  records : list of sObject records
* @return  the mrecords from mock instance.
**/ 
    public static List<sObject> records(List<sObject> records){
        return mockInstance.passThrough(records);   
    }
    
    @TestVisible static void setMock(MockInterface mock){
        mockInstance = mock;
    }
}