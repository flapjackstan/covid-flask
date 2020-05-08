class Borough:
    def __init__(self, code, name):
        self.code  = code
        self.name = name
        
    def getcode(self):
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
    
def convertBorough(df):
    list = []

    for i in range(0,len(df)):
        boro = Borough(df['boro_code'][i],df['boro_name'][i])
        print(boro.getBoroughs())
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