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


@interface DataSource : UIView <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) TableViewController *tableViewConroller;

-(NSInteger)numberOfSectionsForTableView;
-(NSInteger)numberOfRowsInSectionForTableView:(NSInteger)section;
-(RNumber *)entityForTableView: (NSIndexPath *)indexPath;
-(void)startWork;
-(void)setupUseRandomOrg;
-(void)clearAllDataFromCoreData;
-(void)deleteObjectFromCoreData:(NSIndexPath *)indexPath;

@end
