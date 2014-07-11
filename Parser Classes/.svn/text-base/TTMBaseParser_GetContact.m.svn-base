//
//  TTMBaseParser_GetContact.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 13/03/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMBaseParser.h"

#ifndef VIEW_CONTROLLER_MAIN_BODY
@implementation TTMBaseParser
#endif
//ttmachine.no-ip.org/ttmac/validate?code=3wqh12b&emailId=arnav.agni@gmail.com
- (void)makeGetContactServiceRequest:(NSString*)methodName contactDict:(NSMutableDictionary *)contactDict delegate:(id)delegate{
    
        NSError *writeError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contactDict options:NSJSONWritingPrettyPrinted error:&writeError];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON Output: %@", jsonString);
        NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@/%@", [TTMCommon getServerAddress], methodName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        
        NSData *requestData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:delegate];
        assert(connection != nil);
}
#ifndef VIEW_CONTROLLER_MAIN_BODY
@end
#endif
