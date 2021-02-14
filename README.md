# OpenCV 4.3.0 (packaged by [OpenPnP](http://openpnp.org))

[OpenCV](http://opencv.org) Java bindings packaged with native libraries, seamlessly delivered as a turn-key Maven dependency.

## Fork Notes

### Soft Fork

This is a soft fork of Pattern's OpenCV package at https://github.com/PatternConsulting/opencv.
That package has not been maintained in quite some time and I needed updated OpenCV
binaries for OpenPnP. I intend to maintain this fork for the foreseeable future
or until Pattern resumes maintenance of their package.

### Backwards Compatibility

I have left the source code packages and directories the same (nu.pattern)
and only changed the Maven coordinates in the pom.xml. This way the package
remains backwards compatible and it is very easy to switch between the
OpenPnP version and the Pattern version.

### Maven

To use this fork in your project, instead of the Pattern one, simply add
the same dependency but with the groupId org.openpnp instead of nu.pattern.

### Scala

I'm not uploading Scala artifacts as I don't know or use Scala. If someone
wants to maintain that portion of the package, let me know.

## Usage

### Project

OpenPnP's OpenCV package is added to your project as any other dependency.

#### [Maven](http://maven.apache.org/)

```xml
<project>
  
  <!-- ... -->
  
  <dependencies>
    
    <!-- ... -->
    
    <dependency>
      <groupId>org.openpnp</groupId>
      <artifactId>opencv</artifactId>
      <version>4.3.0-3</version>
    </dependency>
    
    <!-- ... -->
    
  </dependencies>
  
  <!-- ... -->
  
</project>
```

### API

Typically, using the upstream [OpenCV Java bindings involves loading the native library](http://docs.opencv.org/doc/tutorials/introduction/desktop_java/java_dev_intro.html#java-sample-with-ant) as follows:

```java
static {
  System.loadLibrary(org.opencv.core.Core.NATIVE_LIBRARY_NAME);
}
```

Fortunately, this is unchanged except for one caveat. To use the native libraries included with this package, first call [`nu.pattern.OpenCV.loadShared()`](https://github.com/PatternConsulting/opencv/blob/master/src/main/java/nu/pattern/OpenCV.java).

**Note: In Java 12+ loadShared() is not available. Use loadLocally() instead, and see notes below.**

This call will—exactly once per class loader—first attempt to load from the system-wide installation (exactly as if `System.loadLibrary(org.opencv.core.Core.NATIVE_LIBRARY_NAME);` were called without any preceding steps). If that fails, the loader will select a binary from the package appropriate for the runtime environment's operating system and architecture. It will write that native library to a temporary directory (also defined by the environment), add that directory to `java.library.path`. _This involves writing to disk_, so consider the implications. Temporary files will be garbage-collected on clean shutdown.

This approach keeps most clients decoupled from Pattern's package and loader. As long as this is done sufficiently early in execution, any library using the OpenCV Java bindings can use the usual load call as documented by the OpenCV project.

There are, however, cases where Java class loaders are frequently changing (_e.g._, application servers, SBT projects, Scala worksheets), and [spurious attempts to load the native library will result in JNI errors](https://github.com/PatternConsulting/opencv/issues/7). As a partial work-around, this package offers an alternative API, [`nu.pattern.OpenCV.loadLocally()`](https://github.com/PatternConsulting/opencv/blob/master/src/main/java/nu/pattern/OpenCV.java), which—also exactly once per class loader—extracts the binary appropriate for the runtime platform, and passes it to `System#load(String)`. Ultimately, this may eventually load the library redundantly in the same JVM, which could be unsafe in production. Use with caution and understand the implications.

It's recommended developers using any JNI library read further:

- [JNI 1.2 Specifications: Library and Version Management](http://docs.oracle.com/javase/7/docs/technotes/guides/jni/jni-12.html#libmanage)
- [Holger Hoffstätte's Comments on Native Libraries, Class Loaders, and Garbage Collection](https://groups.google.com/forum/#!msg/ospl-developer/J4i6cF6yPk0/-3Jm3Qs_HDwJ)

## Debugging

[Java logging](http://docs.oracle.com/javase/8/docs/api/java/util/logging/package-summary.html) is used to produce log messages from `nu.pattern.OpenCV`.

## Rationale

Developers wishing to use the Java API for OpenCV would typically go through the process of building the project, and building it for each platform they wished to support (_e.g._, 32-bit Linux, OS X). This project provides those binaries for inclusion as a typical dependency in Maven, Ivy, and SBT projects.

Apart from testing, this package deliberately specifies no external dependencies. It does, however, make use of modern Java APIs (such as [Java NIO](http://docs.oracle.com/javase/tutorial/essential/io/fileio.html)).

## Support

The following platforms are supported by this package:

OS | Architecture
--- | ---
OS X | x86_32
OS X | x86_64
Linux | x86_64
Linux | ARM_64 (AARCH64)
Windows | x86_32
Windows | x86_64

If you can help create binaries for additional platforms, please see notes under [_Contributing_](#contributing).

## Credits

This package is maintained by [Jason von Nieda](http://github.com/vonnieda).
  
## Acknowledgements

- [Michael Ahlers](http://github.com/michaelahlers), for originally creating and maintaining this project.
- [Greg Borenstein](https://github.com/atduskgreg), whose advice and [OpenCV for Processing](https://github.com/atduskgreg/opencv-processing) project informed this package's development. 
- [Alex Osborne](https://github.com/ato), for helpful [utility class producing temporary directories with Java NIO that are properly garbage-collected on shutdown](https://gist.github.com/ato/6774390).
