//
//  CoreDataManager.m
//  RandomApp
//
//  Created by Andrew on 06.02.15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

#import "CoreDataManager.h"

#import "RNumber.h"

#import "DataSource.h"
#import "AppDelegate.h"

@implementation CoreDataManager

+(instancetype) instance {
    static dispatch_once_t onceToken;
    static CoreDataManager *coreDataManager;
    dispatch_once(&onceToken, ^{
        coreDataManager = [CoreDataManager new];
    });
    return coreDataManager;
}

-(void)insertNumber:(NSInteger)number andMethod:(NSString *)method andRandomNubmbersGenerator:(RandomNumbersGenerator *) __weak randomNumbersGenerator{
    dispatch_async(dispatch_get_main_queue(), ^{
        RNumber *rNumber = [NSEntityDescription insertNewObjectForEntityForName:@"RNumber" inManagedObjectContext:self.managedObjectContext];
        [rNumber setValue:@(number) forKey:@"value"];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        [rNumber setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"date"];
        [rNumber setValue:method forKey:@"method"];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Error, %@", error);
        }
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(number * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [randomNumbersGenerator generateNumber];
    });
}

-(void)clearAllDataFromCoreData {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSFetchRequest *allRNumbers = [[NSFetchRequest alloc] init];
        [allRNumbers setEntity:[NSEntityDescription entityForName:@"RNumber" inManagedObjectContext:self.managedObjectContext]];
        [allRNumbers setIncludesPropertyValues:NO];
        NSError *error = nil;
        NSArray *rNumbers = [self.managedObjectContext executeFetchRequest:allRNumbers error:&error];
        for (NSManagedObject * number in rNumbers) {
            [self.managedObjectContext deleteObject:number];
        }
        NSError *saveError = nil;
        if(![self.managedObjectContext save:&saveError]) {
            NSLog(@"Error, %@", error);
        }
    });
}

-(void)deleteObjectFromCoreData:(RNumber *)number {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.managedObjectContext deleteObject:number];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Error, %@", error);
        }
    });
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "test.RandomApp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RandomApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RandomApp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    NSDictionary *options = @{@"journal_mode":@"DELETE"};
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
