@@
expression ndevexp;
expression E;
identifier func;
@@
func(...) {
	<+...
+#if LINUX_VERSION_IS_GEQ(4,10,0)
	ndevexp->min_mtu = E;
+#endif
	...+>
}

@@
expression ndevexp;
expression E;
identifier func;
@@
func(...) {
	<+...
+#if LINUX_VERSION_IS_GEQ(4,10,0)
	ndevexp->max_mtu = E;
+#endif
	...+>
}

