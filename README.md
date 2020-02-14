# NCCFileDescriptorTap

Captures stdout and/or stderr, or data that is written to any file descriptor, delivering the data to your code for writing to a file or processing.

By default, it will also pass the data along to its original destination, so it acts as a tap.  This is configurable, however.  If processingMode == .redirect, no data is sent to the original destination.
