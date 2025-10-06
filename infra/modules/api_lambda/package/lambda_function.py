import json, os, re, boto3
TABLE = os.environ.get("TABLE_NAME"); dynamodb = boto3.client("dynamodb")
BARCODE_RE = re.compile(r"^[0-9]{11,14}$")
def handler(event, context):
    params = event.get("queryStringParameters") or {}
    barcode = (params.get("barcode") or "").strip()
    if not BARCODE_RE.match(barcode):
        return resp(400, {"ok": False, "error": "Invalid barcode (11-14 digits)."})
    item = dynamodb.get_item(TableName=TABLE, Key={"barcode":{"S":barcode}}, ConsistentRead=True).get("Item")
    if not item: return resp(404, {"ok": False, "error": "Not found", "barcode": barcode})
    data = {"barcode": item["barcode"]["S"], "name": item["name"]["S"], "ingredients": item["ingredients"]["S"]}
    return resp(200, {"ok": True, "data": data})
def resp(code, body): return {"statusCode": code, "headers": {"Content-Type":"application/json"}, "body": json.dumps(body)}
