//
//  ofxiBeacon.h
//
//  Created by Kenta Watashima on 2017/04/13.
//
//

#pragma once

#include "ofMain.h"

class ofxiBeacon {

public:
    ofxiBeacon();
    ofxiBeacon(const string &uuid, const int major, const int minor, const int measuredPower);
    ~ofxiBeacon();
    
    void setup(string uuid, int minor, int major);
    void startAdvertising();
    void stopAdvertising();

};
