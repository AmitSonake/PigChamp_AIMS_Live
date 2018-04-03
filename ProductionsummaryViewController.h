//
//  ProductionsummaryViewController.h
//  PigChamp
//
//  Created by Venturelabour on 06/04/16.
//  Copyright © 2016 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"
#import "SlideNavigationController.h"
#import "MenuViewController.h"

@interface ProductionsummaryViewController : UIViewController<UITableViewDataSource,SlideNavigationControllerDelegate> {
    NSMutableArray *arrProductionSummary;
    NSArray *arrTempCategory;
    MenuViewController *tlc;

    NSString *strOK,*strPlzWait,*strNoInternet,*strIdentityMsg,*strNodataFound,*strServerErr,*strUnauthorised,*strSignOff;
}

@property(strong,nonatomic)CustomIOS7AlertView *customIOS7AlertView;
@property(nonatomic,strong)NSMutableDictionary *dictHeaders;
@property(nonatomic,strong)IBOutlet UITableView *tblProduct;
@property (weak, nonatomic) IBOutlet UIView *vwOverlay;

@end
