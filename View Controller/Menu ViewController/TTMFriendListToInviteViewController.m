//
//  TTMFriendListToInviteViewController.m
//  TextTimeMachine
//
//  Created by essadmin on 5/23/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMFriendListToInviteViewController.h"

@interface TTMFriendListToInviteViewController ()

@end

@implementation TTMFriendListToInviteViewController
@synthesize originalContactList = _originalContactList;
@synthesize onlineFriends = _onlineFriends;
@synthesize dataArray = _dataArray;
@synthesize onlineFriendsGroup = _onlineFriendsGroup;
//@synthesize  mucManager = _mucManager;
@synthesize currentRoom = _currentRoom;
CAShapeLayer *openMenuShape;
CAShapeLayer *closedMenuShape;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIBarButtonItem *)backButton
{
    UIImage *image = [UIImage imageNamed:@"logo"];
    CGRect buttonFrame = CGRectMake(0, 5, 35, 35);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}

- (UIBarButtonItem *)inviteFriendButton
{
    UIImage *image = [UIImage imageNamed:@"friends_add.png"];
    CGRect buttonFrame = CGRectMake(0, 5, 35, 35);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:self action:@selector(inviteFriend:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

- (IBAction)inviteFriend:(id)sender{
    NSArray *selectedIndexPaths = [[NSArray alloc]init];
    selectedIndexPaths = [self.contactList.contactList indexPathsForSelectedRows];
    NSLog(@"%@",selectedIndexPaths);
    if ([selectedIndexPaths count]>0) {
        for (int count = 0 ; count < [selectedIndexPaths count]; count++) {
            
            NSIndexPath *idexPath =[selectedIndexPaths objectAtIndex:count];
            TTMMatchedContact *contact = [self.originalContactList objectAtIndex:idexPath.row];
            NSString *jidStr = [NSString stringWithFormat:@"%@@%@",contact.phone,ChatServerAddress];
            XMPPJID *jid = [XMPPJID jidWithString:jidStr];
            //[[self mucManager] invitSelectedUserIntoGroup:contact.phone];
            [[[TTMMUCManager sharedInstance] currentRoom] inviteUser:jid withMessage:@"Please join my room."];
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }
    }else{
        [TTMCommon alertDisplay:@"Please select friend to invite"];
    }
    
}
-(IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        }];
}

-(void)showConversationForJIDString:(NSString *)jidString
{
    self.conversationJidString = jidString;
    self.cleanName = [jidString stringByReplacingOccurrencesOfString:kXMPPServer withString:@""];
    self.cleanName=[self.cleanName stringByReplacingOccurrencesOfString:@"@" withString:@""];
    self.statusLabel.text = self.cleanName;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.conversationJidString;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:13.0], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    self.navigationItem.leftBarButtonItem=[self backButton];
    self.navigationItem.rightBarButtonItem = [self inviteFriendButton];
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        //self.navigationController.navigationBar.translucent = NO;
    }else {
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
    
    TTMOnlineBuddy *onlineBuddy = [[TTMOnlineBuddy alloc] init];
    [onlineBuddy getOnlineFriend:^(NSMutableArray *list) {
        NSLog(@"Online friend %@", list);
        self.onlineFriends = list;
        [self.contactList.contactList reloadData];
    }];
    
    [self performSelector:@selector(addContactTableView) withObject:nil afterDelay:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)addContactTableView {
    //NSLog(@"%d",)
    // self.contactList = [[TTMContactListView alloc] initWithFrame:CGRectMake(0, ((IS_IPHONE5) ? [TTMCommon getHeight] - 500 : [TTMCommon getHeight] - 230), [TTMCommon getWidth], [TTMCommon getHeight])];
    
    self.contactList = [[TTMContactListView alloc] initWithFrame:CGRectMake(0, 0, [TTMCommon getWidth], [TTMCommon getHeight])];
    self.contactList.contactList.allowsMultipleSelection = YES;
    
    //self.contactList.contactList.bounces = NO;
    [self.view addSubview:self.contactList];
    // [[self getParentViewController].view addSubview:self.contactList];
    [self.contactList setBackgroundColor:[UIColor colorWithRed:16.0/255.0f green:16.0/255.0f blue:16.0/255.0f alpha:1.0f]];
    __weak typeof(self) weakSelf = self;
    [self.contactList setRefrenceForDataLoading:self completionCallBackBlock:^(NSMutableArray *dataArray) {
        weakSelf.dataArray = dataArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // [[TTMActivityIndicator sharedMySingleton] addIndicator:weakSelf.navigationController.view];
        });
    }];
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

- (TTMAppDelegate *)appDelegate {
	return (TTMAppDelegate *)[[UIApplication sharedApplication] delegate];
}
-(NSMutableArray *)originalContactList {
    if(!_originalContactList) {
        _originalContactList = [[NSMutableArray alloc] init];
    }
    return _originalContactList;
}

-(NSMutableArray *)onlineFriends {
    if(!_onlineFriends) {
        _onlineFriends = [[NSMutableArray alloc] init];
    }
    return _onlineFriends;
}
-(NSMutableArray *)onlineFriendsGroup {
    if(!_onlineFriendsGroup) {
        _onlineFriendsGroup = [[NSMutableArray alloc] init];
    }
    return _onlineFriendsGroup;
}
-(NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(NSMutableArray *)selectedFriend {
    if(!_selectedFriend) {
        _selectedFriend = [[NSMutableArray alloc] init];
    }
    return _selectedFriend;
}

/*
 -(TTMMUCManager *)mucManager {
 if(!_mucManager) {
 _mucManager = [[TTMMUCManager alloc] init] ;
 }
 return _mucManager;
 }
 */
#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"original contactlist count %d",[self.originalContactList count]);
    return [self.originalContactList count];
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
    
    TTMMatchedContact *contact = (TTMMatchedContact*) [self.originalContactList objectAtIndex:indexPath.row];
    // Configure the cell...
    NSLog(@"%@",contact.name);
    cell.name.text = contact.name;
    //NSLog(@"%@",contact.phone);
    cell.subTitle.text = contact.phone;
    cell.deviceIdentifier.text = @"Mobile";
    [cell.statusSymbol setImage:([self.onlineFriends containsObject:[NSString stringWithFormat:@"%@%@%@", contact.phone, @"@",[TTMCommon getChatServerHostName]]]) ? [UIImage imageNamed:@"pin_green.png"] : [UIImage imageNamed:@"pin_red.png"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
      /*  TTMMatchedContact *contact = [self.originalContactList objectAtIndex:indexPath.row];
        NSString *jidStr = [NSString stringWithFormat:@"%@@%@",contact.phone,ChatServerAddress];
        XMPPJID *jid = [XMPPJID jidWithString:jidStr];
        //[[self mucManager] invitSelectedUserIntoGroup:contact.phone];
        [[[TTMMUCManager sharedInstance] currentRoom] inviteUser:jid withMessage:@"Please join my room."];*/

    }
    
    /*  dispatch_async(dispatch_get_main_queue(), ^{
     {
     TTMMatchedContact *contact = [self.originalContactList objectAtIndex:indexPath.row];
     [[self selectedFriend] addObject:contact];
     if (!contact.isInvited) {
     contact.isInvited = true;
     NSLog(@"contactcontact %@", contact.email_Id);
     //XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",contact.phone,ChatServerAddress]];
     [[self mucManager] invitSelectedUserIntoGroup:contact.phone];
     }else{
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Already invided for Current group" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
     [alert show];
     }
     }
     });*/
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,20)];
    
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
    
    return  28.0;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}



@end
