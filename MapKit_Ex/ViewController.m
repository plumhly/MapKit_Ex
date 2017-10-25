//
//  ViewController.m
//  ImageCompound
//
//  Created by Plum on 2017/10/24.
//  Copyright © 2017年 Plum. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.manager startUpdatingLocation];
    
}

- (CLLocationManager *)manager {
    if (!_manager) {
        if ([CLLocationManager locationServicesEnabled]) {
            _manager = [[CLLocationManager alloc] init];
            _manager.delegate = self;
            _manager.desiredAccuracy = kCLLocationAccuracyBest;
            [_manager requestWhenInUseAuthorization];
        }
    }
    return _manager;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.firstObject;
    //init mapview
    MKMapView *map = [[MKMapView alloc] initWithFrame:self.view.bounds];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500);
    MKCoordinateRegion newRag = [map regionThatFits:region];
    [map setRegion:newRag animated:YES];
    map.showsUserLocation = YES;
    [self.view addSubview:map];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *mark = placemarks.firstObject;
        NSString *city = mark.locality;
        if (!city) {
            city = mark.administrativeArea;
        }
        self.title = city;
    }];
    [_manager stopUpdatingLocation];
}

- (UIImage *)compoundImageWithNumber:(NSString *)number {
    UIImageView *imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_rent_map_car"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imgview.frame.size.width - 40, 0, 40, 40)];
    imgview.backgroundColor = [UIColor greenColor];
    label.attributedText = [[NSAttributedString alloc] initWithString:number attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSStrokeWidthAttributeName: [NSNumber numberWithInteger:-5]}];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor redColor];
    label.layer.borderWidth = 3;
    label.layer.cornerRadius = 20;
    label.layer.borderColor = [UIColor whiteColor].CGColor;
    label.layer.masksToBounds = YES;
    [imgview addSubview:label];
    [self.view addSubview:imgview];
    UIGraphicsBeginImageContextWithOptions(imgview.frame.size, NO, [UIScreen mainScreen].scale);
    [imgview drawRect:CGRectMake(0, 0, imgview.frame.size.width, imgview.frame.size.height)];
    //    [label drawRect:CGRectMake(imgview.frame.size.width - 40, 0, 40, 40)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end


