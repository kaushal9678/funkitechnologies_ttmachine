//
//  YDDefinitions.h
//  YDChat
//
//  Created by Peter van de Put on 08/12/2013.
//  Copyright (c) 2013 YourDeveloper. All rights reserved.
//

#ifndef YDChat_YDDefinitions_h
#define YDChat_YDDefinitions_h

//Menu Items
static const float tablewidth  = 270.0f;

#define kMenuHomeTag                @"kMenuHomeTag"
#define kMenuChatsTag               @"kMenuChatsTag"
#define kMenuContactsTag            @"kMenuContactsTag"
#define kMenuGroupChatTag           @"kMenuGroupChatTag"
#define kMenuSettingsTag            @"kMenuSettingsTag"


//user info
#define kXMPPmyJID                  @"kXMPPmyJID"
#define kXMPPmyPassword             @"kXMPPmyPassword"

#define kxmppHTTPRegistrationUrl    @"http://ttmachine.no-ip.org:9090/plugins/userService/userservice?type=add&secret=V3q2GdGx&username=%@&password=%@&name=%@&email=%@"
#define kXMPPServer                 @"ttmachine.no-ip.org"
#define kxmppProxyServer            @"ttmachine.no-ip.org"
#define kxmppConferenceServer       @"@conference.ttmachine.no-ip.org"
#define kxmppSearchServer           @"search.ttmachine.no-ip.org"

//Notifications
#define kChatStatus                 @"kChatStatus"
#define kNewMessage                 @"kNewMessage"

//YDConversationViewController
#define lineHeightValue  16.0f
#define maxChatLines 4

//MUC
#define kMyNickName                 @"Peter"
//Storage
#define USE_MEMORY_STORAGE 1
#define USE_HYBRID_STORAGE 0


#endif
