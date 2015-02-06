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

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setupFetchedResultsController];
        [self setupUseRandomOrg];
        [self setupCoreDataManeger];
        [self setupRandomNumbersGenerator];
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
-(void)setupCoreDataManeger {
    self.coreDataManager = [[CoreDataManager alloc] init];
    self.coreDataManager.dataSource = self;
}

-(void)setupRandomNumbersGenerator {
    self.randomNumbersGenerator = [[RandomNumbersGenerator alloc] init];
}

-(void)startWork {
    CoreDataManager * __weak weakCoreDataManager = self.coreDataManager;
    RandomNumbersGenerator * __weak weakRandomNumberGenerator = self.randomNumbersGenerator;
    if(self.useRandomOrg) {
        [weakRandomNumberGenerator randomOrgMethodOfGettingNumber:^(NSInteger rNumber) {
            [weakCoreDataManager insertNumber:rNumber andMethod:@"random.org"];
        }];
    } else {
        [weakCoreDataManager insertNumber:[weakRandomNumberGenerator localMethodOfGettingNumber] andMethod:@"local"];
    }
    
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if (NSFetchedResultsChangeInsert == type){
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    } else if(NSFetchedResultsChangeDelete == type) {
        NSInteger countOfObjects = [[self.fetchedResultsController fetchedObjects] count];
        if(countOfObjects == 0) {
            [self.tableView reloadData];
        } else {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
}

#pragma mark - TableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIndetifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIndetifier];
    }
    RNumber *number = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [number.value stringValue];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ method: %@", number.date, number.method];
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    RNumber *number = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.coreDataManager deleteObjectFromCoreData:number];
}
@end
