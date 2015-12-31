//
//  Notebook+CoreDataProperties.h
//  OutliersApp
//
//  Created by Can ARSLAN on 08/11/15.
//  Copyright © 2015 brn. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Notebook.h"

NS_ASSUME_NONNULL_BEGIN

@interface Notebook (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSOrderedSet<Page *> *pages;

@end

@interface Notebook (CoreDataGeneratedAccessors)

- (void)insertObject:(Page *)value inPagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPagesAtIndex:(NSUInteger)idx;
- (void)insertPages:(NSArray<Page *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPagesAtIndex:(NSUInteger)idx withObject:(Page *)value;
- (void)replacePagesAtIndexes:(NSIndexSet *)indexes withPages:(NSArray<Page *> *)values;
- (void)addPagesObject:(Page *)value;
- (void)removePagesObject:(Page *)value;
- (void)addPages:(NSOrderedSet<Page *> *)values;
- (void)removePages:(NSOrderedSet<Page *> *)values;

@end

NS_ASSUME_NONNULL_END
