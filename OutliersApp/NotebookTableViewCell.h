//
//  NotebookTableViewCell.h
//  OutliersApp
//
//  Created by Can ARSLAN on 14/10/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotebookTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *notebookNameLbl;
@property (weak, nonatomic) IBOutlet UIView *colorView;

@end
