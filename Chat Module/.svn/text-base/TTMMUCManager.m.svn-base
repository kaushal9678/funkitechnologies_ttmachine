//
//  TTMMUCManager.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 23/04/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMMUCManager.h"
#import "XMPPRoomHybridStorage.h"
#import "XMPPRoomMemoryStorage.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "TTMAppDelegate.h"
#import "Room.h"

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif


@interface TTMMUCManager ()<UIAlertViewDelegate>
{
    __strong id <XMPPRoomStorage> xmppRoomStorage;
    XMPPUserCoreDataStorageObject *user;
}
@property (nonatomic,strong) NSString *currentRoomString;
@property (nonatomic,strong) XMPPRoom* currentRoom;
@property (nonatomic,strong) NSMutableArray *rooms;
@end


@implementation TTMMUCManager

static TTMMUCManager *sInstance = NULL;

+(TTMMUCManager *)sharedInstance{
    
    @synchronized(self)
	{
		if (sInstance == NULL)
			sInstance = [[self alloc] init];
	}
	return sInstance;
}

- (TTMAppDelegate *)appDelegate
{
	return (TTMAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (XMPPStream *)xmppStream {
	return [[self appDelegate] xmppStream];
}
/*
- (XMPPRoom *)currentRoom {
	return self.currentRoom;
}
 */

-(void)loadData
{
    if (self.rooms)
        self.rooms =nil;
    self.rooms = [[NSMutableArray alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Room"
                                              inManagedObjectContext:[self appDelegate].managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSError *error=nil;
    NSArray *fetchedObjects = [[self appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *obj in fetchedObjects)
    {
        Room *currentRoom = (Room *)obj;
        [self.rooms addObject:currentRoom];
    }
    //reload the table view
    self.groupCreated(self.rooms);
}

-(void)askForCreatedGroup:(MUCGroup)groups {
    self.groupCreated = groups;
    [self loadData];
}
-(void)createGroups:(MUCGroup )groups {
    self.groupCreated = groups;
    [self askForRoomName:nil];
}
-(NSString *)myCleanJID
{
    NSString *myJid = [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
    myJid = [myJid stringByReplacingOccurrencesOfString:kXMPPServer withString:@""];
    myJid = [myJid stringByReplacingOccurrencesOfString:@"@" withString:@""];
    NSLog(@"myCleanJID : %@",myJid);
    return myJid;
}

#pragma mark actions
-(IBAction)askForRoomName:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Create ROOM" message:@"Enter Room Name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", @"Cancel",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput ;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput)
    {
        UITextField* roomName = [alertView textFieldAtIndex:0];
        if ([roomName.text length]> 0)
        {
            self.currentRoomString = roomName.text;
            NSLog(@"currentRoomString %@",self.currentRoomString);
            [self createRoom] ;
        }
        
    }
    
}
-(void)createRoom
{
  /*  XMPPUserCoreDataStorageObject *user = [[self  appDelegate].xmppRosterStorage myUserForXMPPStream:[[self appDelegate] xmppStream]
                                                    managedObjectContext:[[self  appDelegate] managedObjectContext_roster]];*/
    
    Room  *newRoom =[NSEntityDescription
                     insertNewObjectForEntityForName:@"Room"
                     inManagedObjectContext:[self  appDelegate].managedObjectContext];
    newRoom.name = self.currentRoomString;
    newRoom.roomJID = [NSString stringWithFormat:@"%@_%@%@",[self myCleanJID],self.currentRoomString,kxmppConferenceServer];
    NSError *error = nil;
    if (![[self  appDelegate].managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
    else
    {
        //Create the room
        //Create a unique name
        NSString *roomJIDString = [NSString stringWithFormat:@"%@_%@%@",[self myCleanJID],self.currentRoomString,kxmppConferenceServer];
        XMPPJID *roomJID = [XMPPJID jidWithString:roomJIDString];
#if USE_MEMORY_STORAGE
        xmppRoomStorage = [[XMPPRoomMemoryStorage alloc] init];
#elif USE_HYBRID_STORAGE
        xmppRoomStorage = [XMPPRoomHybridStorage sharedInstance];
#endif
        //Clean first
        if (self.currentRoom)
        {
            [self.currentRoom removeDelegate:self delegateQueue:dispatch_get_main_queue()];
            [self.currentRoom deactivate];
            self.currentRoom=nil;
            
        }
        
        self.currentRoom = [[XMPPRoom alloc] initWithRoomStorage:xmppRoomStorage jid:roomJID];
        [self.currentRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [self.currentRoom activate:[self xmppStream]];
        
        //joining will create the room
        //We now use a hardcoded nickname of course this should be configurable in some kind of settings option
        [self.currentRoom joinRoomUsingNickname:@"9818677706" history:nil];
        
    }
}
#pragma mark delegate methods
-(void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    DDLogInfo(@"joined room");
}
- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    //now we can configure the room
    [self configureThisRoom:sender];
}
-(void)configureThisRoom:(XMPPRoom *)sender
{
    //configure the room
  //  NSXMLElement *query= [NSXMLElement elementWithName:@"query" xmlns:XMPPMUCOwnerNamespace];
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    [x addAttributeWithName:@"type" stringValue:@"submit"];
    
    
    NSXMLElement *root =[NSXMLElement elementWithName:@"field"];
    [root addAttributeWithName:@"type" stringValue:@"hidden"];
    [root addAttributeWithName:@"var"  stringValue:@"FORM_TYPE"];
    NSXMLElement *valField1 = [NSXMLElement elementWithName:@"value" stringValue:@"http://jabber.org/protocol/muc#roomconfig"];
    [root addChild:valField1];
    //[x addChild:field1];
    
    NSXMLElement *loggingfield = [NSXMLElement elementWithName:@"field"];
    [loggingfield addAttributeWithName:@"type" stringValue:@"boolean"];
    [loggingfield addAttributeWithName:@"var" stringValue:@"muc#roomconfig_enable_logging"];
    [loggingfield addAttributeWithName:@"value" stringValue:@"1"];
    //
    NSXMLElement *namefield = [NSXMLElement elementWithName:@"field"];
    [namefield addAttributeWithName:@"type" stringValue:@"text-single"];
    [namefield addAttributeWithName:@"var" stringValue:@"muc#roomconfig_roomname"];
    [namefield addAttributeWithName:@"value" stringValue:self.currentRoomString];
    
    //
    NSXMLElement *subjectField = [NSXMLElement elementWithName:@"field"];
    [subjectField addAttributeWithName:@"type" stringValue:@"boolean"];
    [subjectField addAttributeWithName:@"var" stringValue:@"muc#roomconfig_changesubject"];
    [subjectField addAttributeWithName:@"value" stringValue:@"1"];
    //
    NSXMLElement *membersonlyField = [NSXMLElement elementWithName:@"field"];
    [membersonlyField addAttributeWithName:@"type" stringValue:@"boolean"];
    [membersonlyField addAttributeWithName:@"var" stringValue:@"muc#roomconfig_membersonly"];
    [membersonlyField addAttributeWithName:@"value" stringValue:@"1"];
    //
    NSXMLElement *moderatedfield = [NSXMLElement elementWithName:@"field"];
    [moderatedfield addAttributeWithName:@"type" stringValue:@"boolean"];
    [moderatedfield addAttributeWithName:@"var" stringValue:@"muc#roomconfig_moderatedroom"];
    [moderatedfield addAttributeWithName:@"value" stringValue:@"0"];
    //
    NSXMLElement *persistentroomfield = [NSXMLElement elementWithName:@"field"];
    [persistentroomfield addAttributeWithName:@"type" stringValue:@"boolean"];
    [persistentroomfield addAttributeWithName:@"var" stringValue:@"muc#roomconfig_persistentroom"];
    [persistentroomfield addAttributeWithName:@"value" stringValue:@"0"];
    //
    NSXMLElement *publicroomfield = [NSXMLElement elementWithName:@"field"];
    [publicroomfield addAttributeWithName:@"type" stringValue:@"boolean"];
    [publicroomfield addAttributeWithName:@"var" stringValue:@"muc#roomconfig_publicroom"];
    [publicroomfield addAttributeWithName:@"value" stringValue:@"0"];
    //
    NSXMLElement *maxusersField = [NSXMLElement elementWithName:@"field"];
    [maxusersField addAttributeWithName:@"type" stringValue:@"text-single"];
    [maxusersField addAttributeWithName:@"var" stringValue:@"muc#roomconfig_maxusers"];
    [maxusersField addAttributeWithName:@"value" stringValue:@"10"];
    
    NSXMLElement *ownerField = [NSXMLElement elementWithName:@"field"];
    [ownerField addAttributeWithName:@"type" stringValue:@"jid-multi"];
    [ownerField addAttributeWithName:@"var" stringValue:@"muc#roomconfig_roomowners"];
    [ownerField addAttributeWithName:@"value" stringValue: [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID]];
    
    
    [root addChild:loggingfield];
    [root addChild:namefield];
    [root addChild:membersonlyField];
    [root addChild:moderatedfield];
    [root addChild:persistentroomfield];
    [root addChild:publicroomfield];
    [root addChild:maxusersField];
    [root addChild:ownerField];
    [root addChild:subjectField];
    [x addChild:root];
    
    [sender configureRoomUsingOptions:x];
}


-(void)xmppRoom:(XMPPRoom *)sender didConfigure:(XMPPIQ *)iqResult
{
    //update data
    [self loadData];
}

- (void)invitSelectedUserIntoGroup : (NSString *)phNumber{
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@",phNumber,ChatServerAddress];
    NSLog(@"%@",jidStr);
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
                                              inManagedObjectContext:[self appDelegate].managedObjectContext_roster];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSError *error=nil;
    NSArray *fetchedObjects = [[self appDelegate].managedObjectContext_roster executeFetchRequest:fetchRequest error:&error];
    NSLog(@"fetchedObjects : %@",fetchedObjects);
    for (NSManagedObject *obj in fetchedObjects)
    {
        XMPPUserCoreDataStorageObject *userL = (XMPPUserCoreDataStorageObject *)obj;
        NSLog(@"Nick Name : %@",userL.nickname);
        NSLog(@"Status : %@",userL.jidStr);
        if ([userL.jidStr isEqualToString:jidStr])
            [self.currentRoom inviteUser:userL.jid withMessage:@"Join this room"];
    }
    
}

@end
