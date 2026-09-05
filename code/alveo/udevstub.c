/* Stub libudev.so.1 loaded via LD_LIBRARY_PATH so Xilinx's dlopen("libudev.so.1")
   picks THIS instead of the system libudev (whose udev_enumerate_scan_devices
   SIGABRTs in this udev-less container). Reports an empty device set: the license/
   WebTalk host-info scan finds nothing instead of crashing. */
#include <stdlib.h>
void *udev_new(void){ return malloc(8); }
void *udev_unref(void *u){ (void)u; return 0; }
void *udev_enumerate_new(void *u){ (void)u; return malloc(8); }
void *udev_enumerate_unref(void *e){ (void)e; return 0; }
int   udev_enumerate_scan_devices(void *e){ (void)e; return 0; }          /* no-op, no abort */
int   udev_enumerate_scan_subsystems(void *e){ (void)e; return 0; }
void *udev_enumerate_get_list_entry(void *e){ (void)e; return 0; }        /* empty list */
void *udev_list_entry_get_next(void *l){ (void)l; return 0; }
const char *udev_list_entry_get_name(void *l){ (void)l; return 0; }
const char *udev_list_entry_get_value(void *l){ (void)l; return 0; }
void *udev_device_new_from_syspath(void *u,const char*p){ (void)u;(void)p; return 0; }
void *udev_device_unref(void *d){ (void)d; return 0; }
const char *udev_device_get_devnode(void *d){ (void)d; return 0; }
const char *udev_device_get_devpath(void *d){ (void)d; return 0; }
const char *udev_device_get_devtype(void *d){ (void)d; return 0; }
const char *udev_device_get_subsystem(void *d){ (void)d; return 0; }
const char *udev_device_get_sysname(void *d){ (void)d; return 0; }
const char *udev_device_get_sysnum(void *d){ (void)d; return 0; }
const char *udev_device_get_syspath(void *d){ (void)d; return 0; }
void *udev_device_get_devlinks_list_entry(void *d){ (void)d; return 0; }
void *udev_device_get_properties_list_entry(void *d){ (void)d; return 0; }
