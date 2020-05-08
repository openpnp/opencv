Note to future self:

I was experimenting with using the JNA library loader instead of the custom nu.pattern one. It seems to work but
needs to be tested actually from the jar, and whether or not the file gets deleted.

If it's not deleted, may need to look at how the JNAerator stuff does it.

The tests being commented out and all that were to test to make sure the nu.pattern stuff wasn't accidentally
loading the library.
