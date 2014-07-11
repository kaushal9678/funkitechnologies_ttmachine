//
//  TTMChatViewController.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/14/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//
#import "TTMAppDelegate.h"
#import "TTMChatView.h"
#import "TTMSingleTon.h"
#import "TTMChatViewController.h"

@interface TTMChatViewController ()

@end

@implementation TTMChatViewController
@synthesize  userName = _userName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
 @Get Appdelegate instance vaiable
 */
- (TTMAppDelegate *)appDelegate {
	return (TTMAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
