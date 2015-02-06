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

@interface TableViewController ()

@property (nonatomic, strong) DataSource *dataSource;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showSettings)];
    self.navigationItem.rightBarButtonItem = settings;
    self.title = @"Random Number";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self.dataSource selector:@selector(setupUseRandomOrg) name:NSUserDefaultsDidChangeNotification object:nil];
        [self.dataSource startWork];
    });
    
}

-(void)setupDataSource {
    self.dataSource = [[DataSource alloc] init];
    self.dataSource.tableViewConroller = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource numberOfSectionsForTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfRowsInSectionForTableView:section];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIndetifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIndetifier];
    }
    RNumber *number = [self.dataSource entityForTableView:indexPath];
    [self configureCell:cell withNubmer:number];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataSource deleteObjectFromCoreData:indexPath];
}

-(void)configureCell:(UITableViewCell *)cell withNubmer:(RNumber *)number {
    cell.textLabel.text = [number.value stringValue];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ method: %@", number.date, number.method];
}

-(void)showSettings {
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    settingsViewController.dataSource = self.dataSource;
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

@end
