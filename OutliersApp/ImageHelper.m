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
