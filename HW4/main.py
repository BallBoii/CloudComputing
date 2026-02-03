import json

def lambda_handler(event, context):
    # this function processes the request body with "a", "b", and "op" fields
    # Parse the request body
    body = json.loads(event["body"])
    
    # load parameters and change to float
    a = float(body.get("a"))
    b = float(body.get("b"))
    op = body.get("op")

    # It's should support following operations: "+", "-", "*", "/"
    if op == "+":
        result = a + b
    elif op == "-":
        result = a - b
    elif op == "*":
        result = a * b
    elif op == "/":
        if b == 0:
            return {
                'statusCode': 400,
                'body': json.dumps(json.loads(event["body"]))
            }
        result = a / b  

    else:
        return {
            'statusCode': 400,
            'body': json.dumps(json.loads(event["body"]))
        }
    
    return {
        'statusCode': 200,
        'body': json.dumps(result)
    }