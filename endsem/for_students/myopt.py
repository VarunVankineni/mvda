
#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue May  8 15:28:21 2018

@author: deepak
"""

import numpy as np
from scipy.optimize import minimize

def myobj(x,Z,A):
    '''
    Write the code that computes MLE using x,Z,A
    '''
    
    return mle


def myopt(x0,A,Z):
    
    '''
    INPUTS : 
    % Zn : stacked input and output data in the same configration as used for
    %       estimation of A
    % A : constraint matrix 
    % x0 : intial value for output and input variance. 
    
    OUTPUT : returns the x_best = argmin obj(function(x))... obj defined
    %           below
    '''
    
    # define the function myobj
    # cost = myobj(x0, Z, A)
    
    
    bnds = ((1e-4, np.inf), (1e-4, np.inf))
    Result = minimize(fun = myobj, 
                      x0 = x0, 
                      args = (Z, A),
                      bounds=bnds)
    x_opt = Result.x
    return x_opt