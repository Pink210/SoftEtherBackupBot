import base64
import codecs

base64_by = 'pqVUe07Tw1W2YwZV5dhNDeVKMIA='
b64Str = codecs.encode("pqVUe07Tw1W2YwZV5dhNDeVKMIA=")
resStr = base64.b64decode(b64Str)
print(resStr)