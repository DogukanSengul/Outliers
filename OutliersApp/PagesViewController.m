//
//  PagesContainerViewController.m
//  OutliersApp
//
//  Created by Can ARSLAN on 01/11/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import "PagesViewController.h"
#import "CameraViewController.h"
#import "PageCollectionViewCell.h"
#import "Page.h"
#import "PageThumbViewController.h"

@interface PagesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, CameraViewControllerDelegate>

@property (nonatomic, strong) NSArray *pagesArray;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation PagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pagesArray = [self.notebook.pages array];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pagesArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PageCollectionViewCell *pageCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pageCollectionCell"
                                    forIndexPath:indexPath];
    
    long row = [indexPath row];
    
    Page *page = self.pagesArray[row];
    
//    pageCollectionCell.pageImageView.image = page.image.image;
    
    return pageCollectionCell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"presentCamerView"]) {
        CameraViewController *cameraViewController = segue.destinationViewController;
        cameraViewController.notebook = self.notebook;
        cameraViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"presentPageThumbView"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
        PageImage *pageImage = [self.pagesArray objectAtIndex:indexPath.row];
        PageThumbViewController *pageThumbViewController = segue.destinationViewController;
        pageThumbViewController.notebook = self.notebook;
//        pageThumbViewController.currentPage = pageImage;
    }
}

- (void)notebookDidChange:(Notebook *)notebook {
    self.pagesArray = [self.notebook.pages array];
    [self.collectionView reloadData];
}

@end
