//
//  ReportsMenuViewController.h
//  PigChamp
//
//  Created by Venturelabour on 23/10/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import <Google/Analytics.h>
#import "SlideNavigationController.h"

@interface ReportsMenuViewController : UIViewController<SlideNavigationControllerDelegate>//MenuViewControllerDelegate
{
    NSMutableArray *arrReportsMenu,*arrCode;
    NSString *strTitle,*strUnauthorised,*strServerErr,*strOK;
    MenuViewController *tlc;
}

#pragma mark - Property
@property(nonatomic,strong)IBOutlet UITableView *tblReports;
@property (weak, nonatomic) IBOutlet UIView *vwOverlay;

@end
