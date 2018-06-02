//
//  RootViewController.m
//  gaodeMapDemo
//
//  Created by muhlenXi on 16/9/27.
//  Copyright © 2016年 XiYinjun. All rights reserved.
//

#import "RootViewController.h"
#import "CustomViewController.h"
#import "LocationViewController.h"
#import <MAMapKit/MAMapKit.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface RootViewController ()<MAMapViewDelegate>

@property (nonatomic,strong) MAMapView * mapView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"自定义标注" style:UIBarButtonItemStylePlain target:self action:@selector(pushToCustomViewController:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"定位" style:UIBarButtonItemStylePlain target:self action:@selector(pushToLocationViewController:)];
    
    self.navigationItem.title = @"高德地图";
    
    self.view.backgroundColor =  [UIColor yellowColor];
    
    [self setupMap];
    
    //设置显示区域为深圳展滔科技大厦114.038072,22.639641
    double lati = 22.639641;
    double longi = 114.038072;
    
    [self setMapViewDisplayAreaWithLatitude:lati andLongitude:longi Span:0.02];
    
    //添加系统样式标注
    [self addPointAnnotationWithLatitude:lati andLongitude:longi Title:@"展滔科技大厦" Subtitle:@"深圳市宝安区民治大道1079号"];
    
    //添加折线
    [self addPolyLineOnMap];
    
    //添加圆形覆盖物，radius指的是圆圈的半径
    MACircle *Circle1 = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(lati, longi) radius:500];
    [self.mapView addOverlay:Circle1];
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
    
    //显示实时路况
    //self.mapView.showTraffic = YES;
    
    //给否显示比例尺
    //self.mapView.showsScale = NO;
    //设置比例尺位置
    //self.mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 82);
    
    //是否显示罗盘
    //self.mapView.showsCompass = NO;
    //self.mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 82); //设置指南针位置
    
    //NSLog(@"logoSize == %@",NSStringFromCGSize(self.mapView.logoSize));
    //显示logo在右下角
    //self.mapView.logoCenter = CGPointMake(kScreenWidth-55, kScreenHeight-13);
    
    //设置地图的代理
    self.mapView.delegate = self;
    
}

//设置要显示的区域
- (void) setMapViewDisplayAreaWithLatitude:(double)lati andLongitude:(double) longi Span:(double) span_value
{
    CLLocationCoordinate2D center = {lati,longi};
    
    MACoordinateSpan span = {span_value,span_value};
    
    MACoordinateRegion region = {center,span};
    
    [self.mapView setRegion:region animated:YES];
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

//绘制折线
- (void) addPolyLineOnMap
{
    NSInteger count = 5;
    CLLocationCoordinate2D commonPolylineCoords[count];
    
    //起点：展滔科技大厦
    commonPolylineCoords[0].latitude = 22.639641;
    commonPolylineCoords[0].longitude = 114.038072;
    
    //北站114.02887,22.609235
    commonPolylineCoords[1].latitude = 22.609235;
    commonPolylineCoords[1].longitude = 114.02887;
    
    //民乐地铁站114.048809,22.594144
    commonPolylineCoords[2].latitude = 22.594144;
    commonPolylineCoords[2].longitude = 114.048809;
    
    //东站114.119699,22.60225
    commonPolylineCoords[3].latitude = 22.60225;
    commonPolylineCoords[3].longitude = 114.119699;
    
    //终点：坂田114.06942,22.634804
    commonPolylineCoords[4].latitude = 22.634804;
    commonPolylineCoords[4].longitude = 114.06942;
    
    //构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:count];
    
    //在地图上添加折线对象
    [self.mapView addOverlay: commonPolyline];
    
    

}

#pragma mark - 事件响应

- (void) pushToCustomViewController:(id) sender
{
    CustomViewController * vc = [[CustomViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) pushToLocationViewController:(id) sender
{
    LocationViewController * vc = [[LocationViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        //复用标识符
        
        static NSString * pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView * annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
       
        annotationView.centerOffset = CGPointMake(0, 0);
        NSLog(@"annotationView.bounds == %@",NSStringFromCGRect(annotationView.bounds));
        
        //设置气泡可以弹出，默认为NO
        annotationView.canShowCallout= YES;
        //设置标注动画显示，默认为NO
        annotationView.animatesDrop = YES;
        //设置标注可以拖动，默认为NO
        annotationView.draggable = YES;
        //设置大头针的颜色，有MAPinAnnotationColorRed, MAPinAnnotationColorGreen, MAPinAnnotationColorPurple三种
        annotationView.pinColor = MAPinAnnotationColorPurple;
        
        return annotationView;
    }
    return nil;
}

//移动标注会调用这个方法
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState fromOldState:(MAAnnotationViewDragState)oldState
{
    //标注移动时
    if (newState == MAAnnotationViewDragStateStarting) {
        
        NSArray * overlays = mapView.overlays;
        MACircle * cicle = [[MACircle alloc] init];
        for (NSInteger i = 0; i < overlays.count; i++) {
            
            //如果是圈圈则删除
            if ([overlays[i] isKindOfClass:[cicle class]]) {
                
                [mapView removeOverlay:overlays[i]];
            }
        }
        
    }
    //标注停止移动时
    if (newState == MAAnnotationViewDragStateEnding)
    {
        
        //获取标注新的位置所在的经纬度坐标
        CGPoint endPoint = view.centerOffset;
        
        //修正一下位置
        endPoint.x = endPoint.x + 22;
        endPoint.y = endPoint.y + 36;
        
        CLLocationCoordinate2D coo =  [mapView convertPoint:endPoint toCoordinateFromView:view];
        
        NSLog(@"移动后大头针的经纬度：latitude = %f longitude = %f",coo.latitude,coo.longitude);
        
        //添加新的圈圈
        MACircle * Circle1 = [MACircle circleWithCenterCoordinate:coo radius:500];
        [mapView addOverlay:Circle1];
        
    }
}


- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        
        NSLog(@" MAPolylineRenderer 调用了");
        
        MAPolylineRenderer *  lineRenderer = [[ MAPolylineRenderer alloc] initWithOverlay:overlay];
        
        //折线宽度
        lineRenderer.lineWidth = 5.0f;
        //折线的颜色
        lineRenderer.strokeColor = [UIColor blueColor];
        //折线起始点类型
        lineRenderer.lineJoin = kCGLineJoinBevel;
        //折线终点类型
        lineRenderer.lineCap = kCGLineJoinBevel;
        
        return lineRenderer;
        
    }
    
    //如果是圆形覆盖物
    if ( [overlay isKindOfClass:[MACircle class]]) {
        
        NSLog(@" MACircleRenderer 调用了");
        
        MACircleRenderer * circleRenderer = [[MACircleRenderer alloc] initWithOverlay:overlay];
        //设置圆圈的圆边的宽度
        circleRenderer.lineWidth = 3.0f;
        //圆边的颜色
        circleRenderer.strokeColor = [UIColor colorWithRed:236/255.0 green:65/255.0 blue:110/255.0 alpha:0.8];
        //设置圆圈的填充颜色
        circleRenderer.fillColor = [UIColor colorWithRed:236/255.0 green:65/255.0 blue:110/255.0 alpha:0.3];
        
        return circleRenderer;
        
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
