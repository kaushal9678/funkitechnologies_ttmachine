//
//  TTMBaseParser_CodeVarification.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/9/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMBaseParser.h"

#ifndef VIEW_CONTROLLER_MAIN_BODY
@implementation TTMBaseParser
#endif
//ttmachine.no-ip.org/ttmac/validate?code=3wqh12b&emailId=arnav.agni@gmail.com
- (void)makeCodeVarificationServiceRequest:(NSString*)methodName code:(NSString *)varificationCode userId:(NSString *)userId delegate:(id)delegate{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@/%@?userId=%@&code=%@", [TTMCommon getServerAddress],methodName,userId ,varificationCode] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        NSLog(@"URL is %@", [[NSString stringWithFormat:@"%@/%@?userId=%@&code=%@", [TTMCommon getServerAddress],methodName,userId ,varificationCode] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        [request setHTTPMethod:@"Post"];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:delegate];
        assert(connection != nil);
    });
}
#ifndef VIEW_CONTROLLER_MAIN_BODY
@end
#endif
