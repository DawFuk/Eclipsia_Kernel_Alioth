@r1@
identifier s, func;
@@

struct ethtool_ops s = {
+#if LINUX_VERSION_IS_GEQ(3,5,0)
.get_ts_info = func,
+#endif /* LINUX_VERSION_IS_GEQ(3,5,0) */
};

// ----------------------------------------------------------------------

@@
identifier r1.func;
@@

+#if LINUX_VERSION_IS_GEQ(3,5,0)
func(...) { ... }
+#endif /* LINUX_VERSION_IS_GEQ(3,5,0) */
