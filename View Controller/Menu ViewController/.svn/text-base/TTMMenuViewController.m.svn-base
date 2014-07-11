//
//  TTMMenuViewController.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 08/03/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//
#import "Macro.h"
#import "Room.h"
#import "ContactInfo.h"
#import "TTMMUCManager.h"
#import "TTMAppDelegate.h"
#import "TTMOnlineBuddy.h"
#import "TTMChatView.h"
#import "TTMMatchedContact.h"
#import "TTMHomeGrid.h"
#import "TTMContactCustomCell.h"
#import "TTMContactsFetch.h"
#import "TTMContactListView.h"
#import "TTMMenuViewController.h"
#import "TTMCategoryViewController.h"
#import "TTMConversationViewController.h"
#import "TTMFriendListToInviteViewController.h"

@interface TTMMenuViewController () {
    UIImageView *overLayView;
    BOOL isFirstTime;
    NSIndexPath *idxPath;
}
@property (nonatomic, strong) NSMutableDictionary *contactDictionary;
@property (nonatomic, assign) TTMSelectedCategoryType categoryType;
@end

@implementation TTMMenuViewController

@synthesize chatView = _chatView;
//@synthesize mucManager = _mucManager;
@synthesize onlineFriends = _onlineFriends;
@synthesize  dataArray = _dataArray;
@synthesize contactList = _contactList;
@synthesize footerView = _footerView;
@synthesize groupFriends = _groupFriends;
@synthesize  originalContactList = _originalContactList;
@synthesize onlineFriendsGroup = _onlineFriendsGroup;
@synthesize contactDictionary = _contactDictionary;

CAShapeLayer *openMenuShape;
CAShapeLayer *closedMenuShape;
#pragma mark - View lifecycle

-(NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(NSMutableArray *)onlineFriends {
    if(!_onlineFriends) {
        _onlineFriends = [[NSMutableArray alloc] init];
    }
    return _onlineFriends;
}

-(NSMutableArray *)groupFriends {
    if(!_groupFriends) {
        _groupFriends = [[NSMutableArray alloc] init];
    }
    return _groupFriends;
}

-(NSMutableArray *)onlineFriendsGroup {
    if(!_onlineFriendsGroup) {
        _onlineFriendsGroup = [[NSMutableArray alloc] init];
    }
    return _onlineFriendsGroup;
}

-(TTMFooterView *)footerView {
    if(!_footerView) {
        _footerView = [[TTMFooterView alloc] init];
    }
    return _footerView;
}

-(NSMutableArray *)originalContactList {
    if(!_originalContactList) {
        _originalContactList = [[NSMutableArray alloc] init];
    }
    return _originalContactList;
}

-(NSMutableDictionary *)contactDictionary {
    if(!_contactDictionary) {
        _contactDictionary = [NSMutableDictionary dictionary];
    }
    return _contactDictionary;
}
/*
 @Get App delgate instance
 */
- (TTMAppDelegate *)appDelegate {
	return (TTMAppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //[self showMenu];
    isFirstTime = YES;
    overLayView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [TTMCommon getHeight])];
    [overLayView setBackgroundColor:[UIColor lightGrayColor]];
    [overLayView setAlpha:0.1];
    [overLayView setUserInteractionEnabled:NO];
    self.arrowType = TTMUpwordArrow;
    [self.navigation removeFromSuperview];
    self.navigation = [[TTMCustomNavigation alloc] initWithFrame:CGRectMake(0, 30, [TTMCommon getWidth], 40)];
    [self.view addSubview:self.navigation];
    __weak typeof(self) weakSelf = self;
    [self.navigation addMiddleButton:[UIImage imageNamed:@""] callBackAction:^(id sender) {
        //UIButton *button = (UIButton *)sender;
        //[button setTitle:(self.contactList.frame.size.height == ([TTMCommon getHeight] - 200)) ? @"Contact List" : @"Home" forState:UIControlStateNormal];
        
        weakSelf.arrowType = (weakSelf.contactList.frame.size.height == ([TTMCommon getHeight] - 200)) ? TTMDownword : TTMUpwordArrow;
        [openMenuShape removeFromSuperlayer];
        [weakSelf performSelector:@selector(drawOpenLayer) withObject:nil afterDelay:0.2];
        [UIView animateWithDuration:.3f animations:^{
            
            CGRect theFrame = CGRectMake(0, (weakSelf.contactList.frame.size.height == ([TTMCommon getHeight] - 200)) ? 60 : ((IS_IPHONE5) ? [TTMCommon getHeight] - 300 : [TTMCommon getHeight] - 210), weakSelf.contactList.frame.size.width, (weakSelf.contactList.frame.size.height == ([TTMCommon getHeight] - 200)) ? [TTMCommon getHeight] : ([TTMCommon getHeight] - 200));
            weakSelf.contactList.frame = theFrame;
            [weakSelf.contactList setNeedsLayout];
            TTMChatView *chatView = (TTMChatView *)[[weakSelf getParentViewController].view viewWithTag:5678];
            [chatView setFrame:CGRectMake(0, [TTMCommon getHeight], [TTMCommon getWidth], 0)];
            [chatView removeFromSuperview];
            
        }];
    }];
    
    [self.navigation addLeftButton:[UIImage imageNamed:@"logo_icon"] callBackAction:^(id sender) {
        
    }];
    [self.navigation addRightButton:[UIImage imageNamed:@"setting"] callBackAction:^(id sender) {
        
    }];
    [self.navigation setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor colorWithRed:16.0/255.0f green:16.0/255.0f blue:16.0/255.0f alpha:1.0f]];
    [self performSelector:@selector(showMenu) withObject:nil afterDelay:0.1];
    
    TTMOnlineBuddy *onlineBuddy = [[TTMOnlineBuddy alloc] init];
    [onlineBuddy getOnlineFriend:^(NSMutableArray *list) {
        NSLog(@"Online friend %@", list);
        self.onlineFriends = list;
        [self.contactList.contactList reloadData];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if ([[self appDelegate] connect]) {
        NSLog(@"user has been logged in ");
    }
    //[self showMenu];
}
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Set the current view controller to the one embedded (in the storyboard).
    // Draw the shapes for the open and close menu triangle.
    //[self drawOpenLayer];
    [self performSelector:@selector(drawOpenLayer) withObject:nil afterDelay:0.6];
    //[self drawClosedLayer];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 1) {
        self.arrowType = (self.contactList.frame.size.height == ([TTMCommon getHeight] - 200)) ? TTMDownword : TTMUpwordArrow;
        [openMenuShape removeFromSuperlayer];
        [self performSelector:@selector(drawOpenLayer) withObject:nil afterDelay:0.2];
        [UIView animateWithDuration:.3f animations:^{
            CGRect theFrame = CGRectMake(0, (self.contactList.frame.size.height == ([TTMCommon getHeight] - 200)) ? 55 : ((IS_IPHONE5) ? [TTMCommon getHeight] - 300 : [TTMCommon getHeight] - 210), self.contactList.frame.size.width, (self.contactList.frame.size.height == ([TTMCommon getHeight] - 200)) ? [TTMCommon getHeight] : ([TTMCommon getHeight] - 200));
            self.contactList.frame = theFrame;
            [self.contactList setNeedsLayout];
        }];
    }
}

