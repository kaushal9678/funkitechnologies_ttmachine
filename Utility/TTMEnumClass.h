//
//  TTMEnumClass.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/6/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * enum for Service types
 */
typedef enum ServiceType {
    
    TTMEmailSendService = 0,
    TTMCodeVarificationService = 1,
    TTMGetContactService = 2,
    TTMGetContactSyncService = 3,
    
} TTMServiceType;

/*
 * enum for Service types
 */
typedef enum FileHandleType {
    
    TTMSentImage = 0,
    TTMRecievedImage = 1,
    TTMSetVideo = 2,
    TTMRecievedVideo = 3,
    
} TTMFileHandleType;

/*
 * enum for Service types
 */
typedef enum ArrowFramingType {
    
    TTMPositiveArrowFrame = 0,
    TTMNegativeArrowFrame = 1,
    TTMLeftArrowFrame = 2,
    TTMRightArrowFrame = 3,
    
} TTMArrowFramingType;

/*
 * enum for Service types
 */
typedef enum ServiceName {
    
    TTMEmailSend = 0,
    TTMCodeVarification = 1,
    TTMGetContact = 2,
    TTMGetContactSync = 3,
    
} TTMServiceName;
/*
 * enum for Service types
 */
typedef enum SenderType {
    
    TTMFrom = 0,
    TTMTo = 1,
    
} TTMSenderType;

/*
 * enum for Service types
 */
typedef enum SettingType {
    
    TTMMessageSettingInfo = 0,
    TTMXMPPMessageInfo = 1,
    
} TTMSettingType;

/*
 * enum for Service types
 */
typedef enum SelectedCategoryType {
    
    TTMMessage = 0,
    TTMFriendList = 1,
    TTMChat = 2,
    TTMImages= 3,
    TTMVideo = 4,
    
} TTMSelectedCategoryType;

/*
 * enum for Service types
 */
typedef enum ArrowType {
    
    TTMUpwordArrow = 0,
    TTMDownword = 1,
    
} TTMArrowType;
