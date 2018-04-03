//
//  HelpViewController.h
//  PigChamp
//
//  Created by Venturelabour on 06/11/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import <Google/Analytics.h>
#import "SlideNavigationController.h"

@class CustomIOS7AlertView;

@interface HelpViewController : UIViewController<SlideNavigationControllerDelegate>{//MenuViewControllerDelegate
    MenuViewController *tlc;
    NSString *strOK,*strUnauthorised;
}

@property (weak, nonatomic) IBOutlet UIWebView *webHelp;
@property (weak, nonatomic) IBOutlet UIView *container;
@property(strong, nonatomic)CustomIOS7AlertView *alertwebload;
@property (weak, nonatomic) IBOutlet UIView *vwOverlay;
@end
