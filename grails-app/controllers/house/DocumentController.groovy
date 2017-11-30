package house

import grails.rest.RestfulController
import javax.imageio.ImageIO
import java.io.ByteArrayInputStream;
import sun.misc.BASE64Decoder;

class DocumentController extends RestfulController{

    static responseFormats = ['json', 'xml']
    static allowedMethods = [upload: 'POST']

    DocumentController(){
        super(Document)
    }

    def index(){
        respond Document.findAll()
    }

    // Helper method for decoding an image file
    def decodeImage(String sourceData, String imageName){

        // tokenize the data
        def parts = sourceData.tokenize(",")
        def imageString = parts[1]

        // create a buffered image
        def image = null
        byte[] imageByte

        // decode from base64 back to bytes
        BASE64Decoder decoder = new BASE64Decoder()
        imageByte = decoder.decodeBuffer(imageString)
        ByteArrayInputStream bis = new ByteArrayInputStream(imageByte)

        // reconstruct an image from a byte array
        // if you are working with a different file format, you will need to use a class/method for that format
        image = ImageIO.read(bis)
        bis.close()

        // write the image to a file
        File outputfile = new File("./uploads/" + imageName)
        ImageIO.write(image, "png", outputfile)
    }

    def upload() {
        try{
            // get the text body of the POST request and send it to the decoder method
            decodeImage(request.inputStream.text, params.imageName)
            // saves some metadata in a domain object - tells the database where to find the file
            new Document(filename: params.imageName, fullPath: "./uploads/" + params.imageName).save()
            // all good - send success status
            response.status = 200
        } catch (Exception e){
            e.printStackTrace()
            // if anything goes wrong, send a server error status
            response.status = 500
        }

    }

}
