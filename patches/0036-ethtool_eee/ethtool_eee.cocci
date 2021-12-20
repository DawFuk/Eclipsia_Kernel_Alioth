@r1@
identifier s, func;
@@

struct ethtool_ops s = {
+#if LINUX_VERSION_IS_GEQ(3,6,0)
.get_eee = func,
+#endif /* LINUX_VERSION_IS_GEQ(3,6,0) */
};

@r2@
identifier s, func;
@@

struct ethtool_ops s = {
+#if LINUX_VERSION_IS_GEQ(3,6,0)
.set_eee = func,
+#endif /* LINUX_VERSION_IS_GEQ(3,6,0) */
};

// ----------------------------------------------------------------------

@@
identifier r1.func;
@@

+#if LINUX_VERSION_IS_GEQ(3,6,0)
func(...) { ... }
+#endif /* LINUX_VERSION_IS_GEQ(3,6,0) */

@@
identifier r2.func;
@@

+#if LINUX_VERSION_IS_GEQ(3,6,0)
func(...) { ... }
+#endif /* LINUX_VERSION_IS_GEQ(3,6,0) */
