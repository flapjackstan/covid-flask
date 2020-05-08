# -*- coding: utf-8 -*-
"""
Created on Tue Apr  7 09:42:15 2020

@author: elmsc
"""

import pandas as pd

df = pd.read_csv('../data/schools.csv')

df.to_csv('../data/schools.csv')