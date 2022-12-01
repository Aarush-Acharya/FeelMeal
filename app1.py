from joblib import load
from flask import Flask, jsonify, request
from flask_restful import Resource, Api
import os
import pickle
import joblib
from joblib import load
import numpy as np
import pandas as pd


app = Flask(__name__)
api = Api(app)
@app.post('/upload')
def upload():
    if 'file' not in request.files:
        return jsonify({"error": "No file attached"})
    file = request.files['file']
    file.save('data.csv')
    return jsonify({"message": "Uploaded file successfully"})

@app.route('/result', methods=['GET'])
def data_fetch():
    import pandas as pd
    df = pd.read_csv("data.csv")
    df['Weight Loss Range'] = df['Weight Loss Range'].replace(['2 - 4 kg'], '2-4')
    df['Weight Loss Range'] = df['Weight Loss Range'].replace(['5 - 6 kg'], '5-6')
    df['Weight Loss Range'] = df['Weight Loss Range'].replace(['Above 6 kg'], 'above 6')
    df['Weight Loss Range'] = df['Weight Loss Range'].replace(['Above 6 kg'], 'above 6')
    df1 = df.loc[df['Weight Loss Range'] == '2-4']
    df1_yes = df1.loc[df['Fallen ill'] == 'Yes']
    p1 = len(df1_yes)/len(df1)
    df2 = df.loc[df['Weight Loss Range'] == '5-6']
    df2_yes = df2.loc[df['Fallen ill'] == 'Yes']
    p2 = len(df2_yes)/len(df2)
    df3 = df.loc[df['Weight Loss Range'] == 'above 6']
    df3_yes = df3.loc[df['Fallen ill'] == 'Yes']
    p3 = len(df3_yes)/len(df3)
    a1 = len(df1)/len(df)
    a2 = len(df2)/(len(df1)+len(df2)+len(df3))
    a3 = len(df3)/(len(df1)+len(df2)+len(df3))
    P = p1*a1+p2*a2+p3*a3
    X = range(1, 46)
    import numpy as np
    # import matplotlib.pyplot as plt
    from scipy.stats import geom
    geom_pd = geom.pmf(X, P)
    mean = np.mean(geom_pd)
    dev = geom_pd - mean
    var = np.square(dev)
    exp_var = np.mean(var)
    import math
    std = math.sqrt(exp_var)
    dev_from_var = geom_pd - exp_var
    max_var_dev = max(dev_from_var)
    max_var_dev
    result = np.where(dev_from_var == max_var_dev)
    x = result[0]
    month = x[0] + 3
    computed_json = {
        "Month": int(month),
        }
    return jsonify(computed_json)
    # return str(data)
    # Api-Request :: http://127.0.0.1:5675/api/v1/?field=data_science

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5675)

    