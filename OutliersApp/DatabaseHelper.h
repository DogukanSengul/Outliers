//
//  DatabaseHelper.h
//  Barkonot
//
//  Created by BoranA on 03.10.2012.
//  Copyright (c) 2012 BoranA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DatabaseHelper : NSObject <NSFetchedResultsControllerDelegate> {
    
}

+ (NSManagedObject *)insertNewEntityWithName:(NSString *)entityName
                                  andContext:(NSManagedObjectContext *)managedObjectContext;

+ (NSMutableArray *)getObjectsForEntity:(NSString*)entityName withSortKey:(NSString*)sortKey
                      andSortAscending:(BOOL)sortAscending andContext:(NSManagedObjectContext *)managedObjectContext;
+ (NSMutableArray *)searchObjectsForEntity:(NSString*)entityName
                            withPredicate:(NSPredicate *)predicate
                               andSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending
                               andContext:(NSManagedObjectContext *)managedObjectContext;
+ (BOOL)deleteAllObjectsForEntity:(NSString*)entityName andContext:(NSManagedObjectContext *)managedObjectContext;
+ (void)deleteObject:(NSManagedObject *)object context:(NSManagedObjectContext *)managedObjectContext;

+ (NSUInteger)countForEntity:(NSString *)entityName andContext:(NSManagedObjectContext *)managedObjectContext;
+ (NSUInteger)countForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate
                 andContext:(NSManagedObjectContext *)managedObjectContext;
+ (NSManagedObject *)getLastObjectForEntity:(NSString *)entityName forAttribute:(NSString *)attribute withPredicate:(NSPredicate *)predicate andContext:(NSManagedObjectContext *)managedObjectContext;

+ (NSError *)saveCoreData:(NSManagedObjectContext *)managedObjectContext;

@end
