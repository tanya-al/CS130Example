from PIL import Image, ImageOps
import base64
import cStringIO

def encode_b64(img):
    jpeg_image_buffer = cStringIO.StringIO()
    img.save(jpeg_image_buffer, format="JPEG")
    return base64.b64encode(jpeg_image_buffer.getvalue())

def decode_b64(b64string):
    return Image.open(cStringIO.StringIO(base64.b64decode(b64string)))

def get_thumbnail(b64string):
    img = decode_b64(b64string)
    size = (100, 100)
    img = ImageOps.fit(img, size, Image.ANTIALIAS)
    return encode_b64(img)