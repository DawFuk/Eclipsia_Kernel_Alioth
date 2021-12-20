@@
identifier handlers;
identifier fn;
@@
struct pci_error_handlers handlers = {
+#if LINUX_VERSION_IS_GEQ(3,16,0)
.reset_notify = fn,
+#endif
 };

@@
identifier handlers;
identifier fn;
@@
struct pci_error_handlers handlers[] = {{
+#if LINUX_VERSION_IS_GEQ(3,16,0)
.reset_notify = fn,
+#endif
 }};
