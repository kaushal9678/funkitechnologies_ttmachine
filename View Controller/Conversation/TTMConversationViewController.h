//
//  TTMConversationViewController.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 16/04/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "TTMMediaModel.h"
#import "MyMovieViewController.h"
#import "XMPPRoom.h"

typedef void(^FileReturnName)(TTMMediaModel *urls, NSError *error);

@interface TTMConversationViewController : MyMovieViewController {
    UIView * aProgressView ;
  //  UIProgressView *progressIndicator;
    MBProgressHUD *aMBProgressHUD;
    ASIFormDataRequest *request;
    NSDictionary *pickerInfo ;
    UIImage *theThumbnail ;
    NSData *imgData;
}
@property (nonatomic, strong) NSString *chatType;
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, copy)FileReturnName fileReturnBlock;
@property (nonatomic, strong) NSString *mediaURLString;
@property (strong,nonatomic) IBOutlet UILabel *progressLabel;
@property(weak,nonatomic)IBOutlet  UIProgressView *progressIndicator;
@property (nonatomic,strong) XMPPRoom* currentRoomCVC;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) TTMSelectedCategoryType categorySelected;

-(void)showConversationForJIDString:(NSString *)jidString;
+ (UIImage *)generatePhotoThumbnail:(UIImage *)image ;


@end
