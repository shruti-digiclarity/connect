import json


def lambda_handler(event, context):
    print(json.dumps({"message": "CCaaS demo Lambda invoked", "event": event}))
    return {"status": "ok", "message": "Demo Lambda invoked"}