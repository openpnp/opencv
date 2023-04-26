package nu.pattern;

import org.junit.Assert;
import org.junit.Test;
import org.opencv.core.CvType;
import org.opencv.core.Mat;
import org.opencv.core.Point;
import org.opencv.core.Scalar;
import org.opencv.img_hash.Img_hash;
import org.opencv.imgproc.Imgproc;

public class ImgHashTest {
    static {
        OpenCV.loadLocally();
    }
    @Test
    public void testImgHash(){
        Mat mat = new Mat(400, 400, CvType.CV_8U);
        mat.setTo(new Scalar(0));
        Imgproc.circle(
            mat,
            new Point(200, 200),
            20,
            new Scalar(100),
            -1);

        Mat output = new Mat(400, 400, CvType.CV_8U);
        Img_hash.pHash(mat, output);
        Assert.assertEquals(2, output.dims());
        Assert.assertEquals("[153, 238, 102,  59, 153, 206, 102,  51]", output.dump());
    }
}
