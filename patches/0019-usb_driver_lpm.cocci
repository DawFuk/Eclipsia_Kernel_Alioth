@@
identifier backport_driver;
@@
struct usb_driver backport_driver = {
+#if LINUX_VERSION_IS_GEQ(3,5,0)
	.disable_hub_initiated_lpm = 1,
+#endif
...
};