- (void) drawOpenLayer {
    
    openMenuShape = [CAShapeLayer layer];
    // Constants to ease drawing the border and the stroke.
    int height = 0;
    int width = self.contactList.frame.size.width;
    int triangleSize = 10;
    int trianglePosition = 0.46*width;
    
    // The path for the triangle (showing that the menu is open).
    UIBezierPath *triangleShape = [[UIBezierPath alloc] init];
    [triangleShape moveToPoint:CGPointMake(trianglePosition, height)];
    [triangleShape addLineToPoint:CGPointMake(trianglePosition+triangleSize, height-triangleSize)];
    [triangleShape addLineToPoint:CGPointMake(trianglePosition+2*triangleSize, height)];
    [triangleShape addLineToPoint:CGPointMake(trianglePosition, height)];
    
    //[openMenuShape setPath:triangleShape.CGPath];
    //[openMenuShape setFillColor:[self.menubar.backgroundColor CGColor]];
    [openMenuShape setFillColor:[[UIColor colorWithRed:12.0f/255.0f green:12.0f/255.0f blue:12.0f/255.0f alpha:1.0f] CGColor]];
    UIBezierPath *borderPath = [[UIBezierPath alloc] init];
    [borderPath moveToPoint:CGPointMake(0, height)];
    [borderPath addLineToPoint:CGPointMake(trianglePosition, height)];
    [borderPath addLineToPoint:CGPointMake(trianglePosition+triangleSize, (self.arrowType == TTMUpwordArrow) ? height-triangleSize : height+triangleSize)];
    [borderPath addLineToPoint:CGPointMake(trianglePosition+2*triangleSize, height)];
    [borderPath addLineToPoint:CGPointMake(width, height)];
    
    [openMenuShape setPath:borderPath.CGPath];
    [openMenuShape setStrokeColor:[[UIColor colorWithRed:35.0f/255.0f green:35.0f/255.0f blue:35.0f/255.0f alpha:1.0f] CGColor]];
    
    [openMenuShape setBounds:CGRectMake(0.0f, 0.0f, height+triangleSize, width)];
    [openMenuShape setAnchorPoint:CGPointMake(0.0f, 0.0f)];
    [openMenuShape setPosition:CGPointMake(0.0f, 0.0f)];
    //[closedMenuShape removeFromSuperlayer];
    [[self.contactList layer] addSublayer:openMenuShape];
}

- (CALayer *)hitTest:(CGPoint)thePoint {
    
    return openMenuShape;
}

- (void) drawClosedLayer {
    
    closedMenuShape = [CAShapeLayer layer];
    
    // Constants to ease drawing the border and the stroke.
    int height = self.contactList.frame.size.height;
    int width = self.contactList.frame.size.width;
    
    // The path for the border (just a straight line)
    UIBezierPath *borderPath = [[UIBezierPath alloc] init];
    [borderPath moveToPoint:CGPointMake(0, height)];
    [borderPath addLineToPoint:CGPointMake(width, height)];
    
    [closedMenuShape setPath:borderPath.CGPath];
    [closedMenuShape setStrokeColor:[self.contactList.backgroundColor CGColor]];
    
    [closedMenuShape setBounds:CGRectMake(0.0f, 0.0f, height, width)];
    [closedMenuShape setAnchorPoint:CGPointMake(0.0f, 0.0f)];
    [closedMenuShape setPosition:CGPointMake(0.0f, 0.0f)];
    [openMenuShape removeFromSuperlayer];
    [[[self view] layer] addSublayer:closedMenuShape];
    
}

