//
//  ViewController.m
//  BaiduDemo
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 zhaozq. All rights reserved.
//

#define kScreenWidth           [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight          [[UIScreen mainScreen] bounds].size.height


#import "ViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "JX_GCDTimerManager.h"

#import "trackModel.h"
#import "trackdata.h"
@interface ViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate,BMKRouteSearchDelegate>
{

}
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKUserLocation *userLocation;//获取我的地理位置信息；
@property (nonatomic, strong) NSMutableArray *dataSourceArrays;
@property (nonatomic, strong) JX_GCDTimerManager *timerManager;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong) NSTimer             *myTimer;

@end

//static NSString *myTimer = @"MyTimer";

@implementation ViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
}
- (void)dealloc {
    
    TTVIEW_RELEASE_SAFELY(_mapView);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self.view addSubview:self.mapView];
    [self loadData];
}
- (void)loadData
{WEAKSELF;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"guijixinxi" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *jsonDic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    trackModel *model = [[trackModel alloc] initWithDictionary:jsonDic];
    self.dataSourceArrays  = [model.data mutableCopy];
    
    __block CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(_dataSourceArrays.count * sizeof(CLLocationCoordinate2D));

    [_dataSourceArrays enumerateObjectsUsingBlock:^(trackdata *objModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        coordinates[idx].longitude = [objModel.lon integerValue]/1000000.0 ;
        coordinates[idx].latitude  = [objModel.lat integerValue]/1000000.0 ;
        
        if (idx == 0) {
            CLLocationCoordinate2D point = {coordinates[idx].latitude , coordinates[idx].longitude};
            BMKPointAnnotation *annotation= [[BMKPointAnnotation alloc] init];
            annotation.coordinate = point;
            annotation.title = @"起点";
            annotation.subtitle = @"艹";
            [weakSelf.mapView addAnnotation:annotation];
        }
    }];
    
    BMKPolyline *polyline = [BMKPolyline polylineWithCoordinates:coordinates count:_dataSourceArrays.count];
    //    free(coordinates), coordinates = NULL;
    [_mapView addOverlay:polyline];
    _mapView.visibleMapRect = polyline.boundingMapRect;
    CLLocationCoordinate2D end = {coordinates[1].latitude , coordinates[1].longitude};
    [_mapView setCenterCoordinate:end];
    _mapView.zoomLevel = 16.f;
    
    _count = 0;
    
    if (_myTimer == nil ){
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:.5f target:self selector:@selector(moveCar) userInfo:nil repeats:YES];
    }

//    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:myTimer
//                                                           timeInterval:0.5
//                                                                  queue:nil
//                                                                repeats:YES
//                                                           actionOption:AbandonPreviousAction
//                                                                 action:^{
//                                                                     [weakSelf moveCar];
//                                                                 }];

}
#pragma mark - 定时移动
- (void)moveCar{
    
    if (_count == _dataSourceArrays.count) {
//        [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:myTimer];
        TT_INVALIDATE_TIMER(_myTimer);
        _count = 0;
        return;
    }

    NSArray *annArrays = _mapView.annotations;
    for (BMKPointAnnotation *csanotation in annArrays) {
        
        NSUInteger index = (_count == 0)?0:_count-1;
        trackdata *objData = _dataSourceArrays[index];
        
        if (csanotation.coordinate.latitude == [objData.lat integerValue]/1000000.0 && csanotation.coordinate.longitude == [objData.lon integerValue]/1000000.0) {
            [_mapView removeAnnotation:csanotation];
        }
    }
    trackdata *objModel = _dataSourceArrays[_count];
        
    CLLocationCoordinate2D point = {[objModel.lat integerValue]/1000000.0 , [objModel.lon integerValue]/1000000.0};
    
    BMKPointAnnotation *annotation= [[BMKPointAnnotation alloc] init];
    annotation.coordinate = point;
    annotation.title = @"汽车";
    annotation.subtitle = @"艹";
    [_mapView addAnnotation:annotation];

    _count ++;
}
#pragma mark - private methods
#pragma mark -获取地理位置信息
- (void)userLocationService
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}
#pragma mark -BMKLocationServiceDelegate
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _userLocation = userLocation;
    //定位成功后取消定位
    if (_userLocation)
    {
        [_locService stopUserLocationService];//停止定位服务
    }
    DLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}
// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            //        // 设置可拖拽
            //        annotationView.draggable = YES;
            annotationView.canShowCallout = NO;
            annotationView.selected = YES;
        }
        
        if ([annotation.title isEqualToString:@"汽车"] || [annotation.title isEqualToString:@"起点"]) {
            annotationView.image =[UIImage imageNamed:@"car"];
            annotationView.centerOffset = CGPointMake(-16, 0);

        }else {
            annotationView.image = nil;
        }
        return annotationView;
 
    }

    return nil;
}
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 2.0;
        return polylineView;
    }
    return nil;
}


#pragma mark - setter and getter
- (BMKMapView *)mapView
{
    if (!_mapView) {
        
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth,kScreenHeight-64)];
        _mapView.zoomLevel = 16.f;
        _mapView.showsUserLocation = YES;//显示定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
        _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
        [self userLocationService];
    }
    return _mapView;
}
- (NSMutableArray *)dataSourceArrays
{
    if (!_dataSourceArrays) {
        _dataSourceArrays = [NSMutableArray array];
    }
    return _dataSourceArrays;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
