//
//  TTPictureView.h
//  折线图
//
//  Created by 陶宏路 on 16/8/25.
//  Copyright © 2016年 陶路路. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTPictureView : UIView

-(void)drawRectWithArrayX:(NSArray *)arrayX arrayY:(NSArray *)arrayY dataArray:(NSArray *)dataArray;

-(void)drawRectWithArrayX:(NSArray *)dataArray;

@property (nonatomic,assign) CFTimeInterval  duration;

@end
