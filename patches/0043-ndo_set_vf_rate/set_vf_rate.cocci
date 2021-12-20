@r1@
identifier s, func;
@@

struct net_device_ops s = {
+#if LINUX_VERSION_IS_GEQ(3,16,0)
.ndo_set_vf_rate = func,
+#else
+.ndo_set_vf_tx_rate = func,
+#endif /* LINUX_VERSION_IS_GEQ(3,16,0) */
};

@r2@
identifier s, func2;
@@

struct net_device_ops s = {
.ndo_get_vf_config = func2,
};

// ----------------------------------------------------------------------

@@
identifier r1.func, min_tx_rate, max_tx_rate;
@@

func(...
+#if LINUX_VERSION_IS_GEQ(3,16,0)
 ,int min_tx_rate, int max_tx_rate
+#else
+,int tx_rate
+#endif /* LINUX_VERSION_IS_GEQ(3,16,0) */
 ) { ... }

@@
identifier r2.func2, ivi;
expression assign, assign2;
@@

func2(...  ,struct ifla_vf_info *ivi)
{
 <...
+#if LINUX_VERSION_IS_GEQ(3,16,0)
 ivi->max_tx_rate = assign;
 ivi->min_tx_rate = assign2;
+#else
+ivi->tx_rate = assign;
+#endif /* LINUX_VERSION_IS_GEQ(3,16,0) */
 ...>
}
