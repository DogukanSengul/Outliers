//
//  ImageHelper.m
//  OutliersApp
//
//  Created by Can ARSLAN on 02/12/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import "ImageHelper.h"

#define kImageDirectory @"ImagesDirectory"

@implementation ImageHelper

#pragma mark - Directory

+ (NSString *)getDocumentDirectory {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = ([path count] > 0) ? [path objectAtIndex:0] : nil;
    
    if (!documentDirectory)
        return nil;
    return documentDirectory;
}

+ (NSString *)getImagesDirectory {
    NSString *imageDirectory = [self getDocumentDirectory];
    if (imageDirectory) {
        NSString *destinationPath = [imageDirectory stringByAppendingPathComponent:kImageDirectory];
        
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDirectory;
        if ([fileManager fileExistsAtPath:destinationPath isDirectory:&isDirectory]) {
            if (isDirectory)
                return destinationPath;
            else {
                BOOL isSuccess = [fileManager createDirectoryAtPath:destinationPath withIntermediateDirectories:NO attributes:nil error:&error];
                if (!error && isSuccess)
                    return destinationPath;
            }
        } else {
            BOOL isSuccess = [fileManager createDirectoryAtPath:destinationPath withIntermediateDirectories:NO attributes:nil error:&error];
            if (!error && isSuccess)
                return destinationPath;
        }
    }
    return nil;
}

+ (UIImage *)image:(UIImage *)scannedImage PageNumber:(NSString *)pageNumber{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIImage *image = nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scannedImage.size.width,scannedImage.size.height)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:scannedImage];
    [imgView setFrame:CGRectMake(0, 0, scannedImage.size.width,scannedImage.size.height)];
    [view addSubview:imgView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height / 30.0, view.frame.size.width - view.frame.size.height / 30.0, view.frame.size.height / 20.0)];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont boldSystemFontOfSize:view.frame.size.height / 25.0]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:pageNumber];
    [label setTextAlignment:NSTextAlignmentRight];
    [view addSubview:label];
    
    //Optimized/fast method for rendering a UIView as image on iOS 7 and later versions.
    /*
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, scale);
    [view drawViewHierarchyInRect:view.frame afterScreenUpdates:YES];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    */
    UIGraphicsBeginImageContext(view.frame.size);
    [scannedImage drawInRect:view.frame];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return image;
}

+ (NSString *)saveImageToDirectory:(UIImage *)image withName:(NSString *)imageName {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    NSString *filePath = [[ImageHelper getImagesDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageName]];
    [imageData writeToFile:filePath atomically:YES];
    
    return [NSString stringWithFormat:@"%@.jpg", imageName];
}

+ (NSString *)saveImageThumbToDirectory:(UIImage *)image withName:(NSString *)imageName {
    
    int factor = image.size.width / 200;
    
    CGSize sacleSize = CGSizeMake(image.size.width/factor, image.size.height/factor);
    UIGraphicsBeginImageContextWithOptions(sacleSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, sacleSize.width, sacleSize.height)];
    UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.1);
    
    NSString *filePath = [[ImageHelper getImagesDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_thumb.jpg", imageName]];
    [imageData writeToFile:filePath atomically:YES];
    
    return [NSString stringWithFormat:@"%@_thumb.jpg", imageName];
}

+ (UIImage *)getImageAtFilePath:(NSString *)fileName {
    NSData *imageData = [NSData dataWithContentsOfFile:[[ImageHelper getImagesDirectory] stringByAppendingPathComponent:fileName]];
    UIImage *image = [UIImage imageWithData:imageData];
    
    CGSize sacleSize = CGSizeMake(image.size.width/2, image.size.height/2);
    UIGraphicsBeginImageContextWithOptions(sacleSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, sacleSize.width, sacleSize.height)];
    UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

@end
