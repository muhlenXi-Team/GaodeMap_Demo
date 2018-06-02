//
//  CustomAnnotationView.h
//  gaodeMapDemo
//
//  Created by muhlenXi on 16/9/28.
//  Copyright © 2016年 XiYinjun. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"

/**
 *  自定义标注View
 */
@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic,strong) CustomCalloutView * calloutView;

@end