-(void)navigateToNextScreen {
    [overLayView removeFromSuperview];
    self.contactList.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = CGRectMake(0, (self.contactList.frame.size.height == ([TTMCommon getHeight] - 200)) ? 55 : ((IS_IPHONE5) ? [TTMCommon getHeight] - 300 : [TTMCommon getHeight] - 210), self.contactList.frame.size.width, (self.contactList.frame.size.height == ([TTMCommon getHeight] - 200)) ? [TTMCommon getHeight] : ([TTMCommon getHeight] - 200));
        self.contactList.frame = theFrame;
        [self.contactList setNeedsLayout];
    }];
    [self.footerView removeFromSuperview];
    [self.footerView setFrame:CGRectMake(0, [TTMCommon getHeight] - 50, [TTMCommon getWidth], 50)];
    [self.footerView setBackgroundColor:[UIColor blackColor]];
    [self.navigationController.view addSubview:self.footerView];
    [self.footerView setSelectedImage:[self getImageForSelectedCategory]];
    [self.footerView setSuggestionLabel_string:[self getStringForSelectedCategory]];
    [self.footerView setNeedsLayout];
}
/**
 *  Method is calling for show menu
 */
- (void)showMenu {
    
    TTMTumblrMenuView *menuView = [[TTMTumblrMenuView alloc] init];
    [menuView addMenuItemWithTitle:@"Chat" andIcon:[UIImage imageNamed:@"chat"] andSelectedBlock:^{
        NSLog(@"Text selected");
        // [self.contactList removeFromSuperview];
        self.categoryType = TTMChat;
        [self navigateToNextScreen];
    }];
    //    [menuView addMenuItemWithTitle:@"Friends" andIcon:[UIImage imageNamed:@"friends"] andSelectedBlock:^{
    //        NSLog(@"Photo selected");
    //        self.categoryType = TTMFriendList;
    //        //[self.contactList removeFromSuperview];
    //
    //        [self navigateToNextScreen];
    //
    //    }];
    [menuView addMenuItemWithTitle:@"Message" andIcon:[UIImage imageNamed:@"message"] andSelectedBlock:^{
        NSLog(@"Quote selected");
        // [self.contactList removeFromSuperview];
        self.categoryType = TTMMessage;
        [self navigateToNextScreen];
        
        
    }];
    [menuView addMenuItemWithTitle:@"Picture" andIcon:[UIImage imageNamed:@"picture"] andSelectedBlock:^{
        NSLog(@"Link selected");
        //[self.contactList removeFromSuperview];
        self.categoryType = TTMImages;
        [self navigateToNextScreen];
    }];
    [menuView addMenuItemWithTitle:@"Video" andIcon:[UIImage imageNamed:@"video"] andSelectedBlock:^{
        NSLog(@"Video selected");
        self.categoryType = TTMVideo;
        //[self.contactList removeFromSuperview];
        [self navigateToNextScreen];
    }];
    
    [menuView show];
    [self.contactList removeFromSuperview];
    [self performSelector:@selector(addContactTableView) withObject:nil afterDelay:0.5];
    
}

-(UIImage *)getImageForSelectedCategory {
    switch (self.categoryType) {
        case TTMChat:
            return [UIImage imageNamed:@"chat"];
            break;
        case TTMFriendList:
            return [UIImage imageNamed:@"friends"];
            break;
        case TTMMessage:
            return [UIImage imageNamed:@"message"];
            break;
        case TTMImages:
            return [UIImage imageNamed:@"picture"];
            break;
        case TTMVideo:
            return [UIImage imageNamed:@"video"];
            break;
        default:
            break;
    }
}

-(NSString *)getStringForSelectedCategory {
    switch (self.categoryType) {
        case TTMChat:
            return [NSString stringWithFormat:@"%@",@"Tap a Friend to chat"];
            break;
        case TTMFriendList:
            return [NSString stringWithFormat:@"%@",@"Get friends"];
            break;
        case TTMMessage:
            return [NSString stringWithFormat:@"%@",@"Tap a Friend to message"];
            break;
        case TTMImages:
            return [NSString stringWithFormat:@"%@",@"Tap a Friend to view picture"];
            break;
        case TTMVideo:
            return [NSString stringWithFormat:@"%@",@"Tap a Friend to view video"];
            break;
        default:
            break;
    }
}

-(UIViewController *)getParentViewController {
    
    UIViewController *appRootViewController;
    UIWindow *window;
    
    window = [UIApplication sharedApplication].keyWindow;
    appRootViewController = window.rootViewController;
    
    UIViewController *topViewController = appRootViewController;
    while (topViewController.presentedViewController != nil)
    {
        topViewController = topViewController.presentedViewController;
    }
    return topViewController;
}


