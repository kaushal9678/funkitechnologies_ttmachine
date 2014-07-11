//
//  TTMDataAwareTurnSocket.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 04/04/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//
#import "TURNSocket.h"

#import <Foundation/Foundation.h>

@interface TTMDataAwareTurnSocket : TURNSocket {
    NSData *dataToSend;
}

@property (nonatomic, readwrite) NSData *dataToSend;


@end
