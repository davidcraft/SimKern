#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 15 15:58:09 2017

@author: zhaoqiwang
"""

import numpy as np

class Node(object):
    def __init__(self,name,value =0, change_rate = 0):
        self.name = name
        self.value = value
        self.change_rate = change_rate
        

    def change_val(self,new_vlaue):
        self.value = new_vlaue
    
    def up_date(self):
        '''update the value of a node based on its change_rate'''
        new_value = self.value + change_rate
        if new_value >= 0:
            self.change_val(new_value)
        else:
            print('error:value can not be negative')
            return False
class system(object):
    def __init__
def steady_state(new_state,states):        
    '''check if a system is in a steady state,return the true|false and the index|None'''
    for i in range(len(states)):
        if states[i] == new_state:
            return (True,i)
        else:
            return(False,None)
        
    

def simulation(nodes,functions):
    '''take a list of nodes and a list of functions, then update the value for 
    each node 1 times.'''
    values = []
    rate_changes = []
    for i in nodes:
        i.update()
        
def read_futions(file_name):
    file = open('file_name','r')
    #need a parsing function here
    pass        
#