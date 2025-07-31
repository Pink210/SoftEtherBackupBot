import os
import base64
import json
import pandas as pd
import requests
import urllib3
import datetime
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
import config

os.chdir(os.path.dirname(os.path.abspath(__file__)))

servers = config.lis_servers
password = config.ser_password
time = datetime.datetime.now()

username = ""
def SendCommand(gateway, password, method, params):
    try:
        payload = {
            "jsonrpc": "2.0",
            "id": "rpc_call_id",
            "method": method,
            "params": params
        }
        headers = {'content-type': 'application/json'}
        
        response = requests.request("POST", url=gateway, headers=headers, data=json.dumps(payload), 
                                    verify=False, auth=(username, password))
        data = response.json()
        return data['result']
    except:
        return False

def get_config(server):
    try:
        apisite = f"https://{server}:5555/api/"
        method = "GetConfig"
        params = {}
        r = SendCommand(apisite, password, method, params)
        response = pd.json_normalize(r)['FileData_bin'].values
        response = [x.split('/')[-1] for x in response]
        return response
    except:
        return ["False"]
            
        
def get_backup():
    try:
        print(time.strftime("%Y-%m-%d %H:%M:%S"))
        summary_file = open('summary.txt', "a")
        summary_file.write(f'\n ----------------- \n')
        summary_file.write(f'{time.strftime("%Y-%m-%d %H:%M:%S")}\n')
        for s in servers:
            base64_by = get_config(s)[0]
            if base64_by == "False":
                summary_file.write(f'error geting {s} data\n') 
            else:
                base64_bytes = base64_by.encode('ascii')
                message_bytes = base64.b64decode(base64_bytes)
                message = message_bytes.decode('ascii')
                config_file = open(f'{s}.config', "w")
                config_file.write(message) 
                summary_file.write(f'geting {s} data ok\n')
                if config.telegram_bot:
                    try:
                        send_to_telegram(f'{s}.config')
                    except Exception as e:
                        print(f"Error sending to Telegram: {e}")
                else:
                    pass
    except:
        print('error')
        return
        


def send_to_telegram(filepath):
    try:
        with open(filepath, 'rb') as f:
            files = {'document': f}
            url = f"https://api.telegram.org/bot{config.telegram_bot_token}/sendDocument"
            data = {'chat_id': config.telegram_chat_id}
            response = requests.post(url, data=data, files=files)
            return response.status_code == 200
    except Exception as e:
        print(f"Telegram send error: {e}")
        return False

get_backup()
print("END")