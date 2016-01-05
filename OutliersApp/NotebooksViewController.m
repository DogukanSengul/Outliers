//
//  NotebooksViewController.m
//  OutliersApp
//
//  Created by Can ARSLAN on 01/11/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import "NotebooksViewController.h"
#import "AppDelegate.h"
#import "NotebookTableViewCell.h"
#import "Notebook+CoreDataProperties.h"
#import "DatabaseHelper.h"
#import "NewNotebookViewController.h"
#import "PagesViewController.h"
#import "SDImageCache.h"
#import "MWCommon.h"
#import "MWPhotoBrowser.h"
#import "ImageHelper.h"
#import "Page.h"
#import "PageSelectionInfo.h"

@interface NotebooksViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSManagedObjectContext *moc;
@property (nonatomic, strong) NSMutableArray *notebooks;
@property (nonatomic, strong) MWPhotoBrowser *browser;

@end

@implementation NotebooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.moc = appDelegate.managedObjectContext;
    
    [self.addNoteBookButton centerAlignment];
}

- (void)viewWillAppear:(BOOL)animated {
    self.notebooks = [NSMutableArray arrayWithArray:[DatabaseHelper getObjectsForEntity:@"Notebook" withSortKey:@"name" andSortAscending:YES andContext:self.moc]];
    [self.tableView reloadData];
    [self setNavigationAppearece:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)addBtnTapped:(id)sender {
    NewNotebookViewController *newNotebookViewController = (NewNotebookViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"NewNotebookViewController"];
    [self presentViewController:newNotebookViewController animated:YES completion:nil];
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notebooks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotebookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notebookTableViewCell"];
    
    if (cell == nil) {
        cell = [[NotebookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notebookTableViewCell"];
    }
    
    cell.notebookNameLbl.text = [(Notebook *)self.notebooks[indexPath.row] name];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        Notebook *notebook = [self.notebooks objectAtIndex:indexPath.row];
        [DatabaseHelper deleteObject:notebook context:self.moc];
        [self.notebooks removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    Notebook *notebook = [self.notebooks objectAtIndex:path.row];
    
    [self loadSelectedNotebook:notebook];
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = YES;
    
    // Create browser
    self.browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    self.browser.displayActionButton = displayActionButton;
    self.browser.displayNavArrows = displayNavArrows;
    self.browser.displaySelectionButtons = displaySelectionButtons;
    self.browser.alwaysShowControls = displaySelectionButtons;
    self.browser.zoomPhotosToFill = YES;
    self.browser.enableGrid = enableGrid;
    self.browser.startOnGrid = startOnGrid;
    self.browser.enableSwipeToDismiss = NO;
    self.browser.autoPlayOnAppear = NO;
    self.browser.notebook = notebook;
    
    [self.navigationController pushViewController:self.browser animated:YES];

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < self.thumbs.count)
        return [self.thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    if (index < self.browser.selectionPages.count){
        PageSelectionInfo *pageSelectionInfo = [self.browser.selectionPages objectAtIndex:index];
        return [pageSelectionInfo selected];
    }
    return NO;
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    if (index < self.browser.selectionPages.count){
        PageSelectionInfo *pageSelectionInfo = [self.browser.selectionPages objectAtIndex:index];
        pageSelectionInfo.selected = selected;
        //[self.browser.selectionPages replaceObjectAtIndex:index withObject:pageSelectionInfo];
    }

    
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Delegate

- (void)refreshPhotoBrowserWithNotebook:(Notebook *)notebook {
    [self loadSelectedNotebook:notebook];
    self.browser.notebook = notebook;
    [self.browser reloadData];
}

#pragma mark - Business

- (void)loadSelectedNotebook:(Notebook *)notebook {
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"pageNumber" ascending:YES];
    NSArray *sorted = [notebook.pages sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
        
    for (Page *page in sorted) {
        [photos addObject:[MWPhoto photoWithURL:[NSURL fileURLWithPath:[[ImageHelper getImagesDirectory] stringByAppendingPathComponent:page.pageImagePath]]]];
        [thumbs addObject:[MWPhoto photoWithURL:[NSURL fileURLWithPath:[[ImageHelper getImagesDirectory] stringByAppendingPathComponent:page.pageThumbImagePath]]]];
    }
    
    self.photos = photos;
    self.thumbs = thumbs;
}

@end
