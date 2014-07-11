//
//  TTMContactListView.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/9/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMContactListView.h"

@implementation TTMContactListView
@synthesize contactList = _contactList;
@synthesize contactArray = _contactArray;

-(NSMutableArray *)contactArray {
    if(!_contactArray) {
        _contactArray = [[NSMutableArray alloc] init];
    }
    return _contactArray;
}

-(UITableView *)contactList {
    if(!_contactList) {
        _contactList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    }
    [_contactList setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    return _contactList;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contactArray = [NSMutableArray arrayWithArray:[TTMContacts GetAllContactsFromPhoneBook]];
        [self addSubview:self.contactList];
        [self.contactList setBackgroundColor:[UIColor colorWithRed:10.0/255.0f green:10.0/255.0f blue:10.0/255.0f alpha:1.0f]];
        [self.contactList setSeparatorColor:[UIColor clearColor]];
    }
    return self;
}


-(void)setRefrenceForDataLoading:(id)refrence completionCallBackBlock:(GetAllContactList)callback{
    
    self.contactListBlock = callback;
    self.contactList.delegate = (id)refrence;
    self.contactList.dataSource = (id)refrence;
    self.contactListBlock(self.contactArray);
    [self.contactList reloadData];

}

-(void)setNeedsLayout {
    [super setNeedsLayout];
    [self.contactList setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
