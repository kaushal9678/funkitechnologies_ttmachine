//
//  TTMWebImageOpration.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 6/14/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMWebImageOpration : NSObject
+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage;

@end
