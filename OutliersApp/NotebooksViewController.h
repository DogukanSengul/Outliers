//
//  NotebooksViewController.h
//  OutliersApp
//
//  Created by Can ARSLAN on 01/11/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "BaseViewController.h"

@interface NotebooksViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

- (void)refreshPhotoBrowserWithNotebook:(Notebook *)notebook;

@end
