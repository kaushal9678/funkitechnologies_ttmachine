//
//  TTMDataBaseManager.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 05/06/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//
#import "MessageSetting.h"
#import "TTMDataBaseManager.h"

@implementation TTMDataBaseManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static TTMDataBaseManager* _sharedMySingleton = nil;

/**
 *  Singleton object for this class
 *
 *  @return shared object
 */
+(TTMDataBaseManager*)sharedMySingleton
{
    @synchronized([TTMDataBaseManager class])
    {
        if (!_sharedMySingleton) {
            _sharedMySingleton = [[self alloc] init];
        }
        return _sharedMySingleton;
    }
    return nil;
}
/**
 *  Initialize core data with model class
 */

-(void)initializeTheCoreDataModelClasses {
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context) {
        // Handle the error.
    }
}
//1
- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}
/**
 *  <#Description#>
 *
 *  @param  <# description#>
 *
 *  @return <#return value description#>
 */
//2
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

/**
 *  <#Description#>
 *
 *  @param  <# description#>
 *
 *  @return <#return value description#>
 */
//3
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"SettingDataBase.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    return _persistentStoreCoordinator;
}
/**
 *  Docment directory path
 *
 *  @return Docment directory path
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 *  Fetch data for particuller object in Location table
 *
 *  @param latitute will take the NSString type parameter
 *
 *  @return NSMutable array with bunch of results
 */
-(NSMutableArray *)fetchDataFromCoreDataOnParticularObjectForContactInfo:(id)contactName {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"SettingDataBase" inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"contactName" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"contactName = %@",contactName];
    [request setPredicate:predicate1];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *temp = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
	// Set self's events array to the mutable array, then clean up.
	return temp;
}
/**
 *  Add contact information in database
 *
 *  @param contactInfo contactInfo object for information
 *
 *  @return BOOL value for status
 */

-(BOOL)addContactInformation:(TTMContactInformation *)contactInfo {
    ContactInfo * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"ContactInfo"
                                                        inManagedObjectContext:self.managedObjectContext];
    //  2
    newEntry.contactEmail = [NSString stringWithFormat:@"%@", contactInfo.contactEmail];
    newEntry.contactImage = contactInfo.contactImage;
    newEntry.contactName = [NSString stringWithFormat:@"%@", contactInfo.contactName];
    newEntry.contactNumber = [NSString stringWithFormat:@"%@", contactInfo.contactNumber];
    newEntry.contactStatus = [NSString stringWithFormat:@"%@", contactInfo.contactStatus];
    newEntry.contactTimeZone = [NSString stringWithFormat:@"%@", contactInfo.contactTimeZone];
    newEntry.contactType = [NSString stringWithFormat:@"%@", contactInfo.contactType];
    newEntry.settingType = [NSString stringWithFormat:@"%@", contactInfo.settingType];
    newEntry.time = [NSString stringWithFormat:@"%@", contactInfo.time];
    
    //  3
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return NO;
    }
    return YES;
}

-(BOOL)addMessageSettingInformation:(TTMTimeDelayInfo *)contactInfo {
    
    [self deleteAllRows];
    MessageSetting * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"MessageSetting"
                                                           inManagedObjectContext:self.managedObjectContext];
    //  2
    newEntry.isDuration = [NSNumber numberWithBool:contactInfo.isdurationEnabled];
    newEntry.isSpecific = [NSNumber numberWithBool:contactInfo.isSpecificTimeEnabled];
    newEntry.hours = [NSString stringWithFormat:@"%@", contactInfo.hours];
    newEntry.minutes = [NSString stringWithFormat:@"%@", contactInfo.minutes];
    //  3
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return NO;
    }
    return YES;
}
-(NSMutableArray *)fetchContactInfo {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"ContactInfo" inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"contactName" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *temp = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
	// Set self's events array to the mutable array, then clean up.
	return temp;
}


-(NSMutableArray *)fetchDataFromCoreDataOnMessageSettingInfo {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MessageSetting" inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"hours" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *temp = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
	// Set self's events array to the mutable array, then clean up.
	return temp;
}

-(void)deleteAllRows {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MessageSetting" inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];    NSError *error;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (objects == nil) {
        // handle error
    } else {
        for (NSManagedObject *object in objects) {
            [self.managedObjectContext deleteObject:object];
        }
        [self.managedObjectContext save:&error];
    }
}

@end
