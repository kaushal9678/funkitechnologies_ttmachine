//
//  TTMCommon.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/6/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//
#import "Macro.h"
#import "TTMEnumClass.h"
#import <Foundation/Foundation.h>
#import  <AddressBook/AddressBook.h>
#import "TTMMatchedContact.h"

@interface TTMCommon : NSObject


+(CGFloat)getHeight;

+(CGFloat)getWidth;

+(NSString *)getServerAddress;

+(NSString *)getChatServerHostName;

+(NSString *)getServiceName:(TTMServiceName)servicename;
void LogIt (NSString *format, ...);
+(NSString *)getChatServerStaticIPName;
+(NSString *)getChatServerName;
+(UIColor *)colorFromHexString:(NSString *)hexString;
+(NSString *)fetchNameFromPhNumber:(NSString*)number;
+(void)alertDisplay:(NSString *)msg;
+(void)saveFileForRecievedPicture:(NSData *)filedata fileName:(NSString *)fileName;
+(void)saveFileForSentVideo:(NSData *)filedata fileName:(NSString *)fileName;
+(void)saveFileForSentPicture:(NSData *)filedata fileName:(NSString *)fileName;
+(void)saveFileForRecievedVideo:(NSData *)filedata fileName:(NSString *)fileName;
+(NSString *)getPathForMediaTypeSentOrRecieved:(TTMFileHandleType)fileType fileName:(NSString *)fileName;
+(long long )getUTCTimeInterval;
/**
 *  Create Directory structure for the video recieving and sending
 */
+(void)createDirectoryStructureInDocument;

typedef void (^CaseBlock)();

BOOL getExtensionType(NSString * extension_value);

@end
