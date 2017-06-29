#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jun 27 17:00:25 2017

@author: taylorsorenson
"""

#Run Simulation
import matlab.engine

def runMATLABscript(m_file):
    eng = matlab.engine.start_matlab()
    end.m_file(nargout=0)
    
f = open('/Testing/SampleMFiles/Senescence_m.m')
runMATLABscript(f)
