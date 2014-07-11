//
//  TTMContacts.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/9/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Foundation/Foundation.h>

@interface TTMContacts : NSObject

+ (NSMutableArray *)GetAllContactsFromPhoneBook;
@end
