//
//  NSArray+DSReverseArray.m
//  Domains
//
//  Created by Dinesh Mehta on 25/11/13.
//  Copyright (c) 2013 Dinesh Mehta. All rights reserved.
//

#import "NSArray+DSReverseArray.h"

@implementation NSArray (DSReverseArray)
/*@ Category method is define for reverse an array
 */
- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end
