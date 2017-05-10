//
//  InTableViewHeaderView.m
//  ETMX_1.2
//
//  Created by wenpq on 16/12/17.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "InTableViewHeaderView.h"


@interface InTableViewHeaderView ()

@end



@implementation InTableViewHeaderView
-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.selectedImageView addGestureRecognizer:tap];
    self.backgroundColor = [UIColor colorWithHex:0x45B4FE];
}

-(void)handleTap:(UITapGestureRecognizer *)gesture{
    self.subMold.isSelected = !self.subMold.isSelected;
    if (self.block) {
        self.block(self.subMold);
    }
}

-(void)setSubMold:(SubMold *)subMold{
    _subMold = subMold;
    ETMXTask *firstTask = subMold.tasks[0];
    BOOL isElectrode = [[NSUserDefaults standardUserDefaults] boolForKey:@"KEY_IS_ELECTRODE"];
    self.objectLabel.text = firstTask.object;
    if ([firstTask.container isEqualToString:firstTask.object]) {
        self.objectPlaceLabel.text = Localized(@"mold code");
        self.objectNamePlaceLabel.text = Localized(@"mold name");
    }else{
        if (isElectrode) {
            self.objectPlaceLabel.text = Localized(@"electrode code");
        }else{
            self.objectPlaceLabel.text = Localized(@"part code");
        }
        self.objectNamePlaceLabel.text =Localized(@"part name");
    }
    self.objcectNameLabel.text = firstTask.objectName;
    self.objectStatusPlaceLabel.text = Localized(@"status:");
    self.objectStatusLabel.text = firstTask.support;
    if (subMold.isSelected) {
        self.selectedImageView.image = [UIImage imageNamed:@"selected_image_checkmark"];
    }else{
        self.selectedImageView.image = [UIImage imageNamed:@"selected_image_uncheckmark"];
    }
}
@end
