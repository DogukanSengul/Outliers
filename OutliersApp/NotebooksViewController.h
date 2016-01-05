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
#import "CenteredButton.h"

@interface NotebooksViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (weak, nonatomic) IBOutlet CenteredButton *addNoteBookButton;

- (void)refreshPhotoBrowserWithNotebook:(Notebook *)notebook;

@end
