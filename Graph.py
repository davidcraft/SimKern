#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jun 14 13:29:45 2017

@author: zdiamond
"""
#Graph representation by adjacency matrix

import numpy as np

class Node(object):
    def __init__(self,name,value, rate = 0):
        self.name = name
        self.value = value
        self.rate = rate
        self.connections = []

    def change_val(self,new_vlaue):
        self.value = new_vlaue
       
        
        
class Edge(object):
    def __init__(self,node,function):
        self.node = node
        self.fucntion = function
    def delete_node(seld,d_node):
        #delete a node from a connection 

class Graph():
    self.nodes = {}
    self.edges = []
    self.edge_indicies= {}
    
    def add_node(self,node):
        if isinstance(node,Node) and node.name not in self.nodes:
            self.nodes[node.name] = node
            for row in self.edges:
                row.append(0)
            self.edges.append([0]*(len(self.edges)+1))
            self.edge_indicies[node.name] = len(self.edge_indicies)
        else:
            print('the name or type is invaild')
    
    def add_edge(self,u,v,weight=1,edge):
        if u in self.nodes and v in self.nodes:
            self.edges[self.edge_indicies[u]][self.edge_indicies[v]] = weight
            self.edges[self.edge_indicies[v]][self.edge_indicies[u]] = weight
            
        else:
            r
    def get_matrix(self):
        return np.array(self.edges)
        
    def print_graph(self):
        for v, i in sorted(self.edge_indicies.items()):
            print (v + ' ', end = ' ')
            for j in range(len(self.edges)):
                print(self.edges[i][j], end = ' ')
            print(' ')
   
def read_futions(file_name):
    file = open('file_name','r')
    #need a parsing function here
    pass
      
#
#g = Graph()
#a = Node('A')
#g.add_node(a)
#g.add_node(Node('B'))
#for i in range(ord('A'), ord('G')):
#	g.add_node(Node(chr(i)))
#
#edges = ['AD','CD','BC','CC','CE']
#for edge in edges:
#	g.add_edge(edge[:1], edge[1:],1)
#
#g.print_graph()
#
#adjmat = np.array([[0,0,0,1,0,0],[0,0,1,0,0,0],[0,1,1,1,1,0],[1,0,1,0,0,0],[0,0,1,0,0,0],[0,0,0,0,0,0]])
#print(adjmat)

#Need to figure out a method to transform the printed adjacency matrix to a numpy matrix. Then all we need is an nxn matrix of rate coefficents and whatever dynamics we use!

    
    
