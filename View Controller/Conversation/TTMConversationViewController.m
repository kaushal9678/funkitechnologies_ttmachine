//
//  TTMConversationViewController.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 16/04/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#define YPaddingDoneBUtton 15

#import "MessageSetting.h"
#import "TTMWebImageOpration.h"
#import "TTMConversationViewController.h"
#import "MJPhoto.h"
#import "TTMChatImageView.h"
#import "MJPhotoBrowser.h"
#import "DDLog.h"
#import "TTMMessageSettings.h"
#import "FXLabel.h"
#import "TTMDelayTimeView.h"
#import "DDTTYLogger.h"
#import <CoreData/CoreData.h>
#import "TTMAppDelegate.h"
//ch.07
#import "TTMDateTimePicker.h"
#import "Chat.h"
#import "TTMJsonDecoder.h"
#import "YDFileInfo.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "YDFileSender.h"
#import "UIImageView+WebCache.h"
#import "ASIFormDataRequest.h"
#import "TTMSemiViewController.h"
#import "TTMSubClassSemiViewController.h"
#import "UIViewController+SemiViewController.h"

//#define baseURLForIMageProcess @"http://www.topchalks.com/ttmac/uploadfile"
#define baseURLForIMageProcess @"http://ttmachine.no-ip.org/ttmac/uploadfile"

//http://ttmachine.no-ip.org
#define VIEW_CONTROLLER_MAIN_BODY   1


#if DEBUG
//static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif


@interface TTMConversationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,XMPPStreamDelegate,YDFileSenderDelegate>
{
    float prevLines;
    UIButton *sendButton;
    UIImagePickerController *picturePicker;
    NSString *fileNameToBeUploaded;
    BOOL filesendingInProgress;
    TTMMediaModel *mediaModel;
    NSString *thumbnailImage;
    NSString *videoPath;
    BOOL isRecord;
    UIButton*   playButton;
    BOOL isDurationButtonSelected;
    BOOL isDateTimePickerOpen;
    BOOL isDatePicker;
    NSString *timezInterval;
    
}
@property (nonatomic,strong) NSString *cleanName;
@property (nonatomic,strong) NSString *conversationJidString;
@property (nonatomic,strong) UITableView *mtableView;
@property (nonatomic,strong) NSMutableArray* chats;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UIView *sendView;
@property (nonatomic,strong) UITextView *msgText;
//ch.07
@property (nonatomic,strong) YDFileSender *fileSender;
@property (nonatomic,strong) YDFileInfo *fileInfo;
@property (nonatomic,strong) NSString *requestID;
@property (nonatomic,strong) NSString *streamID;
@end
static UIImage* playButtonImage()
{
    static UIImage* image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"playButton.png"];
    return image;
}
@implementation TTMConversationViewController

@synthesize fileReturnBlock = _fileReturnBlock;
@synthesize mediaURLString = _mediaURLString;

#include "TTMConversationViewController_FileSendManager.m"

- (TTMAppDelegate *)appDelegate
{
	return (TTMAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (XMPPStream *)xmppStream {
	return [[self appDelegate] xmppStream];
}

-(IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(UIButton*)createPlayButton:(UIView *)boundView
{
    UIImage* buttonImage = playButtonImage();
    CGSize buttonSize = buttonImage.size;
    CGRect frameToCenter = CGRectMake((boundView.bounds.size.width/2 - buttonSize.width/4),
                                      (boundView.bounds.size.height/2 - buttonSize.height/4),
                                      buttonSize.width/2,
                                      buttonSize.height/2
                                      );
    UIButton* button = [[UIButton alloc] initWithFrame:frameToCenter];
    button.autoresizingMask =   UIViewAutoresizingFlexibleLeftMargin    |
    UIViewAutoresizingFlexibleTopMargin     |
    UIViewAutoresizingFlexibleRightMargin   |
    UIViewAutoresizingFlexibleBottomMargin;
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
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
-(void)addRightBarButton {
    UIImage *menuImage = [UIImage imageNamed:@"menu_button"];
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect buttonFrame = CGRectMake(0, 5, 20, 35);
    [infoButton setFrame:buttonFrame];
    [infoButton setBackgroundImage:menuImage forState:UIControlStateNormal];
    [infoButton setAction:kUIButtonBlockTouchUpInside withBlock:^{
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [self showRightSemiViewController];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
}
- (void)showRightSemiViewController
{
    TTMSubClassSemiViewController *semiRight = [[TTMSubClassSemiViewController alloc] init];
    [semiRight blockMethodAssinableOnly:^(id sender, NSError *error) {
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
        if(sender){
        TTMDelayTimeView *delayTime = [[TTMDelayTimeView alloc] initWithFrame:CGRectMake(10, 70, self.view.frame.size.width - 20, self.view.frame.size.height - 140)];
        [self.view addSubview:delayTime];
        [delayTime setBackgroundColor:[UIColor blackColor]];
        [delayTime.layer setBorderWidth:2.0f];
        [delayTime.layer setBorderColor:[UIColor greenColor].CGColor];
        [delayTime.layer setCornerRadius:4.0f];
        }
    }];
    self.rightSemiViewController = semiRight;
}

-(void)addOptionforCameraandPicture {
    
    UIView *mediaView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    UIImage *imageCamera = [UIImage imageNamed:@"gallery"];
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setFrame:CGRectMake(20, 5, 40, 30)];
    [cameraButton setBackgroundImage:imageCamera forState:UIControlStateNormal];
    [cameraButton setAction:kUIButtonBlockTouchUpInside withBlock:^{
        [self libraryOpen];
    }];
    UIImage *imageGallery = [UIImage imageNamed:@"camera"];
    UIButton *cameraGellary = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraGellary setFrame:CGRectMake(self.view.frame.size.width - 60, 5, 40, 30)];
    [cameraGellary setBackgroundImage:imageGallery forState:UIControlStateNormal];
    [cameraGellary setAction:kUIButtonBlockTouchUpInside withBlock:^{
        [self cameraOpen];
    }];
    [mediaView addSubview:cameraGellary];
    [mediaView addSubview:cameraButton];
    [self.view addSubview:mediaView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewWillEnterForeground];
    [self addRightBarButton];
    isRecord = NO;
    self.title = [NSString stringWithFormat:@"%@",self.userName];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:13.0], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    self.navigationItem.leftBarButtonItem=[self backButton];
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    }else {
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
    
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
	self.view.backgroundColor=[UIColor whiteColor];
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,20)];
    self.statusLabel.backgroundColor = [UIColor grayColor];
    self.statusLabel.textColor=[UIColor redColor];
    self.statusLabel.textAlignment=NSTextAlignmentCenter;
    [self.statusLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:self.statusLabel];
    
    //Add a UITableView
    self.mtableView = [[UITableView alloc] initWithFrame:CGRectMake(0,60,ScreenWidth,ScreenHeight-80-30) style:UITableViewStylePlain];
    self.mtableView.delegate=self;
    self.mtableView.dataSource=self;
    self.mtableView.rowHeight=64;
    self.mtableView.scrollsToTop = NO;
    self.mtableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.mtableView.backgroundColor = [UIColor clearColor];
    [self.mtableView setSeparatorColor:[UIColor clearColor]];
    [self.mtableView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.mtableView];
    //need a view for sending messages with controls
    if ((self.categorySelected != TTMImages) && (self.categorySelected != TTMVideo)) {
    self.sendView = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight-55,ScreenWidth,40)];
    self.sendView.backgroundColor=[UIColor whiteColor];
    self.msgText = [[UITextView alloc] initWithFrame:CGRectMake(40,3,235,50)];
    self.msgText.backgroundColor = [UIColor whiteColor];
    self.msgText.textColor=[UIColor colorWithRed:0/255.0f green:162.0f/255.0f blue:226.0/255.0f alpha:1.0f];
    self.msgText.font=[UIFont boldSystemFontOfSize:12];
    self.msgText.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    self.msgText.layer.cornerRadius = 10.0f;
    self.msgText.returnKeyType=UIReturnKeyDone;
    self.msgText.showsHorizontalScrollIndicator=NO;
    self.msgText.showsVerticalScrollIndicator=YES;
    [self.msgText setBackgroundColor:[UIColor blackColor]];
    self.msgText.delegate=self;
    [self.sendView addSubview:self.msgText];
    self.msgText.contentInset = UIEdgeInsetsMake(0,0,0,0);
    prevLines=0.9375f;
    //ch.07
    UIButton *uploadButton = [[UIButton alloc] initWithFrame:CGRectMake(5,10,29,26)];
    uploadButton.backgroundColor=[UIColor clearColor];
    [uploadButton setBackgroundImage:[UIImage imageNamed:@"uploadbutton.png"] forState:UIControlStateNormal];
    [uploadButton addTarget:self action:@selector(upload:) forControlEvents:UIControlEventTouchUpInside];
    uploadButton.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [self.sendView addSubview:uploadButton];
    
    //Add the send button
    sendButton = [[UIButton alloc] initWithFrame:CGRectMake(300 - [UIImage imageNamed:@"record"].size.width +10,10,[UIImage imageNamed:@"record"].size.width,[UIImage imageNamed:@"record"].size.height)];
    sendButton.backgroundColor=[UIColor clearColor];
    [sendButton setTitleColor:[UIColor colorWithRed:0/255 green:161.0/255 blue:223/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [self.sendView addSubview:sendButton];
    
    [self.view addSubview:self.sendView];
    }else {
        [self addOptionforCameraandPicture];
    }
    //
    filesendingInProgress=NO;
    [[self xmppStream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}
-(void)attachmentButtonAction:(id)sender {
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:(id)self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                             @"Open Camera",
                            @"Open Library",
                            nil];
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)cameraOpen {
    
    [self actionLaunchAppCamera];
}

-(void)libraryOpen {
    [self actionLaunchAppLibrary];
    
}

-(void)actionLaunchAppLibrary
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = (id)self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ((self.categorySelected != TTMImages) && (self.categorySelected != TTMVideo)) {
        imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie,(NSString *) kUTTypeImage, nil];
    }else{
        if(self.categorySelected == TTMImages) {
            imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *) kUTTypeImage, nil];
        }else{
            imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        }
    }
    
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
        if ((self.categorySelected != TTMImages) && (self.categorySelected != TTMVideo)) {
            
            imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie,(NSString *) kUTTypeImage, nil];
        }else{
            if(self.categorySelected == TTMImages) {
                imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *) kUTTypeImage, nil];
            }else{
                imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
            }
        }
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
#pragma mark Upload
-(IBAction)upload:(id)sender
{
    //    if ([UIImagePickerController isSourceTypeAvailable:
    //         UIImagePickerControllerSourceTypePhotoLibrary])
    //    {
    //        fileNameToBeUploaded=@"";
    //        picturePicker = [[UIImagePickerController alloc] init];
    //        picturePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //        picturePicker.delegate = self;
    //        if (  [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone  )
    //        {
    //            [self presentViewController:picturePicker animated:YES completion:nil];
    //        }
    //    }
    
    [self attachmentButtonAction:nil];
}

