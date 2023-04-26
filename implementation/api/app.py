from flask import Flask, request, jsonify
from sklearn.preprocessing import MinMaxScaler
import numpy as np
import xgboost as xgb
import pickle
import json
from google.cloud import storage
from google.oauth2 import service_account
import json

# Defining the flask app
app = Flask(__name__)


with open('key.json', 'r') as f:
    key_creds = json.load(f)

credentials = service_account.Credentials.from_service_account_info(key_creds)
client = storage.Client(project=key_creds['project_id'], credentials=credentials)


@app.route('/forecast', methods=['POST'])
def forecast_predict():
    # Get the request data
    data = request.get_json()

    array_data = np.array(data['vitals'])  # Convert the data to a numpy array

    # Reshape the input data if it's a 1D array
    if array_data.ndim == 1:
        array_data = array_data.reshape(1, -1)

    input_data = np.array(array_data)  # Convert the data to a numpy array

    with open('pickle/forecast_scaler.pkl', 'rb') as file:
        forecast_scaler = pickle.load(file)
    print('Loaded Forecast Scaler')

    normalized_data = forecast_scaler.transform(input_data)
    
    data = xgb.DMatrix(normalized_data) # Converting the numpy array to a DMatrix object

    print('Begin Prediction')
    forecast_model = xgb.Booster()
    forecast_model.load_model('xgb_forecasting.json')
    print('Loaded Forecast Model')

    forecast = forecast_model.predict(data) # Forecasting each row of the data
    forecast = forecast_scaler.inverse_transform(forecast)

    # Get the last value of your predictions array as the next day's value
    np_array = forecast[-1]
    print("Forecasted Vitals: ", np_array)

    # convert to a nested Python list
    nested_list = np.squeeze(np_array).tolist()
    
    rounded_list = [round(num, 2) for num in nested_list]
    print("Forecasted Vitals: ", rounded_list)

    status_response = get_status({'vitals': rounded_list})
    status = status_response['status']
    print("Patient Health Status: ", status)

    del forecast_model, forecast, status_response, normalized_data, array_data, input_data, data, nested_list, np_array

    # # Return the status and forecast as a JSON response
    response = {'forecasted_vitals': rounded_list, 'status': status}

    return jsonify(response)


@app.route('/status', methods=['POST'])
def status_predict():
    # Get the request data
    data = request.get_json()
    response = get_status(data)
    return jsonify(response)
    
def get_status(data):

    input_data = np.array(data['vitals'])  # Convert the data to a numpy array

    # Reshape the input data if it's a 1D array
    if input_data.ndim == 1:
        input_data = input_data.reshape(1, -1)

    with open('pickle/status_scaler.pkl', 'rb') as file:
        status_min_value, status_max_value = pickle.load(file)
    print('Loaded Status Scaler')

    normalized_input = (input_data - status_min_value) / (status_max_value - status_min_value)

    bucket = client.bucket('vitalrpm-models')
    blob = bucket.blob('hybridmodel.pkl')
    file_contents = blob.download_as_string()

    #Hybrid Health Status Model & Scaler
    status_model = pickle.loads(file_contents)
    print('Loaded Status Model')

    # Pass the scaled data to your model for inference
    acuity = status_model.predict(normalized_input)
    print("Patient Health Status Classification: ", acuity)

    # Map the prediction to a text status
    status = get_status_type(acuity)
    print("Patient Health Status: ", status)

    del status_model, bucket, blob, status_min_value, input_data, status_max_value, file_contents, normalized_input

    # Return the status as a JSON response
    response = {'status': status[0], 'vitals': data['vitals'], 'predicted_acuity': str(acuity[0])}
    return response

def get_status_type(prediction):
    print('Getting Patient Status')
    # Define a dictionary mapping each prediction value to a text status
    status_map = {
        1: 'status_critical',
        2: 'status_high',
        3: 'status_warning',
        4: 'status_normal',
        5: 'status_normal'
    }

    # Check if the prediction is a scalar value or an array of values
    if isinstance(prediction, (int, float)):
        return status_map[prediction]
    else:
        return [status_map[p] for p in prediction]

if __name__ == '__main__':
    app.run(debug=True) 