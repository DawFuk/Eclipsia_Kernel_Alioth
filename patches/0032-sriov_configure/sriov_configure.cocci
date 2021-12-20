@r1@
identifier s, func;
@@

struct pci_driver s = {
+#if LINUX_VERSION_IS_GEQ(3,8,0)
.sriov_configure = func,
+#endif /* LINUX_VERSION_IS_GEQ(3,8,0) */
};

// ----------------------------------------------------------------------

@@
identifier r1.func;
@@

+#if LINUX_VERSION_IS_GEQ(3,8,0)
func(...) { ... }
+#endif /* LINUX_VERSION_IS_GEQ(3,8,0) */
