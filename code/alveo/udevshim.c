/* Container has no /run/udev; libudev's udev_enumerate_scan_devices SIGABRTs.
   Override it (and the hwdb open) to succeed with an empty result so Vivado's
   host-info/WebTalk scan finds no devices instead of crashing. */
int udev_enumerate_scan_devices(void *e){ (void)e; return 0; }
int udev_enumerate_scan_subsystems(void *e){ (void)e; return 0; }
