//
//  RNumber.h
//  RandomApp
//
//  Created by Andrew on 04.02.15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RNumber : NSManagedObject

@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * method;

@end
