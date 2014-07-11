//
//  TTMConfirmationCodeViewController.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/6/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//
#import "TTMBaseParser.h"
#import "TTMButton.h"
#import "Macro.h"
#import "UIColor-Expanded.h"
#import "UITextField+TTMShake.h"
#import "TTMTextField.h"
#import "TTMMenuViewController.h"
#import "TTMConfirmationCodeViewController.h"

#define kYPadding 0
@interface TTMConfirmationCodeViewController ()
@property (nonatomic, strong)TTMTextField *confirm_txtfield;

@end

@implementation TTMConfirmationCodeViewController
@synthesize welcomeLabel = _welcomeLabel;
-(void)addSendNumberButton {

    UIImage *buttonImage = [UIImage imageNamed:@"verifyme"];

    UIButton *numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [numberButton setFrame:CGRectMake(self.view.frame.size.width/2 - buttonImage.size.width/2, [TTMCommon getHeight]/2 + kYPadding + 50, buttonImage.size.width, buttonImage.size.height - 10)];
    [numberButton addTarget:self action:@selector(numberButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [numberButton setBackgroundImage:[UIImage imageNamed:@"verifyme"] forState:UIControlStateNormal];

    [numberButton setTitle:NSLocalizedString(@"Verify Me", @"Verify Me") forState:UIControlStateNormal];
    [numberButton.titleLabel setTextColor:[UIColor darkGrayColor]];
    [numberButton setBackgroundColor:[UIColor clearColor]];
    [numberButton.titleLabel setFont:[UIFont fontWithName:LotoLight size:16.0]];
    [self.view addSubview:numberButton];
    
}
- (void)shakeTextField:(TTMTextField *)textfield
{
	[textfield shake:10
           withDelta:5
            andSpeed:0.04
      shakeDirection:ShakeDirectionHorizontal];
}
-(IBAction)numberButtonPressed:(id)sender {
    if([self.confirm_txtfield.text length] == 0) {
        [self shakeTextField:self.confirm_txtfield];
    }else {
        [[TTMActivityIndicator sharedMySingleton] addIndicator:self.navigationController.view];
        [self callCodeVarificationservice];
    }
}

-(void)callCodeVarificationservice {
    
    TTMBaseParser *parser =  [[TTMBaseParser alloc] init];
    NSMutableDictionary *argumentDict = [NSMutableDictionary dictionary];
    [argumentDict setValue:[NSString stringWithFormat:@"%@", self.confirm_txtfield.text] forKey:@"code"];
    [parser serviceWithArgument:argumentDict serviceType:TTMCodeVarificationService callBackResponse:^(id response, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[TTMActivityIndicator sharedMySingleton] removeIndicator:self.navigationController.view];
                    [self.confirm_txtfield resignFirstResponder];

            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
            [UIView commitAnimations];
        });
        if([response isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"responseresponse %@", response);
                NSString*responseMessage=[[response valueForKey:@"actionErrors"]objectAtIndex:0];
                
                if ([responseMessage isEqualToString:@"Incorrect Validation code"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.welcomeLabel setText:@"Invalid Code"];
                        
                    });
                }else{
                NSString *password = [response objectForKey:@"password"];
                [[TTMSingleTon sharedMySingleton] setPassword:password];
                [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"Password"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                TTMMenuViewController *menuVC = [[TTMMenuViewController alloc] init];
                [self.navigationController pushViewController:menuVC animated:YES];
                }
            });
            
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.welcomeLabel setText:@"Invalid Code"];

            });
        }
    }];
}


-(void)addMobileNumberField {
    
    self.confirm_txtfield = [[TTMTextField alloc] init];
    [self.confirm_txtfield setFrame:CGRectMake(40, [TTMCommon getHeight]/2 + kYPadding, [TTMCommon getWidth]-80, 30)];
    [self.confirm_txtfield setBackground:[UIImage imageNamed:@"txtbg"]];
    [self.view addSubview:self.confirm_txtfield];
    [self.confirm_txtfield setDelegate:(id)self];
    [self.confirm_txtfield setTextAlignment:NSTextAlignmentCenter];
    [self.confirm_txtfield.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.confirm_txtfield setFont:[UIFont fontWithName:LotoLight size:12.0f]];

    [self.confirm_txtfield setPlaceholder:NSLocalizedString(@"Verification Code", @"Verification Code")];
    [self.confirm_txtfield.layer setBorderWidth:1.0f];
}

-(void)addWelcomeLabel {
    UIFont * customFont = [UIFont fontWithName:LotoLight size:18]; //custom font
    NSString * text = NSLocalizedString(@"Varification", @"Varification");
    CGSize labelSize = [text sizeWithFont:customFont constrainedToSize:CGSizeMake(380, 20) lineBreakMode:NSLineBreakByTruncatingTail];
    
    self.welcomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [TTMCommon getHeight]/2 - 100, self.view.frame.size.width, labelSize.height)];
    self.welcomeLabel.text = text;
    self.welcomeLabel.font = customFont;
    self.welcomeLabel.numberOfLines = 1;
    self.welcomeLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
