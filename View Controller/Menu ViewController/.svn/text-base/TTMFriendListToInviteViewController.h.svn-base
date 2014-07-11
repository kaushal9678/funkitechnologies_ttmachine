//
//  TTMFriendListToInviteViewController.h
//  TextTimeMachine
//
//  Created by essadmin on 5/23/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMCommonViewController.h"
#import "TTMCustomNavigation.h"
#import "TTMContactListView.h"
#import "TTMContactCustomCell.h"
#import "TTMMatchedContact.h"
#import "TTMOnlineBuddy.h"
#import "TTMContactsFetch.h"
#import "TTMMUCManager.h"
#import "Room.h"
#import "TTMAppDelegate.h"

@interface TTMFriendListToInviteViewController : TTMCommonViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) TTMCustomNavigation *navigation;
@property (nonatomic, assign) TTMArrowType arrowType;
@property (nonatomic, strong) TTMContactListView *contactList;
@property (nonatomic, strong) Room *currentRoom;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) NSString *conversationJidString;
@property (nonatomic,strong) NSString *cleanName;
@property (nonatomic,strong)NSMutableArray *originalContactList;
@property (nonatomic,strong)NSMutableArray *onlineFriends;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *onlineFriendsGroup;
@property (nonatomic,strong)NSMutableArray *selectedFriend;
//@property (nonatomic,strong)TTMMUCManager *mucManager;
-(void)showConversationForJIDString:(NSString *)jidString;
@end
