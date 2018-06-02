//
//  CustomViewController.m
//  gaodeMapDemo
//
//  Created by muhlenXi on 16/9/28.
//  Copyright © 2016年 XiYinjun. All rights reserved.
//

#import "CustomViewController.h"
#import "CustomAnnotationView.h"

#import <MAMapKit/MAMapKit.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface CustomViewController ()<MAMapViewDelegate>

@property (nonatomic,strong) MAMapView * mapView;


@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"自定义标注";
    
    self.view.backgroundColor =  [UIColor greenColor];
    
    [self setupMap];
    
    //设置显示区域为深圳展滔科技大厦114.038072,22.639641
    double lati = 22.639641;
    double longi = 114.038072;
    
    [self setMapViewDisplayAreaWithLatitude:lati andLongitude:longi Span:0.02];
    
    //添加自定义样式标注
    [self addPointAnnotationWithLatitude:lati andLongitude:longi Title:@"展滔科技大厦" Subtitle:@"深圳市宝安区民治大道1079号"];

}

#pragma mark - 辅助方法

//设置高德地图
- (void) setupMap
{
    [MAMapServices sharedServices].apiKey = gaode_key;
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.mapView];
    
    //设置地图模式
    // MAMapTypeSatellite  // 卫星地图
    // MAMapTypeStandard   // 普通地图
    self.mapView.mapType = MAMapTypeStandard;
    
   
    
    //设置地图的代理
    self.mapView.delegate = self;
    
}

//添加默认样式的点标记，即大头针
- (void) addPointAnnotationWithLatitude:(double)lati andLongitude:(double) longi Title:(NSString *) title Subtitle:(NSString *) subtitle
{
    MAPointAnnotation * pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(lati, longi);
    pointAnnotation.title = title;
    pointAnnotation.subtitle = subtitle;
    
    [self.mapView addAnnotation:pointAnnotation];
    
    
}

//设置要显示的区域
- (void) setMapViewDisplayAreaWithLatitude:(double)lati andLongitude:(double) longi Span:(double) span_value
{
    CLLocationCoordinate2D center = {lati,longi};
    
    MACoordinateSpan span = {span_value,span_value};
    
    MACoordinateRegion region = {center,span};
    
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        
        static NSString * reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView * annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
            
            annotationView.image = [UIImage imageNamed:@"dingfen"];
            
            ///设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView.centerOffset = CGPointMake(0, -15);
            
            return annotationView;
        }
        
    }
    return nil;
}

@end
