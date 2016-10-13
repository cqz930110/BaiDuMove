//
//  AppDelegate.h
//  BaiduDemo
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 zhaozq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager *_mapManager;

}
@property (strong, nonatomic) UIWindow *window;


@end

