//
//  TTMMenuViewController.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 08/03/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "TTMChatView.h"
#import "TTMFooterView.h"
#import "TTMTumblrMenuView.h"
#import "TTMContactListView.h"
#import "TTMCustomNavigation.h"
#import "TTMChatNavigationView.h"
#import "TTMGrowingTextView.h"
#import "TTMMUCManager.h"
#import "TTMContactInformation.h"

@interface TTMMenuViewController : TTMCommonViewController  {
   
}

@property (nonatomic, retain) TTMChatView *chatView;
@property (nonatomic, assign) TTMArrowType arrowType;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *originalContactList;
@property (nonatomic, strong) NSMutableArray *onlineFriends;
@property (nonatomic, strong) NSMutableArray *groupFriends;

@property (nonatomic, strong) NSMutableArray *onlineFriendsGroup;
//@property (nonatomic, strong) TTMMUCManager *mucManager;

@property (nonatomic, strong) TTMFooterView *footerView;
@property (nonatomic, strong) TTMContactListView *contactList;
@property (nonatomic, strong) TTMCustomNavigation *navigation;

//-(void)resignTextView;

@end
