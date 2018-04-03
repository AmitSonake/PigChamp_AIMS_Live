//
//  MenuViewController.h
//  Sidebar
//
//  Created by Venturelabour on 15/10/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/Analytics.h>
#import "SlideNavigationController.h"

@class CustomIOS7AlertView;

//@protocol MenuViewControllerDelegate
//-(void)menuViewControllerDidFinishWithCategoryId:(NSInteger)categoryId;
//@end

@interface MenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *categoryList;
    NSString *strNoInternet,*strSignOff,*strOK,*strCancel,*strSignOut,*strYes,*strServerErr,*strUnauthorised;

}

@property (weak, nonatomic) IBOutlet UILabel *lblFarm;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property(nonatomic,strong)IBOutlet UITableView *tblMenuList;
//@property (nonatomic, weak) id <MenuViewControllerDelegate> delegate;
@property (strong, nonatomic) CustomIOS7AlertView *customIOS7AlertView;
@property (nonatomic, assign) BOOL slideOutAnimationEnabled;

@end
