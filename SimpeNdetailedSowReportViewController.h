//
//  SimpeNdetailedSowReportViewController.h
//  PigChamp
//
//  Created by Venturelabour on 28/03/16.
//  Copyright © 2016 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"
#import "SlideNavigationController.h"
#import "MenuViewController.h"

@interface SimpeNdetailedSowReportViewController : UIViewController<SlideNavigationControllerDelegate> {
NSMutableArray *arrSimpleNdetailed;
NSString *strOK,*strPlzWait,*strNoInternet,*strServerErr,*strUnauthorised,*strSignOff;
    MenuViewController *tlc;

}

#pragma mark- Property
@property(strong,nonatomic)CustomIOS7AlertView *customIOS7AlertView;
@property(strong,nonatomic)NSString *strIdentity;
@property (weak, nonatomic) IBOutlet UIView *vwUnderlineSummary;
@property (weak, nonatomic) IBOutlet UIButton *btnSimple;
@property (weak, nonatomic) IBOutlet UIButton *btnDetailed;
@property (weak, nonatomic) IBOutlet UITableView *tblSimple;
@property (weak, nonatomic) IBOutlet UIView *vwHistory;
@property (weak, nonatomic) IBOutlet UIView *vwUndelineHistory;
@property (weak, nonatomic) NSString *strIdentityId;
@property (weak, nonatomic) IBOutlet UICollectionView *clHistory;
@property (weak, nonatomic)NSString *strTitle;
@property (weak, nonatomic)NSString *strType;
@property (weak, nonatomic) IBOutlet UIView *vwOverlay;

@end
