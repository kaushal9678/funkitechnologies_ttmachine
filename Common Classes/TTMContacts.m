//
//  TTMContacts.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/9/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMContactsFetch.h"
#import "TTMContacts.h"

@implementation TTMContacts
+ (NSMutableArray *)GetAllContactsFromPhoneBook {    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_release(semaphore);
    }
    
    else { // We are on iOS 5 or Older
        accessGranted = YES;
        return [self getContactsWithAddressBook:addressBook];
    }
    
    if (accessGranted) {
       return  [self getContactsWithAddressBook:addressBook];
    }
    return nil;
}

// Get the contacts.
+ (NSMutableArray *)getContactsWithAddressBook:(ABAddressBookRef )addressBook {
    
    NSMutableArray *contactList = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
	CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++) {
        
        TTMContactsFetch *contactHolder = [[TTMContactsFetch alloc] init];
		NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
		ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
		//For username and surname
		ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
		
        CFStringRef firstName, lastName;
		firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
		lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
		[dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
		[contactHolder setName:[NSString stringWithFormat:@"%@ %@", firstName, lastName]];
		//For Email ids
		ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
		if(ABMultiValueGetCount(eMail) > 0) {
			[dOfPerson setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
            [contactHolder setEmail:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0)];
		}
		NSData  *imgData = (__bridge NSData*)ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatThumbnail);

        UIImage  *img = [UIImage imageWithData:imgData];
        NSLog(@"imgimgimgimgimgimgimgimgimgimg %@", img);
        [contactHolder setPersonImage:img];
		//For Phone number
//		NSString* mobileLabel;
        
//		for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
//			mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
//			if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
//			{
//				[dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
//                NSString *phoneNumber = [NSString stringWithFormat:@"%@", (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i)];
//                [contactHolder setPhoneNumber:phoneNumber];
//			}
//			else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
//			{
//				[dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
//                NSString *phoneNumber = [NSString stringWithFormat:@"%@", (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i)];
//
//                [contactHolder setPhoneNumber:phoneNumber];
//
//				break ;
//			}
//            
//        }
        if(phones) {
            for(int ix = 0; ix < ABMultiValueGetCount(phones); ix++){
                CFStringRef typeTmp = ABMultiValueCopyLabelAtIndex(phones, ix);
                CFStringRef numberRef = ABMultiValueCopyValueAtIndex(phones, ix);
                CFStringRef typeRef = ABAddressBookCopyLocalizedLabel(typeTmp);
                
                NSString *phoneNumber = (__bridge NSString *)numberRef;
                //NSString *phoneType = (__bridge NSString *)typeRef;
                
                [contactHolder setPhoneNumber:phoneNumber];
                
                if(typeTmp) CFRelease(typeTmp);
                if(numberRef) CFRelease(numberRef);
                if(typeRef) CFRelease(typeRef);
            }
        }
        [contactList addObject:contactHolder];
        
	}
    NSLog(@"Contacts = %@",contactList);
    return contactList;
}
@end
