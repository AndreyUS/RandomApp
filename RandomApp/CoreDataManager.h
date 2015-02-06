//
//  CoreDataManager.h
//  RandomApp
//
//  Created by Andrew on 06.02.15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

@import Foundation;

@class DataSource;

@class RNumber;

@interface CoreDataManager : NSObject

@property (nonatomic,weak) DataSource *dataSource;

-(void)insertNumber:(NSInteger)number andMethod:(NSString *)method;
-(void)deleteObjectFromCoreData:(RNumber *)number;
-(void)clearAllDataFromCoreData;

@end
