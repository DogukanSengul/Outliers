//
//  UIImageView+ContentFrame.m
//  BrnImageCropper
//
//  Created by Can ARSLAN on 18/10/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import "UIImageView+ContentFrame.h"

@implementation UIImageView (UIImageView_ContentFrame)

- (CGRect)contentFrame {
    CGSize imageSize = self.image.size;
    CGFloat imageScale = fminf(CGRectGetWidth(self.bounds)/imageSize.width, CGRectGetHeight(self.bounds)/imageSize.height);
    CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
    CGRect imageFrame = CGRectMake(0.5f*(CGRectGetWidth(self.bounds)-scaledImageSize.width), 0.5f*(CGRectGetHeight(self.bounds)-scaledImageSize.height), scaledImageSize.width, scaledImageSize.height);
    return imageFrame;
}

- (CGSize)contentSize {
    CGSize imageSize = self.image.size;
   
    CGFloat imageScale = fminf(CGRectGetWidth(self.bounds)/imageSize.width, CGRectGetHeight(self.bounds)/imageSize.height);
    CGSize finalSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
    
    return finalSize;
}

- (CGFloat)contentScale {
    CGSize imageSize = self.image.size;
    CGFloat imageScale = fminf(CGRectGetWidth(self.bounds)/imageSize.width, CGRectGetHeight(self.bounds)/imageSize.height);
    return imageScale;
}

@end