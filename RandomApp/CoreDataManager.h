//
//  CoreDataManager.h
//  RandomApp
//
//  Created by Andrew on 06.02.15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

@import Foundation;


@class RNumber;
@class RandomNumbersGenerator;

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)saveContext;
-(void)insertNumber:(NSInteger)number andMethod:(NSString *)method andRandomNubmbersGenerator:(RandomNumbersGenerator *) __weak randomNumbersGenerator;
-(void)deleteObjectFromCoreData:(RNumber *)number;
-(void)clearAllDataFromCoreData;
+(instancetype) instance;
- (instancetype) init NS_UNAVAILABLE;

@end
