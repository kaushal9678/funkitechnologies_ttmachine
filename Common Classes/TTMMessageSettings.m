//
//  TTMMessageSettings.m
//  TextTimeMachine
//
//  Created by Komal Kumar on 09/06/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//

#import "TTMMessageSettings.h"
#import "TTMSingleTon.h"

@implementation TTMMessageSettings
@synthesize delayInfo ;

+ (TTMMessageSettings *)initWithMessageSettingInfo:(TTMTimeDelayInfo *)messageInfo{
    TTMMessageSettings *message = [[TTMMessageSettings alloc] init];
    
    message.delayInfo = messageInfo;
    return message ;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self setDelayInfo:[aDecoder decodeObjectForKey:@"delayInfor"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    TTMTimeDelayInfo *temome = delayInfo;
    [aCoder encodeObject:temome forKey:@"delayInfor"];
}

- (void)saveDataToDisk:(NSString *)fileName {
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",@"~/Documents",fileName];
    path = [path stringByExpandingTildeInPath];
    
    NSMutableDictionary *rootObject;
    rootObject = [NSMutableDictionary dictionary];
    TTMTimeDelayInfo *temome = delayInfo;
    [rootObject setValue:temome forKey:@"delayInfor"];
    
    [NSKeyedArchiver archiveRootObject:rootObject toFile:path];
}

- (TTMTimeDelayInfo *)loadDataFromDisk:(NSString *)fileName {
    NSString *path = [NSString stringWithFormat:@"%@/%@",@"~/Documents",fileName];
    path = [path stringByExpandingTildeInPath];
    
    NSMutableDictionary *rootObject;
    rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    if ([rootObject valueForKey:@"delayInfor"]) {
        self.delayInfo = [rootObject valueForKey:@"delayInfor"];
    }
    return self.delayInfo;
}

@end
