//
//  CustomAnnotationView.m
//  gaodeMapDemo
//
//  Created by muhlenXi on 16/9/28.
//  Copyright © 2016年 XiYinjun. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

//重写选中方法setSelected
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected) {
        return;
    }
    if (selected == YES) {
        //如果气泡为空则初始化气泡
        if (self.calloutView == nil) {
            
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, 200, 70)];
            
            //设置气泡的中心点
            CGFloat center_x = self.bounds.size.width/2;
            CGFloat center_y = -self.bounds.size.height;
            self.calloutView.center = CGPointMake(center_x, center_y);
        }
        
        //给calloutView赋值
        self.calloutView.thumbnail = [UIImage imageNamed:@"zhantao"];
        self.calloutView.title = self.annotation.title;
        self.calloutView.address = self.annotation.subtitle;
        
        [self addSubview:self.calloutView];
        
    } else {
        //移除气泡
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}



@end
