@isTest
global class qsuiteUtilities_Mock implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if(req.getEndpoint().contains('authenticate.json?')){
        res.setBody(AuthResponse);
         }
        else if(req.getEndpoint().contains('login.json?')){
         res.setBody(LoginResponse);   
        }
        else if(req.getEndpoint().contains('getNailupTargets.json?')){
         res.setBody(getNailUpTarget);   
        }
        else if(req.getEndpoint().contains('naildown.json?')){
         res.setBody(Naidown);   
        }
        else if(req.getEndpoint().contains('createLead.json?')){
         res.setBody(createLead);   
        }
        else if(req.getEndpoint().contains('loadCall.json?')){
         res.setBody(loadCall);   
        }
         else if(req.getEndpoint().contains('redialLead.json?')){
         res.setBody(redialLead);   
        }
        else if(req.getEndpoint().contains('terminateCall.json?')){
         res.setBody(terminateCall);   
        }
        else if(req.getEndpoint().contains('logout.json?')){
         res.setBody(logOutCall);   
        }
        else if(req.getEndpoint().contains('destroy')){
         res.setBody(destroyCall);   
        }
        else if(req.getEndpoint().contains('nextCall.json?'))
        {
            res.setBody(nextCall);
        }
        else if(req.getEndpoint().contains('holdCall.json?'))
        {
            res.setBody(holdCallResponse);
        }
        else if(req.getEndpoint().contains('transferCall.json?'))
        {
            res.setBody(transferCallAPI);
        }
        else if(req.getEndpoint().contains('transferFlip.json?'))
        {
            res.setBody(transferFlip);
        }
        else if(req.getEndpoint().contains('cancelTransfer.json?'))
        {
            res.setBody(transferCancel);
        }
        else if(req.getEndpoint().contains('cancelGNN.json?'))
        {
            res.setBody(cancelGNN);
        }
        else if(req.getEndpoint().contains('cancelGNN.json?'))
        {
            res.setBody(cancelGNN);
        }
        else if(req.getEndpoint().contains('getQueuedCalls.json?'))
        {
            res.setBody(getQueuedCalls);
        }
        res.setStatusCode(200);
        return res;
    }
    
    private string AuthResponse='{"user_specified_login" : ["1"],"session" : ["24614"],"employee" : ["448"],"error" : [{}],"server" : ["4"],"tenant" : ["1"],"success" : ["1"],"auth_key" : ["487a1f23-d36b-11e9-abcc-0a52c0223f8c"]}';
    private string LoginResponse='{"success" : ["1"],"error" : [{}]}';
    private string getNailUpTarget='{ "success" : [ "1" ], "error" : [ {} ], "agent_specified_extension" : [ "0" ], "devices" : [ { "device" : [ { "name" : [ "Extension: 1002001 (1002001_1)" ], "id" : [ "extension_8212" ] } ] } ] }';
    private string Naidown='{ "success" : [ "1" ], "error" : [ {} ], "agent_specified_extension" : [ "0" ], "devices" : [ { "device" : [ { "name" : [ "Extension: 1002001 (1002001_1)" ], "id" : [ "extension_8212" ] } ] } ] }';
    private string createLead='{ "call_list_id" : [ "347030" ], "success" : [ "1" ], "campaign" : [ "258" ], "error" : [ {} ] }';
    private string loadCall = '{ "call_history_id" : [ "1354193" ], "manual_call" : [ {} ], "error" : [ {} ], "success" : [ "1" ], "call_type_text" : [ "Unknown" ], "call_list_id" : [ "347030" ] }';
    private string redialLead='{"success" : ["1"],"error" : [{}]}';
    private string terminateCall='{"error" : [{}],"logout" : ["0"],"denail" : ["0"],"success" : ["1"],"next_call_lead_id" : [{}]}';
    private string logOutCall='{ "success" : [ "1" ], "message" : [ "End of shift" ], "error" : [ {} ] }';
    private string destroyCall='{ "success" : [ "1" ], "error" : [ {} ] }';
    private String holdCallResponse = '{"success":["1"],"error":[{}],"onHold":["0"] }';
    private String nextCall = '{"error" : [       {}    ],    "error_code" : [       {}    ],    "transfer_type" : [       "0"    ],    "uuid" : [       "d5f71956-03dc-4b70-bee8-a2947cd73c9b"    ],    "type" : [       "0"    ],    "inwaiting_audio" : [       {}    ],    "call_type_text" : [       "Inbound"    ],    "action" : [       "INCONNECT"    ],    "callback_alert" : [       "0"    ],    "call_list_id" : [       "387438"    ],    "transfer_conference" : [       "0"    ],    "on_hook" : [       "0"    ],    "success" : [       "1"    ],    "abandoned" : [       "0"    ],    "campaign" : [       "255"    ],    "non_media_event" : [       "0"    ],    "inbound" : [       {          "wait_time" : [             "34"          ],          "queue" : [             "455"          ],          "did" : [             "8445073559"          ],          "callerid" : [             " <5519990593>"          ]       }    ],    "transfer_starter" : [       "0"    ]}';
    private String transferCallAPI = '{    "timers" : [       {}    ],    "type" : [       "3"    ],    "success" : [       "1"    ],    "error" : [       {}    ] }';
    private String transferFlip = '{    "error" : [       {}    ],    "success" : [       "1"    ] }';
    private string cancelGNN = '{    "error" : [       {}    ],    "success" : [       "1"    ] }';
    private string transferCancel = '{    "error" : [       {}    ],    "success" : [       "1"    ] }';
    private string getCallDataResp = 'Test Resp for getData';
    private string getQueuedCalls = '{ "success" : [ "1" ], "error" : [{}], "calls" : [{ "call" : [{ "uuid" : [ "a7915c25-48f1-4241-8af2-cf54295a4023" ], "did" : [ "8445073559" ], "caller_id" : [ " <5519990593>" ], "wait_time" : [ "3" ] } ] } ]}';
}