+ (UIImage *)generateThumbnailIconForVideoFileWith:(NSURL *)contentURL WithSize:(CGSize)size
{
    UIImage *theImage = nil;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:contentURL options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.maximumSize=size;
    generator.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime time = CMTimeMake(100,100); //change whatever you want here.
    CGImageRef imgRef = [generator copyCGImageAtTime:time actualTime:NULL error:&err];
    theImage = [self generatePhotoThumbnail:[[UIImage alloc] initWithCGImage:imgRef]] ;
    CGImageRelease(imgRef);
    return theImage;
}

-(void)makeChatObject:(NSData *)imageData error:(BOOL)iserror fileName:(NSString *)fileName{
    Chat *chat = [NSEntityDescription
                  insertNewObjectForEntityForName:@"Chat"
                  inManagedObjectContext:[self appDelegate].managedObjectContext];
    
    chat.messageBody = @"hdghdf";
    chat.messageDate = [NSDate date];
    chat.hasMedia=[NSNumber numberWithBool: YES];
    chat.isNew=[NSNumber numberWithBool:NO];
    chat.messageStatus=@"send";
    chat.direction = @"OUT";
    chat.mediaType= @"image" ;
    chat.thumbNail = @"";
    chat.originalURL = self.mediaURLString;
    chat.groupNumber=@"LazyImage";
    chat.isGroupMessage=[NSNumber numberWithBool:NO];
    chat.jidString =  self.conversationJidString;
    chat.chatType = @"2";
    chat.image = imageData;
    chat.isError = [NSNumber numberWithBool:iserror];
    chat.mediaFileName = [NSString stringWithFormat:@"%@",fileName];
    NSError *error = nil;
    if (![[self appDelegate].managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
    [self.chats addObject:chat];
    
}
-(void)updateRowAccordingToValue:(NSString *)fileName error:(BOOL)error{
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"Chat"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"mediaFileName==%@",fileName]; // If required to fetch specific vehicle
    fetchRequest.predicate=predicate;
    Chat *newChat=[[[self appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
    [newChat setValue: [NSNumber numberWithBool:error] forKey:@"isError"];
    [[self appDelegate].managedObjectContext save:nil];
}

-(void)deleteResordFromDataBase:(NSString *)fileName {
    
//    Chat* chat = [self.chats lastObject];
//    [[self appDelegate].managedObjectContext deleteObject:chat];
//    [[self appDelegate].managedObjectContext save:nil];
    
    NSFetchRequest *requestData = [[NSFetchRequest alloc] initWithEntityName:@"Chat"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediaFileName == %@", fileName];
    [requestData setPredicate:predicate];
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [self appDelegate].managedObjectContext;//Get your ManagedObjectContext;
    NSArray *result = [managedObjectContext executeFetchRequest:requestData error:&error];
    
    if (!error && result.count > 0) {
        for(NSManagedObject *managedObject in result){
            [managedObjectContext deleteObject:managedObject];
        }
        //Save context to write to store
        [managedObjectContext save:nil];
    }
}

-(NSString *)getFileNameWithoutExt:(NSString *)fullname {
    
    NSURL *pathURL = [NSURL URLWithString:fullname];
    NSString *pathString = [NSString stringWithFormat:@"%@", [pathURL lastPathComponent]];
    NSString *file_name = [[pathString componentsSeparatedByString:@"."] objectAtIndex:0];
    NSLog(@"URL path for filr upload %@", file_name);
    return file_name;
}

-(NSString *)getFailedFileNameWithoutExt:(NSString *)fullname {
    
    NSString *pathString = [NSString stringWithFormat:@"%@", fullname];
    NSString *file_name = [[pathString componentsSeparatedByString:@"."] objectAtIndex:0];
    NSLog(@"URL path for filr upload %@", file_name);
    return file_name;
}


-(NSString *)getFileNameWithExt:(NSString *)fullname {
    NSURL *pathURL = [NSURL URLWithString:fullname];
    NSString *pathString = [NSString stringWithFormat:@"%@", [pathURL lastPathComponent]];
    NSLog(@"URL path for filr upload %@", pathString);
    return pathString;
}

#pragma mark UIImpagePicker Delegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    pickerInfo = [[NSDictionary alloc] initWithDictionary:info];
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ( [ mediaType isEqualToString:@"public.image" ]) {
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

        UIImage *correctImage = [self scaleAndRotateImage:image];
        NSString *fname = [YDHelper createUniqueFileNameWithoutExtension];
        
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/%@.jpg",fname]];
        [UIImageJPEGRepresentation(correctImage, 0.5f) writeToFile:jpgPath atomically:YES];
        fileNameToBeUploaded=jpgPath;
        [TTMCommon saveFileForSentPicture:UIImageJPEGRepresentation(correctImage, 0.5f) fileName:@"kk"];
        [self makeChatObject:UIImageJPEGRepresentation(correctImage, 0.5f) error:NO fileName:fname];
        [self.mtableView reloadData];
        [self sendImageMediaType:correctImage imageName:fname returnBlock:^(TTMMediaModel *urls, NSError *error) {
            if(!error) {
            
                [self deleteResordFromDataBase:[self getFileNameWithoutExt:urls.original_url]];
                [self sendMessageWithMediaType:urls.original_url thumbnailURL:urls.thumbnail isMEdiaTypeVideo:NO thumbNailImage:urls.thumbNailImage];
                [self loadData];

            }else {
                NSString *fileName = [self getFileNameWithoutExt:urls.original_url];
                NSLog(@"fileName fileName %@", fileName);
                [self updateRowAccordingToValue:fileName error:YES];
                //[self makeChatObject:UIImageJPEGRepresentation(correctImage, 0.5f) error:YES fileName:fileName];
                [self loadData];
            }
        }];
    }
    //not production code,  do not use hard coded string in real app
    else if ( [ mediaType isEqualToString:@"public.movie" ]){
        NSURL *url =  [info objectForKey:UIImagePickerControllerMediaURL];
        NSString * str = [[NSString stringWithFormat:@"%@", url] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",[url lastPathComponent]] withString:@""];
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        gen.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
        NSError *error = nil;
        CMTime actualTime;
        
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        videoPath = [NSString stringWithFormat:@"%@", str];
        NSLog(@"urlString %@", [url lastPathComponent]);
        [self makeChatObject:UIImageJPEGRepresentation(thumb, 0.5f) error:NO fileName:[url lastPathComponent]];
        [self.mtableView reloadData];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        [TTMCommon saveFileForSentVideo:urlData fileName:@"kk"];
        
        [self sendVideoMediaType:url  returnBlock:^(TTMMediaModel *urls, NSError *error) {
            if(!error){
                
                [self deleteResordFromDataBase:[self getFileNameWithExt:urls.original_url]];
                [self sendMessageWithMediaType:urls.original_url thumbnailURL:urls.thumbnail isMEdiaTypeVideo:YES thumbNailImage:urls.thumbNailImage];
                [self loadData];

            }else{
                NSString *urlPath = [self getFileNameWithExt:urls.original_url];
                NSLog(@"video url value is %@", urlPath);
                [self updateRowAccordingToValue:urlPath error:YES];
                [self loadData];

//                [self deleteResordFromDataBase:urlPath];
//                [self makeChatObject:UIImageJPEGRepresentation(thumb, 0.5f) error:YES fileName:urlPath];
            }
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSMutableDictionary *)makeJSONForFileSending:(NSString *)url thumbnail:(NSString *)thumbnailURL type:(NSString *)type{
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *temJsonDict = [NSMutableDictionary dictionary];
    [temJsonDict setObject:type forKey:@"type"];
    [temJsonDict setObject:(url) ? url : @"" forKey:@"filePath"];
    [temJsonDict setObject:(thumbnailURL) ? thumbnailURL : @"" forKey:@"thumbnailPath"];
    TTMDataBaseManager *dataBaseManager = [TTMDataBaseManager sharedMySingleton];
    [dataBaseManager initializeTheCoreDataModelClasses];
    
    NSMutableArray *dataArray = [dataBaseManager fetchDataFromCoreDataOnMessageSettingInfo];
    if([dataArray count] > 0){
        MessageSetting *delayInfo = [dataArray objectAtIndex:0];
        if([delayInfo.isDuration boolValue]){
            long totalTime = ((([[delayInfo hours] intValue]*60)*60)*1000) + (([[delayInfo minutes] intValue]*60) *1000);
            long long totalRelativeTime = totalTime + [TTMCommon getUTCTimeInterval];
            [self convertMilisecondInSeconds:totalRelativeTime];
            NSString *timeInterval = [NSString stringWithFormat:@"%lli",totalRelativeTime];
            [temJsonDict setObject:timeInterval forKey:@"timeDelayed"];
        }
        if([delayInfo.isSpecific boolValue]) {
            NSLog(@"delayInfo.specificDateTimeInterval %@", timezInterval);
            [temJsonDict setObject:timezInterval forKey:@"timeDelayed"];
        }
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:temJsonDict, nil];
    [jsonDict setValue:tempArray forKey:@"messageList"];
    return jsonDict;
}
-(void)convertMilisecondInSeconds:(long long)interval {
    
    NSDate *currentDate = [NSDate date];
    NSString* format = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    
    // Set up an NSDateFormatter for UTC time zone
    NSDateFormatter* formatterUtc = [[NSDateFormatter alloc] init];
    [formatterUtc setDateFormat:format];
    [formatterUtc setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString* input = [formatterUtc stringFromDate:currentDate];
    
    // Cast the input string to NSDate
    NSDate* utcDate = [formatterUtc dateFromString:input];
    
    // Set up an NSDateFormatter for the device's local time zone
    NSDateFormatter* formatterLocal = [[NSDateFormatter alloc] init];
    [formatterLocal setDateFormat:format];
    [formatterLocal setTimeZone:[NSTimeZone localTimeZone]];
    NSString *stringValue = [NSString stringWithFormat:@"%f",[utcDate timeIntervalSince1970] * 1000];
    long long timeINterval = [@(floor([utcDate timeIntervalSince1970] * 1000)) longLongValue];

    // Create local NSDate with time zone difference
    formatterUtc.dateFormat = @"HH:mm:ss";
    long seconds = lroundf((interval - timeINterval));
    NSLog(@"Finla Time: %li and total time %lli and only time %lli and string value is %@", seconds , interval, timeINterval, stringValue);
    
}

-(NSMutableDictionary *)makeJSONForTextSending:(NSString *)text type:(NSString *)type {
    

    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *temJsonDict = [NSMutableDictionary dictionary];
    [temJsonDict setObject:type forKey:@"type"];
    [temJsonDict setObject:text forKey:@"content"];
    
    TTMDataBaseManager *dataBaseManager = [TTMDataBaseManager sharedMySingleton];
    [dataBaseManager initializeTheCoreDataModelClasses];

    NSMutableArray *dataArray = [dataBaseManager fetchDataFromCoreDataOnMessageSettingInfo];
    if([dataArray count] > 0){
    MessageSetting *delayInfo = [dataArray objectAtIndex:0];
    if([delayInfo.isDuration boolValue]){
        long totalTime = ((([[delayInfo hours] intValue]*60)*60)*1000) + (([[delayInfo minutes] intValue]*60) *1000);
        long long totalRelativeTime = totalTime + [TTMCommon getUTCTimeInterval];
        [self convertMilisecondInSeconds:totalRelativeTime];
        NSString *timeInterval = [NSString stringWithFormat:@"%lli",totalRelativeTime];
        
        [temJsonDict setObject:timeInterval forKey:@"timeDelayed"];
    }
        if([delayInfo.isSpecific boolValue]) {
            NSLog(@"delayInfo.specificDateTimeInterval %@", timezInterval);
            [temJsonDict setObject:timezInterval forKey:@"timeDelayed"];
        }
}
// Take delay message komal
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:temJsonDict, nil];
    [jsonDict setValue:tempArray forKey:@"messageList"];
    return jsonDict;
}


#pragma mark image helper
- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

-(NSString *)generateIDWithPrefix:(NSString *)_prefix
{
    int x = arc4random() % 10000;
    return [NSString stringWithFormat:@"%@%i",_prefix,x ];
}
-(void)sendFile
{
    
    NSString *filePath = fileNameToBeUploaded;
    CFStringRef fileExtension = (__bridge CFStringRef)[filePath pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    NSString *MIMETypeString = (__bridge_transfer NSString *)MIMEType;
    NSString *URL = fileNameToBeUploaded;
    
    NSError *AttributesError = nil;
    NSDictionary *FileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:URL error:&AttributesError];
    NSNumber *FileSizeNumber = [FileAttributes objectForKey:NSFileSize];
    // NSArray *splitter = [MIMETypeString componentsSeparatedByString:@"/"];
    // NSString *extension = [splitter objectAtIndex:1];
    NSString *mediaType = @"image";
    long FileSize = [FileSizeNumber longValue];
    /*   XMPPUserCoreDataStorageObject *user = [[self appDelegate ].xmppRosterStorage userForJID:
     [XMPPJID jidWithString:self.conversationJidString]
     xmppStream:[self appDelegate ].xmppStream
     managedObjectContext:[self appDelegate ]. managedObjectContext_roster];*/
    
    //create message
    self.streamID=[self generateIDWithPrefix:@"ip_"];
    self.requestID = [self generateIDWithPrefix:@"jsi_"];
    NSXMLElement *si= [NSXMLElement elementWithName:@"si" xmlns:@"http://jabber.org/protocol/si"];
    [si addAttributeWithName:@"id" stringValue:self.streamID];
    
    [si addAttributeWithName:@"mime-type" stringValue:MIMETypeString];
    [si addAttributeWithName:@"profile" stringValue:@"http://jabber.org/protocol/si/profile/file-transfer"];
    
    NSXMLElement *fileElement = [NSXMLElement elementWithName:@"file" xmlns:@"http://jabber.org/protocol/si/profile/file-transfer"];
    
    [fileElement addAttributeWithName:@"name" stringValue:[fileNameToBeUploaded lastPathComponent]];
    [fileElement addAttributeWithName:@"size" stringValue:[NSString stringWithFormat:@"%ld",FileSize]];
    [fileElement addAttributeWithName:@"desc" stringValue:@""];
    [si addChild:fileElement];
    NSXMLElement *feature = [NSXMLElement elementWithName:@"feature" xmlns:@"http://jabber.org/protocol/feature-neg"];
    
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    [x addAttributeWithName:@"type" stringValue:@"form"];
    
    NSXMLElement *field =[NSXMLElement elementWithName:@"field"];
    [field addAttributeWithName:@"type" stringValue:@"list-single"];
    [field addAttributeWithName:@"var"  stringValue:@"stream-method"];
    
    NSXMLElement *option = [NSXMLElement elementWithName:@"option" ] ;
    NSXMLElement *bs =[NSXMLElement elementWithName:@"value" stringValue:@"http://jabber.org/protocol/bytestreams"] ;
    [option addChild:bs];
    [field addChild:option];
    [x addChild:field];
    [feature addChild:x];
    [si addChild:feature];
    XMPPJID *toJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@/Spark 2.6.3",self.conversationJidString]];
    XMPPIQ *iqtoSend=[XMPPIQ iqWithType:@"set" to:toJid elementID:self.requestID child:si];
    //Clear your object
    if (self.fileInfo)
        self.fileInfo=nil;
    
    self.fileInfo = [[YDFileInfo alloc] initWithFileName:fileNameToBeUploaded mediaType:mediaType mimeType:MIMETypeString size:FileSize localName:fileNameToBeUploaded IQ:[NSString stringWithFormat:@"%@",iqtoSend] fileNameAsSent:fileNameToBeUploaded sender:@""];
    
    
    //send the Stanza
    [self appDelegate].isSending=YES;
    [self.xmppStream sendElement:iqtoSend];
}
#pragma mark FileSender delegates
- (void)fileSender:(YDFileSender *)sender didSucceedWithSocket:(GCDAsyncSocket *)socket
{
    NSLog(@"localfileName %@",self.fileInfo.localFileName);
    NSData *dataToSend = [NSData dataWithContentsOfFile:self.fileInfo.localFileName];
    if (dataToSend!=nil)
    {
        [socket writeData:dataToSend withTimeout:-1 tag:-898];
        [socket disconnectAfterWriting];
        filesendingInProgress=NO;
        
    }
    Chat *chat = [NSEntityDescription
                  insertNewObjectForEntityForName:@"Chat"
                  inManagedObjectContext:[self appDelegate].managedObjectContext];
    chat.messageBody = @"file sent";
    chat.messageDate = [NSDate date];
    chat.hasMedia=[NSNumber numberWithBool:YES];
    chat.isNew=[NSNumber numberWithBool:NO];
    chat.messageStatus=@"sent";
    chat.direction = @"OUT";
    chat.groupNumber=@"";
    chat.isGroupMessage=[NSNumber numberWithBool:NO];
    chat.jidString =  self.conversationJidString;
    chat.localfileName = self.fileInfo.localFileName;
    chat.mimeType=_fileInfo.mimeType;
    chat.mediaType= @"image";
    chat.isError = [NSNumber numberWithBool:NO];

    chat.filenameAsSent=self.fileInfo.filenameAsSent;
    NSError *error = nil;
    if (![[self appDelegate].managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
    [self appDelegate].isSending=NO;
    self.fileInfo=nil;
    [self loadData];
}

- (void)fileSenderDidFail:(YDFileSender *)sender
{
    NSLog(@"FAIL");
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark sending a file
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    
    
    NSXMLElement *siRequest = [iq elementForName:@"si" xmlns:@"http://jabber.org/protocol/si"];
    NSXMLElement *errorElement = [iq elementForName:@"error"];
    NSXMLElement *unAvailableElement = [errorElement elementForName:@"service-unavailable" xmlns:@"urn:ietf:params:xml:ns:xmpp-stanzas" ] ;
    
    if ([iq isErrorIQ] )
    {
        if (errorElement && unAvailableElement)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error" message:@"user is offline" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        filesendingInProgress=NO;
        return NO;
    }
    if (siRequest && !filesendingInProgress)
    {
        
        XMPPJID *toJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@/Spark 2.6.3",self.conversationJidString ]];
        if (self.fileSender)
            self.fileSender=nil;
        
        self.fileSender = [[YDFileSender alloc] initWithStream:[self xmppStream]  toJID:toJid];
        self.fileSender.streamID=self.streamID;
        self.fileSender.transferID=self.requestID;
        self.fileSender.fileInfo=self.fileInfo;
        [self.fileSender startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        filesendingInProgress=YES;
        [self appDelegate].isSending=YES;
        return NO;
    }
    
    return NO;
}

-(void)changeUpdateStatus:(NSNotification *)notify{
    [self updateStatusAccordingToDataBase];
}

-(void)updateStatusAccordingToDataBase {
    TTMDataBaseManager *dataBaseManager = [TTMDataBaseManager sharedMySingleton];
    [dataBaseManager initializeTheCoreDataModelClasses];
    
    NSMutableArray *dataArray = [dataBaseManager fetchDataFromCoreDataOnMessageSettingInfo];
    if([dataArray count] > 0){
        MessageSetting *delayInfo = [dataArray objectAtIndex:0];
        if([delayInfo.isDuration boolValue]){
            isDurationButtonSelected = YES;
            
        }else {
            isDurationButtonSelected = NO;
            
        }
    }
}


#pragma mark view appearance
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Add Observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageReceived:) name:kNewMessage  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusUpdateReceived:) name:kChatStatus  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUpdateStatus:) name:@"ChangeStatus"  object:nil];
    [self updateStatusAccordingToDataBase];
    [self.mtableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //Remove notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kChatStatus  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNewMessage object:nil];
    
}
-(void)statusUpdateReceived:(NSNotification *)aNotification
{
    NSString *msgStr=  [[aNotification userInfo] valueForKey:@"msg"] ;
    msgStr = [msgStr stringByReplacingOccurrencesOfString:@"@" withString:@""];
    self.statusLabel.text = [NSString stringWithFormat:@"%@ %@",self.cleanName,msgStr];
}
-(void)newMessageReceived:(NSNotification *)aNotification
{
    
    //reload our data
    [self loadData];
}
-(void)showConversationForJIDString:(NSString *)jidString
{
    self.conversationJidString = jidString;
    self.cleanName = [jidString stringByReplacingOccurrencesOfString:kXMPPServer withString:@""];
    self.cleanName=[self.cleanName stringByReplacingOccurrencesOfString:@"@" withString:@""];
    self.statusLabel.text = self.cleanName;
    [self loadData];
}


-(void)loadData
{
    NSString *chatTypeValue = nil;
    if (self.chats)
        self.chats =nil;
    if ((self.categorySelected != TTMImages) && (self.categorySelected != TTMVideo)) {

    }else {
        if(self.categorySelected == TTMImages) {
            chatTypeValue = [NSString stringWithFormat:@"%@", @"4"];
        }else {
            chatTypeValue = [NSString stringWithFormat:@"%@", @"5"];
        }
    }
    self.chats = [[NSMutableArray alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Chat"
                                              inManagedObjectContext:[self appDelegate].managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    if ((self.categorySelected != TTMImages) && (self.categorySelected != TTMVideo)) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jidString == %@ AND chatType != %@ AND chatType != %@",self.conversationJidString,@"4", @"5"];
        [fetchRequest setPredicate:predicate];
    }else{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jidString == %@ AND chatType == %@",self.conversationJidString,chatTypeValue];
    [fetchRequest setPredicate:predicate];
    }
    NSError *error=nil;
    NSArray *fetchedObjects = [[self appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *obj in fetchedObjects)
    {
        [self.chats addObject:obj];
        //Since they are now visible set the isNew to NO
        Chat *thisChat = (Chat *)obj;
        if ([thisChat.isNew  boolValue])
            thisChat.isNew = [NSNumber numberWithBool:NO];
    }
    //Save changes
    error = nil;
    if (![[self appDelegate].managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
    //reload the table view
    [self.mtableView reloadData];
    [self scrollToBottomAnimated:YES];
    //[self.mtableView setContentOffset:CGPointMake(0.0f, self.mtableView.contentSize.height - self.view.frame.size.height) animated:NO];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableView
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Chat *currentChatMessage = (Chat *)[self.chats objectAtIndex:indexPath.row];
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData: [currentChatMessage.messageBody dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error:nil];
    TTMJsonDecoder *decoder = ([currentChatMessage.mediaType isEqualToString:@"image"]) ? [self getURLFromJSON:[NSMutableDictionary dictionaryWithDictionary:JSON]] : [self getTextFromJSON:[NSMutableDictionary dictionaryWithDictionary:JSON]];
    if ([[NSString stringWithFormat:@"%@", decoder.type] isEqualToString:@"1"])
    {
        UIFont* systemFont = [UIFont boldSystemFontOfSize:12];
        int width = 185.0, height = 10000.0;
        NSMutableDictionary *atts = [[NSMutableDictionary alloc] init];
        [atts setObject:systemFont forKey:NSFontAttributeName];
        
        CGRect textSize = [decoder.url boundingRectWithSize:CGSizeMake(width, height)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:atts
                                                    context:nil];
        float textHeight = textSize.size.height;
        return textHeight+40;
    }
    else
    {
        return 130;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	return self.chats.count;
}

-(TTMJsonDecoder *)getURLFromJSON:(NSMutableDictionary *)dict {
    
    NSMutableArray *jsonArray = [dict objectForKey:@"messageList"];
    NSLog(@"jsonArray %@", jsonArray);
    if([jsonArray count]) {
        TTMJsonDecoder *decoder = [[TTMJsonDecoder alloc] init];
        NSMutableDictionary *temJsonDict = [jsonArray objectAtIndex:0];
        [decoder setType:[temJsonDict objectForKey:@"type"]];
        [decoder setUrl:[temJsonDict objectForKey:@"filePath"]];
        return decoder;
    }
    return nil;
}

-(TTMJsonDecoder *)getTextFromJSON:(NSMutableDictionary *)dict {
    
    NSMutableArray *jsonArray = [dict objectForKey:@"messageList"];
    NSLog(@"jsonArray in text%@", jsonArray);
    if([jsonArray count]) {
        TTMJsonDecoder *decoder = [[TTMJsonDecoder alloc] init];
        NSMutableDictionary *temJsonDict = [jsonArray objectAtIndex:0];
        [decoder setType:[temJsonDict objectForKey:@"type"]];
        [decoder setUrl:[temJsonDict objectForKey:@"content"]];
        [decoder setTimeDelayed:[temJsonDict objectForKey:@"timeDelayed"]];

        return decoder;
    }
    return nil;
}
-(BOOL) imageExistAtPath:(NSString *)assetsPath
{
    __block BOOL imageExist = NO;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:[NSURL URLWithString:assetsPath] resultBlock:^(ALAsset *asset) {
        if (asset) {
            imageExist = YES;
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Error %@", error);
    }];
    return imageExist;
}
-(void)handleTwoFingerTap:(UIGestureRecognizer *)recognizer {
    
    UIView *tappedView = [recognizer view];
    UIView *subView = [tappedView viewWithTag:7890];
    NSLog(@"subView subView %@", subView);
    TTMChatImageView *imageview = (TTMChatImageView *)[subView viewWithTag:6789];
    if(([[NSString stringWithFormat:@"%@",imageview.type] isEqualToString:@"2"]) || [[NSString stringWithFormat:@"%@",imageview.type] isEqualToString:@"4"]) {
        
        NSURL *url = [NSURL URLWithString:imageview.originalImage];
        NSString *filename = [[url path] lastPathComponent];
        NSLog(@"SUbview x cocordinate is %f", subView.frame.origin.x);
        NSString *fullPath = nil;
        if(subView.frame.origin.x < 100) {
            fullPath = [TTMCommon getPathForMediaTypeSentOrRecieved:TTMSentImage fileName:filename];
        }else {
            fullPath = [TTMCommon getPathForMediaTypeSentOrRecieved:TTMRecievedImage fileName:filename];
        }
        bool b=[[NSFileManager defaultManager] fileExistsAtPath:fullPath];
        
        if(!b) {
            dispatch_async(dispatch_queue_create("BackgroundThread", nil), ^{
                NSData *urlData = [NSData dataWithContentsOfURL:url];
                if(subView.frame.origin.x < 100) {
                    [TTMCommon saveFileForSentPicture:urlData fileName:filename];
                }else {
                    [TTMCommon saveFileForRecievedPicture:urlData fileName:filename];
                }
            });
        }
        NSLog(@"full path is image %@", fullPath);
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:imageview.originalImage]; //
        photo.srcImageView = imageview; //UIImageView
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0; //
        browser.photos = [NSArray arrayWithObject:photo]; //
        [browser show];
    }else {
        BOOL isFileExist = NO;
        NSString *fullPath = nil;
        NSURL *theMovieURL = [NSURL URLWithString:imageview.originalImage];
        NSString *filename = [[theMovieURL path] lastPathComponent];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingString:@"/tmp"], filename];
        if ([fileManager fileExistsAtPath:filePath]) {
            isFileExist = YES;
        }
        if(!isFileExist) {
            if(subView.frame.origin.x < 100) {
                fullPath = [TTMCommon getPathForMediaTypeSentOrRecieved:TTMSentImage fileName:filename];
            }else {
                fullPath = [TTMCommon getPathForMediaTypeSentOrRecieved:TTMRecievedVideo fileName:filename];
                
            }
            bool b=[[NSFileManager defaultManager] fileExistsAtPath:fullPath];
            
            if(!b) {
                dispatch_async(dispatch_queue_create("Background", nil), ^{
                    NSData *urlData = [NSData dataWithContentsOfURL:theMovieURL];
                    if(subView.frame.origin.x < 100) {
                        [TTMCommon saveFileForSentVideo:urlData fileName:filename];
                    }else {
                        [TTMCommon saveFileForRecievedVideo:urlData fileName:filename];
                    }
                });
                
            }
        }
        bool b=[[NSFileManager defaultManager] fileExistsAtPath:fullPath];
        
        if(isFileExist) {
            theMovieURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",(filePath) ? filePath : fullPath]];
        }
        if(b){
            theMovieURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",fullPath]];
        }
        NSLog(@"full path is video %@ and %@ and %@", fullPath, filePath, theMovieURL);
        
        if (theMovieURL){
            if ([theMovieURL scheme])	// sanity check on the URL
            {
                /* Play the movie with the specified URL. */
                [self playMovieStream:theMovieURL];
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        [cell setBackgroundColor:[UIColor blackColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
	Chat* chat = [self.chats objectAtIndex:indexPath.row];
    //ch.07 is there is media involved you need a different way of showing
    //if ([chat.hasMedia boolValue])
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData: [chat.messageBody dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error:nil];
    //if (getExtensionType([self getExtensionName:chat.messageBody])) {
    NSLog(@"json and json body %@ and %@", JSON, chat.messageBody);
    TTMJsonDecoder *decoder = ([chat.mediaType isEqualToString:@"image"]) ? [self getURLFromJSON:[NSMutableDictionary dictionaryWithDictionary:JSON]] : [self getTextFromJSON:[NSMutableDictionary dictionaryWithDictionary:JSON]];
    
    if (![[NSString stringWithFormat:@"%@", decoder.type] isEqualToString:@"1"]) {
        
        float leftmarker = 0;
        NSString *balloonName;
        if (![chat.direction isEqualToString:@"IN"])
        {
            leftmarker=10;
            balloonName=@"BalloonLeft.png";
        } else {
            leftmarker=80;
            balloonName=@"BalloonRightred.png";
        }
        UIView *cellContentView = [[UIView alloc] initWithFrame:CGRectMake(0,3,ScreenWidth,130)];
        UIView *mediaPlaceholderView = [[UIView alloc] initWithFrame:CGRectMake(leftmarker,6,240,120)];
        mediaPlaceholderView.backgroundColor=[UIColor colorWithRed:42.0/255.0f green:221.0/255.0f blue:242.0/255.0f alpha:1.0];
        //[self getExtensionName:chat.messageBody];
        UIImageView *mediaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,160,120)];
        mediaImageView.backgroundColor=[UIColor clearColor];
        
        mediaImageView.image=[UIImage imageNamed:balloonName];
        [mediaPlaceholderView addSubview:mediaImageView];
        TTMChatImageView *preview = [[TTMChatImageView alloc]  initWithFrame:CGRectMake(10,3,mediaPlaceholderView.frame.size.width - 20,90)];
        [preview setOriginalImage:chat.originalURL];
        [preview setThumbNail:chat.thumbNail];
        [preview setType:decoder.type];
        [preview setUserInteractionEnabled:YES];
        [preview setTag:6789];
        preview.backgroundColor=[UIColor clearColor];
        preview.layer.cornerRadius=5.0f;
        preview.clipsToBounds=YES;
        preview.contentMode = UIViewContentModeScaleAspectFit;
        
        if((![[NSString stringWithFormat:@"%@", decoder.type] isEqualToString:@"2"]) && (![[NSString stringWithFormat:@"%@", decoder.type] isEqualToString:@"4"])) {
        if([chat.groupNumber isEqualToString:@"LazyImage"]) {
            playButton = nil;

        }else{
                playButton = [self createPlayButton:preview];
        }
        } else
            playButton = nil;
        [preview addSubview:playButton];
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSLog(@"thumbNail url : %@",chat.thumbNail);
        
        [manager downloadWithURL:[NSURL URLWithString:[chat.thumbNail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            NSLog(@"Error is %@", error);
            if(!image){
                preview.image = [UIImage imageWithData:chat.image];
            }else{
                preview.image = image;
            }
        }];
        __weak typeof(preview) weakSelf = preview;
        
        
        [preview setImageWithURL:[NSURL URLWithString:[chat.thumbNail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageWithData:chat.image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if(error) {
                if([chat.groupNumber isEqualToString:@"LazyImage"]){
                [weakSelf setImageWithURL:[NSURL URLWithString:chat.thumbNail] placeholderImage:[UIImage imageWithData:chat.image]];
                }else{
                [TTMWebImageOpration processImageDataWithURLString:chat.thumbNail andBlock:^(NSData *imageData) {
                        UIImage *image = [UIImage imageWithData:imageData];
                        weakSelf.image = image;
                }];
                }
            }
        }];
        if([chat.groupNumber isEqualToString:@"LazyImage"]) {
            
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            activityIndicator.alpha = 1.0;
            activityIndicator.center = CGPointMake(preview.frame.size.width/2, preview.frame.size.height/2);
            activityIndicator.hidesWhenStopped = YES;
            [preview addSubview:activityIndicator];
            [activityIndicator startAnimating];
            if ([chat.isError boolValue]) {
                [activityIndicator stopAnimating];
            }

        }else {
            
        }
        [mediaImageView addSubview:preview];
        // }
        //if you also support audio you might want to add a fixed icon for an audio file or a video thumbnail
        //add some a sender label and time info
        [mediaPlaceholderView addSubview:mediaImageView];
        //SenderLabel
        FXLabel *senderLabel = [[FXLabel alloc] initWithFrame:CGRectMake(10,10 ,300,20)];
        senderLabel.backgroundColor=[UIColor clearColor];
        senderLabel.font = [UIFont systemFontOfSize:10];
        senderLabel.textColor=[UIColor blackColor];
        senderLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
        senderLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
        senderLabel.shadowBlur = 1.0f;
        senderLabel.innerShadowBlur = 2.0f;
        senderLabel.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        senderLabel.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
        float senderStartX;
        if ([chat.direction isEqualToString:@"IN"])
        {
            // left aligned
            senderLabel.frame=CGRectMake(170,mediaPlaceholderView.frame.size.height - 20,150,13);
            senderLabel.text= [NSString stringWithFormat:@"%@: %@",self.cleanName,[YDHelper dayLabelForMessage:chat.messageDate]];
            senderStartX=19;
            [senderLabel setTextAlignment:NSTextAlignmentRight];
            [senderLabel setTextColor:[UIColor whiteColor]];
            mediaPlaceholderView.backgroundColor=[UIColor colorWithRed:42.0/255.0f green:221.0/255.0f blue:242.0/255.0f alpha:1.0];
            
        }
        else
        {
            senderLabel.frame=CGRectMake(10,mediaPlaceholderView.frame.size.height - 20,250,13);
            senderLabel.text= [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"You",nil), [YDHelper dayLabelForMessage:chat.messageDate]];
            senderStartX=155;
            [senderLabel setTextAlignment:NSTextAlignmentLeft];
            [senderLabel setTextColor:[UIColor whiteColor]];
            if ([chat.isError boolValue]) {
                [senderLabel setTextColor:[UIColor redColor]];
                [senderLabel setText:[NSString stringWithFormat:@"%@", @"Message sending failed"]];
            }else{
                [senderLabel setTextColor:[UIColor whiteColor]];
                senderLabel.text= [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"You",nil), [YDHelper dayLabelForMessage:chat.messageDate]];
            }
            mediaPlaceholderView.backgroundColor=[UIColor colorWithRed:147.0/255.0f green:190.0/255.0f blue:26.0/255.0f alpha:1.0];
        }
        [cellContentView addSubview:mediaPlaceholderView];
        [cellContentView addSubview:senderLabel];
        [mediaPlaceholderView setTag:7890];
        cell.backgroundView = cellContentView;
        [cell.backgroundView setUserInteractionEnabled:YES];
        [cell bringSubviewToFront:cellContentView];
        UITapGestureRecognizer *twoFingerTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self         action:@selector(handleTwoFingerTap:)];
        [twoFingerTap1 setNumberOfTouchesRequired:1];
        [cell.backgroundView addGestureRecognizer:twoFingerTap1];
        
    }
    else //no media
    {
        
        UIFont* systemFont = [UIFont boldSystemFontOfSize:12];
        int width = 185.0, height = 10000.0;
        NSMutableDictionary *atts = [[NSMutableDictionary alloc] init];
        [atts setObject:systemFont forKey:NSFontAttributeName];
        
        CGRect textSize = [decoder.url boundingRectWithSize:CGSizeMake(width, height)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:atts
                                                    context:nil];
        float textHeight = textSize.size.height;
        //Body
        UITextView *body = [[UITextView alloc] initWithFrame:CGRectMake(30,3,(textSize.size.width < 300) ? textSize.size.width :  300,textHeight+10)];
        body.backgroundColor = [UIColor colorWithRed:79.0/255.0 green:128.0/255.0 blue:155.0/255.0 alpha:1.0f];
        body.editable = NO;
        body.scrollEnabled = NO;
        body.backgroundColor=[UIColor clearColor];
        body.textColor=[UIColor blackColor];
        [body setFont:[UIFont  boldSystemFontOfSize:12]];
        body.text = decoder.url;
        [body sizeToFit];
        //SenderLabel
        FXLabel *senderLabel = [[FXLabel alloc] initWithFrame:CGRectMake(10,textHeight +10 ,300,20)];
        senderLabel.backgroundColor=[UIColor clearColor];
        senderLabel.font = [UIFont systemFontOfSize:10];
        senderLabel.textColor=[UIColor blackColor];
        senderLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
        senderLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
        senderLabel.shadowBlur = 1.0f;
        senderLabel.innerShadowBlur = 2.0f;
        senderLabel.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        senderLabel.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
        UIImage *bgImage;
        float senderStartX;
        UIImageView *balloonHolder = [[UIImageView alloc] initWithFrame:CGRectMake(0,5,(textSize.size.width < 300) ? textSize.size.width :  300,textHeight+35 )];
        [balloonHolder.layer setCornerRadius:2.0f ];
        if ([chat.direction isEqualToString:@"IN"])
        { // left aligned
            bgImage = [[UIImage imageNamed:@"leftballoon.png"] stretchableImageWithLeftCapWidth:0  topCapHeight:15];
            body.frame=CGRectMake(40,3,270,textHeight+10 );
            senderLabel.frame=CGRectMake(10,textHeight+15,300,13);
            senderLabel.text= [NSString stringWithFormat:@"%@: %@",self.cleanName,[YDHelper dayLabelForMessage:chat.messageDate]];
            senderStartX=10;
            [senderLabel setTextAlignment:NSTextAlignmentRight];
            [senderLabel setTextColor:[UIColor whiteColor]];
            [body setTextAlignment:NSTextAlignmentRight];
            balloonHolder.backgroundColor=[UIColor colorWithRed:42.0/255.0f green:221.0/255.0f blue:242.0/255.0f alpha:1.0];
            [balloonHolder setFrame:CGRectMake(310 - ((textSize.size.width + 10) < 130 ? 140 : (textSize.size.width + 90)),5,((textSize.size.width + 10) < 130 ? 140 : (textSize.size.width + 90)),textHeight+35 )];
        } else {
            //right aligned
            bgImage = [[UIImage imageNamed:@"rightballoonred.png"] stretchableImageWithLeftCapWidth:0  topCapHeight:15];
            body.frame=CGRectMake(10,3,240.0,textHeight+10);
            senderLabel.frame=CGRectMake(10,textHeight+15,300,13);
            senderLabel.text= [NSString stringWithFormat:@"You %@" ,[YDHelper dayLabelForMessage:chat.messageDate]];
            senderStartX=55;
            [senderLabel setTextAlignment:NSTextAlignmentLeft];
            [senderLabel setTextColor:[UIColor whiteColor]];
            
            [body setTextAlignment:NSTextAlignmentLeft];
            balloonHolder.backgroundColor=[UIColor colorWithRed:147.0/255.0f green:190.0/255.0f blue:26.0/255.0f alpha:1.0];
            [balloonHolder setFrame:CGRectMake(10,5,(textSize.size.width < 300) ? textSize.size.width+ 100 :  300,textHeight+35 )];
            
        }
        CGFloat heightForThisCell =  textHeight + 40;
        UIView *cellContentView = [[UIView alloc] initWithFrame:CGRectMake(0,5,320,heightForThisCell)];
        [cellContentView addSubview:balloonHolder];
        [cellContentView addSubview:body];
        [cellContentView addSubview:senderLabel];
        cell.backgroundView = cellContentView;
    }
	return cell;
}

-(NSString *)getExtensionName:(NSString *)filePath {
    
    NSURL *urll = [NSURL URLWithString:filePath];
    NSString *filenameWithExtension = [urll lastPathComponent];
    
    NSArray *parts = [filenameWithExtension componentsSeparatedByString:@"."];
    if([parts count] >1) {
        NSString *filename = [parts objectAtIndex:[parts count]-2];
        NSString *extension = [parts objectAtIndex:[parts count] - 1];
        
        NSLog(@"%@ %@", filename, extension);
        return extension;
        
    }else {
        return @"";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark screenupdates
//when you start entering text, the table view should be shortened
-(void)shortenTableView
{
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.2];
    self.mtableView.frame=CGRectMake(0,60,ScreenWidth,230);
    [self scrollToBottomAnimated:YES];
    [UIView commitAnimations];
    prevLines=0.9375f;
    
}
//when finished entering text the table view should change to normal size
-(void)showFullTableView {
    
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.2];
    self.sendView.frame = CGRectMake(0,ScreenHeight-60,ScreenWidth,40);
    self.mtableView.frame=CGRectMake(0,60,ScreenWidth,ScreenHeight-80-56);
    [UIView commitAnimations];
    [self scrollToBottomAnimated:YES];
    
    
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    NSInteger bottomRow = [self.chats count] - 1;
    if (bottomRow >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:bottomRow inSection:0];
        [self.mtableView scrollToRowAtIndexPath:indexPath
                               atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

+ (void) loadFromURL: (NSURL*) url callback:(void (^)(UIImage *image))callback {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:imageData];
            callback(image);
        });
    });
}
#pragma mark UITextView Delegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    if([textView.text length] > 0) {
        isRecord = NO;
        [sendButton setFrame:CGRectMake(300 - [UIImage imageNamed:@"record"].size.width - 5,YPaddingDoneBUtton,70,[UIImage imageNamed:@"record"].size.height)];
        if(isDurationButtonSelected) {
            [sendButton setFrame:CGRectMake(300 - [UIImage imageNamed:@"record"].size.width + 9,YPaddingDoneBUtton,40,40)];

            [sendButton setTitle:@"" forState:UIControlStateNormal];
            [sendButton setBackgroundImage:[UIImage imageNamed:@"timeImage"] forState:UIControlStateNormal];
        }else{
            [sendButton setTitle:@"Send" forState:UIControlStateNormal];
            [sendButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
    } else {
        isRecord = YES;
        [sendButton setFrame:CGRectMake(300 - [UIImage imageNamed:@"record"].size.width +10,YPaddingDoneBUtton,[UIImage imageNamed:@"record"].size.width,[UIImage imageNamed:@"record"].size.height)];
        
        [sendButton setTitle:@"" forState:UIControlStateNormal];
        [sendButton setBackgroundImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        [self showFullTableView];
        if([textView.text length] > 0) {
            isRecord = NO;
            [sendButton setFrame:CGRectMake(300 - [UIImage imageNamed:@"record"].size.width - 5,YPaddingDoneBUtton,70,[UIImage imageNamed:@"record"].size.height)];
            if(isDurationButtonSelected) {
                [sendButton setFrame:CGRectMake(300 - [UIImage imageNamed:@"record"].size.width + 9,YPaddingDoneBUtton,40,40)];

                [sendButton setTitle:@"" forState:UIControlStateNormal];
                [sendButton setBackgroundImage:[UIImage imageNamed:@"timeImage"] forState:UIControlStateNormal];
            }else{
                [sendButton setTitle:@"Send" forState:UIControlStateNormal];
                [sendButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            }
        } else {
            isRecord = YES;
            [sendButton setFrame:CGRectMake(300 - [UIImage imageNamed:@"record"].size.width +10,YPaddingDoneBUtton,[UIImage imageNamed:@"record"].size.width,[UIImage imageNamed:@"record"].size.height)];
            
            [sendButton setTitle:@"" forState:UIControlStateNormal];
            [sendButton setBackgroundImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
        }
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView {
    
    if([textView.text length] > 0) {
        isRecord = NO;

        if(isDurationButtonSelected){
            [sendButton setFrame:CGRectMake(300 - [UIImage imageNamed:@"record"].size.width + 9,YPaddingDoneBUtton,40,40)];

            [sendButton setTitle:@"" forState:UIControlStateNormal];
            [sendButton setBackgroundImage:[UIImage imageNamed:@"timeImage.png"] forState:UIControlStateNormal];
        }else {
            [sendButton setFrame:CGRectMake(300 - [UIImage imageNamed:@"record"].size.width - 5,YPaddingDoneBUtton,70,[UIImage imageNamed:@"record"].size.height)];
            [sendButton setTitle:@"Send" forState:UIControlStateNormal];
            [sendButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
       ;
    }else {
        isRecord = YES;
        [sendButton setFrame:CGRectMake(300 - [UIImage imageNamed:@"record"].size.width +10,YPaddingDoneBUtton,[UIImage imageNamed:@"record"].size.width,[UIImage imageNamed:@"record"].size.height)];
        
        [sendButton setTitle:@"" forState:UIControlStateNormal];
        [sendButton setBackgroundImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    }
    
    UIFont* systemFont = [UIFont boldSystemFontOfSize:12];
    int width = 185.0, height = 10000.0;
    NSMutableDictionary *atts = [[NSMutableDictionary alloc] init];
    [atts setObject:systemFont forKey:NSFontAttributeName];
    
    CGRect textSize = [self.msgText.text boundingRectWithSize:CGSizeMake(width, height)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:atts
                                                      context:nil];
    float textHeight = textSize.size.height;
    float lines = textHeight / lineHeightValue;
    // NSLog(@"textViewDidChange h: %0.f  lines %0.f ",textHeight,lines);
    if (lines >=4)
        lines=4;
    if (lines < 1.0)
        lines = 1.0;
    //Send your chat state
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:self.conversationJidString];
    NSXMLElement *status = [NSXMLElement elementWithName:@"composing" xmlns:@"http://jabber.org/protocol/chatstates"];
    [message addChild:status];
    [[self appDelegate].xmppStream sendElement:message];
    
    if (prevLines!=lines)
        [self shortenTableView];
    
    prevLines=lines;
}

-(void)updateTimeInterval:(NSString *)timeInterval{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MessageSetting" inManagedObjectContext:[self appDelegate].managedObjectContext];
	[fetchRequest setEntity:entity];
//    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"isSpecific==%@",[NSNumber numberWithBool:YES]]; // If required to fetch specific vehicle
//    fetchRequest.predicate=predicate;
    NSLog(@"messageSetting %@", [[[self appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject]);

    MessageSetting *messageSetting=[[[self appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:nil] lastObject];
    [messageSetting setValue:[NSString stringWithFormat:@"%@", timeInterval] forKey:@"timeInterval"];
    [[self appDelegate].managedObjectContext save:nil];

}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    TTMDataBaseManager *dataBaseManager = [TTMDataBaseManager sharedMySingleton];
    [dataBaseManager initializeTheCoreDataModelClasses];
    NSMutableArray *dataArray = [dataBaseManager fetchDataFromCoreDataOnMessageSettingInfo];
    if([dataArray count] > 0){
        MessageSetting *delayInfo = [dataArray objectAtIndex:0];
        if([delayInfo.isSpecific boolValue]){
            if(!isDatePicker){
                isDateTimePickerOpen = YES;
                isDatePicker = YES;
                TTMDateTimePicker *timePicker = [[TTMDateTimePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 237, self.view.frame.size.width, 237)];
                [self.view addSubview:timePicker];
                [timePicker callingMethodForGetResponseOfTimeSelected:^(NSString *timeInfo) {
                    isDateTimePickerOpen = NO;
                    NSLog(@"timeInfo timeInfo %@", timeInfo);
                    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
                    
//                    NSString *string = @"7:00";
//                    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//                    NSDateFormatter *timeOnlyFormatter = [[NSDateFormatter alloc] init];
//                    [timeOnlyFormatter setLocale:locale];
//                    [timeOnlyFormatter setDateFormat:@"h:mm"];
//                    
//                    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//                    NSDate *today = [NSDate date];
//                    NSDateComponents *todayComps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
//                    
//                    NSDateComponents *comps = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[timeOnlyFormatter dateFromString:string]];
//                    comps.day = todayComps.day;
//                    comps.month = todayComps.month;
//                    comps.year = todayComps.year;
//                    NSDate *date = [calendar dateFromComponents:comps];
//                    
//                    
                    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                    NSDate *utcDate = [dateFormatter dateFromString:timeInfo];
                    long long timeINtervalLocal = [@(floor([utcDate timeIntervalSince1970] * 1000)) longLongValue];
                    timezInterval = [NSString stringWithFormat:@"%lld", timeINtervalLocal];
                    //[self updateTimeInterval:[NSString stringWithFormat:@"%lld", timeINtervalLocal]];
                }];
                [timePicker setBackgroundColor:[UIColor darkGrayColor]];
                [textView resignFirstResponder];
            }
        }
    }
    if(!isDateTimePickerOpen) {
        [UIView beginAnimations:@"moveView" context:nil];
        [UIView setAnimationDuration:0.3];
        self.sendView.frame = CGRectMake(0,ScreenHeight-280,ScreenWidth,(IS_IPHONE5) ? 50 : 65);
        [UIView commitAnimations];
        [self shortenTableView];
        [self.msgText becomeFirstResponder];
        //Send your chat state
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:self.conversationJidString];
        NSXMLElement *status = [NSXMLElement elementWithName:@"composing" xmlns:@"http://jabber.org/protocol/chatstates"];
        [message addChild:status];
        [[self appDelegate].xmppStream sendElement:message];
    }
}

-(NSString *)makeStringFromJSON :(NSMutableDictionary *)jsonDictionary {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:&error];
    
    NSString *jsonString = nil;
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

-(NSString *)getMessageTypeFromJSON:(NSDictionary *)dict {
    
    NSMutableArray *jsonArray = [dict objectForKey:@"messageList"];
    NSLog(@"jsonArray %@", jsonArray);
    if([jsonArray count]) {
        NSMutableDictionary *temJsonDict = [jsonArray objectAtIndex:0];
        NSLog(@"chat type is %@", [NSString stringWithFormat:@"%@",[temJsonDict objectForKey:@"type"]]);
        return [NSString stringWithFormat:@"%@",[temJsonDict objectForKey:@"type"]];
    }
    return nil;
}

-(NSString *)inserMessageTypeinChat:(NSString *)jsonString {
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData: [jsonString  dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error:nil];
   return [self getMessageTypeFromJSON:JSON];
}
#pragma mark send message
-(IBAction)sendMessage:(id)sender
{
    NSString *messageStr = nil;
    messageStr = [self makeStringFromJSON:[self makeJSONForTextSending:self.msgText.text type:@"1"]];
    if([messageStr length] > 0)
    {
        //send chat message
        
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:messageStr];
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:self.conversationJidString];
        [message addChild:body];
        NSXMLElement *status = [NSXMLElement elementWithName:@"active" xmlns:@"http://jabber.org/protocol/chatstates"];
        [message addChild:status];
        NSLog(@"conversationJidString %@", self.conversationJidString);
        
        if ([_chatType isEqualToString:@"chat"]) {
            [[self appDelegate].xmppStream sendElement:message];
        }else{
            [[self currentRoomCVC] sendMessage:[XMPPMessage messageFromElement:message]];
        }
        
        // We need to put our own message also in CoreData of course and reload the data
        Chat *chat = [NSEntityDescription
                      insertNewObjectForEntityForName:@"Chat"
                      inManagedObjectContext:[self appDelegate].managedObjectContext];
        chat.messageBody = messageStr;
        chat.messageDate = [NSDate date];
        chat.hasMedia=[NSNumber numberWithBool:NO];
        chat.isNew=[NSNumber numberWithBool:NO];
        chat.messageStatus=@"send";
        chat.direction = @"OUT";
        chat.mediaType=  @"text";
        chat.chatType = [self inserMessageTypeinChat:messageStr];
        chat.thumbNail = @"";
        chat.originalURL = @"";
        chat.groupNumber=@"";
        chat.isGroupMessage=[NSNumber numberWithBool:NO];
        chat.jidString =  self.conversationJidString;
        chat.isError = [NSNumber numberWithBool:NO];

        NSError *error = nil;
        if (![[self appDelegate].managedObjectContext save:&error])
        {
            NSLog(@"error saving");
        }
    }
    
    self.msgText.text=@"";
    if ([self.msgText isFirstResponder])
        [self.msgText resignFirstResponder ];
    
    //Reload our data
    [self loadData];
    //Restore the Screen
    [self showFullTableView];
    [sendButton setFrame:CGRectMake(300 - [UIImage imageNamed:@"record"].size.width +10,7,[UIImage imageNamed:@"record"].size.width,[UIImage imageNamed:@"record"].size.height)];
    
    [sendButton setTitle:@"" forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    //  }
    
}


#pragma mark send message
-(IBAction)sendMessageWithMediaType:(NSString *)imageURL thumbnailURL:(NSString *)thumbnail isMEdiaTypeVideo:(BOOL)isvideo thumbNailImage:(UIImage *)image{
    
    NSLog(@"self.categorySelected %d", self.categorySelected);
    NSString *messageStr = nil;
    if ((self.categorySelected != TTMImages) && (self.categorySelected != TTMVideo)) {
        messageStr = (isvideo)? [self makeStringFromJSON:[self makeJSONForFileSending:imageURL thumbnail:thumbnail type:@"3"]]
                                                          : [self makeStringFromJSON:[self makeJSONForFileSending:imageURL thumbnail:thumbnail type:@"2"]];
    }else {
        messageStr = (self.categorySelected == TTMImages)?  [self makeStringFromJSON:[self makeJSONForFileSending:imageURL thumbnail:thumbnail type:@"4"]]
        : [self makeStringFromJSON:[self makeJSONForFileSending:imageURL thumbnail:thumbnail type:@"5"]];
    }
    if([messageStr length] > 0)
    {
        //send chat message
        
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:messageStr];
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:self.conversationJidString];
        [message addChild:body];
        NSXMLElement *status = [NSXMLElement elementWithName:@"active" xmlns:@"http://jabber.org/protocol/chatstates"];
        [message addChild:status];
        NSLog(@"conversationJidString %@", self.conversationJidString);
        
        if ([_chatType isEqualToString:@"chat"]) {
            [[self appDelegate].xmppStream sendElement:message];
        }else{
            [[self currentRoomCVC] sendMessage:[XMPPMessage messageFromElement:message]];
        }
        
        // We need to put our own message also in CoreData of course and reload the data
        Chat *chat = [NSEntityDescription
                      insertNewObjectForEntityForName:@"Chat"
                      inManagedObjectContext:[self appDelegate].managedObjectContext];
        chat.messageBody = messageStr;
        chat.messageDate = [NSDate date];
        chat.hasMedia=[NSNumber numberWithBool: YES];
        chat.isNew=[NSNumber numberWithBool:NO];
        chat.messageStatus=@"send";
        chat.direction = @"OUT";
        chat.mediaType=  @"image";
        chat.chatType = [self inserMessageTypeinChat:messageStr];
        chat.image = UIImageJPEGRepresentation(image, 0.5);
        chat.thumbNail = [NSString stringWithFormat:@"%@", thumbnail];
        chat.originalURL = [NSString stringWithFormat:@"%@",imageURL];
        chat.groupNumber=@"";
        chat.isGroupMessage=[NSNumber numberWithBool:NO];
        chat.jidString =  self.conversationJidString;
        chat.isError = [NSNumber numberWithBool:NO];
        
        NSError *error = nil;
        if (![[self appDelegate].managedObjectContext save:&error])
        {
            NSLog(@"error saving");
        }
    }
    //self.mediaURLString = @"";
    
    self.msgText.text=@"";
    if ([self.msgText isFirstResponder])
        [self.msgText resignFirstResponder ];
    
    //Reload our data
    [self loadData];
    //Restore the Screen
    [self showFullTableView];
    [sendButton setFrame:CGRectMake(300 - [UIImage imageNamed:@"record"].size.width +10,7,[UIImage imageNamed:@"record"].size.width,[UIImage imageNamed:@"record"].size.height)];
    
    [sendButton setTitle:@"" forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    //  }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
