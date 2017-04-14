//
//  ofxiBeacon.m
//
//  Created by Kenta Watashima on 2017/04/13.
//
//

#import "ofxiBeacon.h"
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BeaconAdvertisementData.h"

@interface ofxiBeaconDelegate : NSObject <CBPeripheralManagerDelegate>

+ (ofxiBeaconDelegate *)sharedInstanceWithUUIDString:(NSString *)uuidString major:(uint16_t)major minor:(uint16_t)minor measuredPower:(int8_t)measuredPower;
- (void)startAdvertising;
- (void)stopAdvertising;
@property (nonatomic, assign) CBPeripheralManager *peripheralManager;
@property (nonatomic, readonly) BeaconAdvertisementData *beaconData;

@end

# pragma mark -

ofxiBeaconDelegate *delegate;

ofxiBeacon::ofxiBeacon() {}

ofxiBeacon::ofxiBeacon(const string &uuid, const int major, const int minor, const int measuredPower) {
    delegate = [ofxiBeaconDelegate sharedInstanceWithUUIDString:[NSString stringWithUTF8String:uuid.c_str()]
                                                          major:major
                                                          minor:minor
                                                  measuredPower:measuredPower];
}

ofxiBeacon::~ofxiBeacon() {
}

void ofxiBeacon::startAdvertising() {
    [delegate startAdvertising];
}

void ofxiBeacon::stopAdvertising() {
    [delegate stopAdvertising];
}

# pragma mark -

@implementation ofxiBeaconDelegate

+ (ofxiBeaconDelegate *)sharedInstanceWithUUIDString:(NSString *)uuidString major:(uint16_t)major minor:(uint16_t)minor measuredPower:(int8_t)measuredPower {
    static ofxiBeaconDelegate *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] initWithUUIDStrimg:uuidString major:major minor:minor measuredPower:measuredPower];
    });
    
    return _sharedInstance;
}

- (id)initWithUUIDStrimg:(NSString *)uuidString major:(uint16_t)major minor:(uint16_t)minor measuredPower:(int8_t)measuredPower {
    self = [super init];
    if (self) {
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
        
        NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:uuidString];
        _beaconData = [[BeaconAdvertisementData alloc] initWithProximityUUID:proximityUUID
                                                                       major:major
                                                                       minor:minor
                                                               measuredPower:measuredPower];
    }
    return self;
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"powered on");
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    NSLog(@"start advertising");
}

- (void)startAdvertising {
    if (_peripheralManager.isAdvertising) {
        return;
    }
    
    [_peripheralManager startAdvertising:_beaconData.beaconAdvertisement];
}

- (void)stopAdvertising {
    if (!_peripheralManager.isAdvertising) {
        return;
    }
    
    [_peripheralManager stopAdvertising];
}

@end
