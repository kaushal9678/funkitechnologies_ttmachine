//
//  TTMSplashViewController.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 07/03/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//
#import "TTMSplashViewController.h"

@interface TTMSplashViewController ()

@end

@implementation TTMSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self addWelcomeLabel];
    [self imageLogo];
    [self imageNext];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)addWelcomeLabel {
    UIFont * customFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18]; //custom font
    NSString * text = NSLocalizedString(@"Welcome in Time Text Machine app", @"Welcome in Time Text Machine app");
    CGSize labelSize = [text sizeWithFont:customFont constrainedToSize:CGSizeMake(380, 20) lineBreakMode:NSLineBreakByTruncatingTail];
    
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, labelSize.height)];
    fromLabel.text = text;
    fromLabel.font = customFont;
    fromLabel.numberOfLines = 1;
    fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    fromLabel.adjustsFontSizeToFitWidth = YES;
    fromLabel.adjustsLetterSpacingToFitWidth = YES;
    fromLabel.minimumScaleFactor = 10.0f/12.0f;
    fromLabel.clipsToBounds = YES;
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.textColor = [UIColor blackColor];
    fromLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:fromLabel];
}

-(void)imageLogo {
    UIImage *tempImage = [UIImage imageNamed:@"images.jpeg"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, 40, 100, 100)];
    [imgView setImage:tempImage];
    [self.view addSubview:imgView];

}

-(void)imageNext {
    UIImage *tempImage = [UIImage imageNamed:@"arrow_bottom.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 60, [TTMCommon getHeight]- 100, tempImage.size.width, tempImage.size.height)];
    [imgView setImage:tempImage];
    [self.view addSubview:imgView];
    [imgView setUserInteractionEnabled:YES];

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
