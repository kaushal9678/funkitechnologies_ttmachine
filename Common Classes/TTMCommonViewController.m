//
//  TTMCommonViewController.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 12/03/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMCommonViewController.h"

@interface TTMCommonViewController ()

@end

@implementation TTMCommonViewController

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
	// Do any additional setup after loading the view.
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    
     [self.view setBackgroundColor:[UIColor colorWithRed:12.0/255.0f green:12.0/255.0f blue:12.0/255.0f alpha:1.0f]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
