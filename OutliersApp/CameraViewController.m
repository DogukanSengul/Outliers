//
//  CameraViewController.m
//  OutliersApp
//
//  Created by Can ARSLAN on 03/11/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import "CameraViewController.h"
#import "IPDFCameraViewController.h"
#import "ImagePreviewView.h"
#import "ImageCorrection/ImageCorrectionViewController.h"
#import "AppDelegate.h"
#import "DatabaseHelper.h"
#import "Page+CoreDataProperties.h"
#import "Page.h"
#import "ImageHelper.h"

@interface CameraViewController () <IPDFCameraViewDelegate, ImageCorrectionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *scannedQRLabel;
@property (weak, nonatomic) IBOutlet IPDFCameraViewController *cameraViewController;
@property (weak, nonatomic) IBOutlet UIImageView *focusIndicator;
@property (strong, nonatomic) UIImage* scannedImage;
@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) ImagePreviewView *imagePreviewView;

- (IBAction)focusGesture:(id)sender;

- (IBAction)captureButton:(id)sender;

@end

@implementation CameraViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.moc = appDelegate.managedObjectContext;
    
    [self.cameraViewController setupCameraView];
    [self.cameraViewController setEnableBorderDetection:YES];
    
    self.cameraViewController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.cameraViewController start];
    self.scannedQRLabel.text = @"Page #";
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark CameraVC Actions

- (IBAction)focusGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized)
    {
        CGPoint location = [sender locationInView:self.cameraViewController];
        
        [self focusIndicatorAnimateToPoint:location];
        
        [self.cameraViewController focusAtPoint:location completionHandler:^
         {
             [self focusIndicatorAnimateToPoint:location];
         }];
    }
}

- (void)focusIndicatorAnimateToPoint:(CGPoint)targetPoint {
    [self.focusIndicator setCenter:targetPoint];
    self.focusIndicator.alpha = 0.0;
    self.focusIndicator.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^
     {
         self.focusIndicator.alpha = 1.0;
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.4 animations:^
          {
              self.focusIndicator.alpha = 0.0;
          }];
     }];
}

- (IBAction)borderDetectToggle:(id)sender {
    BOOL enable = !self.cameraViewController.isBorderDetectionEnabled;
    [self changeButton:sender targetTitle:(enable) ? @"CROP On" : @"CROP Off" toStateEnabled:enable];
    self.cameraViewController.enableBorderDetection = enable;
}

- (IBAction)filterToggle:(id)sender
{
    [self.cameraViewController setCameraViewType:(self.cameraViewController.cameraViewType == IPDFCameraViewTypeBlackAndWhite) ? IPDFCameraViewTypeNormal : IPDFCameraViewTypeBlackAndWhite];
}

- (IBAction)torchToggle:(id)sender {
    BOOL enable = !self.cameraViewController.isTorchEnabled;
    [self changeButton:sender targetTitle:(enable) ? @"FLASH On" : @"FLASH Off" toStateEnabled:enable];
    self.cameraViewController.enableTorch = enable;
}

- (void)changeButton:(UIButton *)button targetTitle:(NSString *)title toStateEnabled:(BOOL)enabled {
    //[button setTitle:title forState:UIControlStateNormal];
    //[button setTitleColor:(enabled) ? [UIColor colorWithRed:1 green:0.81 blue:0 alpha:1] : [UIColor whiteColor] forState:UIControlStateNormal];
    [button setSelected:enabled];
}

#pragma mark -
#pragma mark CameraVC Capture Image

