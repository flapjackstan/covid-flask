# -*- coding: utf-8 -*-
"""
Created on Mon May 11 11:32:20 2020

@author: elmsc
"""
import os
os.chdir('C:/Users/elmsc/Documents/school/cpsc/dbms/covid-flask')

import geopandas as gpd
import pandas as pd


class Patient:
    
    
    def __init__(self, first_name, last_name, id, lat, long, symptoms):
        self.first = first_name
        self.last = last_name
        self.id = id
        self.lat  = lat
        self.long  = long
        self.symptoms = symptoms
        self.zip = 0
        #self.geoLocate()
                
    def getFirst(self):
        return self.first
        
    def getLast(self):
        return self.last

    def getId(self):
        return self.id  

    def getLat(self):
        return self.lat

    def getLong(self):
        return self.long
        
    def getSymptoms(self):
        return self.symptoms
    
    def getZip(self):
        return self.zip
    
    def getColumns(self):
        return ['first_name', 'last name', 'id', 'lat', 'long', 'symptoms']
    
    def setZip(self, zip_code):
        self.zip = zip_code

    def getPatient(self, geo = False):
        if geo:
            return (self.getFirst(),self.getLast(), self.getId(), self.getZip(), self.getSymptoms())
        else:
            return [[self.getFirst(),self.getLast(), self.getId(), self.getLat(), self.getLong(), self.getSymptoms()]]
    
    def toDF(self):
        df = pd.DataFrame(self.getPatient(), columns=self.getColumns())
        return df
    
    def geoLocate(self, polygon):
        df = pd.DataFrame(self.getPatient(), columns=self.getColumns())
        
        gdf = gpd.GeoDataFrame(df, geometry=gpd.points_from_xy(df.long, df.lat))
        gdf.crs= {'init': 'epsg:4326'} #WGS84
        
        zip_codes = gpd.read_file('data/spatial/shp/bor_zip_codes.shp')
        zip_codes.crs= {'init': 'epsg:4326'} #WGS84
        
        gdf =  gpd.sjoin(gdf, polygon[['GEOID10','geometry']], how="inner", op='intersects')
        
        gdf.drop(['geometry','lat','long','index_right'],axis=1, inplace=True)
        
        zip_code = gdf.loc[0][4]
        
        self.setZip(zip_code)

    
zip_codes = gpd.read_file('data/spatial/shp/bor_zip_codes.shp')
zip_codes.crs= {'init': 'epsg:4326'} #WGS84
    
patient = Patient('omar', 'cam', 123456789, 40.729260,-73.977929, 'bloody nose')
patient.geoLocate(zip_codes)

print(patient.getPatient(geo=True))

### NEXT GET THIS INTO DB!

#
#patient =  gpd.sjoin(patient, zip_codes['GEOID10'], how="inner", op='intersects')
#zipcode = patient['GEOID10']
