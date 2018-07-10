//
//  JLDoubleRingChart.m
//  JLNewRingChart
//
//  Created by 李杰 on 2016/11/17.
//  Copyright © 2016年 JackLee. All rights reserved.
//

#import "JLRingChart.h"
#import <Masonry.h>

@implementation JLRingChart

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hasSpace = YES;
        [self addSubview:self.centerLab];
        [self.centerLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.hasSpace = YES;
        [self addSubview:self.centerLab];
        [self.centerLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self customLayer];
    }
    
    return self;
}

- (UILabel *)centerLab{
    if (!_centerLab) {
        _centerLab = [UILabel new];
        _centerLab.numberOfLines = 2;
        _centerLab.font = [UIFont gs_fontNum:15];
        _centerLab.textColor = [UIColor colorWithHex:0x333333];
        _centerLab.textAlignment = NSTextAlignmentCenter;
    }
    return _centerLab;
}

- (void)customLayer{
    
    _mylayer = [CALayer layer];
    _mylayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self.layer addSublayer:_mylayer];
    
    
}


- (void)setValueDataArr:(NSArray *)valueDataArr
{
    
    _valueDataArr = valueDataArr;
    
    
    
}



- (void)setFillColorArray:(NSArray *)fillColorArray
{
    _fillColorArray = fillColorArray;
}

-(void)setAngle:(CGFloat)angle
{
    _angle = angle;
}

//画环图的图层
- (void)startToDrawLayer
{
    if (self.hasSpace) {
        _itemsSpace =  (M_PI * 4.0 * 10 / 360)/_valueDataArr.count ;
    }
    
    [self colorArrAndRingWidth];

    [self setupRingLayer];
}

//填充颜色和环图的宽度
- (void)colorArrAndRingWidth{
    
    /*        环图的宽度         */
    if (!_ringWidth) {
        _ringWidth = 25.0;
    }
    
    /*        每段环图的填充颜色         */
    if (!_fillColorArray) {
        _fillColorArray = RING_COLOR_ARR(0.8);
    }
    
    if (!_angle) {
        _angle = -1/2;
    }
}

