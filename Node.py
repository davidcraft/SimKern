#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jun 14 12:00:09 2017

@author: zdiamond
"""

class Node(object):
    
    import numpy as np
    from pylab import *
    
    def __init__(self,node):
        self.node = node
    
    def num_nodes(self):
        return len(Graph.get_nodes())
    
    
    