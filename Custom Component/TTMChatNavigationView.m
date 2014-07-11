//
//  TTMChatNavigationView.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/23/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "Macro.h"
#import "TTMMedallionView.h"
#import "TTMChatNavigationView.h"

@implementation TTMChatNavigationView
@synthesize actions;
@synthesize iconButton;
@synthesize pictureButton;
@synthesize attchmentButton;
@synthesize menuButton;
@synthesize contactInfo;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *iconImage = [UIImage imageNamed:@"chat"];
        self.iconButton = [self addCustomButton:iconImage selector:@selector(iconButtonPressed:) frame:CGRectMake(5, 0, iconImage.size.width/2 - 12, iconImage.size.height/2 - 10) callBackAction:^(id sender) {
            NSLog(@"Icon button pressed");
            //[self.delegate iconButtonPressed:self];
            
        }];
        TTMMedallionView *imageView = [[TTMMedallionView alloc] initWithFrame:CGRectMake(iconImage.size.width/2 , 0, iconImage.size.width/2-12, iconImage.size.height/2-10)];
        [imageView.layer setBorderColor:[UIColor clearColor].CGColor];
        [imageView.layer setBorderWidth:1.0f];
        [self addSubview:imageView];
//        self.pictureButton = [self addCustomButton:iconImage selector:@selector(profileButtonPressed:) frame:CGRectMake(iconImage.size.width/2 , 0, iconImage.size.width/2-5, iconImage.size.height/2-5) callBackAction:^(id sender) {
//            NSLog(@"profile picture button pressed");
//        }];
        
        self.attchmentButton = [self addCustomButton:[UIImage imageNamed:@"attach"] selector:@selector(attachmentButtonPressed:) frame:CGRectMake(self.frame.size.width - 55, 5, [UIImage imageNamed:@"attach"].size.width- 5, [UIImage imageNamed:@"attach"].size.height - 10) callBackAction:^(id sender) {
            NSLog(@"attachment button pressed");
        }];
       
        self.menuButton = [self addCustomButton:[UIImage imageNamed:@"menu_button"] selector:@selector(menuButtonPressed:) frame:CGRectMake(self.frame.size.width - 18, 5, [UIImage imageNamed:@"menu_button"].size.width, [UIImage imageNamed:@"menu_button"].size.height + 5) callBackAction:^(id sender) {
            NSLog(@"menu button pressed");
        }];
        //[self addProfileInfoLabel];
    }
    return self;
}
-(void)addProfileInfoLabel  {
    
    UILabel *suggestionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 80, 0, 180,27)];
    [suggestionLabel setText:[NSString stringWithFormat:@"%@", self.contactInfo.email_Id]];
    [suggestionLabel setTextColor:[UIColor whiteColor]];
    [suggestionLabel setFont:[UIFont fontWithName:LotoLight size:14.0f]];
    [self addSubview:suggestionLabel];
    self.profileName = suggestionLabel;
    
}
-(void)setNeedsLayout {
    
    [super setNeedsLayout];
    
    [self.pictureButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.attchmentButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.menuButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.profileName setText:[NSString stringWithFormat:@"%@", self.contactInfo.email_Id]];
}
-(IBAction)iconButtonPressed:(id)sender {
    [self.delegate iconButtonAction:sender];
}
-(IBAction)profileButtonPressed:(id)sender {
    
}
-(IBAction)attachmentButtonPressed:(id)sender {
    [self.delegate attachmentButtonAction:sender];

}
-(IBAction)menuButtonPressed:(id)sender {
    
}
-(UIButton *)addCustomButton:(UIImage *)image selector:(SEL)selector frame:(CGRect)frame callBackAction:(NavigationAction)callBack{
    
    //self.action = callBack;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button setTag:self.tag];
    [button setBackgroundColor:[UIColor clearColor]];
    return button;
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
