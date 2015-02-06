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

-(NSManagedObjectContext *)managedObjectContext {
    return APP_DELEGATE.managedObjectContext;
}

-(void)insertNumber:(NSInteger)number andMethod:(NSString *)method{
    dispatch_async(dispatch_get_main_queue(), ^{
        RNumber *rNumber = [NSEntityDescription insertNewObjectForEntityForName:@"RNumber" inManagedObjectContext:[self managedObjectContext]];
        [rNumber setValue:@(number) forKey:@"value"];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        [rNumber setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"date"];
        [rNumber setValue:method forKey:@"method"];
        NSError *error = nil;
        if (![[self managedObjectContext] save:&error]) {
            NSLog(@"Error, %@", error);
        }
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(number * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.dataSource startWork];
    });
}

-(void)clearAllDataFromCoreData {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSFetchRequest * allRNumbers = [[NSFetchRequest alloc] init];
        [allRNumbers setEntity:[NSEntityDescription entityForName:@"RNumber" inManagedObjectContext:self.managedObjectContext]];
        [allRNumbers setIncludesPropertyValues:NO];
        NSError * error = nil;
        NSArray * rNumbers = [self.managedObjectContext executeFetchRequest:allRNumbers error:&error];
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

@end
