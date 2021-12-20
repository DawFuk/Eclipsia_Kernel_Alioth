@r1@
identifier s, func;
@@

struct net_device_ops s = {
+#if LINUX_VERSION_IS_GEQ(3,2,0)
.ndo_set_vf_spoofchk = func,
+#endif /* LINUX_VERSION_IS_GEQ(3,2,0) */
};

@r2@
identifier s, func2;
@@

struct net_device_ops s = {
.ndo_get_vf_config = func2,
};

// ----------------------------------------------------------------------

@@
identifier r1.func;
@@

+#if LINUX_VERSION_IS_GEQ(3,2,0)
func(...) { ... }
+#endif /* LINUX_VERSION_IS_GEQ(3,2,0) */

@@
identifier r2.func2, ivi;
expression assign;
@@

func2(...  ,struct ifla_vf_info *ivi)
{
 <...
+#if LINUX_VERSION_IS_GEQ(3,2,0)
 ivi->spoofchk = assign;
+#endif /* LINUX_VERSION_IS_GEQ(3,2,0) */
 ...>
}
