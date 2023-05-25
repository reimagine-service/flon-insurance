/**
* @description       : A method that is overriden in the test class. When used outside of a test,
                        returns the records. When used in a test class, will return the overriden
                        method in the class that is defined in the test class, this overidden method
                        returns a list of the external object (BestTimeToCall__x)
* @author            : Accenture
* @group             : 
* @last modified on  : 03-09-2023
* @last modified by  : Accenture
**/
public virtual inherited sharing class MockInterface{
/**
* @description 
* @author  Accenture| 03-09-2023 
* @param records list of sobject records
* @return  list of records
**/ 
    public virtual List<SObject> passThrough(List<SObject> records){
        return records;
    } 
}