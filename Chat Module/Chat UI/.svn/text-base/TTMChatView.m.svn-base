//
//  TTMChatView.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/14/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//
#define FONT_SIZE 11.0f
#define CELL_CONTENT_WIDTH 250.0f
#define CELL_CONTENT_MARGIN 11.0f

#import "TTMChatView.h"
#import "XMPP.h"
#import "TTMLine.h"
#import "TTMChatCustonCell.h"
#import "TTMAppDelegate.h"
#import "NSString+Utils.h"
#import "NSArray+DSReverseArray.h"

@implementation TTMChatView

@synthesize messageField = _messageField, chatWithUser, tView = _tView;
@synthesize sendButton = _sendButton;
@synthesize messages = _messages;
@synthesize delegate = _delegate;
@synthesize contactInfo = _contactInfo;

/*
 @Message text field initialization
 */
-(UITextField *)messageField {
    if(!_messageField) {
        _messageField = [[UITextField alloc] initWithFrame:CGRectMake(5, self.frame.size.height - 40, self.frame.size.width - 50, 30)];
        [_messageField setBorderStyle:UITextBorderStyleRoundedRect];
    }
    return _messageField;
}
/*
 @Send Button initialization
 */
-(UIButton *)sendButton {
    
    if(!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [_sendButton setFrame:CGRectMake(self.messageField.frame.size.width + 5, self.frame.size.height - 40, 45, 30)];
    return _sendButton;
}

/*
 @UITableView initialization
 */
-(UITableView *)tView {
    if(!_tView) {
        
        _tView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 325, self.frame.size.height - 80)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
        [_tView addGestureRecognizer:tap];
    }
    turnSockets = [[NSMutableArray alloc] init];
    _tView.dataSource = (id)self;
    _tView.delegate = (id)self;
    _tView.backgroundColor = [UIColor clearColor];
    _tView.pagingEnabled = YES;
    [_tView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    return _tView;
}
/*
 @Message Array allocation
 */
-(NSMutableArray *)messages {
    if(!_messages) {
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages;
}

/*
 @Chat view frame initialization
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        [self addSubview:self.tView];
        //[self addSubview:self.messageField];
        self.messageField.delegate = (id)self;
        [self.messageField setReturnKeyType:UIReturnKeySend];
        //[self addSubview:self.sendButton];
        [self.sendButton setTitle:@"" forState:UIControlStateNormal];
        [self.sendButton setBackgroundImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
        [self.sendButton setBackgroundColor:[UIColor clearColor]];
        [self.sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        TTMAppDelegate *del = [self appDelegate];
        del.messageDelegate = self;
        [self startChatWithSpecificUser:self.chatWithUser];
        //[self addSubview:self.expandableButton];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustFrameOnViewLoad:) name:@"AdjustFrame" object:nil];
        [self addKeyBoardView:self];
    }
    return self;
}
-(void)addKeyBoardView:(UIView *)addView {
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 50, 320, 40)];
    
	textView = [[TTMGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240, 40)];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
	textView.returnKeyType = UIReturnKeySend; //just as an example
	textView.font = [UIFont systemFontOfSize:15.0f];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor blackColor];
    textView.placeholder = @"Enter message";
    textView.textColor =[UIColor colorWithRed:0/255.0 green:161.0/255.0 blue:224.0/255.0 alpha:1.0f];
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    [addView addSubview:containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, 248, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:textView];
    [containerView addSubview:entryImageView];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(containerView.frame.size.width - 58, 3, [UIImage imageNamed:@"record"].size.width, [UIImage imageNamed:@"record"].size.height);
    //doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"record"] forState:UIControlStateSelected];
	[containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}
-(void)resignTextView
{
	//[textView resignFirstResponder];
    [self sendButtonAction:nil];
}
- (void)growingTextViewDidEndEditing:(TTMGrowingTextView *)growingTextView {

}

- (BOOL)growingTextView:(TTMGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
 // good tester function - thanks
 {
    
    if([text isEqualToString:@"\n"]) {
        [self sendButtonAction:nil];

        return NO;
    }else{
    }
    
    return YES;
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height) - 10;
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	containerView.frame = containerFrame;
    
	CGSize keyboardSize = [[[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	// commit animations
	[UIView commitAnimations];
    self.tView.frame =  CGRectMake(0, 40, 325, self.frame.size.height - 80 - keyboardSize.height);
            if([self.messages count]) {
                
            int lastRowNumber = (int) [self.tView numberOfRowsInSection:0] - 1;
            NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
    
        	[self.tView scrollToRowAtIndexPath:ip
        					  atScrollPosition:UITableViewScrollPositionTop
        							  animated:YES];
        }
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	containerView.frame = containerFrame;
	self.tView.frame =  CGRectMake(0, 40, 325, self.frame.size.height - 80);
	// commit animations
	[UIView commitAnimations];
    if([self.messages count]) {
        int lastRowNumber = (int) [self.tView numberOfRowsInSection:0] - 1;
        NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [self.tView scrollToRowAtIndexPath:ip
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
    }
}

- (void)growingTextView:(TTMGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
}
-(void) didTapOnTableView:(UIGestureRecognizer*) recognizer {
    
    [textView resignFirstResponder];
    if([self.messageField isFirstResponder]) {
        
        [self.messageField resignFirstResponder];
        [self.messageField setFrame:CGRectMake(0, self.frame.size.height - 40, self.messageField.frame.size.width, self.messageField.frame.size.height)];
        [self.sendButton setFrame:CGRectMake(self.messageField.frame.size.width + 5, self.frame.size.height - 40, self.sendButton.frame.size.width, self.sendButton.frame.size.height)];
    }
}

//- (void)keyboardWillShow:(NSNotification *)note {
//    [UIView animateWithDuration:.0f animations:^{
//        CGSize keyboardSize = [[[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//
//    [self.messageField setFrame:CGRectMake(0, self.frame.size.height - keyboardSize.height - 38, self.messageField.frame.size.width, self.messageField.frame.size.height)];
//    [self.sendButton setFrame:CGRectMake(self.messageField.frame.size.width + 5, self.frame.size.height - keyboardSize.height - 38, self.sendButton.frame.size.width, self.sendButton.frame.size.height)];
//        self.tView.frame =  CGRectMake(0, 40, 325, self.frame.size.height - 80 - keyboardSize.height);
//        if([self.messages count]) {
//        int lastRowNumber = [self.tView numberOfRowsInSection:0] - 1;
//        NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
//        
//    	[self.tView scrollToRowAtIndexPath:ip
//    					  atScrollPosition:UITableViewScrollPositionTop
//    							  animated:YES];
//        }
//    }];
//}
//
//- (void)keyboardWillHide:(NSNotification *)note {
//    //[UIView animateWithDuration:.0f animations:^{
//        
//        [self.messageField setFrame:CGRectMake(0, self.frame.size.height - 40, self.messageField.frame.size.width, self.messageField.frame.size.height)];
//        [self.sendButton setFrame:CGRectMake(self.messageField.frame.size.width + 5, self.frame.size.height - 40, self.sendButton.frame.size.width, self.sendButton.frame.size.height)];
//    self.tView.frame =  CGRectMake(0, 40, 325, self.frame.size.height - 80);
//    if([self.messages count]) {
//
//    int lastRowNumber = [self.tView numberOfRowsInSection:0] - 1;
//    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
//    
//    [self.tView scrollToRowAtIndexPath:ip
//                      atScrollPosition:UITableViewScrollPositionTop
//                              animated:YES];
//    }
//   // }];
//}

/*
 @Expandble caht view  action
 */

-(IBAction)chatexpandAbleButtonPressed:(id)sender {
    
    UIButton *tempChatButton = (UIButton *)sender;
    if([self.delegate respondsToSelector:@selector(chatButtonAction:)]) {
        [self.delegate chatButtonAction:sender];
    }
    [tempChatButton setSelected:!tempChatButton.isSelected];
    
}
-(void)adjustFrameOnViewLoad:(NSNotification *)notify {
    CGRect frame = [self realRect:[notify object]];
    [self chatButtonAction:frame];
}

- (CGRect)realRect:(NSString *)frameString {
    
    return CGRectFromString(frameString );
}

/*
 @Chat button action
 */
-(void)chatButtonAction:(CGRect)frame{
    
    [self.tView setFrame:CGRectMake(self.tView.frame.origin.x, 50, self.tView.frame.size.width, frame.size.height - 70)];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    [self sendButtonAction:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
   // [textField resignFirstResponder];
     [self sendMessage];
    return YES;
}
/*
 @Send text field initialization
 */
-(IBAction)sendButtonAction:(id)sender {
    TTMAppDelegate *del = [self appDelegate];
    del.messageDelegate = self;
    if([self.chatWithUser length] > 0) {
        [self sendMessage];
        [self.tView setContentOffset:CGPointMake(0, self.tView.contentSize.height - 220) animated:NO];
    }else {
        //  showAlertWithMessage(@"Please select atleast one buddy/friend", nil, @"OK", nil, nil);
    }
}
/*
 @Get Appdelegate instance vaiable
 */
- (TTMAppDelegate *)appDelegate {
	return (TTMAppDelegate *)[[UIApplication sharedApplication] delegate];
}
/*
 @Get XMPPStream instance vaiable
 */
- (XMPPStream *)xmppStream {
	return [[self appDelegate] xmppStream];
}

-(void)assignChatUser:(NSString *)chatUser {
    self.chatWithUser = chatUser; // @ missing
}
/*
 @Method is called when caht will start with a specific user
 */
-(void)startChatWithSpecificUser:(NSString *)userName {
    
    turnSockets = [[NSMutableArray alloc] init];
//    if([self.delegate respondsToSelector:@selector(selectedUserCellPressed:)]) {
//        [self.delegate selectedUserCellPressed:chatWithUser];
//    }
}

- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket {
	
	NSLog(@"TURN Connection succeeded!");
	NSLog(@"You now have a socket that you can use to send/receive data to/from the other person.");
	[turnSockets removeObject:sender];
}

- (void)turnSocketDidFail:(TURNSocket *)sender {
	
	NSLog(@"TURN Connection failed!");
	[turnSockets removeObject:sender];
	
}
/*
 @Send message action
 */
- (IBAction)sendMessage {
	
    NSString *messageStr = textView.text;
	
    if([messageStr length] > 0) {
		NSLog(@"self.chatWithUser %@", self.chatWithUser);
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:messageStr];
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue: [NSString stringWithFormat:@"%@",self.chatWithUser]];
        [message addChild:body];
		
        [self.xmppStream sendElement:message];
		
		textView.text = @"";
        
		NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
		[m setObject:[messageStr substituteEmoticons] forKey:@"msg"];
		[m setObject:@"you" forKey:@"sender"];
		[m setObject:[NSString getCurrentTime] forKey:@"time"];
		
		[self.messages addObject:m];
		[self.tView reloadData];
    }
}


#pragma mark -
#pragma mark Table view delegates

static CGFloat padding = 20.0;


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    @try {
        
        //NSArray *temparray = [self.messages reversedArray];
        NSArray *temparray = self.messages;

        NSMutableArray *reverseArray = [NSMutableArray arrayWithArray:temparray];
        NSDictionary *s = (NSDictionary *) [reverseArray objectAtIndex:indexPath.row];
        
        static NSString *CellIdentifier = @"MessageCellIdentifier";
        
        TTMChatCustonCell *cell = (TTMChatCustonCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[TTMChatCustonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSString *sender = [s objectForKey:@"sender"];
        NSString *message = [s objectForKey:@"msg"];
        NSString *time = [[s objectForKey:@"time"] stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"sendersendersender %@", sender);
        CGSize  textSize = {self.frame.size.width / 2 - 20, 10000.0 };
        CGRect textRect = [message boundingRectWithSize:textSize
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:16.0f]}
                                                context:nil];
        
        CGSize size = textRect.size;
        //        CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:13]
        //                          constrainedToSize:textSize
        //                              lineBreakMode:UILineBreakModeWordWrap];
        
        size.width += (padding/2);
        cell.messageContentView.text = message;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = NO;
        
        UIImage *bgImage = nil;
        if ([sender isEqualToString:@"you"]) { // left aligned
        
            [cell.messageContentView setFrame:CGRectMake(2, -5, self.frame.size.width / 2 + 80, size.height + 10)];
            [cell.messageContentView setBackgroundColor:[UIColor clearColor]];
            [cell.bgImageView setFrame:CGRectMake( cell.messageContentView.frame.origin.x - padding/2,
                                                  0,
                                                  size.width+padding,
                                                  size.height+padding - 10)];
            [cell.messageContentView setTextColor:[TTMCommon colorFromHexString:@"#00b6d7"]];
            cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@", time];
            cell.senderType = TTMTo;
            [cell setNeedsLayout];
        } else {
            [cell.messageContentView setFrame:CGRectMake(70,
                                                         -5,
                                                         self.frame.size.width / 2 + 85,
                                                         size.height + 10)];
            [cell.messageContentView setBackgroundColor:[UIColor clearColor]];
            [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2,
                                                  0,
                                                  size.width+padding,
                                                  size.height+padding - 10)];
            [cell.messageContentView setTextColor:[UIColor blackColor]];
            cell.senderType = TTMFrom;
            [cell setNeedsLayout];
        }
        cell.bgImageView.image = bgImage;
        //cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", sender, time];
        cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@", time];

        [cell.messageContentView setBackgroundColor:[UIColor clearColor]];
        return cell;
        
    }
    @catch (NSException *exception) {
        
    }
}

