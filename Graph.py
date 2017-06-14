#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jun 13 21:44:57 2017

@author: zdiamond
"""
class Graph(object):
    
    import numpy as num
    from pylab import *
    
    def __init__(self,graph_dict):
        if graph_dict == None:
            graph_dict = {}
        self.graph_dict = graph_dict
        
    def get_nodes(self):
        return list(self.graph_dict.keys())

    def get_edges(self):
        return self.generate_edges()
    
    def add_node(self,node):
        if node not in self.graph.dict:
            self.graph_dict[node] = []
            
    def add_edge(self,edge):
        edge = set(edge)
        (n1,n2) = tuple(edge)
        if n1 in self.graph_dict:
            self.graph_dict[n1].append(n2)
        else:
            self.graph_dict[n1] = n2
    
    def generate_edges(self):
        edges = []
        for node in self.graph_dict:
            for pal in self.graph_dict[node]:
                if {pal,node} not in edges:
                    edges.append({node,pal})
        return edges


           
            
        
        
    
    

               

        
        
            


