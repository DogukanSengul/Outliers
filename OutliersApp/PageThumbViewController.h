//
//  PageThumbViewController.h
//  OutliersApp
//
//  Created by Can ARSLAN on 10/11/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"
#import "Notebook.h"

@interface PageThumbViewController : UIViewController <UIPageViewControllerDataSource>

- (IBAction)startWalkthrough:(id)sender;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@property (strong, nonatomic) Notebook *notebook;

@end
