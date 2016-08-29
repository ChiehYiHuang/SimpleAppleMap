//
//  ViewController.m
//  SimpleAppleMap
//
//  Created by Rebecca on 2016/8/29.
//  Copyright © 2016年 Rebecca. All rights reserved.
//

#import "ViewController.h"
#import "MapAnnotation.h"

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface ViewController ()  {
    MKMapView *mapView;
    NSArray *testArray;
    CLLocationCoordinate2D coorToBeSend;
    
    NSArray *latitudeList;
    NSArray *longitudeList;
    NSArray *titleList;
    
    NSMutableArray *dataList;
}

@end

@implementation ViewController

#pragma mark - Override
- (void)viewDidLoad {
    [super viewDidLoad];
    dataList = [[NSMutableArray alloc] init];
    
    latitudeList = [[NSArray alloc] initWithObjects:
                    @"24.450304",
                    @"23.812758",
                    @"25.155667",
                    @"21.945735",
                    @"25.0463398",
                    nil];
    longitudeList = [[NSArray alloc] initWithObjects:
                     @"120.878624",
                     @"120.850054",
                     @"121.547690",
                     @"120.783842",
                     @"121.5559068",
                     nil];
    titleList = [[NSArray alloc] initWithObjects:
                 @"雪霸國家公園",
                 @"玉山國家公園",
                 @"陽明山國家公園",
                 @"墾丁國家公園",
                 @"方塊夫兒",
                 nil];
    
    CGRect rect;
    
    // Init MapView
    rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    mapView = [[MKMapView alloc]initWithFrame:rect];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
    // 設定預設位置
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = 23.668278;
    theCoordinate.longitude= 120.6872;
    
    // 設定範圍
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta = 3;
    theSpan.longitudeDelta = 3;
    
    MKCoordinateRegion theRegion;
    theRegion.center = theCoordinate;
    theRegion.span = theSpan;
    
    [mapView setMapType:MKMapTypeStandard];
    [mapView setRegion:theRegion];
    
    // 添加記號
    [self addPoint];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Funcions
- (void)addPoint {
    for (int i = 0; i < [titleList count]; i++) {
        MapAnnotation *annot = [[MapAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [latitudeList[i] floatValue];
        coor.longitude = [longitudeList[i] floatValue];
        annot.coordinate = coor;
        annot.title = titleList[i];
        [dataList addObject:annot];
        annot = nil;
    }
    [mapView addAnnotations:dataList];
}
- (void)sendAppleMap {
    CLLocationCoordinate2D to;
    
    // 目的地經緯度
    to.latitude = coorToBeSend.latitude;
    to.longitude = coorToBeSend.longitude;
    
    // 調用內建地圖（定位）
    // 顯示目的地座標並畫路線
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
    
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                   launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                  
                                                             forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
}

#pragma mark - Event Functions
- (void)showDetails {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"使用Apple內建地圖導航", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[MapAnnotation class]]) {
        static NSString* travellerAnnotationIdentifier = @"TravellerAnnotationIdentifier";
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:travellerAnnotationIdentifier];
        if (!pinView) {
            MKAnnotationView* customPinView = [[MKAnnotationView alloc]
                                               initWithAnnotation:annotation reuseIdentifier:travellerAnnotationIdentifier];
            //點擊彈出標籤
            customPinView.canShowCallout = YES;
            customPinView.tag = -1;
            
            if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
                NSLog(@"版本低於6.0");
            } else {
                UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                [rightButton addTarget:self
                                action:@selector(showDetails)                      forControlEvents:UIControlEventTouchUpInside];
                customPinView.rightCalloutAccessoryView = rightButton;
            }
            
            UIImage *image = [UIImage imageNamed:@"marker.png"];
            customPinView.image = image;
            customPinView.opaque = YES;
            
            [customPinView setAutoresizesSubviews:YES];
            
            return customPinView;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(NA, 4_0) {
    NSLog(@"選中...");
    CLLocationCoordinate2D corr = [view.annotation coordinate];
    coorToBeSend = corr;
    NSLog(@"%f",corr.longitude);
    NSLog(@"%f",corr.latitude);
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self sendAppleMap];
            break;
        default:
            break;
    }
}

@end
