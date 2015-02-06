//
//  SettingsViewController.h
//  RandomApp
//
//  Created by Andrew on 05.02.15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

@import UIKit;

#import "DataSource.h"

@interface SettingsViewController : UIViewController

@property(nonatomic, strong) IBOutlet UILabel *textLabel;
@property(nonatomic, strong) IBOutlet UISwitch *settingsSwitch;
@property(nonatomic, weak) DataSource *dataSource;

-(IBAction) clearCoreData;

@end
