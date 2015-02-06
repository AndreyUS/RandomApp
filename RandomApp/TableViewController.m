//
//  TableViewController.m
//  RandomApp
//
//  Created by Andrew on 04.02.15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

#import "RNumber.h"

#import "TableViewController.h"
#import "SettingsViewController.h"
#import "DataSource.h"

@interface TableViewController ()

@property (nonatomic, strong) DataSource *dataSource;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showSettings)];
    self.navigationItem.rightBarButtonItem = settings;
    self.title = @"Random Number";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self.dataSource selector:@selector(setupUseRandomOrg) name:NSUserDefaultsDidChangeNotification object:nil];
        [self.dataSource startWork];
    });
    
}

-(void)setupDataSource {
    self.dataSource = [[DataSource alloc] init];
    self.dataSource.tableView = self.tableView;
    self.tableView.dataSource = self.dataSource;
}

-(void)showSettings {
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    settingsViewController.coreDataManager = self.dataSource.coreDataManager;
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

@end
