//
//  DataSource.m
//  RandomApp
//
//  Created by Andrew on 04.02.15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

#import "DataSource.h"

#import "RNumber.h"

#import "AppDelegate.h"

@interface DataSource ()

@property (nonatomic, assign) BOOL useRandomOrg;

@end

@implementation DataSource

- (id)init {
    self = [super init];
    
    if (self) {
        [self setupFetchedResultsController];
    }
    
    return self;
}

-(void)setupFetchedResultsController {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RNumber" inManagedObjectContext: self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescription = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescription, nil]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest
                                     managedObjectContext:self.managedObjectContext
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];
}

-(NSManagedObjectContext *)managedObjectContext {
    return APP_DELEGATE.managedObjectContext;
}

-(void)setupUseRandomOrg {
    self.useRandomOrg = [[NSUserDefaults standardUserDefaults] boolForKey:@"SettingsUseRandomOrg"];
}

-(NSInteger)numberOfSectionsForTableView {
    return [[self.fetchedResultsController sections] count];
}

-(NSInteger)numberOfRowsInSectionForTableView:(NSInteger)section {
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

-(RNumber *)entityForTableView:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

-(void)startWork {
    [self setupUseRandomOrg];
    if(self.useRandomOrg) {
        DataSource * __weak weakSelf = self;
        [self randomOrgMethodOfGettingNumber:^(NSInteger rNumber) {
            [weakSelf insertNumber:rNumber andMethod:@"random.org"];
        }];
    } else {
        [self insertNumber:[self localMethodOfGettingNumber] andMethod:@"local"];
    }
}

-(void)insertNumber:(NSInteger)number andMethod:(NSString *)method{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        NSEntityDescription *entity = [self.fetchedResultsController.fetchRequest entity];
        RNumber *track = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        [track setValue:@(number) forKey:@"value"];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        [track setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"date"];
        [track setValue:method forKey:@"method"];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error, %@", error);
        }
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(number * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startWork];
    });
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
        self.useRandomOrg = NO;
    }];
    
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if (NSFetchedResultsChangeInsert == type){
        [self.tableViewConroller.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    } else if(NSFetchedResultsChangeDelete == type) {
        NSInteger countOfObjects = [[self.fetchedResultsController fetchedObjects] count];
        if(countOfObjects == 0) {
            [self.tableViewConroller.tableView reloadData];
        } else {
            [self.tableViewConroller.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                     withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
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

-(void)deleteObjectFromCoreData:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        RNumber *number = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:number];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Error, %@", error);
        }
    });
}

@end