-(void)addHeaderViewOnTableView {
    
    UIButton *headerLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.contactList.frame.size.width/2, 29)];
    [headerLabel setTitle:@"Friends" forState:UIControlStateNormal];
    [headerLabel setTitleColor:[UIColor colorWithRed:0/255 green:161.0/255 blue:223/255.0 alpha:1.0] forState:UIControlStateSelected];
    [headerLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headerLabel addTarget:self action:@selector(friendsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerLabel.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [headerLabel setSelected:YES];
    [headerLabel.titleLabel setFont:[UIFont fontWithName:LotoLight size:15.0f]];
    [headerLabel setTag:6789];
    [headerLabel setBackgroundColor:[UIColor blackColor]];
    UILabel *headerLine = [[UILabel alloc] initWithFrame:CGRectMake(headerLabel.frame.size.width - 4,headerLabel.frame.size.height/2 - 10,2,20)];
    [headerLine setBackgroundColor:[UIColor darkGrayColor]];
    [headerLabel addSubview:headerLine];
    [self.contactList addSubview:headerLabel];
    [self.contactList bringSubviewToFront:headerLabel];
    headerLabel = [[UIButton alloc] initWithFrame:CGRectMake(self.contactList.frame.size.width/2, 0, self.contactList.frame.size.width/2, 29)];
    [headerLabel setTitle:@"Groups" forState:UIControlStateNormal];
    [headerLabel setTitleColor:[UIColor colorWithRed:0/255 green:161.0/255 blue:223/255.0 alpha:1.0] forState:UIControlStateSelected];
    [headerLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headerLabel setTag:6799];
    
    [headerLabel.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [headerLabel addTarget:self action:@selector(groupButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerLabel.titleLabel setFont:[UIFont fontWithName:LotoLight size:15.0f]];
    headerLabel.backgroundColor = [UIColor blackColor];
    [self.contactList addSubview:headerLabel];
    [self.contactList bringSubviewToFront:headerLabel];
    
    
}

-(IBAction)addGroupButtonPressed:(id)sender {
    [self.originalContactList removeAllObjects];
    [[TTMMUCManager sharedInstance] createGroups:^(NSMutableArray *groupArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.groupFriends = [NSMutableArray arrayWithArray:groupArray];
            NSLog(@"Group Array : %@",groupArray);
            [self.contactList.contactList reloadData];
        });
    }];
}
-(IBAction)groupButtonAction:(id)sender {
    UIButton *friendButton = (UIButton *)[self.contactList viewWithTag:6789];
    UIButton *groupButton = (UIButton *)[self.contactList viewWithTag:6799];
    [friendButton setSelected:NO];
    [groupButton setSelected:YES];
    //[self.originalContactList removeAllObjects];
    [[TTMMUCManager sharedInstance]  askForCreatedGroup:^(NSMutableArray *groupArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.groupFriends = [NSMutableArray arrayWithArray:groupArray];
            [self.contactList.contactList reloadData];
        });
    }];
    
}

-(IBAction)friendsButtonAction:(id)sender {
    UIButton *friendButton = (UIButton *)[self.contactList viewWithTag:6789];
    UIButton *groupButton = (UIButton *)[self.contactList viewWithTag:6799];
    [friendButton setSelected:YES];
    [groupButton setSelected:NO];
    
    self.originalContactList = [NSMutableArray arrayWithArray:self.onlineFriendsGroup];
    [self.contactList.contactList reloadData];
    
}

-(void)callFriendSyncService {
    NSMutableDictionary *originalDict = [NSMutableDictionary dictionary];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"];

    [originalDict setObject:userId forKey:@"userId"];
    TTMBaseParser *parser =  [[TTMBaseParser alloc] init];
    [parser serviceWithArgument:originalDict serviceType:TTMGetContactSyncService callBackResponse:^(id response, NSError *error) {
        if([response isKindOfClass:[NSDictionary class]]) {
            NSString *timeStamp = [response objectForKey:@"frTimeStamp"];
            NSMutableArray *contactListArray = [response objectForKey:@"friendList"];
            [contactListArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSMutableDictionary *dict = [contactListArray objectAtIndex:idx];
                TTMMatchedContact *matchedContact = [[TTMMatchedContact alloc] init];
                [matchedContact setName:[TTMCommon fetchNameFromPhNumber:[dict valueForKey:@"phone"]]];
                [matchedContact setEmail_Id:[dict valueForKey:@"email"]];
                [matchedContact setPhone:[dict valueForKey:@"phone"]];
                [matchedContact setFrTimeStamp:timeStamp];
                [matchedContact setFrTimeZone:[dict valueForKey:@"timeZone"]];
                
                TTMContactInformation *contactInfo = [[TTMContactInformation alloc] init];
                [contactInfo setContactEmail:[NSString stringWithFormat:@"%@",matchedContact.email_Id]];
                [contactInfo setContactName:[NSString stringWithFormat:@"%@",matchedContact.name]];
                [contactInfo setContactNumber:[NSString stringWithFormat:@"%@",matchedContact.phone]];
                [contactInfo setContactTimeZone:[NSString stringWithFormat:@"%@",matchedContact.frTimeZone]];
                [contactInfo setContactType:[NSString stringWithFormat:@"%@",@"0"]];
                [contactInfo setContactStatus:[NSString stringWithFormat:@"%@",@"1"]];
                [contactInfo setSettingType:[NSString stringWithFormat:@"%@",@"1"]];
                [contactInfo setTime:[NSString stringWithFormat:@"%@",@"1"]];
                [contactInfo setContactImage:nil];
                TTMDataBaseManager *dataBaseManager = [TTMDataBaseManager sharedMySingleton];
                [dataBaseManager initializeTheCoreDataModelClasses];
                BOOL isInfoSaved = [dataBaseManager addContactInformation:contactInfo];
                NSLog(@"isInfoSaved isInfoSaved %d", isInfoSaved);
                
            }];
            self.onlineFriendsGroup = [self.originalContactList copy];
            [self.contactList.contactList reloadData];
        }
    }];
}