//    self.welcomeLabel.adjustsFontSizeToFitWidth = YES;
//    self.welcomeLabel.adjustsLetterSpacingToFitWidth = YES;
    //self.welcomeLabel.minimumScaleFactor = 10.0f/12.0f;
    self.welcomeLabel.clipsToBounds = YES;
    self.welcomeLabel.backgroundColor = [UIColor clearColor];
    self.welcomeLabel.textColor = [UIColor whiteColor];
    self.welcomeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.welcomeLabel];
}

-(void)addSuggestionLabel {
    UIFont * customFont = [UIFont fontWithName:LotoLight size:12.0f]; //custom font
    NSString * text = NSLocalizedString(@"Please check your email/sms and enter the varification code below", @"Please check your email/sms and enter the varification code below");
    CGSize maximumLabelSize = CGSizeMake([TTMCommon getWidth] - 100,9999);
    
    CGSize labelSize = [text sizeWithFont:[UIFont fontWithName:LotoLight size:12.0f]
                                            constrainedToSize:maximumLabelSize
                                                lineBreakMode:NSLineBreakByCharWrapping];
    
    self.suggestionLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, [TTMCommon getHeight]/2 - 80, [TTMCommon getWidth] - 120, labelSize.height+ 50)];
    self.suggestionLabel.text = text;
    self.suggestionLabel.font = customFont;
    self.suggestionLabel.numberOfLines = 0;
    self.suggestionLabel.backgroundColor = [UIColor clearColor];
    self.suggestionLabel.textColor = [UIColor whiteColor];
    self.suggestionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.suggestionLabel];
}
-(void)callResendCodeservice {

    TTMBaseParser *parser =  [[TTMBaseParser alloc] init];
    NSMutableDictionary *argumentDict = [NSMutableDictionary dictionary];
    [argumentDict setValue:getValueForKey(EmailDefaultKey) forKey:@"email"];
    [parser serviceWithArgument:argumentDict serviceType:TTMEmailSendService callBackResponse:^(id response, NSError *error) {
        [[TTMActivityIndicator sharedMySingleton] removeIndicator:self.navigationController.view];
        NSLog(@"Response is %@", response);
        if([[response valueForKey:@"status"] integerValue]) {
            
            
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.welcomeLabel setText:@"Invalid Code"];
            });
        }
    }];
}
-(void)addVarificationCodeLabel {
    UIFont * customFont = [UIFont fontWithName:LotoLight size:12.0f]; //custom font
    NSString * text = NSLocalizedString(@"Need the varification code again?", @"Need the varification code again?");
    CGSize maximumLabelSize = CGSizeMake([TTMCommon getWidth] - 100,9999);
    
    CGSize labelSize = [text sizeWithFont:[UIFont fontWithName:LotoLight size:12.0f]
                        constrainedToSize:maximumLabelSize
                            lineBreakMode:NSLineBreakByCharWrapping];
    
    UILabel *codeRegeneration = [[UILabel alloc]initWithFrame:CGRectMake(60, [TTMCommon getHeight] - 80, [TTMCommon getWidth] - 120, labelSize.height)];
    codeRegeneration.text = text;
    codeRegeneration.font = customFont;
    codeRegeneration.numberOfLines = 0;
    codeRegeneration.backgroundColor = [UIColor clearColor];
    codeRegeneration.textColor = [UIColor whiteColor];
    codeRegeneration.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:codeRegeneration];
}

-(void)addButtonOnView:(CGRect)frame background:(NSString *)background callBack:(GetButtonAction)callbak {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(buttonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"resend"] forState:UIControlStateNormal];
    [button setTitle:@"    resend" forState:UIControlStateNormal];
    button.frame = frame;
    [button.titleLabel setFont:[UIFont fontWithName:LotoLight size:8.0f]];
    [self.view addSubview:button];
    //self.callBackBlock = callbak;

}
-(IBAction)buttonPressed:(id)sender {
    //self.callBackBlock(sender);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    TTMLogo *logo = [[TTMLogo alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - logoImage.size.width/2 + 12, 50, logoImage.size.width-25, logoImage.size.height-25)];
    [self.view addSubview:logo];
    [self addWelcomeLabel];
	// Do any additional setup after loading the view.
    [self addMobileNumberField];
    [self addSuggestionLabel];
    [self addSendNumberButton];
    [self addVarificationCodeLabel];
    UIImage *tempImage = [UIImage imageNamed:@"resend"];
    __weak typeof(self) weakSelf = self;
    [self addButtonOnView:CGRectMake(self.view.frame.size.width/2 - tempImage.size.width/2 , [TTMCommon getHeight] - 50, tempImage.size.width, tempImage.size.height) background:@"" callBack:^(id sender) {
        [weakSelf.confirm_txtfield resignFirstResponder];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            weakSelf.view.frame = CGRectMake(0,0,weakSelf.view.frame.size.width,weakSelf.view.frame.size.height);
            [UIView commitAnimations];
        });
        [[TTMActivityIndicator sharedMySingleton] addIndicator:weakSelf.navigationController.view];

        [weakSelf callResendCodeservice];
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,-70,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
    });
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
