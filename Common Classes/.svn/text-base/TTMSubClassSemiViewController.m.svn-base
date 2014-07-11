//
//  TTMSubClassSemiViewController.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 6/7/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//

#import "TTMSubClassSemiViewController.h"

@interface TTMSubClassSemiViewController ()

@end

@implementation TTMSubClassSemiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        self.sideAnimationDuration = 0.6f;
        self.sideOffset = 100.0f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentView.alpha = 0.6f;
    self.contentView.backgroundColor = [UIColor darkGrayColor];
    UIButton *delayTime = [UIButton buttonWithType:UIButtonTypeCustom];
    [delayTime setFrame:CGRectMake(self.view.frame.size.width/2 - 25, 100, self.view.frame.size.width/2 + 10 , 30)];
    [delayTime setTitle:@"Delay Time" forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    __weak typeof(delayTime) weakSelfB = delayTime;
    [delayTime setAction:kUIButtonBlockTouchUpInside withBlock:^{
        weakSelf.complitionBlock(weakSelfB, nil);
        [self dismissSemi:self];
    }];
    [delayTime.layer setCornerRadius:2.0f];
    [delayTime.layer setBorderColor:[UIColor redColor].CGColor];
    [delayTime.layer setBorderWidth:2.0f];
    [self.view addSubview:delayTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
