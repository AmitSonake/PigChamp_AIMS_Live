//
//  DataEntryViewController.h
//  PigChamp
//
//  Created by Venturelabour on 20/10/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import <Google/Analytics.h>
#import "SlideNavigationController.h"

@class SettingsViewController;

@interface DataEntryViewController : UIViewController<UITableViewDelegate,SlideNavigationControllerDelegate> {//MenuViewControllerDelegate
    NSMutableArray *arrDataEntryMenu;
    NSInteger slectedRow;
    //NSInteger Category;
    NSString *strDepat,*strOK,*strUnauthorised,*strServerErr;
    SettingsViewController *settingsViewController;
    MenuViewController *tlc;
}

#pragma mark - property
@property (weak, nonatomic) IBOutlet UITableView *tblDataEntry;
@property (weak, nonatomic) IBOutlet UIView *vwOverlay;
@property (weak, nonatomic) IBOutlet UIView *vwContaner;

@end
