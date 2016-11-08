//
//  ETMXTableViewCell2.m
//  ETMX
//
//  Created by wenpq on 16/11/4.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "ETMXTableViewCell2.h"

@interface ETMXTableViewCell2()
@property (strong, nonatomic) IBOutlet UILabel *taskCode;
@property (strong, nonatomic) IBOutlet UILabel *objectName;
@property (strong, nonatomic) IBOutlet UILabel *status;


@end
@implementation ETMXTableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTask:(ETMXTask *)task{
    self.taskCode.text = [task valueForKey:@"code"];
    self.objectName.text = [task valueForKey:@"objectName"];
    self.status.text = [task valueForKey:@"status"];

}
@end