-(void)addContactTableView {
    
    self.contactList = [[TTMContactListView alloc] initWithFrame:CGRectMake(0, ((IS_IPHONE5) ? [TTMCommon getHeight] - 320 : [TTMCommon getHeight] - 230), [TTMCommon getWidth], [TTMCommon getHeight] - 200)];
    [[self getParentViewController].view addSubview:self.contactList];
    [self.contactList setBackgroundColor:[UIColor colorWithRed:16.0/255.0f green:16.0/255.0f blue:16.0/255.0f alpha:1.0f]];
    [self addHeaderViewOnTableView];
    __weak typeof(self) weakSelf = self;
    if([[self getContactFromDatBase] count]){
        [self callFriendSyncService];
        [self.contactList setRefrenceForDataLoading:self completionCallBackBlock:^(NSMutableArray *dataArray) {
            
        } ];
        self.onlineFriendsGroup = [self.originalContactList copy];
        [self.contactList.contactList reloadData];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contactList.contactList reloadData];
        });
    }else {
        [self.contactList setRefrenceForDataLoading:self completionCallBackBlock:^(NSMutableArray *dataArray) {
            weakSelf.dataArray = dataArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[TTMActivityIndicator sharedMySingleton] addIndicator:weakSelf.navigationController.view];
            });
            [weakSelf callFetchContactservice];
        }];
    }
    self.contactList.userInteractionEnabled = !isFirstTime;
    if(isFirstTime)
        [self.contactList addSubview:overLayView];
    isFirstTime = NO;
    
}
-(NSMutableArray *)makeDictionaryFromArray {
    NSMutableArray *dataArray = [NSMutableArray array];
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TTMContactsFetch *contact = [self.dataArray objectAtIndex:idx];
        NSMutableDictionary *contactDictionary = [NSMutableDictionary dictionary];
        //[contactDictionary setObject:@"9958573454" forKey:@"phone"];
        //[contactDictionary setObject:@"amit" forKey:@"name"];
        NSString *strNew = [contact.phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
        strNew = [strNew stringByReplacingOccurrencesOfString:@")" withString:@""];
        strNew = [strNew stringByReplacingOccurrencesOfString:@" " withString:@""];
        strNew = [strNew stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if(contact.personImage)
        [self.contactDictionary setObject:contact.personImage forKey:strNew];
        if(strNew) {
            [contactDictionary setObject:strNew forKey:@"phone"];
            [contactDictionary setObject:contact.name forKey:@"name"];
            [dataArray addObject:contactDictionary];
        }
        NSData *imageData = UIImageJPEGRepresentation(contact.personImage, 0.3);
        NSTimeZone *localTime = [NSTimeZone systemTimeZone];
        TTMContactInformation *contactInfo = [[TTMContactInformation alloc] init];
        [contactInfo setContactEmail:[NSString stringWithFormat:@"%@",contact.email]];
        [contactInfo setContactName:[NSString stringWithFormat:@"%@",contact.name]];
        [contactInfo setContactNumber:[NSString stringWithFormat:@"%@",strNew]];
        [contactInfo setContactTimeZone:[NSString stringWithFormat:@"%@",localTime.name]];
        [contactInfo setContactType:[NSString stringWithFormat:@"%@",@"0"]];
        [contactInfo setContactStatus:[NSString stringWithFormat:@"%@",@"1"]];
        [contactInfo setSettingType:[NSString stringWithFormat:@"%@",@"1"]];
        [contactInfo setTime:[NSString stringWithFormat:@"%@",@"1"]];
        [contactInfo setContactImage:imageData];
//        TTMDataBaseManager *dataBaseManager = [TTMDataBaseManager sharedMySingleton];
//        [dataBaseManager initializeTheCoreDataModelClasses];
//        BOOL isInfoSaved = [dataBaseManager addContactInformation:contactInfo];
//        NSLog(@"isInfoSaved isInfoSaved %d", isInfoSaved);
    }];
    NSLog(@"self.contactDictionary %@", self.contactDictionary);
    return dataArray;
}

