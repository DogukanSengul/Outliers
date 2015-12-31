//
//  Page+CoreDataProperties.h
//  OutliersApp
//
//  Created by Osman SÖYLEMEZ on 23/12/15.
//  Copyright © 2015 brn. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Page.h"

NS_ASSUME_NONNULL_BEGIN

@interface Page (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *pageImagePath;
@property (nullable, nonatomic, retain) NSNumber *pageNumber;
@property (nullable, nonatomic, retain) NSString *pageThumbImagePath;
@property (nullable, nonatomic, retain) Notebook *notebook;

@end

NS_ASSUME_NONNULL_END