- (IBAction)captureButton:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    [self.cameraViewController captureImageWithCompletionHander:^(NSString *imageFilePath)
     {
         self.scannedImage = [UIImage imageWithContentsOfFile:imageFilePath];
         NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"ImagePreviewView"
                                                           owner:self
                                                         options:nil];
         
         float width = self.view.frame.size.width - 20;
         float height = (self.scannedImage.size.height * width) / self.scannedImage.size.width;
         
         self.imagePreviewView = [nibViews firstObject];
         [self.imagePreviewView setFrame:CGRectMake(0, 64, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height - 60)];
         //[self.imagePreviewView setCenter:weakSelf.view.center];
         self.imagePreviewView.imageView.image = [UIImage imageWithContentsOfFile:imageFilePath];
         [weakSelf.view addSubview:self.imagePreviewView];
         
         UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(dismissPreview:)];
         [self.imagePreviewView addGestureRecognizer:dismissTap];
         
         [self.imagePreviewView.adjustBtn addTarget:self action:@selector(pushAdjustView:) forControlEvents:UIControlEventTouchUpInside];
         [self.imagePreviewView.useButton addTarget:self action:@selector(useImage:) forControlEvents:UIControlEventTouchUpInside];
         
         [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.7 options:UIViewAnimationOptionAllowUserInteraction animations:^
          {
              //[self.imagePreviewView.imageView setFrame:weakSelf.view.bounds];
              [self.imagePreviewView.imageView setFrame:CGRectMake(10, 0, width, height)];
          } completion:nil];
     }];
}

- (void)didCaptureString:(NSString *)string {
    self.scannedQRLabel.text = string;
    self.qrImageView.hidden = NO;
}

- (void)dismissPreview:(UITapGestureRecognizer *)dismissTap {
    [self.cameraViewController addMetaDataOutput];
    [self.cameraViewController start];

    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.imagePreviewView.frame = CGRectOffset(self.view.bounds, 0, self.view.bounds.size.height);
    }
                     completion:^(BOOL finished) {
                         [self.imagePreviewView removeFromSuperview];
                         [self.qrImageView setHidden:YES];
                         self.scannedQRLabel.text = @"Page #";
                     }];
}

- (void)pushAdjustView:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"presentImageCorrectionView" sender:nil];
    });
}

- (void)useImage:(id)sender {
    Page *page = (Page *)[DatabaseHelper insertNewEntityWithName:@"Page" andContext:self.moc];
    if (!self.qrImageView.hidden) {
        page.pageNumber = self.scannedQRLabel.text;
    }

    page.notebook = self.notebook;
    NSString *imageName = [[NSUUID UUID] UUIDString];
    
    page.pageImagePath = [ImageHelper saveImageToDirectory:self.scannedImage withName:imageName];
    page.pageThumbImagePath = [ImageHelper saveImageThumbToDirectory:self.scannedImage withName:imageName];

    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.notebook.pages];
    [tempSet addObject:page];
    self.notebook.pages = tempSet;
    
    NSError *error = nil;
    [self.moc save:&error];
    
    [self dismissPreview:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"presentImageCorrectionView"]) {
        
        ImageCorrectionViewController *imageCorrectionViewController = segue.destinationViewController;
        imageCorrectionViewController.image = self.scannedImage;
        imageCorrectionViewController.delegate = self;
    }
}

- (void)didSaveImage:(UIImage *)savedImage {
    Page *page = (Page *)[DatabaseHelper insertNewEntityWithName:@"Page" andContext:self.moc];
    if (!self.qrImageView.hidden) {
        page.pageNumber = self.scannedQRLabel.text;
    }
    
    NSString *imageName = [[NSUUID UUID] UUIDString];
    
    page.pageImagePath = [ImageHelper saveImageToDirectory:savedImage withName:imageName];
    page.pageThumbImagePath = [ImageHelper saveImageThumbToDirectory:savedImage withName:imageName];

    page.notebook = self.notebook;
    
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.notebook.pages];
    [tempSet addObject:page];
    self.notebook.pages = tempSet;
    
    NSError *error;
    [self.moc save:&error];
}

- (IBAction)dismissView:(id)sender {
    [self.delegate notebookDidChange:self.notebook];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.cameraViewController stop];
    }];
}

@end
