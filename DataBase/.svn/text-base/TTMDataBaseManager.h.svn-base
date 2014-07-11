//
//  TTMDataBaseManager.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 05/06/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ContactInfo.h"
#import "MessageSetting.h"
#import "TTMTimeDelayInfo.h"
#import "TTMContactInformation.h"

@interface TTMDataBaseManager : NSObject

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator ;

-(void)deleteAllRows;
+(TTMDataBaseManager*)sharedMySingleton;
-(NSMutableArray *)fetchContactInfo;
-(void)initializeTheCoreDataModelClasses;
-(NSMutableArray *)fetchDataFromCoreDataOnMessageSettingInfo ;
-(BOOL)addContactInformation:(TTMContactInformation *)contactInfo;
-(BOOL)addMessageSettingInformation:(TTMTimeDelayInfo *)contactInfo;

@end
