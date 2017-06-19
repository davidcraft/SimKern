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

#class system(object):
#    def __init__(self,nodes,functions):
#        self.
#        


def steady_state(new_state,states):        
    '''check if a system is in a steady state,return the true|false and the index|None'''
    for i in range(len(states)):
        if states[i] == new_state:
            return (True,i)
        else:
            return(False,None)
        
def value_vector(nodes):
    '''take a list of nodes and return a list contain their value'''
    value = [i.value for i in nodes]
    return value

def update_states(init_state, functions):
    '''given a list of intital_value, and functions, return a list of new_value'''
    for i in init_state:
        
            

def simulation(nodes,functions):
    '''take a list of nodes and a list of functions, then update the value for 
    each node 1 times.'''
    initail_values = value_vector(nodes)
    states = [initail_values]
    rate_changes = []
    t = 0
    while t <= 1000:
        new_state = update_state(states[-1],functions)#give the new state if not in a steady state
        bo,ind = steady_state(new_state,states)
        if bo:
            return (states,ind)]# return different things depanding on what we need later on 
        states.append(new_state)#add the new state to existing states
        t +=1
    print('no steady state has been found in',t,'times, None is returned')
    return None

def read_futions(file_name):
    file = open('file_name','r')
    #need a parsing function here
    pass        

#some example diff_q
fuctions = 
dx1 = k11*x1.value + k12 *(x1.value + x2.value)
dx2 = k21*x2.value + k22 *(x1.value + x2.value)
dx3 = k31*x3.value + k32 *(x1.value + x2.value + x3.value)
fuctions = []

food_web = []