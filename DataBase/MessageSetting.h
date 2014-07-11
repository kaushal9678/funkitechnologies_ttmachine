//
//  MessageSetting.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 6/14/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MessageSetting : NSManagedObject

@property (nonatomic, retain) NSString * hours;
@property (nonatomic, retain) NSNumber * isDuration;
@property (nonatomic, retain) NSNumber * isSpecific;
@property (nonatomic, retain) NSString * minutes;
@property (nonatomic, retain) NSString * specificDateTimeInterval;
@property (nonatomic, retain) NSString * timeInterval;

@end
