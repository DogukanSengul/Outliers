//
//  ImagePreviewView.m
//  OutliersApp
//
//  Created by Can ARSLAN on 16/10/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import "ImagePreviewView.h"

@implementation ImagePreviewView

- (void)awakeFromNib{
    [self.imageView setClipsToBounds:YES];
}

@end
