//
//  OpenHistoryInfoView.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import "OpenHistoryInfoView.h"
#import "HistoryListTableViewCell.h"
#import "GameCurrentStatueInfo.h"

@implementation OpenHistoryInfoView

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
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.masksToBounds =YES;
        _tableView.layer.cornerRadius =  5;
        
    }
    
    return self;
}

+ (instancetype)initHistoryInfoViewWithFrame:(CGRect)frame{
    return [[OpenHistoryInfoView alloc]initWithFrame:frame];
}

- (IBAction)clickBgButtonAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(closeHistoryView)])
    {
        [self.delegate closeHistoryView];
    }

}

- (void)updateTableViewCellList
{
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataSourceArray.count;
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}


//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HistoryListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.oneLabel.layer.masksToBounds =YES;
        cell.oneLabel.layer.cornerRadius = cell.oneLabel.frame.size.height/2;
        cell.twoLabel.layer.masksToBounds =YES;
        cell.twoLabel.layer.cornerRadius = cell.twoLabel.frame.size.height/2;
        cell.threeLabel.layer.masksToBounds =YES;
        cell.threeLabel.layer.cornerRadius = cell.threeLabel.frame.size.height/2;
        cell.fourLabel.layer.masksToBounds =YES;
        cell.fourLabel.layer.cornerRadius = cell.fourLabel.frame.size.height/2;
        
    }
    GameHistoryListInfo *info = [_dataSourceArray objectAtIndex:indexPath.row];
    
    NSString * showStr = showStr = [NSString stringWithFormat:@"第 <color1>%@</color1> 期",info.game_num];
    
    NSDictionary* style = @{@"color1":HuangSColor};
    
    cell.numLabel.attributedText = [showStr attributedStringWithStyleBook:style];
    cell.typeLabel.text = [NSString stringWithFormat:@"（%@）",info.result_type];
    
    NSArray * array = [info.game_result_desc componentsSeparatedByString:@"+"];
    
    if (array.count >= 3) {
        
        cell.oneLabel.text = [array objectAtIndex:0];
        cell.twoLabel.text = [array objectAtIndex:1];
        NSArray * array1 = [[array objectAtIndex:2] componentsSeparatedByString:@"="];
        
        if (array1.count >= 2) {
            cell.threeLabel.text = [array1 objectAtIndex:0];
            cell.fourLabel.text = [array1 objectAtIndex:1];
            //color  1红 2绿 3蓝 4无
            if ([info.color intValue] == 1) {
                cell.fourLabel.backgroundColor = HongSColor;
            }else if ([info.color intValue] == 2) {
                cell.fourLabel.backgroundColor = LvSColor;
            }else if ([info.color intValue] == 3) {
                cell.fourLabel.backgroundColor = LanSColor;
            }else{
                cell.fourLabel.backgroundColor = HuiSColor;
            }
        }
        
    }
    
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


@end
