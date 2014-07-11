//
//  TTMButtonWithSubTitle.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/9/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMButtonWithSubTitle.h"

@implementation TTMButtonWithSubTitle
@synthesize selctedLabel = _selctedLabel;

-(void)addButtonWithTitle:(NSString *)title imageName:(NSString *)image callBack:(GridButtonAction)callback{
    self.buttonAction = callback;
    UIImage *imageNamed = [UIImage imageNamed:image];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, imageNamed.size.width, imageNamed.size.height)];
    [button setBackgroundImage:imageNamed forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button setTag:self.tag];
    [button setBackgroundColor:[UIColor redColor]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height + 2, imageNamed.size.width, 20)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:title];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [self addSubview:titleLabel];
    self.selctedLabel = titleLabel;
    
}

-(IBAction)buttonPressed:(id)sender {
    //self.buttonAction(sender, [sender tag]);
}

@end
