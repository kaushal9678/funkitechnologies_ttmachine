//
//  TTMChatView.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/14/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"
#import "TURNSocket.h"
#import "TTMChatCustonCell.h"
#import "TTMCustomDelegate.h"
#import "TTMMatchedContact.h"
#import "TTMGrowingTextView.h"

@protocol ChatDelegateACtion;

@interface TTMChatView : UIView<UITableViewDelegate, UITableViewDataSource, TTMCustomDelegate, TTMGrowingTextViewDelegate> {
    UITextField		*messageField;
	UITableView		*tView;
	NSMutableArray	*messages;
	NSMutableArray *turnSockets;
    TTMGrowingTextView *textView;
	UIView *containerView;
	
}
@property (nonatomic, strong) TTMMatchedContact *contactInfo;
@property (nonatomic, strong) NSString		*chatWithUser;
@property (nonatomic, strong) UIButton *expandableButton;
@property (nonatomic, retain) IBOutlet UITextField *messageField;
@property (nonatomic, retain) IBOutlet UITableView *tView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) NSMutableArray	*messages;
@property (nonatomic, assign) id <ChatDelegateACtion> delegate;
-(void)assignChatUser:(NSString *)chatUser;
@end

/*
 @Protocol is declared for the chat view actions
 */
@protocol ChatDelegateACtion <NSObject>

@optional
// Chat button action
-(void)chatButtonAction:(id)sender;
//Method is declared for the  selcted user cell pressed
-(void)selectedUserCellPressed:(NSString *)chatUserName;
//Method is declared for the  get reteligence data from serverusing chat keyboard
-(void)getReteligencyFRomChat:(NSString *)chatString;

@end

