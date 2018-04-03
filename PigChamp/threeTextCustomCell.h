//
//  threeTextCustomCell.h
//  PigChamp
//
//  Created by Venturelabour on 12/07/16.
//  Copyright © 2016 Venturelabour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface threeTextCustomCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel *lblDetail;
@property(nonatomic,strong)IBOutlet UITextField *txtFirst;
@property(nonatomic,strong)IBOutlet UITextField *txtSecond;
@property(nonatomic,strong)IBOutlet UITextField *txtThird;

@end
