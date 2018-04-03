//
//  HistorySummaryViewController.h
//  PigChamp

//  Created by Venturelabour on 19/11/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCollectionViewLayout.h"
#import "cell.h"
#import "contentCollectionViewCell.h"
#import <Google/Analytics.h>
#import "SlideNavigationController.h"
#import "MenuViewController.h"

@class CustomIOS7AlertView;

@interface HistorySummaryViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SlideNavigationControllerDelegate>
{
    NSMutableArray *arrSummary,*arrhistory;
    NSString *selecteditem;
    NSString *strOk,*strCancel,*strInternet,*strWait,*strServerErr,*strUnauthorised,*strLoading,*strYes,*strNo,*strSignOff;
    NSIndexPath* indexPathDelete;
    CustomCollectionViewLayout *customCollectionViewLayoutobj;
    NSString *strSureDelete;
    NSString *strSelectDelete;
    NSString *strSelectEdit;
    MenuViewController *tlc;
}

#pragma mark - Property
@property (weak, nonatomic) IBOutlet UIView *vwUnderlineSummary;
@property (weak, nonatomic) IBOutlet UIButton *btnHistory;
@property (weak, nonatomic) IBOutlet UIButton *btnSummary;
@property (weak, nonatomic) IBOutlet UITableView *tblSummary;
@property (weak, nonatomic) IBOutlet UIView *vwHistory;
@property (weak, nonatomic) IBOutlet UIView *vwUndelineHistory;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) NSString *strIdentityId;
@property(strong,nonatomic)CustomIOS7AlertView *customIOS7AlertView;
@property (weak, nonatomic) IBOutlet UICollectionView *clHistory;
@property (weak, nonatomic)NSString *strTitle;
@property (weak, nonatomic) IBOutlet UIView *vwOverlay;

#pragma mark - methods
- (IBAction)btnDelete_tapped:(id)sender;
- (IBAction)btnEdit_tapped:(id)sender;

@end