-(void)callFetchContactservice {
    
    NSMutableDictionary *originalDict = [NSMutableDictionary dictionary];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"];
    [originalDict setObject:[self makeDictionaryFromArray] forKey:@"contactList"];
    [originalDict setObject:userId forKey:@"userId"];
    TTMBaseParser *parser =  [[TTMBaseParser alloc] init];
    [parser serviceWithArgument:originalDict serviceType:TTMGetContactService callBackResponse:^(id response, NSError *error) {
        NSLog(@"Response is %@", response);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[TTMActivityIndicator sharedMySingleton] removeIndicator:self.navigationController.view];
            if([response isKindOfClass:[NSDictionary class]]) {
                NSString *timeStamp = [response objectForKey:@"frTimeStamp"];
                NSMutableArray *contactListArray = [response objectForKey:@"friendList"];
                [contactListArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSMutableDictionary *dict = [contactListArray objectAtIndex:idx];
                    TTMMatchedContact *matchedContact = [[TTMMatchedContact alloc] init];
                    [matchedContact setName:[TTMCommon fetchNameFromPhNumber:[dict valueForKey:@"phone"]]];
                    [matchedContact setEmail_Id:[dict valueForKey:@"email"]];
                    [matchedContact setPhone:[dict valueForKey:@"phone"]];
                    [matchedContact setFrTimeStamp:timeStamp];
                    [matchedContact setFrTimeZone:[dict valueForKey:@"timeZone"]];

                    [self.originalContactList addObject:matchedContact];
                    TTMContactInformation *contactInfo = [[TTMContactInformation alloc] init];
                    [contactInfo setContactEmail:[NSString stringWithFormat:@"%@",matchedContact.email_Id]];
                    [contactInfo setContactName:[NSString stringWithFormat:@"%@",matchedContact.name]];
                    [contactInfo setContactNumber:[NSString stringWithFormat:@"%@",matchedContact.phone]];
                    [contactInfo setContactTimeZone:[NSString stringWithFormat:@"%@",matchedContact.frTimeZone]];
                    [contactInfo setContactType:[NSString stringWithFormat:@"%@",@"0"]];
                    [contactInfo setContactStatus:[NSString stringWithFormat:@"%@",@"1"]];
                    [contactInfo setSettingType:[NSString stringWithFormat:@"%@",@"1"]];
                    [contactInfo setTime:[NSString stringWithFormat:@"%@",@"1"]];
                    [contactInfo setContactImage:nil];
                    TTMDataBaseManager *dataBaseManager = [TTMDataBaseManager sharedMySingleton];
                    [dataBaseManager initializeTheCoreDataModelClasses];
                    BOOL isInfoSaved = [dataBaseManager addContactInformation:contactInfo];
                    NSLog(@"isInfoSaved isInfoSaved %d", isInfoSaved);
                    
                }];
                self.onlineFriendsGroup = [self.originalContactList copy];
                [self.contactList.contactList reloadData];
            }
        });
        if([response isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
    }];
}

-(NSMutableArray *)getContactFromDatBase {
    
    NSMutableArray *contactInfoArray = [NSMutableArray array];
    TTMDataBaseManager *dataBaseManager = [TTMDataBaseManager sharedMySingleton];
    [dataBaseManager initializeTheCoreDataModelClasses];
    NSMutableArray *contactArray = [dataBaseManager fetchContactInfo];
    [self.originalContactList removeAllObjects];
    [contactArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ContactInfo *contactInfo = [contactArray objectAtIndex:idx];

        TTMMatchedContact *matchedContact = [[TTMMatchedContact alloc] init];
        [matchedContact setName:contactInfo.contactName];
        [matchedContact setEmail_Id:contactInfo.contactEmail];
        [matchedContact setPhone:contactInfo.contactNumber];
        [matchedContact setFrTimeStamp:contactInfo.time];
        [matchedContact setFrTimeZone:contactInfo.contactTimeZone];
        [contactInfoArray addObject:matchedContact];
        [self.originalContactList addObject:matchedContact];
    }];
    return contactInfoArray;
}

-(void)iconButtonAction:(id)sender {
    
    TTMChatView *chatView = (TTMChatView *)[[self getParentViewController].view viewWithTag:5678];
    [chatView setFrame:CGRectMake(0, [TTMCommon getHeight], [TTMCommon getWidth], 0)];
    [chatView removeFromSuperview];
}

-(void)addHeaderView:(UIView *)containerView1 userInfo:(TTMMatchedContact *)contact {
    
    TTMChatNavigationView *headerView = [[TTMChatNavigationView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [headerView setContactInfo:contact];
    [headerView setDelegate:(id)self];
    [headerView addProfileInfoLabel];
    [headerView setBackgroundColor:[UIColor blackColor]];
    [containerView1 addSubview:headerView];
    [containerView1 setNeedsLayout];
}

-(void)attachmentButtonAction:(id)sender {
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:(id)self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Open Camera",
                            @"Open Library",
                            nil];
    popup.tag = 1233;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)cameraOpen {
    
    [self actionLaunchAppCamera];
}

-(void)libraryOpen {
    [self actionLaunchAppLibrary];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
-(void)actionLaunchAppLibrary
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = (id)self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    
    [self presentModalViewController:imagePicker animated:YES];
}

-(void)actionLaunchAppCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = (id)self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        
        [self presentModalViewController:imagePicker animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                       message:@"Unable to find a camera on your device."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
    
}
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (popup.tag == 1234) {
        switch (buttonIndex) {
            case 2:
                [popup dismissWithClickedButtonIndex:0 animated:YES];
                break;
            case 1:{
                TTMFriendListToInviteViewController *friendListVC = [[TTMFriendListToInviteViewController alloc]init];
                friendListVC.originalContactList = [self originalContactList];
                friendListVC.onlineFriends = [self onlineFriends];
                friendListVC.currentRoom = (Room *)[self.groupFriends objectAtIndex:idxPath.row];
                UINavigationController *conversation = [[UINavigationController alloc] initWithRootViewController:friendListVC];
                //[friendListVC showConversationForJIDString:[NSString stringWithFormat:@"%@",@"9716145332_hello@conference.ttmachine.no-ip.org"]];
                
                NSLog(@"Current Room : %@",[NSString stringWithFormat:@"%@", ((Room *)[self.groupFriends objectAtIndex:idxPath.row]).roomJID]);
                [friendListVC showConversationForJIDString:[NSString stringWithFormat:@"%@", ((Room *)[self.groupFriends objectAtIndex:idxPath.row]).roomJID]];
                [self presentViewController:conversation animated:YES completion:^{
                    
                }];
            }
                break;
            case 0:
            {
                Room *roomGroup = [self.groupFriends objectAtIndex:idxPath.row];
                NSLog(@"contactcontact %@ ", roomGroup.roomJID);
                [self addChatViewWIthSpecificGroup:roomGroup];
            }

                break;
            default:
                break;
        }

    }else if(popup.tag == 1233){
        switch (buttonIndex) {
            case 2:
                [popup dismissWithClickedButtonIndex:0 animated:YES];
                break;
            case 1:
                [self libraryOpen];
                break;
            case 0:
                [self cameraOpen];
                break;
            default:
                break;
        }
    }
}

