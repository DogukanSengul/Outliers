//
//  ViewController.m
//  BrnImageCropper
//
//  Created by Can ARSLAN on 18/10/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import "ImageCorrectionViewController.h"
#import "BrnDrawRect.h"
#import "UIImageView+ContentFrame.h"

#define UIViewAutoresizingFlexibleMargins                 \
UIViewAutoresizingFlexibleBottomMargin    | \
UIViewAutoresizingFlexibleLeftMargin      | \
UIViewAutoresizingFlexibleRightMargin     | \
UIViewAutoresizingFlexibleTopMargin

@interface ImageCorrectionViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIButton *originalBtn;
@property (nonatomic, weak) IBOutlet UIButton *cropBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic, strong) BrnDrawRect *adjustRect;
@property (nonatomic, assign) CGFloat scaleRatio;
@property (nonatomic, assign) CGFloat scaleFactor;

@end

@implementation ImageCorrectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = self.image;
    
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];

    self.scaleFactor = [self.imageView contentScaleFactor];
    self.scaleRatio = [self.imageView contentScale];
    
    [self initCropView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)initCropView {
    [self.originalBtn setEnabled:NO];
    [self.saveBtn setEnabled:NO];
    
    self.adjustRect = [[BrnDrawRect alloc] initWithFrame:self.imageView.frame];
    self.adjustRect.autoresizingMask = UIViewAutoresizingFlexibleMargins;
    [self.view addSubview:self.adjustRect];
    
    CIImage* ciimage = [[CIImage alloc] initWithCGImage:self.imageView.image.CGImage];
    
    CIRectangleFeature *rectangleFeature = [self biggestRectangleInRectangles:[[self highAccuracyRectangleDetector] featuresInImage:ciimage]];
    
    if (rectangleFeature) {
        [self convertCIToCG:rectangleFeature];
    }
}

- (CIDetector *)highAccuracyRectangleDetector
{
    static CIDetector *detector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      detector = [CIDetector detectorOfType:CIDetectorTypeRectangle context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
                  });
    return detector;
}

- (CIImage *)drawHighlightOverlayForPoints:(CIImage *)image topLeft:(CGPoint)topLeft topRight:(CGPoint)topRight bottomLeft:(CGPoint)bottomLeft bottomRight:(CGPoint)bottomRight {
    CIImage *overlay = [CIImage imageWithColor:[CIColor colorWithRed:1 green:0 blue:0 alpha:0.6]];
    overlay = [overlay imageByCroppingToRect:image.extent];
    overlay = [overlay imageByApplyingFilter:@"CIPerspectiveTransformWithExtent" withInputParameters:@{@"inputExtent":[CIVector vectorWithCGRect:image.extent],@"inputTopLeft":[CIVector vectorWithCGPoint:topLeft],@"inputTopRight":[CIVector vectorWithCGPoint:topRight],@"inputBottomLeft":[CIVector vectorWithCGPoint:bottomLeft],@"inputBottomRight":[CIVector vectorWithCGPoint:bottomRight]}];
    
    return [overlay imageByCompositingOverImage:image];
}

- (CIRectangleFeature *)biggestRectangleInRectangles:(NSArray *)rectangles {
    if (![rectangles count]) return nil;
    
    float halfPerimiterValue = 0;
    
    CIRectangleFeature *biggestRectangle = [rectangles firstObject];
    
    for (CIRectangleFeature *rect in rectangles)
    {
        CGPoint p1 = rect.topLeft;
        CGPoint p2 = rect.topRight;
        CGFloat width = hypotf(p1.x - p2.x, p1.y - p2.y);
        
        CGPoint p3 = rect.topLeft;
        CGPoint p4 = rect.bottomLeft;
        CGFloat height = hypotf(p3.x - p4.x, p3.y - p4.y);
        
        CGFloat currentHalfPerimiterValue = height + width;
        
        if (halfPerimiterValue < currentHalfPerimiterValue)
        {
            halfPerimiterValue = currentHalfPerimiterValue;
            biggestRectangle = rect;
        }
    }
    
    return biggestRectangle;
}

- (CIImage *)correctPerspectiveForImage:(CIImage *)image withFeatures:(NSDictionary *)rectangleCoordinates {
    return [image imageByApplyingFilter:@"CIPerspectiveCorrection" withInputParameters:rectangleCoordinates];
}

