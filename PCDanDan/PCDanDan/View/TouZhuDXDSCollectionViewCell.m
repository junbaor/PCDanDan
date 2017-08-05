//
//  TouZhuDXDSCollectionViewCell.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import "TouZhuDXDSCollectionViewCell.h"
#import "TouzhuXXCollectionViewCell.h"
#import "TSWFCollectionViewCell.h"

@implementation TouZhuDXDSCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"TouZhuDXDSCollectionViewCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        [self resignCollectionViewCell];
    }
    return self;
}


- (void)resignCollectionViewCell
{
    [_collectView registerClass:[TouzhuXXCollectionViewCell class] forCellWithReuseIdentifier:@"TouzhuXXCollectionViewCell"];
    [_collectView registerClass:[TSWFCollectionViewCell class] forCellWithReuseIdentifier:@"TSWFCollectionViewCell"];
}

- (void)updateUI
{
    
    if (_showType == 0) {
        if (_gameBiLiInfo.da_xiao.count > _selectDXDSIndex) {
            GameBiLiListInfo *info = [_gameBiLiInfo.da_xiao objectAtIndex:_selectDXDSIndex];
            _resultLabel.text = [NSString stringWithFormat:@"中奖和值:[%@]",info.result];
        }
        
        
    }else if (_showType == 1)
    {
        if (_gameBiLiInfo.shu_zi.count > _selectCSZIndex) {
            GameBiLiListInfo *info = [_gameBiLiInfo.shu_zi objectAtIndex:_selectCSZIndex];
            _resultLabel.text = [NSString stringWithFormat:@"中奖和值:[%@]",info.result];
        }
    }else{
        if (_gameBiLiInfo.te_shu.count > _selectTSWFIndex) {
            GameBiLiListInfo *info = [_gameBiLiInfo.te_shu objectAtIndex:_selectTSWFIndex];
            _resultLabel.text = [NSString stringWithFormat:@"中奖和值:[%@]",info.result];
        }
    }
    
    [_collectView  reloadData];
}

#pragma mark - collectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_showType == 0) {
        return _gameBiLiInfo.da_xiao.count;
    }else if (_showType == 1)
    {
       return _gameBiLiInfo.shu_zi.count;
    }else{
        return _gameBiLiInfo.te_shu.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"index = %ld",(long)_showType);
    if(_showType == 0 || _showType == 1)
    {
        
        TouzhuXXCollectionViewCell *cell = (TouzhuXXCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TouzhuXXCollectionViewCell" forIndexPath:indexPath];
        if (_showType == 0) {
            if (indexPath.row == _selectDXDSIndex) {
                cell.selectImage.hidden = NO;
            }else{
                cell.selectImage.hidden = YES;
            }
            GameBiLiListInfo *info = [_gameBiLiInfo.da_xiao objectAtIndex:indexPath.row];
            cell.titleLabel.text = info.bili_name;
            cell.biliLabel.text = [NSString stringWithFormat:@"1:%.2f",info.bili];
        }else{
            if (indexPath.row == _selectCSZIndex) {
                cell.selectImage.hidden = NO;
            }else{
                cell.selectImage.hidden = YES;
            }
            GameBiLiListInfo *info = [_gameBiLiInfo.shu_zi objectAtIndex:indexPath.row];
            cell.titleLabel.text = info.bili_name;
            cell.biliLabel.text = [NSString stringWithFormat:@"1:%.2f",info.bili];
        }
        return cell;
    }else{
        
        TSWFCollectionViewCell *cell = (TSWFCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TSWFCollectionViewCell" forIndexPath:indexPath];
        cell.titleLabel.layer.borderColor = [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5] CGColor];
        cell.titleLabel.layer.borderWidth = 1.0f;
        
        if (indexPath.row == _selectTSWFIndex) {
            cell.selectImage.hidden = NO;
        }else{
            cell.selectImage.hidden = YES;
        }
        switch (indexPath.row %4) {
            case 0:
                cell.titleLabel.backgroundColor = RGB(252, 13, 27);
                break;
            case 1:
                cell.titleLabel.backgroundColor = RGB(38, 129, 41);
                break;
            case 2:
                cell.titleLabel.backgroundColor = RGB(50, 83, 190);
                break;
            case 3:
                cell.titleLabel.backgroundColor = RGB(252, 105, 43);
                break;
            default:
                break;
        }
        GameBiLiListInfo *info = [_gameBiLiInfo.te_shu objectAtIndex:indexPath.row];
        cell.titleLabel.text = info.bili_name;
        cell.biliLabel.text = [NSString stringWithFormat:@"1:%.2f",info.bili];
        return cell;
    }
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(_showType == 0 || _showType == 1)
    {
        return CGSizeMake( collectionView.frame.size.width/5,50);
    }else{
        return CGSizeMake( collectionView.frame.size.width/2,50);
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (_showType == 0) {
        _selectDXDSIndex = indexPath.row;
        GameBiLiListInfo *info = [_gameBiLiInfo.da_xiao objectAtIndex:indexPath.row];
        _resultLabel.text = [NSString stringWithFormat:@"中奖和值:[%@]",info.result];
        
    }else if (_showType == 1)
    {
        _selectCSZIndex = indexPath.row;
        GameBiLiListInfo *info = [_gameBiLiInfo.shu_zi objectAtIndex:indexPath.row];
        _resultLabel.text = [NSString stringWithFormat:@"中奖和值:[%@]",info.result];
    }else{
        _selectTSWFIndex = indexPath.row;
        GameBiLiListInfo *info = [_gameBiLiInfo.te_shu objectAtIndex:indexPath.row];
        if ([info.result intValue] == -1) {
            _resultLabel.text = @"开奖三个数字都一致";
        }else{
           _resultLabel.text = [NSString stringWithFormat:@"中奖和值:[%@]",info.result];
        }
    }
    [collectionView reloadData];
    
    UICollectionView *collectView = [self collectView];
    NSIndexPath *indexPare = [collectView indexPathForCell:self];
    
    if([self.delegate respondsToSelector:@selector(clickIconWithIndex:withParentIndex:)])
    {
        [self.delegate clickIconWithIndex:indexPath.row withParentIndex:indexPare.row];
    }
}

- (UICollectionView *)collectView
{
    UIView *collectView = self.superview;
    while (![collectView isKindOfClass:[UICollectionView class]] && collectView) {
        collectView = collectView.superview;
    }
    return (UICollectionView *)collectView;
}

@end
