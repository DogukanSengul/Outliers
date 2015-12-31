//
//  BaseViewController.m
//  OutliersApp
//
//  Created by Osman SÖYLEMEZ on 30/12/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setNavigationAppearece:(BOOL)translucent{
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = [UIColor whiteColor];
    navBar.barTintColor = [UIColor colorWithRed:34/255.0 green:37/255.0 blue:46/255.0 alpha:1.0];
    navBar.translucent = translucent;
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    UIImage* logoImage = [UIImage imageNamed:@"navbar_logo"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:40/255.0 green:44/255.0 blue:55/255.0 alpha:1.0];
}

@end
