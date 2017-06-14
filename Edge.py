#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jun 14 12:00:16 2017

@author: zdiamond
"""

class Edge(object):
    
    import numpy as np
    from pylab import *
    
    def __init__(self,edge):
        self.edge = edge
        
    def num_edges(self):
        return len(Graph.get_edges())
    