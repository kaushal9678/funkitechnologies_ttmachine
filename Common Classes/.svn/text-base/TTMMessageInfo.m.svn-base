//
//  TTMMessageInfo.m
//  TextTimeMachine
//
//  Created by Komal Verma on 08/06/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//

#import "TTMMessageInfo.h"

@implementation TTMMessageInfo
@synthesize messageInfo ;


+ (TTMMessageInfo *)initWithXMPPMessageInfo:(XMPPMessage *)messageInfo{
    TTMMessageInfo *message = [[TTMMessageInfo alloc] init];
    
    message.messageInfo = messageInfo;
    
    return message ;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self setMessageInfo:[aDecoder decodeObjectForKey:@"messageInfo"]];
    }
    return self;
}
                            
- (void)encodeWithCoder:(NSCoder *)aCoder {
    XMPPMessage *temome = messageInfo;

    [aCoder encodeObject:temome forKey:@"messageInfo"];
}

- (void)saveDataToDisk:(NSString *)fileName {
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",@"~/Documents",fileName];
    path = [path stringByExpandingTildeInPath];
    
    NSMutableDictionary *rootObject;
    rootObject = [NSMutableDictionary dictionary];
    XMPPMessage *temome = messageInfo;
    [rootObject setValue:temome forKey:@"messageInfo"];
    
    [NSKeyedArchiver archiveRootObject:rootObject toFile:path];
}

- (XMPPMessage *)loadDataFromDisk:(NSString *)fileName {
    NSString *path = [NSString stringWithFormat:@"%@/%@",@"~/Documents",fileName];
    path = [path stringByExpandingTildeInPath];
    
    NSMutableDictionary *rootObject;
    rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    if ([rootObject valueForKey:@"messageInfo"]) {
        self.messageInfo = [rootObject valueForKey:@"messageInfo"];
    }
    return self.messageInfo;
}
@end
