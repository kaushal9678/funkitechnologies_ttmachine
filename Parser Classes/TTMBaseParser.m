//
//  TTMBaseParser.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/6/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//
#define VIEW_CONTROLLER_MAIN_BODY   1

#import "SBJsonParser.h"
#import "TTMBaseParser.h"

@implementation TTMBaseParser
@synthesize response_Data;

#include "TTMBaseParser_EmailSend.m"
#include "TTMBaseParser_GetContact.m"
#include "TTMBaseParser_ContactSync.m"
#include "TTMBaseParser_CodeVarification.m"

-(void)serviceWithArgument:(NSMutableDictionary *)argument serviceType:(TTMServiceType)serviceType callBackResponse:(ServerResponse)callBack {
    
    self.callBackResponse = callBack;
    switch (serviceType) {
        case TTMEmailSendService:
            [self makeEmailSendServiceRequest:[TTMCommon getServiceName:TTMEmailSend] userName:[argument valueForKey:@"email"] phoneNumber:[argument valueForKey:@"Phone"] timeZone:[argument valueForKey:@"timeZone"] delegate:self];
            break;
        case TTMCodeVarificationService:
            [self makeCodeVarificationServiceRequest:[TTMCommon getServiceName:TTMCodeVarification] code:[argument objectForKey:@"code"] userId:[[TTMSingleTon sharedMySingleton] user_id] delegate:self];
            break;
        case TTMGetContactService: {
            dispatch_async(dispatch_get_main_queue()
                           , ^{
                               [self makeGetContactServiceRequest:[TTMCommon getServiceName:TTMGetContact] contactDict:argument delegate:self];

                           });
        }
            break;
        case TTMGetContactSyncService: {
            dispatch_async(dispatch_get_main_queue()
                           , ^{
                [self makeContactSyncServiceRequest:[TTMCommon getServiceName:TTMGetContactSync] userId:[argument valueForKey:@"userId"] delegate:self];
                           });
        }
            break;
        default:
            break;
    }
}

#pragma mark --
#pragma mark NSURLConnection delegate Methods
- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response {
#pragma unused(theConnection)
	NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int responseStatusCode = (int)[httpResponse statusCode] ;
    NSLog(@"responseStatusCode is %d",responseStatusCode);
	self.response_Data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data {
#pragma unused(theConnection)
	//NSLog(@"didReceiveData is calling");
	[self.response_Data appendData:data];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error {
#pragma unused(theConnection)
#pragma unused(error)
    //assert(theConnection == self.connection);
	NSString *message = [NSString stringWithFormat:@"error %@",[error localizedDescription]];
    NSLog(@"Error is %@", message);
    self.callBackResponse(nil, error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection {
#pragma unused(theConnection)
    dispatch_queue_t myQueue = dispatch_queue_create("MyQueuemainresponse", nil);
    dispatch_async(myQueue, ^{
        [self handleMainResponse:self.response_Data];
    });
}

- (void)handleMainResponse : (NSMutableData *)responseParameter {
    NSString *responseString = [[NSString alloc] initWithData:responseParameter encoding:NSUTF8StringEncoding];
    dispatch_queue_t myQueue = dispatch_queue_create("MyQueueResponse", nil);
    dispatch_async(myQueue, ^{
        NSLog(@"responseStringresponseString %@", responseString);
        id response = [self JSONValue:responseString];
        NSLog(@"response is:  %@",response);
         self.callBackResponse(response, nil);
    });
}

#pragma mark json value from string
- (id) JSONValue:(NSString *)parameter {
	SBJsonParser *jparser = [[SBJsonParser alloc] init];
	id response = [jparser objectWithString:parameter];
	return response;
}

@end
