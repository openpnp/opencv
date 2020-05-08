package nu.pattern;

import java.util.ArrayList;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;
import org.opencv.core.Core;
import org.opencv.core.CvType;
import org.opencv.core.Mat;
import org.opencv.core.MatOfPoint;
import org.opencv.core.MatOfRect;
import org.opencv.core.Point;
import org.opencv.core.Scalar;
import org.opencv.features2d.MSER;
import org.opencv.imgproc.Imgproc;

import com.sun.jna.NativeLibrary;

@RunWith(JUnit4.class)
public class MserTest {
    static NativeLibrary library;
    static {
//        OpenCV.loadLocally();
//        Runtime.getRuntime().loadLibrary(Core.NATIVE_LIBRARY_NAME);

        /**
         * Okay, this actually works. But does it work from a jar, and does it delete the
         * temporary file?
         */
        System.setProperty("jna.debug_load", "true");
        System.setProperty("jna.debug_load.jna", "true");
        library = NativeLibrary.getInstance(Core.NATIVE_LIBRARY_NAME);
        System.load(library.getFile().getAbsolutePath());
        System.out.println(library);
    }
    
    /**
     * Draws a filled circle in an image and then uses MSER to attempt to
     * find it. Expects to find one result.
     */
    @Test
    public void testMser() {
        Mat mat = new Mat(400, 400, CvType.CV_8U);
        mat.setTo(new Scalar(0));
        Imgproc.circle(
                mat, 
                new Point(200, 200), 
                20, 
                new Scalar(100), 
                -1);
        MSER mser = MSER.create();
        List<MatOfPoint> msers = new ArrayList<>();
        MatOfRect bboxes = new MatOfRect();
        mser.detectRegions(mat, msers, bboxes);
        Assert.assertEquals(1, msers.size());
    }
}


