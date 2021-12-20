@r@
identifier s,func;
@@

struct ethtool_ops s = {
.get_rxnfc = func,
};

@@
identifier r.func,rule_locs;
typedef u32;
@@

// ----------------------------------------------------------------------

func(...
+#if LINUX_VERSION_IS_GEQ(3,2,0)
,u32 *rule_locs
+#else
+,void *rule_locs
+#endif /* LINUX_VERSION_IS_GEQ(3,2,0) */
 ) { ... }
