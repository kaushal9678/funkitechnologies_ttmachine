//
//  TTMContactListView.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/9/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMContacts.h"

typedef void(^GetAllContactList)(NSMutableArray *);
@interface TTMContactListView : UIView

@property (nonatomic, strong) GetAllContactList contactListBlock;
@property (nonatomic, strong) UITableView *contactList;
@property (nonatomic, strong) NSMutableArray *contactArray;

-(void)setRefrenceForDataLoading:(id)refrence completionCallBackBlock:(GetAllContactList)callback;
@end
