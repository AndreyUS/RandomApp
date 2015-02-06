//
//  SettingsViewController.m
//  RandomApp
//
//  Created by Andrew on 05.02.15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

#import "SettingsViewController.h"
#import "CoreDataManager.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateStatusOfSettingsSwitch];
    [self.settingsSwitch addTarget:self action:@selector(changedStatusOfSettingsSwitch:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)clearCoreData {
    [self.coreDataManager clearAllDataFromCoreData];
}

-(void)updateStatusOfSettingsSwitch {
    BOOL statusOfSettingsSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:@"SettingsUseRandomOrg"];
    [self.settingsSwitch setOn:statusOfSettingsSwitch];
}

-(void)changedStatusOfSettingsSwitch:(id)sender {
    BOOL statusOfSettingsSwitch = [sender isOn];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:statusOfSettingsSwitch forKey:@"SettingsUseRandomOrg"];
    [defaults synchronize];
}

@end
