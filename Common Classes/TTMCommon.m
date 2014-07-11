//
//  TTMCommon.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/6/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMCommon.h"

@implementation TTMCommon


+(CGFloat)getHeight {
    return[[UIScreen mainScreen] bounds].size.height;
}

+(CGFloat)getWidth {
    return[[UIScreen mainScreen] bounds].size.width;
}

+(NSString *)getServerAddress {
    
    //For global acccess
   // return [NSString stringWithFormat:@"%@", @"http://ttmachine.no-ip.org/ttmac"]; // xmpp server
    //For Local acccess
    return ServerAddress;// [NSString stringWithFormat:@"%@", @"http://www.topchalks.com/ttmac"];
   // return @"essadmins-macbook-pro.local";
}

+(NSString *)getServiceName:(TTMServiceName)servicename {
    switch (servicename) {
        case TTMCodeVarification:
            return ServiceValidate;//[NSString stringWithFormat:@"%@", ServiceValidate];
            break;
        case TTMEmailSend:
            return ServiceSendvalidationcode;//[NSString stringWithFormat:@"%@", ServiceSendvalidationcode];
            break;
        case TTMGetContact:
            return ServiceGetfriendlist;//[NSString stringWithFormat:@"%@", ServiceGetfriendlist];
            break;
        case TTMGetContactSync:
            return [NSString stringWithFormat:@"%@", @"syncfriendlist"];
            break;
            
        default:
            break;
    }
    return nil;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
/***
 ** Method is define for getting server host name
 ***/
+(NSString *)getChatServerHostName {
    
    NSString *hostName = [[NSUserDefaults standardUserDefaults] valueForKey:@"HostName"];
    return (hostName.length) > 0 ? hostName :[NSString stringWithFormat:@"%@", ChatServerAddress];
   // return (hostName.length)>0 ?hostName:@"essadmins-macbook-pro.local";
    //192.168.1.150
    //ttmachine.no-ip.org
}
void LogIt (NSString *format, ...)
{
    va_list args;
    va_start (args, format);
    NSString *string;
    string = [[NSString alloc] initWithFormat: format  arguments: args];
    va_end (args);
    //printf ("%s\n", [string cString]);
} // LogIt
/***
 ** Method is define for getting server host name
 ***/
+(NSString *)getChatServerStaticIPName {
    
    return [NSString stringWithFormat:@"%@", ChatServerAddress];
    
    //192.168.1.150
    //ttmachine.no-ip.org
}
/**
 *  Creting the directory structure for recieved image and videos.
 */
+(void)createDirectoryStructureInDocument{
    NSArray *directoryNames = [NSArray arrayWithObjects:@"Sent pictures",@"Sent videos",@"Received pictures",@"Received videos",nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    for (int i = 0; i < [directoryNames count] ; i++) {
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[directoryNames objectAtIndex:i]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
    }
}
/**
 *  Method is define for write the sent image file in the Document directory
 *
 *  @param filedata NSData type from a URL
 *  @param fileName File name by which this file will be saved on the Document directory
 */
+(void)saveFileForSentPicture:(NSData *)filedata fileName:(NSString *)fileName{
    NSData *data = filedata;
    
    NSString *fullPath = [TTMCommon getPathForMediaTypeSentOrRecieved:TTMSentImage fileName:fileName];
    
    if([[NSFileManager defaultManager] isReadableFileAtPath:fullPath])
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:NULL];
    
    [data writeToFile:fullPath atomically:YES];
}
/**
 *  Method is define for write the sent video file in the Document directory
 *
 *  @param filedata NSData type from a URL
 *  @param fileName File name by which this file will be saved on the Document directory
 */

+(void)saveFileForSentVideo:(NSData *)filedata fileName:(NSString *)fileName{
    NSData *data = filedata;
    
    NSString *fullPath = [TTMCommon getPathForMediaTypeSentOrRecieved:TTMSetVideo fileName:fileName];
    if([[NSFileManager defaultManager] isReadableFileAtPath:fullPath])
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:NULL];
    
    [data writeToFile:fullPath atomically:YES];
}
/**
 *  Method is define for write the recieved image  file in the Document directory
 *
 *  @param filedata NSData type from a URL
 *  @param fileName File name by which this file will be saved on the Document directory
 */

+(void)saveFileForRecievedPicture:(NSData *)filedata fileName:(NSString *)fileName{
    NSData *data = filedata;
    
    NSString *fullPath = [TTMCommon getPathForMediaTypeSentOrRecieved:TTMRecievedImage fileName:fileName];
    if([[NSFileManager defaultManager] isReadableFileAtPath:fullPath])
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:NULL];
    
    [data writeToFile:fullPath atomically:YES];
}
/**
 *  Method is define for write the recieved video file in the Document directory
 *
 *  @param filedata NSData type from a URL
 *  @param fileName File name by which this file will be saved on the Document directory
 */
