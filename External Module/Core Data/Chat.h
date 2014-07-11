//
//  Chat.h
//  TextTimeMachine
//
//  Created by Komal Kumar on 13/06/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Chat : NSManagedObject

@property (nonatomic, retain) NSString * chatType;
@property (nonatomic, retain) NSString * direction;
@property (nonatomic, retain) NSString * filenameAsSent;
@property (nonatomic, retain) NSString * groupNumber;
@property (nonatomic, retain) NSNumber * hasMedia;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * isError;
@property (nonatomic, retain) NSNumber * isGroupMessage;
@property (nonatomic, retain) NSNumber * isNew;
@property (nonatomic, retain) NSString * jidString;
@property (nonatomic, retain) NSString * localfileName;
@property (nonatomic, retain) NSString * mediaType;
@property (nonatomic, retain) NSString * messageBody;
@property (nonatomic, retain) NSDate * messageDate;
@property (nonatomic, retain) NSString * messageStatus;
@property (nonatomic, retain) NSString * mimeType;
@property (nonatomic, retain) NSString * originalURL;
@property (nonatomic, retain) NSString * roomJID;
@property (nonatomic, retain) NSString * roomName;
@property (nonatomic, retain) NSString * thumbNail;
@property (nonatomic, retain) NSString * mediaFileName;

@end
