//
//  SearchListViewController.h
//  PigChamp
//
//  Created by Venturelabour on 02/11/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/Analytics.h>
#import "SlideNavigationController.h"
#import "MenuViewController.h"

@class CustomIOS7AlertView;

@interface SearchListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SlideNavigationControllerDelegate>{
    NSMutableArray *arrSearchList;
    NSInteger selectedRow;
    NSString *strPlzWait,*strNoInternet,*strOk,*strIdentityMsg,*strServerErr,*strUnauthorised,*strYes,*strNo,*strSignOff;
    NSString *strPigs;
    NSArray *arrDeleted;
    MenuViewController *tlc;
}

#pragma mark - Property
@property (weak, nonatomic) IBOutlet UILabel *lblSearchResultHint;
@property(nonatomic,strong)IBOutlet UITableView *tblSearchList;
@property(nonatomic,strong)NSString *strMatchfilter;
@property(nonatomic,strong)NSString *strMatchfilterBoarSow;
@property(nonatomic,strong) NSString *strIdentity;
@property(strong,nonatomic)CustomIOS7AlertView *customIOS7AlertView;
@property(strong,nonatomic)NSMutableArray *arrSearchList;
@property (strong, nonatomic)NSString *strIdentityText;
@property (weak, nonatomic) IBOutlet UIView *vwOverlay;

@end
