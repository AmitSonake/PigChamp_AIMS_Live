//
//  DataEntrySubMenuViewController.h
//  PigChamp
//
//  Created by Venturelabour on 27/10/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/Analytics.h>
#import "SlideNavigationController.h"
#import "MenuViewController.h"

@interface DataEntrySubMenuViewController : UIViewController<SlideNavigationControllerDelegate>
{
    NSMutableArray *arrMenu,*arrEventCode;
    MenuViewController *tlc;
    NSString *strOK,*strUnauthorised,*strServerErr;

}

#pragma mark - view life cycle
@property (weak, nonatomic) IBOutlet UITableView *tblDataEntrySubMenu;
@property (weak, nonatomic) NSString *strDataEntrySubMenu;
@property (strong, nonatomic) NSString *countMenu;
@property (weak, nonatomic) IBOutlet UIView *vwOverlay;

@end
