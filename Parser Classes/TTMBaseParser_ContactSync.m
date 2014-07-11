//
//  TTMBaseParser_ContactSync.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 6/7/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//

#import "TTMBaseParser.h"

#ifndef VIEW_CONTROLLER_MAIN_BODY
@implementation TTMBaseParser
#endif
//ttmachine.no-ip.org/ttmac/sendvalidationcode?emailId=arnav.agni@gmail.com
- (void)makeContactSyncServiceRequest:(NSString*)methodName userId:(NSString *)userId  delegate:(id)delegate{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@/%@?userId=%@", [TTMCommon getServerAddress],methodName, userId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        NSLog(@"server with ip issync service %@", [[NSString stringWithFormat:@"%@/%@?userId=%@", [TTMCommon getServerAddress],methodName, userId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        [request setHTTPMethod:@"Post"];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:delegate];
        assert(connection != nil);
    });
}
#ifndef VIEW_CONTROLLER_MAIN_BODY
@end
#endif
