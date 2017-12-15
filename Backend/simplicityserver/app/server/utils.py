from PIL import Image, ImageOps
import base64
import cStringIO


class Utils():
    """
    Contains helper functions for the server endpoints
    """

    def encode_b64(self, img):
        """
        Encodes an image into base 64 format

        :param img: the PIL Image to convert to base 64
        :returns: a string containing the image encoded into base64 text
        """
        jpeg_image_buffer = cStringIO.StringIO()
        img.save(jpeg_image_buffer, format="JPEG")
        return base64.b64encode(jpeg_image_buffer.getvalue())

    def decode_b64(self, b64string):
        """
        Decodes a base64 image into PIL Image format

        :param b64string: the string containing the image in base64 format to decode
        :returns: a PIL Image decoded from the base64 string
        """
        return Image.open(cStringIO.StringIO(base64.b64decode(b64string)))

    def get_thumbnail(self, b64string):
        """
        Generates a thumbnail from an image encoded in base64

        :param b64string: the full-sized image that the thumbnail should be created from
        :returns: a string containing the thumbnail-sized version of the image in base64 format
        """
        img = self.decode_b64(b64string)
        size = (100, 100)
        img = ImageOps.fit(img, size, Image.ANTIALIAS)
        return self.encode_b64(img)