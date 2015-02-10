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

@property(nonatomic, strong) IBOutlet UILabel *textLabel;
@property(nonatomic, strong) IBOutlet UISwitch *settingsSwitch;

-(IBAction) clearCoreData;

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
    [[CoreDataManager instance] clearAllDataFromCoreData];
}

-(void)updateStatusOfSettingsSwitch {
    BOOL statusOfSettingsSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:settingsUseRandomOrg];
    [self.settingsSwitch setOn:statusOfSettingsSwitch];
}

-(void)changedStatusOfSettingsSwitch:(id)sender {
    BOOL statusOfSettingsSwitch = [sender isOn];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:statusOfSettingsSwitch forKey:settingsUseRandomOrg];
    [defaults synchronize];
}

@end
