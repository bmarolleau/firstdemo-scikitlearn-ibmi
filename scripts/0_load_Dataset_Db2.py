import ibm_db_dbi as dbi
import pandas as pd

# Telco Churn dataset from a CRM datasource - here Db2 for i in CHURN/CUSTCHURN2 7044 records

sql="SELECT * from CHURN.CUSTCHURN2"
pd.set_option('display.max_columns', 30)
try:
    conn = dbi.connect()
    df_fromdb2 = pd.read_sql(sql, conn)
    #print(df_fromdb2)
    df_fromdb2.info()
    
except Exception as err:
    print('Error'+ str(err))
