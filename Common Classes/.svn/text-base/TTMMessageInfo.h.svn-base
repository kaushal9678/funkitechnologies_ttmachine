//
//  TTMMessageInfo.h
//  TextTimeMachine
//
//  Created by Komal Verma on 08/06/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPMessage.h"


@interface TTMMessageInfo : NSObject <NSCoding>{
    XMPPMessage *messageInfo;
}


@property (nonatomic, strong) XMPPMessage *messageInfo;
- (void)saveDataToDisk:(NSString *)fileName;

- (XMPPMessage *)loadDataFromDisk:(NSString *)fileName ;

+ (TTMMessageInfo *)initWithXMPPMessageInfo:(XMPPMessage *)messageInfo;

@end
