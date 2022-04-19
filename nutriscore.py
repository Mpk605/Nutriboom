import requests

result = requests.get('https://world.openfoodfacts.org/api/v0/product/737628064502.json')
result.json()
