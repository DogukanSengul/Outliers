//
//  PageSelectionInfo.h
//  OutliersApp
//
//  Created by Osman SÖYLEMEZ on 23/12/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Page.h"

@interface PageSelectionInfo : NSObject

@property (nonatomic, strong) Page *page;
@property (nonatomic) BOOL selected;

@end