+(void)saveFileForRecievedVideo:(NSData *)filedata fileName:(NSString *)fileName{
    NSData *data = filedata;
    NSString *fullPath = [TTMCommon getPathForMediaTypeSentOrRecieved:TTMRecievedVideo fileName:fileName];
    
    if([[NSFileManager defaultManager] isReadableFileAtPath:fullPath])
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:NULL];
    
    [data writeToFile:fullPath atomically:YES];
}
/**
 *  Method is defined for get common URL for sent and recieved file
 *
 *  @param fileType This will suggest the file type is sent or recieved
 *  @param fileName this is declare for file name
 *
 *  @return Return string type common path
 */
+(NSString *)getPathForMediaTypeSentOrRecieved:(TTMFileHandleType)fileType fileName:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,  YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    switch (fileType) {
        case TTMRecievedVideo:
           return [[NSString stringWithFormat:@"%@/%@",documentsDirectory,@"Received videos"] stringByAppendingPathComponent:fileName];
            break;
        case TTMRecievedImage:
            return [[NSString stringWithFormat:@"%@/%@",documentsDirectory,@"Received pictures"] stringByAppendingPathComponent:fileName];
            break;
        case TTMSentImage:
            return [[NSString stringWithFormat:@"%@/%@",documentsDirectory,@"Sent pictures"]stringByAppendingPathComponent:fileName];
            break;
        case TTMSetVideo:
            return [[NSString stringWithFormat:@"%@/%@",documentsDirectory,@"Sent videos"] stringByAppendingPathComponent:fileName];
            break;
            
        default:
            break;
    }
}


/***
 ** Method is define for getting server host name
 ***/
+(NSString *)getChatServerName {
    
    return [NSString stringWithFormat:@"%@", ChatServerAddress];
    
    //192.168.1.150
    //ttmachine.no-ip.org
}

BOOL getExtensionType(NSString * extension_value) {
    
    NSString *lookup = [NSString stringWithFormat:@"%@", extension_value]; // The value you want to switch on
    __block BOOL drawType = NO;
    // Squint and this looks like a proper switch block!
    // New ObjC syntax makes the NSDictionary creation cleaner.
    NSDictionary *d = @{
                        @"png":
                            ^() {
                                drawType =  YES;
                            },
                        @"jpeg":
                            ^() {
                                drawType = YES;
                            },
                        @"jpg":
                            ^() {
                                drawType = YES;
                            },
                        @"gif":
                            ^() {
                                drawType = YES;
                            },
                        @"MOV":
                            ^() {
                                drawType = YES;
                            },
                        @"mov":
                            ^() {
                                drawType = YES;
                            },
                        @"mp4":
                            ^() {
                                drawType = YES;
                            }
                        };
    CaseBlock c = d[lookup];
    if (c)
        c();
    else {
        NSLog(@"Not Found");
    }
    return drawType;
}

+ (NSString *)fetchNameFromPhNumber:(NSString*)number{
    NSMutableString *name = [[NSMutableString alloc] init];
    
    ABAddressBookRef addressBook = ABAddressBookCreate( );
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
    NSLog(@"To be searche:%@", number);
    
    for ( int i = 0; i < nPeople; i++ )
    {
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            NSString *str = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            if ([str isEqualToString:number]) {
                NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
                NSLog(@"Name:%@ %@", firstName, lastName);
                [name appendString:firstName];
                [name appendString:@" "];
                [name appendString:(lastName ==nil)?@"":lastName];
                return name;
            }
        }
    }
    //name = @"Prem";
    return name;
}
/**
 *  get UTC format Interval
 *
 *  @return long long return type
 */
+(long long )getUTCTimeInterval  {
    
    NSDate *currentDate = [NSDate date];
    NSString* format = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    
    // Set up an NSDateFormatter for UTC time zone
    NSDateFormatter* formatterUtc = [[NSDateFormatter alloc] init];
    [formatterUtc setDateFormat:format];
    [formatterUtc setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString* input = [formatterUtc stringFromDate:currentDate];
    
    // Cast the input string to NSDate
    NSDate* utcDate = [formatterUtc dateFromString:input];
    
    // Set up an NSDateFormatter for the device's local time zone
    NSDateFormatter* formatterLocal = [[NSDateFormatter alloc] init];
    [formatterLocal setDateFormat:format];
    [formatterLocal setTimeZone:[NSTimeZone localTimeZone]];
    
    // Create local NSDate with time zone difference
    formatterUtc.dateFormat = @"HH:mm:ss";
    
    long long timeINtervalLocal = [@(floor([utcDate timeIntervalSince1970] * 1000)) longLongValue];
    
    return timeINtervalLocal;
}

+ (void)alertDisplay:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
@end
