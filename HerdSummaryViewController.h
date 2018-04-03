//
//  HerdSummaryViewController.h
//  PigChamp
//
//  Created by Venturelabour on 16/03/16.
//  Copyright © 2016 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"
#import "SlideNavigationController.h"
#import "MenuViewController.h"

@interface HerdSummaryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SlideNavigationControllerDelegate> {
    //NSMutableArray *arrHerd;
    NSMutableDictionary *dict;
    NSString *strOK,*strPlzWait,*strNoInternet,*strServerErr,*strUnauthorised,*strSignOff;
    MenuViewController *tlc;

}

#pragma mark - Property
@property(nonatomic,strong)IBOutlet UITableView *tblHerdReport;
@property(strong,nonatomic)CustomIOS7AlertView *customIOS7AlertView;
@property(nonatomic,strong)IBOutlet UIView *vwHeader;
@property (weak, nonatomic) IBOutlet UIView *vwOverlay;

@end
