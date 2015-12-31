//
//  IPDFCameraViewController.h
//  InstaPDF
//
//  Created by Maximilian Mackh on 06/01/15.
//  Copyright (c) 2015 mackh ag. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,IPDFCameraViewType)
{
    IPDFCameraViewTypeBlackAndWhite,
    IPDFCameraViewTypeNormal
};

@protocol IPDFCameraViewDelegate <NSObject>

- (void)didCaptureString:(NSString *)string;

@end

@interface IPDFCameraViewController : UIView

@property (nonatomic, weak) id <IPDFCameraViewDelegate> delegate;
@property (nonatomic,assign,getter=isBorderDetectionEnabled) BOOL enableBorderDetection;
@property (nonatomic,assign,getter=isTorchEnabled) BOOL enableTorch;
@property (nonatomic,assign) IPDFCameraViewType cameraViewType;

- (void)setupCameraView;

- (void)start;
- (void)stop;

- (void)focusAtPoint:(CGPoint)point completionHandler:(void(^)())completionHandler;

- (void)captureImageWithCompletionHander:(void(^)(NSString *imageFilePath))completionHandler;

@end