- (UIImage *)makeUIImageFromCIImage:(CIImage *)ciImage {
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:ciImage fromRect:[ciImage extent]];
    
    UIImage* uiImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return uiImage;
}

- (CGPoint)pointForCoordinate:(CGPoint)point {
    point =  CGPointMake(point.x * self.scaleRatio / self.scaleFactor, point.y * self.scaleRatio / self.scaleFactor);
    
    return point;
}

- (void)convertCIToCG:(CIRectangleFeature *)rectFeature {
    CGRect rect = [self.imageView contentFrame];
    CGFloat axisCorrection = rect.origin.y + rect.size.height;
    CGFloat scale = self.scaleRatio/self.scaleFactor;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
    transform = CGAffineTransformTranslate(transform, 0, -axisCorrection/scale);

    CGPoint topLeft = CGPointApplyAffineTransform(rectFeature.topLeft, transform);
    CGPoint topRight = CGPointApplyAffineTransform(rectFeature.topRight, transform);
    CGPoint bottomRight = CGPointApplyAffineTransform(rectFeature.bottomRight, transform);
    CGPoint bottomLeft = CGPointApplyAffineTransform(rectFeature.bottomLeft, transform);
    
    topLeft = [self pointForCoordinate:topLeft];
    topRight = [self pointForCoordinate:topRight];
    bottomRight = [self pointForCoordinate:bottomRight];
    bottomLeft = [self pointForCoordinate:bottomLeft];

    [self.adjustRect topLeftCornerToCGPoint:topLeft];
    [self.adjustRect topRightCornerToCGPoint:topRight];
    [self.adjustRect bottomRightCornerToCGPoint:bottomRight];
    [self.adjustRect bottomLeftCornerToCGPoint:bottomLeft];
}

- (NSDictionary *)convertCGToCI {
    CGRect rect = [self.imageView contentFrame];
    CGFloat axisCorrection = rect.origin.y + rect.size.height;
    CGFloat scale = self.scaleRatio/self.scaleFactor;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
    transform = CGAffineTransformTranslate(transform, 0, -axisCorrection/scale);
    
    CGPoint bottomLeft = [_adjustRect coordinatesForPoint:1 withScaleFactor:scale];
    CGPoint bottomRight = [_adjustRect coordinatesForPoint:2 withScaleFactor:scale];
    CGPoint topRight = [_adjustRect coordinatesForPoint:3 withScaleFactor:scale];
    CGPoint topLeft = [_adjustRect coordinatesForPoint:4 withScaleFactor:scale];
    
    CGPoint tBottonLeft = CGPointApplyAffineTransform(bottomLeft, transform);
    CGPoint tBottomRight = CGPointApplyAffineTransform(bottomRight, transform);
    CGPoint tTopRight = CGPointApplyAffineTransform(topRight, transform);
    CGPoint tTopLeft = CGPointApplyAffineTransform(topLeft, transform);
    
    NSMutableDictionary *rectangleCoordinates = [NSMutableDictionary new];
    
    rectangleCoordinates[@"inputTopLeft"] = [CIVector vectorWithCGPoint:tTopLeft];
    rectangleCoordinates[@"inputTopRight"] = [CIVector vectorWithCGPoint:tTopRight];
    rectangleCoordinates[@"inputBottomLeft"] = [CIVector vectorWithCGPoint:tBottonLeft];
    rectangleCoordinates[@"inputBottomRight"] = [CIVector vectorWithCGPoint:tBottomRight];
    
    return rectangleCoordinates;
}

- (IBAction)crop:(id)sender {
    CIImage* ciimage = [[CIImage alloc] initWithCGImage:self.imageView.image.CGImage];
    
    ciimage = [self correctPerspectiveForImage:ciimage withFeatures:[self convertCGToCI]];
    
    self.imageView.image = [self makeUIImageFromCIImage:ciimage];
    
    [self.adjustRect removeFromSuperview];
    
    [self.originalBtn setEnabled:YES];
    [self.saveBtn setEnabled:YES];
}

- (IBAction)loadOriginal:(id)sender {
    self.imageView.image = self.image;
    [self initCropView];
}

- (IBAction)useImage:(id)sender {
    [self.delegate didSaveImage:self.imageView.image];
    [self.delegate dismissPreview:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