-(TTMChatView *)chatView {
    if(!_chatView) {
        _chatView = [[TTMChatView alloc] initWithFrame:CGRectMake(0, 50, [TTMCommon getWidth], [TTMCommon getHeight])];
    }
    return _chatView;
}



-(void)addChatViewWIthSpecificUser:(TTMMatchedContact *)user {
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([[self appDelegate] connect]) {
        
        self.chatView.frame = CGRectMake(0, 55, [TTMCommon getWidth], [TTMCommon getHeight] - 45);
        self.chatView.delegate = (id)self;
        
        TTMConversationViewController *conversationVC = [[TTMConversationViewController alloc]init];
        conversationVC.chatType = @"chat";
        [conversationVC setUserName:user.name];
        [conversationVC setCategorySelected:self.categoryType];
        UINavigationController *conversation = [[UINavigationController alloc] initWithRootViewController:conversationVC];
        [conversationVC showConversationForJIDString:[NSString stringWithFormat:@"%@%@%@",user.phone,@"@",[TTMCommon getChatServerStaticIPName]]];
        [self presentViewController:conversation animated:YES completion:^{
            
        }];
        
        
    }
}

-(void)addChatViewWIthSpecificGroup:(Room *)groupRoom {
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([[self appDelegate] connect]) {
        
        self.chatView.frame = CGRectMake(0, 55, [TTMCommon getWidth], [TTMCommon getHeight] - 45);
        self.chatView.delegate = (id)self;
        NSLog(@"groupRoom.roomJIDgroupRoom.roomJID %@", groupRoom.roomJID);
        [[[TTMMUCManager sharedInstance] currentRoom] joinRoomUsingNickname:@"9818677706" history:nil];
        TTMConversationViewController *conversationVC = [[TTMConversationViewController alloc]init];
        [conversationVC setCategorySelected:self.categoryType];
        conversationVC.chatType = @"groupchat";
        conversationVC.currentRoomCVC = [[TTMMUCManager sharedInstance]  currentRoom];
        UINavigationController *conversation = [[UINavigationController alloc] initWithRootViewController:conversationVC];
        [conversationVC showConversationForJIDString:[NSString stringWithFormat:@"%@",groupRoom.roomJID]];
        [self presentViewController:conversation animated:YES completion:^{
            
        }];
        
        
    }
}

