//
//  TTMWebImageOpration.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 6/14/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//

#import "TTMWebImageOpration.h"

@implementation TTMWebImageOpration
+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_queue_t callerQueue = dispatch_get_current_queue();
    dispatch_queue_t downloadQueue = dispatch_queue_create("com.myapp.processsmagequeue", NULL);
    dispatch_async(downloadQueue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(callerQueue, ^{
            processImage(imageData);
        });
    });
    dispatch_release(downloadQueue);
}
@end
