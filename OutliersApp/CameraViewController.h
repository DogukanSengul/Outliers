//
//  CameraViewController.h
//  OutliersApp
//
//  Created by Can ARSLAN on 03/11/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notebook.h"
#import "BaseViewController.h"

@protocol CameraViewControllerDelegate <NSObject>

- (void)notebookDidChange:(Notebook *)notebook;

@end

@interface CameraViewController : BaseViewController

@property (weak, nonatomic) id<CameraViewControllerDelegate> delegate;
@property (nonatomic, strong) Notebook *notebook;

- (void)dismissPreview:(UITapGestureRecognizer *)dismissTap;

@end
