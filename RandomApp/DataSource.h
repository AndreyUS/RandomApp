//
//  DataSource.h
//  RandomApp
//
//  Created by Andrew on 04.02.15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

@import UIKit;

#import "RNumber.h"

#import "TableViewController.h"
#import "CoreDataManager.h"
#import "RandomNumbersGenerator.h"

@class CoreDataManager;

@interface DataSource : NSObject <NSFetchedResultsControllerDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) CoreDataManager *coreDataManager;
@property (nonatomic, strong) RandomNumbersGenerator *randomNumbersGenerator;

-(void)startWork;
-(void)setupUseRandomOrg;

@end
