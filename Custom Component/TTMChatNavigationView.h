//
//  TTMChatNavigationView.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/23/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMMatchedContact.h"

@protocol IconActionDelegate <NSObject>

-(void)iconButtonAction:(id)sender;
-(void)attachmentButtonAction:(id)sender;

@end

typedef void(^NavigationAction)(id sender);

@interface TTMChatNavigationView : UIView

@property (nonatomic, strong) TTMMatchedContact *contactInfo;
@property (nonatomic, copy) NavigationAction actions;
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UIButton *pictureButton;
@property (nonatomic, strong) UIButton *attchmentButton;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UILabel *profileName;
@property (nonatomic, strong) id <IconActionDelegate> delegate;
-(void)addProfileInfoLabel;
@end
