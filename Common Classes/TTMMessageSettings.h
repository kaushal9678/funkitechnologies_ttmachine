//
//  TTMMessageSettings.h
//  TextTimeMachine
//
//  Created by Komal Kumar on 09/06/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTMTimeDelayInfo.h"


@interface TTMMessageSettings : NSObject <NSCoding>{
    TTMTimeDelayInfo *delayInfo;
}


@property (nonatomic, strong) TTMTimeDelayInfo *delayInfo;

- (void)saveDataToDisk:(NSString *)fileName;

- (TTMTimeDelayInfo *)loadDataFromDisk:(NSString *)fileName ;

+ (TTMMessageSettings *)initWithMessageSettingInfo:(TTMTimeDelayInfo *)messageInfo;

@end