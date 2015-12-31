//
//  ViewController.h
//  BrnImageCropper
//
//  Created by Can ARSLAN on 18/10/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageCorrectionViewControllerDelegate <NSObject>

- (void)didSaveImage:(UIImage *)pageImage;
- (void)dismissPreview:(UITapGestureRecognizer *)dismissTap;

@end

@interface ImageCorrectionViewController : UIViewController

@property (weak, nonatomic) id<ImageCorrectionViewControllerDelegate> delegate;

@property (nonatomic, strong) UIImage *image;

@end

