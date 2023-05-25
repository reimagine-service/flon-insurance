/**
 * @description       : 
 * @author            : Accenture
 * @group             : 
 * @last modified on  : 03-24-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class RS_ScheduleCallbackMock implements httpcalloutmock {
 /**
 * @description 
 * @author Accenture | 03-24-2023 
 * @param req 
 * @return httpresponse 
 **/
 global httpresponse respond(httprequest req) 
   {
       httpresponse res = new httpresponse();
       res.setStatus('success');
       res.setHeader('Content-Type', 'application/json');
       res.setStatusCode(200);
       string json='{}';
		  res.setbody(json);
       return res;
   }
}