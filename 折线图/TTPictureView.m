//
//  TTPictureView.m
//  折线图
//
//  Created by 陶宏路 on 16/8/25.
//  Copyright © 2016年 陶路路. All rights reserved.
//

#import "TTPictureView.h"

@interface TTPictureView ()

@property (nonatomic,strong) CAShapeLayer * lineChartLayer;

@property (nonatomic,strong) UIBezierPath * path;

@property (nonatomic,strong) NSArray * lineArray;

@property (nonatomic,strong) NSArray * dataArrayYY;

@property (nonatomic,strong) NSArray * arrayX;
@property (nonatomic,strong) NSArray * arrayY;
@property (nonatomic,strong) NSArray * dataArray;


@end

CFTimeInterval  timeDuration = 3;

@implementation TTPictureView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}


-(void)drawRect:(CGRect)rect{
    
    if (self.arrayX.count == 0 || self.arrayY.count == 0) {
        
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetRGBFillColor (context, 0.01, 0.01, 0.01, 1);
    CGContextMoveToPoint(context, 30, 0);
    CGContextAddLineToPoint(context, 30, rect.size.height - 30);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 30);
    [self toDrawTextWithRect:rect str:self.arrayX str:self.arrayY dataArray:self.dataArray context:context];
    CGContextStrokePath(context);
}

- (void)toDrawTextWithRect:(CGRect)rect1 str:(NSArray<NSString *>*)dataArrayX str:(NSArray<NSString *>*)dataArrayY dataArray:(NSArray *)dataArray context:(CGContextRef)context{
    if( dataArrayX == nil || context == nil || dataArrayY == nil)
        return;
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBFillColor (context, 0.01, 0.01, 0.01, 1);
    
    //段落格式
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;//水平居中
    //字体
    UIFont  *font = [UIFont boldSystemFontOfSize:12];
    //构建属性集合
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle};
    //获得size
//    CGFloat marginTop = 30;
    //垂直居中要自己计算
   
    NSMutableArray <NSString *>* Xarray = [NSMutableArray array];
    
//    X轴数据绘制
    [dataArrayX enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize strSize = [obj sizeWithAttributes:attributes];
        CGFloat margin = (rect1.size.width - (dataArrayX.count * strSize.width) - 30) / (dataArrayX.count - 1);
        CGRect r = CGRectMake(30 + (idx)*(strSize.width + margin), rect1.size.height - strSize.height - 10 ,strSize.width, strSize.height);
        
        [obj drawInRect:r withAttributes:attributes];
        [Xarray addObject:[NSString stringWithFormat:@"%f",r.origin.x]];
    }];
    
    self.lineArray = Xarray.copy;
    
//    Y轴数据绘制
    [dataArrayY enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        CGSize strSize = [obj sizeWithAttributes:attributes];
        CGFloat marginY = (rect1.size.height - 30 - (dataArrayY.count * strSize.height)) / (dataArrayY.count + 1);
        CGRect r = CGRectMake(25 - strSize.width, rect1.size.height - 30 - (marginY + strSize.height)*(idx + 1),strSize.width, strSize.height);
    
        [obj drawInRect:r withAttributes:attributes];

    }];
    
    if (dataArray.count > 0) {
        
        NSMutableArray * dataArrayYY = [NSMutableArray array];
        
        //    获取折线坐标数据
        CGFloat numbers = [dataArrayY.lastObject floatValue] + ([dataArrayY[1] floatValue] - [dataArrayY[0] floatValue]);
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGSize strSize = [obj sizeWithAttributes:attributes];
            CGRect r = CGRectMake([self.lineArray[idx] floatValue], (numbers - [dataArray[idx] floatValue]) /numbers*(rect1.size.height - 30) , strSize.width, strSize.height);
            [obj drawInRect:r withAttributes:attributes];
            
            [dataArrayYY addObject:[NSString stringWithFormat:@"%f",r.origin.y]];
            
        }];
        
        self.dataArrayYY = dataArrayYY.copy;
        
        [self drawLineWithArray:Xarray str:dataArrayYY];
    }
    
    
}

//    绘制折线

-(void)drawLineWithArray:(NSArray *)dataArray str:(NSArray<NSString *>*)dataArrayY{
    
    UIBezierPath * path = [[UIBezierPath alloc]init];
    self.path = path;
    path.lineWidth  =1.0;
    [[UIColor blackColor] setStroke];
    
    [path moveToPoint:CGPointMake([dataArray[0] floatValue], [dataArrayY[0] floatValue])];
    
    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx > dataArrayY.count - 1) {
            
            return ;
        }
       
        [path addLineToPoint:CGPointMake([dataArray[idx] floatValue], [dataArrayY[idx] floatValue])];
        
    }];

    self.lineChartLayer = [CAShapeLayer layer];
    self.lineChartLayer.path = path.CGPath;
    self.lineChartLayer.strokeColor = [UIColor orangeColor].CGColor;
    self.lineChartLayer.fillColor = [[UIColor clearColor] CGColor];
    // 默认设置路径宽度为0，使其在起始状态下不显示
    self.lineChartLayer.lineWidth = 2;
    self.lineChartLayer.lineCap = kCALineCapRound;
    self.lineChartLayer.lineJoin = kCALineJoinRound;
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = timeDuration;
    pathAnimation.repeatCount = 1;
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    // 设置动画代理，动画结束时添加一个标签，显示折线终点的信息
    //    pathAnimation.delegate = self;
    [self.lineChartLayer addAnimation:pathAnimation forKey:@"strokeEnd"];

    [self.layer addSublayer:self.lineChartLayer];
    
}
-(void)setDuration:(CFTimeInterval)duration{
    
    _duration = duration;
    timeDuration = duration;
}

-(void)drawRectWithArrayX:(NSArray *)arrayX arrayY:(NSArray *)arrayY dataArray:(NSArray *)dataArray{
    
    [self.lineChartLayer removeFromSuperlayer];
    self.dataArray = nil;
    self.arrayX = arrayX;
    self.arrayY = arrayY;
    self.dataArray = dataArray;
    [self setNeedsDisplay];
}

-(void)drawRectWithArrayX:(NSArray *)dataArray{
    [self.lineChartLayer removeFromSuperlayer];
    self.dataArray = dataArray;
    [self setNeedsDisplay];
}
@end
