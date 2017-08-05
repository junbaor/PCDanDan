//
//  IMGroupHeadView.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/19.
//  Copyright © 2017年 li. All rights reserved.
//

#import "IMGroupHeadView.h"

@implementation IMGroupHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        //        _insertView.frame = frame;
        //        [self addSubview:_insertView];
        self = [nib objectAtIndex:0];
        self.frame = frame;
        [self updateUi];
    }
    
    return self;
}

+ (instancetype)initAudienceViewWithFrame:(CGRect)frame{
    return [[IMGroupHeadView alloc]initWithFrame:frame];
}

- (void)updateUi
{
    NSString * showStr = [NSString stringWithFormat:@"距离 <color1>--</color1> 期截止"];
    
    NSDictionary* style = @{@"color1":RGB(58, 132, 255)};
    
    _numLabel.attributedText = [showStr attributedStringWithStyleBook:style];
    
    showStr = @"第 <color1>--</color1> 期";
    _qsLabel.attributedText = [showStr attributedStringWithStyleBook:style];
    
    _oneLabel.layer.masksToBounds =YES;
    _oneLabel.layer.cornerRadius = _oneLabel.frame.size.height/2;
    _twoLabel.layer.masksToBounds =YES;
    _twoLabel.layer.cornerRadius = _twoLabel.frame.size.height/2;
    _threeLabel.layer.masksToBounds =YES;
    _threeLabel.layer.cornerRadius = _threeLabel.frame.size.height/2;
    _fourLabel.layer.masksToBounds =YES;
    _fourLabel.layer.cornerRadius = _fourLabel.frame.size.height/2;
}
@end
