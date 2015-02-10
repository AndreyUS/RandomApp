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
#import "RandomNumbersGenerator.h"

@interface DataSource : NSObject <NSFetchedResultsControllerDelegate, UITableViewDataSource>


@property (nonatomic,strong) UITableView *tableView;


-(void)startWork;

@end
