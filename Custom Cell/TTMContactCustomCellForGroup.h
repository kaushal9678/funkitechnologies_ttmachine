//
//  TTMContactCustomCellForGroup.h
//  TextTimeMachine
//
//  Created by essadmin on 5/26/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "TTMMedallionView.h"
@interface TTMContactCustomCellForGroup : UITableViewCell
@property (nonatomic, strong) TTMMedallionView    *connectionImage;
@property (nonatomic, strong) UILabel        *name;
@property (nonatomic, strong) UILabel        *subTitle;
@property (nonatomic, strong) UILabel        *deviceIdentifier;
@property (nonatomic, strong) UIImageView    *statusSymbol;
@property (nonatomic, strong) UIImageView    *selectedSymbol;
@end
