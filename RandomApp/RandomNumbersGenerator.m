//
//  RandomNumbersGenerator.m
//  RandomApp
//
//  Created by Andrew on 06.02.15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

#import "RandomNumbersGenerator.h"

#import "CoreDataManager.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

@interface RandomNumbersGenerator()

@property (nonatomic, assign) BOOL useRandomOrg;
@property (nonatomic, strong) CoreDataManager *coreDataManager;

@end

@implementation RandomNumbersGenerator

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setupCoreDataManager];
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    }
    return self;
}

-(BOOL)useRandomOrg {
    return[[NSUserDefaults standardUserDefaults] boolForKey:settingsUseRandomOrg];
}

-(void)setupCoreDataManager {
    self.coreDataManager = [CoreDataManager instance];
}

-(NSInteger)localMethodOfGettingNumber {
    return (NSInteger)5 + arc4random() % (10-5+1);
}

-(void)randomOrgMethodOfGettingNumber:(void(^)(NSInteger rNumber))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"jsonrpc":@"2.0",@"method":@"generateIntegers",@"params":@{@"apiKey":@"01ad058c-e3aa-41b6-826c-ea042b6db939",@"n":@1,@"min":@5,@"max":@10,@"replacement":@true,@"base":@10},@"id":@15894};
    [manager POST:@"https://api.random.org/json-rpc/1/invoke" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = responseObject[@"result"];
        NSDictionary *random = result[@"random"];
        NSArray *array = random[@"data"];
        block([array[0] integerValue]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)generateNumber {
    CoreDataManager * __weak weakCoreDataManager = self.coreDataManager;
    __block NSInteger seconds;
    if([self useRandomOrg]) {
        [self randomOrgMethodOfGettingNumber:^(NSInteger rNumber) {
            seconds = rNumber;
            [weakCoreDataManager insertNumber:rNumber andMethod:@"random.org"];
            [self generateNumberAfter:seconds];
        }];
    } else {
        seconds = [self localMethodOfGettingNumber];
        [weakCoreDataManager insertNumber:seconds andMethod:@"local"];
        [self generateNumberAfter:seconds];
    }
}

-(void)generateNumberAfter:(NSInteger)seconds {
    RandomNumbersGenerator __weak *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf generateNumber];
    });
}

@end
