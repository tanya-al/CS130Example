from PIL import Image, ImageOps
import base64
import cStringIO

class Utils():
	def encode_b64(self, img):
	    jpeg_image_buffer = cStringIO.StringIO()
	    img.save(jpeg_image_buffer, format="JPEG")
	    return base64.b64encode(jpeg_image_buffer.getvalue())

	def decode_b64(self, b64string):
	    return Image.open(cStringIO.StringIO(base64.b64decode(b64string)))

	def get_thumbnail(self, b64string):
	    img = self.decode_b64(b64string)
	    size = (100, 100)
	    img = ImageOps.fit(img, size, Image.ANTIALIAS)
	    return self.encode_b64(img)