-(BOOL)isGroupButtonSelected{
    
    UIButton *groupButton = (UIButton *)[self.contactList viewWithTag:6799];
    //NSLog(@"Group Button Selected %d", [groupButton isSelected]);
    return [groupButton isSelected];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Number of rows %d", ([self isGroupButtonSelected]) ? [self.groupFriends count] + 1: [self.originalContactList count]);
    // Return the number of rows in the section.
    return ([self isGroupButtonSelected]) ? [self.groupFriends count] + 1: [self.originalContactList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    TTMContactCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[TTMContactCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [footerButton setTitle:@"Add Group" forState:UIControlStateNormal];
        [cell.contentView addSubview:footerButton];
        [footerButton setTag:7890];
        [footerButton setFrame:cell.frame];
    }
    UIButton *button = (UIButton  *)[cell.contentView viewWithTag:7890];
    [button setHidden:YES];
    [cell.connectionImage setHidden:NO];
    
    if(![self isGroupButtonSelected]) {
        TTMMatchedContact *contact = [self.originalContactList objectAtIndex:indexPath.row];
        // Configure the cell...
        cell.name.text = contact.name;
        cell.subTitle.text = contact.phone;
        cell.deviceIdentifier.text = @"Mobile";
        [cell.statusSymbol setImage:([self.onlineFriends containsObject:[NSString stringWithFormat:@"%@%@%@", contact.phone, @"@",[TTMCommon getChatServerHostName]]]) ? [UIImage imageNamed:@"pin_green.png"] : [UIImage imageNamed:@"pin_red.png"]];
        NSLog(@"kjdshgkjfdhgjkdfjghkjdfh %@", [self.contactDictionary objectForKey:contact.phone]);
        [cell setPersonImage:[self.contactDictionary objectForKey:contact.phone]];
    }else {
        [cell.connectionImage setHidden:YES];
        if([self.groupFriends count] > indexPath.row) {
            Room *roomsCreated = [self.groupFriends objectAtIndex:indexPath.row];
            cell.name.text = roomsCreated.name;
            cell.subTitle.text = @"";
            cell.deviceIdentifier.text = @"";
            [cell.statusSymbol setImage:[UIImage imageNamed:@""]];
        }else {
            [button setHidden:NO];
            [button setBackgroundColor:[UIColor colorWithRed:87.0/255.0f green:208.0/255.0f blue:59.0/255.0f alpha:1.0f]];
            [button addTarget:self action:@selector(addGroupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.name.text = @"";
            cell.subTitle.text = @"";
            cell.deviceIdentifier.text = @"Mobile";
            [cell.statusSymbol setImage:[UIImage imageNamed:@""]];
            [cell.connectionImage setHidden:YES];
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[self.footerView removeFromSuperview];
    self.arrowType = (self.contactList.frame.size.height == ([TTMCommon getHeight] - 200)) ? TTMDownword : TTMUpwordArrow;
    [openMenuShape removeFromSuperlayer];
    [self performSelector:@selector(drawOpenLayer) withObject:nil afterDelay:0.2];
    [UIView animateWithDuration:.3f animations:^{
        
        CGRect theFrame = CGRectMake(0, (self.contactList.frame.size.height == ([TTMCommon getHeight] - 200)) ? 46 : ((IS_IPHONE5) ? [TTMCommon getHeight] - 320 : [TTMCommon getHeight] - 230), self.contactList.frame.size.width, (self.contactList.frame.size.height == ([TTMCommon getHeight] - 200)) ? [TTMCommon getHeight] : ([TTMCommon getHeight] - 200));
        self.contactList.frame = theFrame;
        [self.contactList setNeedsLayout];
    }];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chatView removeFromSuperview];
        self.chatView = nil;
        if([self isGroupButtonSelected]) {
            
            Room *roomGroup = [self.groupFriends objectAtIndex:idxPath.row];
            NSLog(@"contact  %@  contact  ", roomGroup.roomJID);
            idxPath = indexPath;
            [self askToAddFriedOrChat:nil];
            
            //Need to open Friend list
            
            
        }else {
            TTMMatchedContact *contact = [self.originalContactList objectAtIndex:indexPath.row];
            NSLog(@"contactcontact %@", contact.email_Id);
            
            [self addChatViewWIthSpecificUser:contact];
        }
    });
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
    
    //    UILabel *headerLine = [[UILabel alloc] initWithFrame:CGRectMake(headerView.frame.size.width/2 - 5,0,2,20)];
    //    [headerLine setBackgroundColor:[UIColor darkGrayColor]];
    //    [headerView addSubview:headerLine];
    
    //    UIButton *headerLabel = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, headerView.frame.size.width-200.0, headerView.frame.size.height)];
    //    [headerLabel setTitle:@"Friends" forState:UIControlStateNormal];
    //    [headerLabel.titleLabel setTextColor:[UIColor whiteColor]];
    //    [headerLabel.titleLabel setTextAlignment:NSTextAlignmentLeft];
    //    [headerLabel.titleLabel setFont:[UIFont fontWithName:LotoLight size:12.0f]];
    //    headerLabel.backgroundColor = [UIColor clearColor];
    //
    //    [headerView addSubview:headerLabel];
    //
    //    headerLabel = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width/2 + 20, 10, headerView.frame.size.width-200.0, headerView.frame.size.height)];
    //    [headerLabel setTitle:@"Groups" forState:UIControlStateNormal];
    //    [headerLabel.titleLabel setTextColor:[UIColor whiteColor]];
    //    [headerLabel.titleLabel setTextAlignment:NSTextAlignmentLeft];
    //    [headerLabel.titleLabel setFont:[UIFont fontWithName:LotoLight size:12.0f]];
    //    headerLabel.backgroundColor = [UIColor clearColor];
    //
    //    [headerView addSubview:headerLabel];
    return headerView;
    
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  35.0;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)askToAddFriedOrChat : (NSString *)group{
    
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:(id)self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Chat",
                            @"Invite Friends",
                            nil];
    popup.tag = 1234;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
    /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select option for " message:group delegate:self cancelButtonTitle:@"Invite Friends" otherButtonTitles:@"Chat", nil];
     
     [alert show];*/
}
/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==  0) {
        TTMFriendListToInviteViewController *friendListVC = [[TTMFriendListToInviteViewController alloc]init];
        friendListVC.originalContactList = [self originalContactList];
        UINavigationController *conversation = [[UINavigationController alloc] initWithRootViewController:friendListVC];
        [friendListVC showConversationForJIDString:[NSString stringWithFormat:@"%@",@"9716145332_hello@conference.ttmachine.no-ip.org"]];
        [self presentViewController:conversation animated:YES completion:^{
            
        }];
        
    }else if(buttonIndex == 1){
        Room *roomGroup = [self.groupFriends objectAtIndex:idxPath.row];
        NSLog(@"contactcontact %@ ", roomGroup.roomJID);
        [self addChatViewWIthSpecificGroup:roomGroup];
    }
}*/
@end
