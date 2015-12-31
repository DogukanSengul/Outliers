//
//  UIImageView+ContentFrame.h
//  BrnImageCropper
//
//  Created by Can ARSLAN on 18/10/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView (UIImageView_ContentFrame)

- (CGRect)contentFrame;
- (CGFloat)contentScale;
- (CGSize)contentSize;

@end
