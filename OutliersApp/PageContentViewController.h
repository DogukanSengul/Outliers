//
//  PageContentViewController.h
//  OutliersApp
//
//  Created by Can ARSLAN on 10/11/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

@end
