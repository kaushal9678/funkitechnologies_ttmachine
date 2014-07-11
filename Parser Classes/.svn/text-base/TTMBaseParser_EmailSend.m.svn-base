//
//  TTMBaseParser_EmailSend.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/9/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMBaseParser.h"

#ifndef VIEW_CONTROLLER_MAIN_BODY
@implementation TTMBaseParser
#endif
//ttmachine.no-ip.org/ttmac/sendvalidationcode?emailId=arnav.agni@gmail.com
- (void)makeEmailSendServiceRequest:(NSString*)methodName userName:(NSString *)user_name phoneNumber:(NSString *)number timeZone:(NSString *)timeZone delegate:(id)delegate{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@/%@?emailId=%@&phone=%@&timeZone=%@", [TTMCommon getServerAddress],methodName, user_name, number, timeZone] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        NSLog(@"server with ip is %@", [[NSString stringWithFormat:@"%@/%@?emailId=%@&phone=%@&timeZone=%@", [TTMCommon getServerAddress],methodName, user_name, number, timeZone] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        [request setHTTPMethod:@"Post"];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:delegate];
        assert(connection != nil);
    });
}
#ifndef VIEW_CONTROLLER_MAIN_BODY
@end
#endif
