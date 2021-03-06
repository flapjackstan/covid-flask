import geopandas as gpd
import pandas as pd

class Borough:
    def __init__(self, code, name):
        self.code  = code
        self.name = name
        
    def getCode(self):
        return self.code

    def getName(self):
        return self.name

    def getBoroughs(self):
        return (self.getcode(), self.getName())
        
class Hospitals:
    def __init__(self, name, lat, long):
        self.name = name
        self.lat  = lat
        self.long  = long

    def getName(self):
        return self.name

    def getLat(self):
        return self.lat

    def getLong(self):
        return self.long

    def getHospitals(self):
        return (self.getName(),self.getLat(), self.getLong())
        
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
        
        gdf = gpd.GeoDataFrame(df, geometry=gpd.points_from_xy(df.long.astype(float), df.lat.astype(float)))
        gdf.crs= {'init': 'epsg:4326'} #WGS84
        
        zip_codes = gpd.read_file('data/spatial/shp/bor_zip_codes.shp')
        zip_codes.crs= {'init': 'epsg:4326'} #WGS84
        
        gdf =  gpd.sjoin(gdf, polygon[['GEOID10','geometry']], how="inner", op='intersects')
        
        gdf.drop(['geometry','lat','long','index_right'],axis=1, inplace=True)
        
        zip_code = gdf.loc[0][4]
        
        self.setZip(zip_code)
        
class Results:
    
    def __init__(self,id, results):
        self.id = id
        self.results = results
                

    def getId(self):
        return self.id  
        
    def getResults(self):
        return self.results
    

def convertBorough(df):
    list = []

    for i in range(0,len(df)):
        boro = Borough(df['boro_code'][i],df['boro_name'][i])
        list.append(boro)
    
    del(i)
    return(list)
    
def convertHospitals(df):
    list = []

    for i in range(0,len(df)):
        hospital = Hospitals(df['HOSPITAL_NAME'][i],df['LATITUDE'][i],df['LONGITUDE'][i])
        #print(hospital.getHospitals())
        list.append(hospital)

    del(i)
    return(list)