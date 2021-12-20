@@
identifier s;
@@

static
+#if LINUX_VERSION_IS_GEQ(3,7,0)
const
+#endif /* LINUX_VERSION_IS_GEQ(3,7,0) */
struct pci_error_handlers s = { ... };
