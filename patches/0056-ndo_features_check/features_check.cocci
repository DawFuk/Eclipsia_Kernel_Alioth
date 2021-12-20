@r1@
identifier s, func;
@@

struct net_device_ops s = {
+#if LINUX_VERSION_IS_GEQ(3,19,0)
.ndo_features_check = func,
+#endif /* LINUX_VERSION_IS_GEQ(3,19,0) */
};

// ----------------------------------------------------------------------

@r2@
identifier r1.func;
@@

+#if LINUX_VERSION_IS_GEQ(3,19,0)
func(...) { ... }
+#endif /* LINUX_VERSION_IS_GEQ(3,19,0) */
