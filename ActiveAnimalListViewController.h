//
//  ActiveAnimalListViewController.h
//  PigChamp
//
//  Created by Venturelabour on 22/03/16.
//  Copyright © 2016 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"
#import "SlideNavigationController.h"
#import "MenuViewController.h"

@interface ActiveAnimalListViewController : UIViewController<SlideNavigationControllerDelegate> {
    NSMutableArray *arrActiveAnimalList;
    NSString *strOK,*strPlzWait,*strNoInternet,*strIdentityMsg,*strUnauthorised,*strSignOff;
    MenuViewController *tlc;
}

#pragma mark- Property
@property(nonatomic,strong)IBOutlet UITableView *tblActiveList;
@property(strong,nonatomic)CustomIOS7AlertView *customIOS7AlertView;
@property(strong,nonatomic)NSString *strIdentity;
@property (weak, nonatomic) IBOutlet UIView *vwOverlay;

@end
