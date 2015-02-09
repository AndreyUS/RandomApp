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
        [self setupUseRandomOrg];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUseRandomOrg) name:UIApplicationWillEnterForegroundNotification object:nil];
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    }
    return self;
}

-(void)setupUseRandomOrg {
    self.useRandomOrg = [[NSUserDefaults standardUserDefaults] boolForKey:@"SettingsUseRandomOrg"];
}

-(void) setupCoreDataManager {
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
    __block NSInteger number;
    if(self.useRandomOrg) {
       [self randomOrgMethodOfGettingNumber:^(NSInteger rNumber) {
           number = rNumber;
            [weakCoreDataManager insertNumber:rNumber andMethod:@"random.org" andRandomNubmbersGenerator:self];
        }];
    } else {
        number = [self localMethodOfGettingNumber];
        [weakCoreDataManager insertNumber:number andMethod:@"local" andRandomNubmbersGenerator:self];
    }
}

@end
