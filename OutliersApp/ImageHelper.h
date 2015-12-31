//
//  ImageHelper.h
//  OutliersApp
//
//  Created by Can ARSLAN on 02/12/15.
//  Copyright © 2015 brn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

@interface ImageHelper : NSObject

+ (NSString *)getDocumentDirectory;
+ (NSString *)getImagesDirectory;
+ (NSString *)saveImageToDirectory:(UIImage *)image withName:(NSString *)imageName;
+ (NSString *)saveImageThumbToDirectory:(UIImage *)image withName:(NSString *)imageName;
+ (UIImage *)getImageAtFilePath:(NSString *)fileName;

@end
