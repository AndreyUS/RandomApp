//
//  RandomNumbersGenerator.h
//  RandomApp
//
//  Created by Andrew on 06.02.15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

@import Foundation;

@interface RandomNumbersGenerator : NSObject

-(NSInteger)localMethodOfGettingNumber;
-(void)randomOrgMethodOfGettingNumber:(void(^)(NSInteger rNumber))block;

@end