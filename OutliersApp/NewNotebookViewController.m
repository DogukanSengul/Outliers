//
//  NewNotebookViewController.m
//  OutliersApp
//
//  Created by Can ARSLAN on 01/11/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import "NewNotebookViewController.h"
#import "AppDelegate.h"
#import "DatabaseHelper.h"
#import "Notebook+CoreDataProperties.h"
#import "Notebook.h"

@interface NewNotebookViewController ()

@property (nonatomic, strong) NSManagedObjectContext *moc;

@property (nonatomic, weak) IBOutlet UITextField *notebookNameTxt;

@end

@implementation NewNotebookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.moc = appDelegate.managedObjectContext;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneBtnTapped:(id)sender {
    Notebook *notebook = (Notebook *)[DatabaseHelper insertNewEntityWithName:@"Notebook" andContext:self.moc];
    notebook.name = self.notebookNameTxt.text;
    
    NSError *error;
    [self.moc save:&error];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeBtnTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
