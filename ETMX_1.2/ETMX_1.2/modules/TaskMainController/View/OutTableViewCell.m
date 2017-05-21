//
//  OutTableViewCell.m
//  ETMX_1.2
//
//  Created by wenpq on 16/12/15.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "OutTableViewCell.h"

@implementation OutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.inTableView.inTableViewDelegate =self;
    self.contentView.backgroundColor = [UIColor colorWithHex:0xFFC690];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSubMold:(SubMold *)subMold{
    _subMold =subMold;
    self.inTableView.subMold = subMold;
}
#pragma mark --InTableViewDelegate

-(void)onTapInTableView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTapIndexPath:)]) {
        [self.delegate onTapIndexPath:self.indexPath];
    }
}

-(void)onAllTaskSelected{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onAllTaskSelected:)]) {
        [self.delegate onAllTaskSelected:self.indexPath];
    }
}

@end