- (UIImage *) imageFromView:(UIView *)view {
    
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(currentContext, 0, view.frame.size.height);
    // passing negative values to flip the image
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    [view.layer renderInContext:currentContext];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	@try {
        
        NSArray *temparray = self.messages;
        NSMutableArray *reverseArray = [NSMutableArray arrayWithArray:temparray];
        NSDictionary *dict = (NSDictionary *)[reverseArray objectAtIndex:indexPath.row];
        NSString *msg = [dict objectForKey:@"msg"];
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);

        CGSize size = [msg sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:18.0f] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat height = size.height ;
        return height + 25;
        
    }
    @catch (NSException *exception) {
        
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [self.messages count];
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
	
}

#pragma mark -
#pragma mark Chat delegates

- (void)newMessageReceived:(NSDictionary *)messageContent {
	
    NSArray *tempArray = [[messageContent objectForKey:@"sender"] componentsSeparatedByString:@"/"];
    @try {
        NSString *firstString = [tempArray objectAtIndex:0];
        NSLog(@"firstString %@", firstString);
        self.chatWithUser = firstString;
    }
    @catch (NSException *exception) {
        
    }
    
    NSString *m = [messageContent objectForKey:@"msg"];
    if([m length] > 0) {
        [messageContent setValue:[m substituteEmoticons] forKey:@"msg"];
        [messageContent setValue:[NSString getCurrentTime] forKey:@"time"];
        [self.messages addObject:messageContent];
    }
	[self.tView reloadData];
    int lastRowNumber = (int)[self.tView numberOfRowsInSection:0] - 1;
    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
    
    [self.tView scrollToRowAtIndexPath:ip
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:YES];
//	NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:self.messages.count-1
//												   inSection:0];
//	
//    [self.tView scrollToRowAtIndexPath:topIndexPath
//    					  atScrollPosition:UITableViewScrollPositionMiddle
//    							  animated:YES];
}

- (void)dealloc
{
    //self.delegate = nil;
    TTMAppDelegate *del = [self appDelegate];
    del.messageDelegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AdjustFrame" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    NSLog(@"deallocate chat view");
    
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
