//
//  TTTableViewCell.m
//  折线图
//
//  Created by 陶宏路 on 16/8/25.
//  Copyright © 2016年 陶路路. All rights reserved.
//

#import "TTTableViewCell.h"
#import "TTPictureView.h"

@interface TTTableViewCell ()

@property (nonatomic,strong) TTPictureView * view;
@end

@implementation TTTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpUI];
    }
    
    return self;
}

- (void)setUpUI{
    
    self.view = [[TTPictureView alloc]init];
    NSArray * arrayX = @[@"8-1",@"8-3",@"8-4",@"8-5",@"8-6",@"8-7",@"8-8"];
    NSArray *  arrayY =  @[@"100",@"200",@"300",@"400",@"500",@"600",@"700"];
//    NSArray *  dataArray = @[@"330",@"200",@"500",@"400",@"500",@"100"];
    [self.view drawRectWithArrayX:arrayX arrayY:arrayY dataArray:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.view];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self addSubview:button];
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(didButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button2 = [[UIButton alloc]initWithFrame:CGRectMake(345, 0, 30, 30)];
    [self addSubview:button2];
    button2.backgroundColor = [UIColor orangeColor];
    [button2 addTarget:self action:@selector(didButtont) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)didButtont{
    NSArray *  dataArray = @[@"50",@"300",@"200",@"500",@"700",@"200"];
    self.view.duration = 4;
    [self.view drawRectWithArrayX:dataArray];
    
}
-(void)didButton{
    
    //    NSArray * arrayX = @[@"8-1",@"8-3",@"8-4",@"8-5",@"8-6",@"8-7"];
    //    NSArray *  arrayY =  @[@"100",@"200",@"300",@"400",@"500",@"600"];
    NSArray *  dataArray = @[@"550",@"100",@"200",@"600",@"700"];
    self.view.duration = 2;
    //    [self.view drawRectWithArrayX:arrayX arrayY:arrayY dataArray:dataArray];
    [self.view drawRectWithArrayX:dataArray];
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.view.frame = CGRectMake(20, 20, self.contentView.frame.size.width - 40, self.frame.size.height - 40);
    
}
@end
