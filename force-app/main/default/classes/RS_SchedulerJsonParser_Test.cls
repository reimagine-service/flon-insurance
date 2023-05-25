@IsTest
public class RS_SchedulerJsonParser_Test {
static testMethod void testParse() {
    Test.startTest();
    String json ='{"candidates": [{"endTime": "2023-02-20T10:00:00.000+0000","resources": ["0Hn3C00000029MJSAY"],"startTime": "2023-02-20T09:00:00.000+0000","territoryId": "0Hh3C0000002EGjSAM"},{"endTime": "2023-02-20T11:00:00.000+0000","resources": ["0Hn3C00000029MJSAY"],"startTime": "2023-02-20T10:00:00.000+0000","territoryId": "0Hh3C0000002EGjSAM"},{"endTime": "2023-02-20T12:00:00.000+0000","resources": ["0Hn3C00000029MJSAY"],"startTime": "2023-02-20T11:00:00.000+0000","territoryId": "0Hh3C0000002EGjSAM"},{"endTime": "2023-02-20T13:00:00.000+0000","resources": ["0Hn3C00000029MJSAY"],"startTime": "2023-02-20T12:00:00.000+0000","territoryId": "0Hh3C0000002EGjSAM"}]}';
    RS_SchedulerJsonParser obj1 = RS_SchedulerJsonParser.parse(json);
	System.assert(obj1 != null);
    Test.stopTest();
}
}