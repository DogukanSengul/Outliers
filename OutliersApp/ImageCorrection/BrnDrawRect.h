//
//  BrnDrawRect.h
//  BrnImageCropper
//
//  Created by Can ARSLAN on 18/10/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrnDrawRect : UIView
{
    CGPoint touchOffset;
    CGPoint a;
    CGPoint b;
    CGPoint c;
    CGPoint d;
    
    BOOL frameMoved;
}

@property (strong, nonatomic) UIButton *pointD;
@property (strong, nonatomic) UIButton *pointC;
@property (strong, nonatomic) UIButton *pointB;
@property (strong, nonatomic) UIButton *pointA;

- (BOOL)frameEdited;
- (void)resetFrame;
- (CGPoint)coordinatesForPoint:(int)point withScaleFactor:(CGFloat)scaleFactor;

- (void)bottomLeftCornerToCGPoint:(CGPoint)point;
- (void)bottomRightCornerToCGPoint:(CGPoint)point;
- (void)topRightCornerToCGPoint:(CGPoint)point;
- (void)topLeftCornerToCGPoint:(CGPoint)point;

@end
