//
//  TTMContactsFetch.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/9/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMContactsFetch : NSObject

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *email;
@property (nonatomic, strong)NSString *phoneNumber;
@property (nonatomic, strong) UIImage *personImage;
@end
