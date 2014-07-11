//
//  TTMCustomNavigation.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 11/03/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//
#import "Macro.h"
#import "TTMCustomNavigation.h"

@implementation TTMCustomNavigation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)addLeftButton:(UIImage *)image callBackAction:(ButtonAction)callBack{
    //self.action = callBack;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(5, -3, image.size.width+5, image.size.height+5)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button setTag:self.tag];
    [button setBackgroundColor:[UIColor clearColor]];
}

-(void)addRightButton:(UIImage *)image callBackAction:(ButtonAction)callBack{
    //self.action = callBack;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(self.frame.size.width - image.size.width - 19, 0, image.size.width+12, image.size.height+10)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button setTag:self.tag];
    [button setBackgroundColor:[UIColor clearColor]];
    
}
-(void)addMiddleButton:(UIImage *)image callBackAction:(ButtonAction)callBack{
    self.action = callBack;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(self.frame.size.width/2 - 35, -8, 70, self.frame.size.height)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(middleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button setTitle:@"Home" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTag:self.tag];
    [button.titleLabel setFont:[UIFont fontWithName:LotoLight size:22.0f]];
    [button setBackgroundColor:[UIColor clearColor]];

}


-(IBAction)middleButtonPressed:(id)sender {
    self.action(sender);
}


-(IBAction)leftButtonPressed:(id)sender {
    //self.action(sender);
}

-(IBAction)rightButtonPressed:(id)sender {
    //self.action(sender);
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
