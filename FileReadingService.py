#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jun 28 17:30:28 2017

@author: zdiamond
"""

import re
import os
import random
from SupportedFileTypes import SupportedFileTypes
from SupportedDistributions import SupportedDistributions
from FileProcessingService import FileProcessingService

class FileReadingService(object):
    
    def __init__(self,file,my_files):
        self.file = file
        self.my_files = my_files
        
    def ReadFiles(self,my_files):
        pass
        #Calls simulator and runs though data
        
    def getClassifications(self,my_files):
        pass
        for file in my_files:
            pass
            #Extract 0/1s
        
        return #a list, array, etc. of these for SVM
    
        