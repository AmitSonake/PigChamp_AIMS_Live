//
//  AboutViewController.h
//  PigChamp
//
//  Created by Venturelabour on 06/11/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import <Google/Analytics.h>
#import "SlideNavigationController.h"

@class SettingsViewController;

@interface AboutViewController : UIViewController<SlideNavigationControllerDelegate>//MenuViewControllerDelegate
{
    SettingsViewController *settingsViewController;
    MenuViewController *tlc;
    NSString *strOK,*strUnauthorised,*strServerErr;
}

@property (weak, nonatomic) IBOutlet UIView *vwOverlay;

@end