//画圆环的图层
- (void)setupRingLayer{
    
    _midValueArr = [[NSMutableArray alloc ]init];
    
    CGFloat lastBegin = -( [_valueDataArr[0] floatValue] *M_PI*2/2) + M_PI*_angle;
    
    
    NSInteger  i = 0;
    CGContextRef contex = UIGraphicsGetCurrentContext();
    CGFloat redius = _mylayer.frame.size.height/2 - _ringWidth/2;
    CGFloat longLen = redius +30;
    CGPoint chartOrigin = CGPointMake(_mylayer.frame.size.width/2, _mylayer.frame.size.height/2);
    for (id obj in _valueDataArr) {
        
        CAShapeLayer *ringLayer = [CAShapeLayer layer] ;
        
        ringLayer.fillColor = [UIColor clearColor].CGColor;
        
        ringLayer.lineWidth = _ringWidth;
        
        ringLayer.fillColor = [UIColor clearColor].CGColor;
        
        if (i<_fillColorArray.count) {
            
            ringLayer.strokeColor =[_fillColorArray[i] CGColor];
            
        }
        
        CGFloat cuttentpace = [obj floatValue]  * (M_PI * 2 - _itemsSpace * _valueDataArr.count);
        
        UIBezierPath *thePath = [UIBezierPath bezierPath];
        
        
        NSNumber *midValue = [NSNumber numberWithFloat: -(lastBegin + cuttentpace/2) + M_PI*_angle];
        
        [_midValueArr addObject: midValue];
        
        [thePath addArcWithCenter:chartOrigin radius:redius  startAngle:lastBegin  endAngle:lastBegin  + cuttentpace clockwise:YES];
        
        ringLayer.path = thePath.CGPath;
        
        [_mylayer addSublayer:ringLayer];
        
        
        CGFloat midSpace = lastBegin + cuttentpace / 2;
        
        CGPoint begin = CGPointMake(chartOrigin.x + sin(midSpace) * redius, chartOrigin.y - cos(midSpace)*redius);
        CGPoint endx = CGPointMake(chartOrigin.x + sin(midSpace) * longLen, chartOrigin.y - cos(midSpace)*longLen);
        
        lastBegin += (cuttentpace+_itemsSpace);
        
        
        
        
        [self drawLineWithContext:contex andStarPoint:begin andEndPoint:endx andIsDottedLine:NO andColor:_fillColorArray[i]];
        
        CGPoint secondP = CGPointZero;
        CGSize size = [[NSString stringWithFormat:@"%.02f%c",[_valueDataArr[i] floatValue] * 100,'%'] boundingRectWithSize:CGSizeMake(200, 100) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
        if (midSpace<M_PI) {
            secondP =CGPointMake(endx.x + 20, endx.y);
                        [self drawText:[NSString stringWithFormat:@"%.02f%c",[_valueDataArr[i] floatValue] * 100,'%'] andContext:contex atPoint:CGPointMake(secondP.x + 3, secondP.y - size.height / 2) WithColor:_fillColorArray[i] andFontSize:10];
            
        }else{
            secondP =CGPointMake(endx.x - 20, endx.y);
                        [self drawText:[NSString stringWithFormat:@"%.02f%c",[_valueDataArr[i] floatValue] * 100,'%'] andContext:contex atPoint:CGPointMake(secondP.x - size.width - 3, secondP.y - size.height/2) WithColor:_fillColorArray[i] andFontSize:10];
        }
                          [self drawLineWithContext:contex andStarPoint:endx andEndPoint:secondP andIsDottedLine:NO andColor:_fillColorArray[i]];
                        [self drawPointWithRedius:3 andColor:_fillColorArray[i] andPoint:secondP andContext:contex];
        i++;
    }
    
}



- (void)reloadDatas{
    [self.superview layoutIfNeeded];
    if (_mylayer) {
        
        [_mylayer removeFromSuperlayer];
    }
    
    [self customLayer];
    
    [self startToDrawLayer];
    
    [self annomationMoveTo:0];
    
}



- (void)annomationMoveTo:(NSInteger)item
{
    
    for (int i=0 ; i<_midValueArr.count; i++) {
        
        if (item != self.theOne) {
            
            if (item == i) {
                
                _mylayer.transform = CATransform3DMakeRotation([[_midValueArr objectAtIndex:i]floatValue], 0, 0, 1);
                
            }
        }
    }
    
    self.theOne = item;
}

/**
 *  绘制文字
 *
 *  @param text    文字内容
 *  @param context 图形绘制上下文
 *  @param rect    绘制点
 *  @param color   绘制颜色
 */
- (void)drawText:(NSString *)text andContext:(CGContextRef )context atPoint:(CGPoint )rect WithColor:(UIColor *)color andFontSize:(CGFloat)fontSize{
    
    
    [[NSString stringWithFormat:@"%@",text] drawAtPoint:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:color}];
    
    [color setFill];
    
    CGContextDrawPath(context, kCGPathFill);
    
}
/**
 *  绘制线段
 *
 *  @param context  图形绘制上下文
 *  @param start    起点
 *  @param end      终点
 *  @param isDotted 是否是虚线
 *  @param color    线段颜色
 */
- (void)drawLineWithContext:(CGContextRef )context andStarPoint:(CGPoint )start andEndPoint:(CGPoint)end andIsDottedLine:(BOOL)isDotted andColor:(UIColor *)color{
    
    
    //    移动到点
    CGContextMoveToPoint(context, start.x, start.y);
    //    连接到
    CGContextAddLineToPoint(context, end.x, end.y);
    
    
    CGContextSetLineWidth(context, 0.3);
    
    
    [color setStroke];
    
    if (isDotted) {
        CGFloat ss[] = {1.5,2};
        
        CGContextSetLineDash(context, 0, ss, 2);
    }
    CGContextMoveToPoint(context, end.x, end.y);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawPointWithRedius:(CGFloat)redius andColor:(UIColor *)color andPoint:(CGPoint)p andContext:(CGContextRef)contex{
    
    CGContextAddArc(contex, p.x, p.y, redius, 0, M_PI * 2, YES);
    [color setFill];
    CGContextDrawPath(contex, kCGPathFill);
    
}

@end
