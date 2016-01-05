//
//  NSString+Utils.m
//  OutliersApp
//
//  Created by Osman SÖYLEMEZ on 05/01/16.
//  Copyright © 2016 brn. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

- (BOOL)isANumber{
    NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '^[0-9]+$'"];
    return [numberPredicate evaluateWithObject:self];
}

@end
