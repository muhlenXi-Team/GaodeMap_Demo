//
//  CustomCalloutView.h
//  gaodeMapDemo
//
//  Created by muhlenXi on 16/9/28.
//  Copyright © 2016年 XiYinjun. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  自定义气泡
 */
@interface CustomCalloutView : UIView

@property (nonatomic,strong) UIImage * thumbnail;  //!< 缩略图片
@property (nonatomic,copy) NSString * title;  //!< 标题
@property (nonatomic,copy) NSString * address; //!< 地址

@end
