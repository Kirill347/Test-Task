global with sharing class ItemsHttpCalloutMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"name":"Test Item 1","imageURL":"test Url","weight":5,"description":"Test Item 1 Description"},'+
        '{"name":"Test Item 2","imageURL":"test Url","weight":5,"description":"Test Item 2 Description"}]');
        response.setStatusCode(200);
        return response; 
    }
}
